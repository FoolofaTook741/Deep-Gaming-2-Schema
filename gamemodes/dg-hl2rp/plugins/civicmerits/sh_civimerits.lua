function PLUGIN:CreateSyncVars()
    SYNC_CIVIC_MERITS = impulse.Sync.RegisterVar(SYNC_SIGNEDINT)
    SYNC_CIVIC_ID = impulse.Sync.RegisterVar(SYNC_BIGINT)
end

impulse.CivicMerits = impulse.CivicMerits or {}

impulse.CivicMerits.MaxAdd = 10
impulse.CivicMerits.MaxSubtract = 20
impulse.CivicMerits.MaxReasonLength = 200
impulse.CivicMerits.AdjustCooldown = 2
impulse.CivicMerits.Min = -50

function impulse.CivicMerits.CanManage(ply)
    local team = ply:Team()

    if team == TEAM_CP then
        return ply:GetTeamRank() >= RANK_I1
    elseif team == TEAM_CA then
        return ply:GetTeamRank() ~= nil
    elseif team == TEAM_CWU then
        return ply:GetTeamRank() >= RANK_SUPERVISOR
    end

    return false
end

if SERVER then
    function impulse.CivicMerits.SanitizeReason(reason)
        return string.gsub(reason, "@", "@\226\128\139")
    end

    function impulse.CivicMerits.Log(ply, targName, targSteamID, isAddition, amount, newTotal, override, reason)
        local fields = {
            { name = "Supervisor:", value = ply:Name() .. " (" .. ply:SteamID() .. ")" },
            { name = "Citizen:", value = targName .. " (" .. targSteamID .. ")" },
            { name = "Action:", value = isAddition and "Addition" or "Subtraction" },
            { name = "Amount:", value = tostring(amount) },
            { name = "New Total:", value = tostring(newTotal) }
        }

        if reason then
            table.insert(fields, { name = "Reason:", value = impulse.CivicMerits.SanitizeReason(reason) })
        end

        local embeds = {{
            title = override and "Civic Merits Adjusted (Staff Override)" or "Civic Merits Adjusted",
            description = override and "A staff member has manually adjusted a citizen's Civic Merits."
                or "A supervisor has adjusted a citizen's Civic Merits via PDA.",
            color = isAddition and 3066993 or 15158332,
            fields = fields
        }}

        ReqwestLog(embeds, DG_CVMERITS)
    end
end

local civicMeritsCommand = {
    description = "(Staff Only) Adjusts a player's Civic Merits. Args: STEAMID +/-AMOUNT",
    requiresArg = true,
    leadAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not SERVER then return end

        if (ply.nextCivicMeritsAdjust or 0) > CurTime() then
            return
        end
        ply.nextCivicMeritsAdjust = CurTime() + impulse.CivicMerits.AdjustCooldown

        local steamid = arg[1]
        local rawAmount = arg[2]

        if not steamid or not string.match(steamid, "^STEAM_%d:%d:%d+$") then
            return ply:Notify("Invalid SteamID format. Expected STEAM_X:Y:Z.")
        end

        if not rawAmount then
            return ply:Notify("You must specify an amount, e.g. +10 or -5.")
        end

        local numAmount = tonumber(rawAmount) or 0
        local isAddition = numAmount > 0
        local amount = math.floor(math.abs(numAmount))

        if amount == 0 then
            return
        end

        if isAddition and amount > impulse.CivicMerits.MaxAdd then
            return ply:Notify("You may only issue up to " .. impulse.CivicMerits.MaxAdd .. " merits at a time.")
        end

        if not isAddition and amount > impulse.CivicMerits.MaxSubtract then
            return ply:Notify("You may only subtract up to " .. impulse.CivicMerits.MaxSubtract .. " merits at a time.")
        end

        local targ = player.GetBySteamID(steamid)

        if targ == ply and not ply:IsSuperAdmin() then
            return ply:Notify("You cannot adjust your own Civic Merits.")
        end

        local query = mysql:Select("impulse_players")
        query:Select("civic_merits")
        query:Where("steamid", steamid)
        query:Callback(function(result)
            if not IsValid(ply) then return end

            if not (type(result) == "table" and #result > 0) then
                return ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
            end

            local current = tonumber(result[1].civic_merits) or 0

            if not isAddition and current <= impulse.CivicMerits.Min then
                return ply:Notify("This player is already at the minimum Civic Merits (" .. impulse.CivicMerits.Min .. ").")
            end

            local newTotal = isAddition and (current + amount) or math.max(impulse.CivicMerits.Min, current - amount)

            local updateQuery = mysql:Update("impulse_players")
            updateQuery:Where("steamid", steamid)
            updateQuery:Update("civic_merits", newTotal)
            updateQuery:Execute()

            local targName = steamid
            if targ and IsValid(targ) then
                targName = targ:Name()
                targ:SetSyncVar(SYNC_CIVIC_MERITS, newTotal, true)
                targ:Notify("Your Civic Merits have been " .. (isAddition and "increased" or "decreased") .. " by " .. amount .. " by " .. ply:Name() .. ". New total: " .. newTotal)
            end

            impulse.CivicMerits.Log(ply, targName, steamid, isAddition, amount, newTotal, true)

            ply:Notify("Civic Merits for " .. steamid .. " set to " .. newTotal .. ".")
        end)
        query:Execute()
    end
}
impulse.RegisterChatCommand("/civicmerits", civicMeritsCommand)