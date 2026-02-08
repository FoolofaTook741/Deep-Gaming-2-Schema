util.AddNetworkString("cpmessage")
util.AddNetworkString("otamessage")
util.AddNetworkString("ocamessage")
util.AddNetworkString("staffcpmessage")
util.AddNetworkString("staffotamessage")
util.AddNetworkString("staffocamessage")

DG_SOCIOSTABILITYSCORE = 0
DG_OTABSLCOUNT = 0
DG_CPBSLCOUNT = 0
DG_OCABSLCOUNT = 0
DG_SOCIOSTABILITYSCORE_REAL = 0

hook.Add("Think", "AutoUpdateCounters", function()
    if !timer.Exists("autoupdatecounterscd") then
        net.Start("cpmessage")
        net.WriteUInt(DG_CPBSLCOUNT, 6)
        net.Broadcast()
        net.Start("staffcpmessage")
        net.WriteUInt(DG_CPBSLCOUNT, 6)
        net.Broadcast()
        net.Start("otamessage")
        net.WriteUInt(DG_OTABSLCOUNT, 6)
        net.Broadcast()
        net.Start("staffotamessage")
        net.WriteUInt(DG_OTABSLCOUNT, 6)
        net.Broadcast()
        net.Start("ocamessage")
        net.WriteUInt(DG_OCABSLCOUNT, 6)
        net.Broadcast()
        net.Start("staffocamessage")
        net.WriteUInt(DG_OCABSLCOUNT, 6)
        net.Broadcast()
        timer.Create("autoupdatecounterscd", 10, 1, function() end)
    end
end)

local ExplosionVictims = {}
hook.Add("PlayerDeath", "bslcounter", function(victim, inflictor, attacker)
    local victimTeam = victim:Team()
    local isCP = victim:IsCP()
    local isIED = false

    if IsValid(inflictor) then
        local class = inflictor:GetClass()
		local model = inflictor:GetModel()
        if class == "item_usable" and model == "models/weapons/w_c4_planted.mdl" then
            isIED = true
        end
    end

    local shouldCount = (attacker:IsPlayer() and not attacker:IsCP()) or isIED

    if shouldCount and (victimTeam == TEAM_CP or victimTeam == TEAM_OTA or victimTeam == TEAM_CA) then

        local countVar, netMsg, staffMsg, timerSuffix = nil, nil, nil, nil
        if victimTeam == TEAM_CP then
            countVar, netMsg, staffMsg, timerSuffix = DG_CPBSLCOUNT, "cpmessage", "staffcpmessage", "cpcountercooldown"
            DG_CPBSLCOUNT = math.Clamp(DG_CPBSLCOUNT + 1, 0, 63)
        elseif victimTeam == TEAM_OTA then
            countVar, netMsg, staffMsg, timerSuffix = DG_OTABSLCOUNT, "otamessage", "staffotamessage", "otacountercooldown"
            DG_OTABSLCOUNT = math.Clamp(DG_OTABSLCOUNT + 1, 0, 63)
        elseif victimTeam == TEAM_CA then
            countVar, netMsg, staffMsg, timerSuffix = DG_OCABSLCOUNT, "ocamessage", "staffocamessage", "ocacountercooldown"
            DG_OCABSLCOUNT = math.Clamp(DG_OCABSLCOUNT + 1, 0, 63)
        end

        if countVar then
            net.Start(netMsg)
            net.WriteUInt(countVar, 6)
            net.Broadcast()

            net.Start(staffMsg)
            net.WriteUInt(countVar, 6)
            net.Broadcast()

            local timerName = timerSuffix .. "_" .. math.random(1, 100000)
            timer.Create(timerName, 900, 1, function()
                if victimTeam == TEAM_CP then
                    DG_CPBSLCOUNT = math.Clamp(DG_CPBSLCOUNT - 1, 0, 63)
                elseif victimTeam == TEAM_OTA then
                    DG_OTABSLCOUNT = math.Clamp(DG_OTABSLCOUNT - 1, 0, 63)
                elseif victimTeam == TEAM_CA then
                    DG_OCABSLCOUNT = math.Clamp(DG_OCABSLCOUNT - 1, 0, 63)
                end

				local currentCount = 0

				if victimTeam == TEAM_CP then
					currentCount = DG_CPBSLCOUNT
				elseif victimTeam == TEAM_OTA then
					currentCount = DG_OTABSLCOUNT
				elseif victimTeam == TEAM_CA then
					currentCount = DG_OCABSLCOUNT
				end

				net.Start(netMsg)
				net.WriteUInt(currentCount, 6)
				net.Broadcast()

				net.Start(staffMsg)
				net.WriteUInt(currentCount, 6)
				net.Broadcast()
            end)
        end
    end

    if isCP then
        local points = 0
        if victimTeam == TEAM_CP then
            local rank = victim:GetTeamRank()
            if rank ~= nil and RANK_DVL ~= nil and RANK_CMD ~= nil then
                points = (rank < RANK_DVL) and 8 or (rank == RANK_CMD) and 34 or 8
            else
                points = 8
            end
        elseif victimTeam == TEAM_OTA then
            local rank = victim:GetTeamRank()
            if rank ~= nil and RANK_ORD ~= nil and RANK_CSC ~= nil then
                if rank < RANK_ORD then
                    points = 8
                elseif rank == RANK_ORD then
                    points = 34
                elseif rank == RANK_CSC then
                    points = 67
                end
            else
                points = 8
            end
        end

        if points > 0 then
            DG_SOCIOSTABILITYSCORE_REAL = DG_SOCIOSTABILITYSCORE_REAL + points
            DG_SOCIOSTABILITYSCORE = math.min(DG_SOCIOSTABILITYSCORE_REAL, 100)

            net.Start("DeepSociostabilityScore")
            net.WriteUInt(DG_SOCIOSTABILITYSCORE, 8)
            net.Broadcast()

            timer.Simple(600, function()
                DG_SOCIOSTABILITYSCORE_REAL = DG_SOCIOSTABILITYSCORE_REAL - points
                DG_SOCIOSTABILITYSCORE = math.Clamp(DG_SOCIOSTABILITYSCORE_REAL, 0, 100)

                net.Start("DeepSociostabilityScore")
                net.WriteUInt(DG_SOCIOSTABILITYSCORE, 8)
                net.Broadcast()
            end)
        end
    end
end)

-- ADDED: Fail safes to the bsl counter, this caused a duping gltich, player would die on unranked and get instantly respawned while keeping items in inv