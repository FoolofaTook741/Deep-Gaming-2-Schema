if SERVER then
    local maxPortals = 6 -- Maximum number of portals allowed at one time
    local spawnTimer = 3600 -- Spawn timer in seconds
    local vortPortalSpawnPos = impulse.Config.vortPortalSpawnPos
	if not vortPortalSpawnPos then return end

    local portalTypes = {
        { class = "deep_vortportal_low", weight = 70 },
        { class = "deep_vortportal_mid", weight = 25 },
        { class = "deep_vortportal_high", weight = 5 }
    }

    local function getPortal()
        local totalWeight = 0
        for _, data in ipairs(portalTypes) do
            totalWeight = totalWeight + data.weight
        end
        local rand = math.random(1, totalWeight)
        for _, data in ipairs(portalTypes) do
            rand = rand - data.weight
            if rand <= 0 then
                return data.class
            end
        end
    end

    local function occupied(spawnPos)
        for _, data in ipairs(portalTypes) do
            local portals = ents.FindByClass(data.class)
            for _, portal in ipairs(portals) do
                if portal:GetPos():Distance(spawnPos) < 50 then
                    return true
                end
            end
        end
        return false
    end

    local function unusedSpawn()
        local found = {}
        for _, spawnPos in ipairs(vortPortalSpawnPos) do
            if not occupied(spawnPos) then
                table.insert(found, spawnPos)
            end
        end
        if #found > 0 then
            return table.Random(found)
        end
        return nil
    end

    local function spawn()
        local totalPortals = 0
        for _, data in ipairs(portalTypes) do
            totalPortals = totalPortals + #ents.FindByClass(data.class)
        end

        if totalPortals < maxPortals then
            local portalsToSpawn = maxPortals - totalPortals
            local notify = false
            for i = 1, portalsToSpawn do
                local spawnPos = unusedSpawn()
                if spawnPos then
                    local portalType = getPortal()
                    local portal = ents.Create(portalType)
                    if IsValid(portal) then
                        portal:SetPos(spawnPos)
                        portal:Spawn()
                        if not notify and portal:GetBodygroup(8) ~= 1 then
                            for _, ply in ipairs(player.GetAll()) do
                                if ply:Team() == TEAM_VORT then
                                    ply:Notify("You sense a surge of Xen energy")
                                end
                            end
                            notify = true
                        end
                    end
                end
            end
        end
    end

    hook.Add("InitPostEntity", "InitialVortPortalSpawn", function()
        spawn()
    end)

    timer.Create("vortSkillPortalTimer", spawnTimer, 0, function()
        spawn()
    end)
end
