util.AddNetworkString("impulseHL2RPAdjustCivicMerits")

net.Receive("impulseHL2RPAdjustCivicMerits", function(len, ply)
    local target = net.ReadEntity()
    local isAddition = net.ReadBool()
    local amount = net.ReadUInt(16)
    local reason = string.Trim(net.ReadString() or "")

    if (ply.nextCivicMeritsAdjust or 0) > CurTime() then
        return
    end
    ply.nextCivicMeritsAdjust = CurTime() + impulse.CivicMerits.AdjustCooldown

    if not ply:Alive() then
        return ply:Notify("You must be alive to do this.")
    end

    if not impulse.CivicMerits.CanManage(ply) then
        return ply:Notify("You do not have permission to manage Civic Merits.")
    end

    if not IsValid(target) or not target:IsPlayer() then
        return ply:Notify("Invalid target.")
    end

    if not (target:Team() == TEAM_CITIZEN or target:Team() == TEAM_CWU) then
        return ply:Notify("Civic Merits can only be adjusted for Citizens or CWU.")
    end

    if target == ply and not ply:IsSuperAdmin() then
        return ply:Notify("You cannot adjust your own Civic Merits.")
    end

    if amount == 0 then
        return ply:Notify("No change to Civic Merits made.")
    end

    if isAddition and amount > impulse.CivicMerits.MaxAdd then
        return ply:Notify("You may only issue up to " .. impulse.CivicMerits.MaxAdd .. " merits at a time.")
    end

    if not isAddition and amount > impulse.CivicMerits.MaxSubtract then
        return ply:Notify("You may only subtract up to " .. impulse.CivicMerits.MaxSubtract .. " merits at a time.")
    end
    if reason == "" then
        return ply:Notify("You must enter a reason.")
    end

    if #reason > impulse.CivicMerits.MaxReasonLength then
        reason = string.sub(reason, 1, impulse.CivicMerits.MaxReasonLength)
    end

    local current = target:GetCivicMerits()

    if not isAddition and current <= impulse.CivicMerits.Min then
        return ply:Notify(target:Nick() .. " is already at the minimum Civic Merits (" .. impulse.CivicMerits.Min .. ").")
    end

    local newTotal = isAddition and (current + amount) or math.max(impulse.CivicMerits.Min, current - amount)

    target:SetSyncVar(SYNC_CIVIC_MERITS, newTotal, true)

    local query = mysql:Update("impulse_players")
    query:Where("steamid", target:SteamID())
    query:Update("civic_merits", newTotal)
    query:Execute()

    impulse.CivicMerits.Log(ply, target:Name(), target:SteamID(), isAddition, amount, newTotal, false, reason)

    ply:Notify(target:Nick() .. "'s Civic Merits set to " .. newTotal .. ".")
    target:Notify("Your Civic Merits have been " .. (isAddition and "increased" or "decreased") .. " by " .. amount .. " by " .. ply:Name() .. ". New total: " .. newTotal)
end)