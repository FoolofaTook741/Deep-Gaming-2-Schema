plogs.Register('Kills', true, Color(255,0,0))

plogs.AddHook('PlayerDeathPostSnapshot', function(pl, _, attacker)
    local copy = {
        ['Name'] = pl:Name(),
        ['SteamID'] = pl:SteamID(),
    }
    local weapon = ''
    
    if IsValid(attacker) then
        if attacker:IsPlayer() then
            copy['Attacker Name'] = attacker:Name()
            copy['Attacker SteamID'] = attacker:SteamID()

            if (pl.LastSnapshotID or -1) == (attacker.LastSnapshotID or -2) then
                copy['Snapshot ID'] = pl.LastSnapshotID	
            end

            weapon = ' with ' .. (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() or 'unknown')
            attacker = attacker:NameID()
        else
            if attacker.CPPIGetOwner and IsValid(attacker:CPPIGetOwner()) then
                weapon = ' with ' .. attacker:GetClass()
                attacker = attacker:CPPIGetOwner():NameID()
            else
                attacker = attacker:GetClass()
            end
        end
    else
        attacker = tostring(attacker)
    end

    local msg = attacker .. ' killed ' .. pl:NameID() .. weapon

    plogs.PlayerLog(pl, 'Kills', msg, copy)
end)

plogs.Register('Damage', false)

local HITGROUP_NAMES = {
    [HITGROUP_GENERIC] = "Generic",
    [HITGROUP_HEAD] = "Head",
    [HITGROUP_CHEST] = "Chest",
    [HITGROUP_STOMACH] = "Stomach",
    [HITGROUP_LEFTARM] = "Left Arm",
    [HITGROUP_RIGHTARM] = "Right Arm",
    [HITGROUP_LEFTLEG] = "Left Leg",
    [HITGROUP_RIGHTLEG] = "Right Leg",
    [HITGROUP_GEAR] = "Gear"
}

plogs.AddHook('EntityTakeDamage', function(ent, dmginfo)
    if not ent:IsPlayer() then return end

    local copy = {
        ['Name'] = ent:Name(),
        ['SteamID'] = ent:SteamID(),
    }

    local weapon = ''
    local attacker = dmginfo:GetAttacker()
    local distanceText = ''
    local hitgroupText = ''

    if ent.LastHitGroup then
        local hg = 0
        if type(ent.LastHitGroup) == "function" then
            hg = ent:LastHitGroup()
        else
            hg = ent.LastHitGroup
        end
        hitgroupText = " [Hitgroup: " .. (HITGROUP_NAMES[hg] or tostring(hg)) .. "]"
    end

    if IsValid(attacker) then
        if attacker == Entity(0) then return end
        if attacker == ent then return end

        if attacker:IsPlayer() or (IsValid(attacker) and attacker.GetPos) then
            local distHU = ent:GetPos():Distance(attacker:GetPos())
            local distMeters = distHU / 39.37
            distanceText = string.format(" [Distance: %.1fm]", distMeters)
        end 

        if attacker:IsPlayer() then
            copy['Attacker Name'] = attacker:Name()
            copy['Attacker SteamID'] = attacker:SteamID()
            weapon = ' with ' .. (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() or 'unknown')
            attacker = attacker:NameID()
        else
            if attacker.CPPIGetOwner and IsValid(attacker:CPPIGetOwner()) then
                weapon = ' with ' .. attacker:GetClass()
                attacker = attacker:CPPIGetOwner():NameID()
            else
                attacker = attacker:GetClass()
            end
        end
    else
        attacker = tostring(attacker)
    end

    plogs.PlayerLog(ent, 'Damage', attacker .. ' did ' .. math.Round(dmginfo:GetDamage(), 0) .. ' damage to ' .. ent:NameID() .. weapon .. distanceText .. hitgroupText, copy)
end)

