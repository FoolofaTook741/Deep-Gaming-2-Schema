impulse.RagdollFizzleZones = impulse.RagdollFizzleZones or {}

local function AddRagdollFizzleZone(data)
    local mins = Vector(
        math.min(data.pos1.x, data.pos2.x),
        math.min(data.pos1.y, data.pos2.y),
        math.min(data.pos1.z, data.pos2.z)
    )
    local maxs = Vector(
        math.max(data.pos1.x, data.pos2.x),
        math.max(data.pos1.y, data.pos2.y),
        math.max(data.pos1.z, data.pos2.z)
    )

    impulse.RagdollFizzleZones[data.name] = {mins = mins, maxs = maxs}
end

AddRagdollFizzleZone({name = "ragdollfizzle1", pos1 = Vector(-819.23693847656, 4655.908203125, 70.673377990723), pos2 = Vector(-674.54473876953, 4318.7846679688, -193.86051940918)})
AddRagdollFizzleZone({name = "ragdollfizzle2", pos1 = Vector(-326.84661865234, 5590.6079101563, 7994.7416992188), pos2 = Vector(-521.20452880859, 6105.7353515625, 8150.1049804688)})
AddRagdollFizzleZone({name = "ragdollfizzle3", pos1 = Vector(7638.119140625, -123.09993743896, 6689.6918945313), pos2 = Vector(7420.34765625, -651.41143798828, 6946.5073242188)})
AddRagdollFizzleZone({name = "ragdollfizzle4", pos1 = Vector(7664.0341796875, -106.89172363281, 165.01664733887), pos2 = Vector(7386.3935546875, -693.77673339844, -171.12861633301)})

local function AABBOverlap(mins1, maxs1, mins2, maxs2)
    return mins1.x <= maxs2.x and maxs1.x >= mins2.x
       and mins1.y <= maxs2.y and maxs1.y >= mins2.y
       and mins1.z <= maxs2.z and maxs1.z >= mins2.z
end

local function RagdollDissolve(ent, position, attacker, dissolveType)
    local Dissolver = ents.Create("env_entity_dissolver")
    if not IsValid(Dissolver) then return end

    timer.Simple(5, function()
        if IsValid(Dissolver) then
            Dissolver:Remove()
        end
    end)

    Dissolver.Target = "dissolve"..ent:EntIndex()
    Dissolver:SetKeyValue("dissolvetype", dissolveType)
    Dissolver:SetKeyValue("magnitude", 0)
    Dissolver:SetPos(position)
    Dissolver:SetPhysicsAttacker(attacker)
    Dissolver:Spawn()

    ent:SetName(Dissolver.Target)

    Dissolver:Fire("Dissolve", Dissolver.Target, 0)
    Dissolver:Fire("Kill", "", 0.01)

    return Dissolver
end

timer.Create("Impulse_RagdollFizzleCheck", .5, 0, function()
    for _, ragdoll in ipairs(ents.FindByClass("prop_ragdoll")) do
        if ragdoll.Fizzling then continue end
        if ragdoll:GetNWBool("IsKnockoutRagdoll", false) then continue end

        local rMins, rMaxs = ragdoll:WorldSpaceAABB()

        for name, zone in pairs(impulse.RagdollFizzleZones) do
            if AABBOverlap(rMins, rMaxs, zone.mins, zone.maxs) then
                ragdoll.Fizzling = true
                RagdollDissolve(ragdoll, ragdoll:GetPos(), game.GetWorld(), 0)
                break
            end
        end
    end
end)