if SERVER then
    local NPCRelations = {
        npc_citizen      = { Citizen = D_NU, Combine = D_HT, Zombie = D_HT, Antlion = D_HT },
        npc_metropolice  = { Citizen = D_HT, Combine = D_NU, Zombie = D_HT, Antlion = D_HT },
        npc_antlion      = { Citizen = D_HT, Combine = D_HT, Zombie = D_HT, Antlion = D_NU },
        npc_zombie       = { Citizen = D_HT, Combine = D_HT, Zombie = D_NU, Antlion = D_HT }
    }

    local RecognizedEnts = setmetatable({}, { __mode = 'k' })
    local PlayerFactionCache = {}

    local NPCTypes = { Citizen = "npc_citizen", Combine = "npc_metropolice", Zombie = "npc_zombie", Antlion = "npc_antlion" }

    local function NPCSpawned(ent)
        local r = NPCRelations[ent:GetClass()]
        if not r then
            r = {}
            for k, v in pairs(NPCTypes) do
                local e = ents.Create(v)
                e:Spawn()
                local n = ent:Disposition(e)
                e:Remove()
                r[k] = n
            end
            NPCRelations[ent:GetClass()] = r
        end
        RecognizedEnts[ent] = true
    end

    local function GetPlayerFaction(ply)
        if PlayerFactionCache[ply] then return PlayerFactionCache[ply] end

        local faction
        if ply:GetMoveType() == MOVETYPE_NOCLIP and (ply:IsAdmin() or ply:IsGameMaster()) then
            faction = "Nobody"
        elseif ply:IsRebel() or (ply:Team() == TEAM_VORT and ply:GetBodygroup(8) == 0 and ply:GetBodygroup(7) == 0) then
            faction = "Citizen"
        elseif ply:IsCP() then
            faction = "Combine"
        elseif ply:Team() == TEAM_ZOMBIE then
            faction = "Zombie"
        else
            faction = "Citizen"
        end

        PlayerFactionCache[ply] = faction
        return faction
    end

    local function UpdateNPCRelationships(npc)
        if not IsValid(npc) or not npc:IsNPC() or npc:IsPlayer() or npc:GetClass():match("^npc_turret_") then return end
        if npc.IsPlayerOwned then return end

        if not RecognizedEnts[npc] then NPCSpawned(npc) end
        local cls = npc:GetClass()

        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) then
                local faction = GetPlayerFaction(ply)
                local relation = NPCRelations[cls][faction] or D_NU
                npc:AddEntityRelationship(ply, relation, 0)
            end
        end
    end

    timer.Create("NPCRelationshipUpdater", 1, 0, function()
        for _, npc in ipairs(ents.FindByClass("npc_*")) do
            UpdateNPCRelationships(npc)
        end
    end)

    -- Clear player cache on spawn/team change
    hook.Add("PlayerSpawn", "ClearFactionCache", function(ply)
        PlayerFactionCache[ply] = nil
    end)
    hook.Add("OnPlayerChangedTeam", "ClearFactionCache", function(ply)
        PlayerFactionCache[ply] = nil
    end)
end
