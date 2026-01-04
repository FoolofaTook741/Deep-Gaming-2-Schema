

function impulse.MakeBigExplosion(ent, magnitude, debrisCount)
    local debris = {}
    local splitMark = ((debrisCount or 9) * .45)

    for i=1,(debrisCount or 9) do
        local flyer = ents.Create("prop_physics")
        flyer:SetPos(ent:GetPos())

        if i > splitMark then
            flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
        else
            flyer:SetModel("models/combine_helicopter/bomb_debris_"..math.random(2, 3)..".mdl")
        end

        flyer:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        flyer:Spawn()
        flyer:Ignite(40)

        local phys = flyer:GetPhysicsObject()

        if phys and IsValid(phys) then
            phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
        end

        table.insert(debris, flyer)
    end

    timer.Simple(50, function()
        for v,k in pairs(debris) do
            if IsValid(k) then
                k:Remove()
            end
        end
    end)

    local explodeEnt = ents.Create("env_explosion")
    explodeEnt:SetPos(ent:GetPos())

    if IsValid(ent.Placer) then
        explodeEnt:SetOwner(ent.Placer)
    end 

    explodeEnt:Spawn()
    explodeEnt:SetKeyValue("iMagnitude", magnitude)
    explodeEnt:Fire("explode", "", 0)

    local fire = ents.Create("env_fire")
    fire:SetPos(ent:GetPos())
    fire:Spawn()
    fire:Fire("StartFire")

    timer.Simple(60, function()
        if IsValid(fire) then
            fire:Remove()
        end
    end)

    local effectData = EffectData()
    effectData:SetOrigin(ent:GetPos())
    util.Effect("Explosion", effectData)

    ent:EmitSound("weapons/c4/c4_explode1.wav", 500)
    ent:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
    ent:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
    ent:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

    for v,k in pairs(player.GetAll()) do
        k:SurfacePlaySound("ambient/levels/streetwar/city_battle7.wav")
    end

    util.ScreenShake(ent:GetPos(), 4, 2, 2.5, 100000)

    ent:Remove()

    local pos = ent:GetPos()

    timer.Simple(0.1,function()
        for v,k in ipairs(player.GetAll()) do
            if k:GetPos():DistToSqr(pos) < (1200 ^ 2) then
                if k:Alive() then
                    net.Start("impulseHL2RPTearGasFX")
                    net.WriteFloat(20.6)
		            net.Send(k)
                end
            end
        end
    end)

    timer.Simple(1, function()
        for v,k in pairs(ents.FindByClass("prop_ragdoll")) do
            if k:GetPos():DistToSqr(pos) < (1200 ^ 2) then
                k:Ignite(50)
            end
        end
    end)
end