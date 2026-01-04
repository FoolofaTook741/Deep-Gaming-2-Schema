impulse.Gag = impulse.Gag or {}
impulse.SetGagged = impulse.SetGagged or {}
impulse.IsGagged = impulse.IsGagged or {}
local infoCol = Color(135, 206, 250)

if SERVER then
    util.AddNetworkString("giveGag")
end

-- Set the gag state for an individual player using NWBool
function impulse.SetGagged(ply, g)
    if IsValid(ply) then
        ply:SetNWBool("isGagged", g)
    end
end

function impulse.IsGagged(ply)
    if IsValid(ply) then
        return ply:GetNWBool("isGagged")
    end
    return false
end

local gagCommand = {
    description = "Gags the player for a certain amount of time.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local time = arg[2]
        local reason = arg[3]
        local plyTarget = impulse.FindPlayer(name)

        if not time or not tonumber(time) then
            return ply:Notify("Please specify a valid time value in minutes.")
        end

        time = tonumber(time)
        local timeSeconds = time * 60

        if plyTarget then
            local sid = plyTarget:SteamID()
            impulse.Gag[sid] = CurTime() + timeSeconds
            plyTarget:Notify("Reason: " .. (reason or "Behaviour that violates the community guidelines") .. ".")
            plyTarget:Notify("You have been issued a voice chat gag by a game moderator that will last " .. time .. " minutes.")
            
            -- Set the gag state only for the target player.
            impulse.SetGagged(plyTarget, true)

            timer.Create("impulseGag" .. sid, timeSeconds, 1, function()
                if not impulse.Gag[sid] then return end
                impulse.SetGagged(plyTarget, false)
                impulse.Gag[sid] = nil
                
                if IsValid(plyTarget) then
                    plyTarget:Notify("Your gag has expired. You may now use Voice Chat again.")
                end
            end)

            ply:Notify("You have issued " .. plyTarget:SteamName() .. " a gag for " .. time .. " minutes.")

            for _, v in pairs(player.GetAll()) do
                v:AddChatText(infoCol, plyTarget:SteamName() .. " has been gagged for " .. time .. " minutes by a game moderator.")
            end

            net.Start("giveGag")
            net.WriteUInt(os.time() + timeSeconds, 16)
            net.Send(plyTarget)
        else
            return ply:Notify("Could not find player: " .. tostring(name))
        end
    end
}

impulse.RegisterChatCommand("/gag", gagCommand)

local ungagCommand = {
    description = "Removes a gag from a player.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg)
        local name = arg[1]
        local plyTarget = impulse.FindPlayer(name)

        if plyTarget then
            local sid = plyTarget:SteamID()
            impulse.Gag[sid] = nil
            plyTarget:Notify("Your gag has been removed.")
            
            impulse.SetGagged(plyTarget, false)

            ply:Notify("You have removed " .. plyTarget:SteamName() .. " gag.")

        else
            return ply:Notify("Could not find player: " .. tostring(name))
        end
    end
}

impulse.RegisterChatCommand("/ungag", ungagCommand)

if CLIENT then
    net.Receive("giveGag", function()
        local time = net.ReadUInt(16)
        local endTime = os.time() + time
        local endDate = os.date("%H:%M:%S - %d/%m/%Y", endTime)
        local template = "You have an active Voice communication gag for a violation of the server rules.\nExpiry time: " .. endDate
        local id = "oocban_" .. endDate

        impulse.MenuMessage.Add(id, "Gag Notice", template, Color(179, 58, 58), impulse.Config.RulesURL, "Read the rules", endTime)
        impulse.MenuMessage.Save(id)
    end)
end
