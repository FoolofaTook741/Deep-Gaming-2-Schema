local ALWAYS_PIERCE = {
    [MAT_GLASS] = true,
    [MAT_VENT] = true,
    [MAT_GRATE] = true
}

Plutonic.Framework.FireBullets = function(self, bullet, SuppressHostEvents)
    local num_bullets = bullet.Num or 1
    local spread = bullet.Spread or Vector(0, 0, 0)
    local damage = bullet.Damage or 0
    
    bullet.Callback = function(attacker, tr)
        --ParticleEffect("muzzleflash_1", tr.StartPos, tr.HitNormal:Angle(), nil)
        
        -- Only pierce if the weapon has Primary.Piercing enabled AND it's a pierceable material
        if self.Primary.Piercing and ALWAYS_PIERCE[tr.MatType] and not pierce_shot then
            -- Find the exit point
            local exitPoint = util.TraceLine({
                start = tr.HitPos + tr.Normal * 16,
                endpos = tr.HitPos,
                filter = attacker,
                mask = MASK_SHOT
            })

            if exitPoint.Hit then
                local newbullet = {
                    Num = num_bullets,
                    Src = exitPoint.HitPos,
                    Dir = tr.Normal,
                    Spread = spread,
                    Tracer = 9999,
                    Force = 1,
                    Damage = damage / 1.6,
                    AmmoType = "Pistol"
                }
                self:GetOwner():FireBullets(newbullet)
            end
        end

        util.ParticleTracerEx("Tracer", tr.StartPos, tr.HitPos, true, self:EntIndex(), 1)
        
        if self.CanBreachDoors and impulse and IsValid(tr.Entity) and tr.Entity:IsDoor() and tr.Entity:GetClass() == "prop_door_rotating" then
            local door = tr.Entity
            local hp = door.__BREACH_HEALTH or 80
            door.__BREACH_HEALTH = hp - self.Primary.Damage
            
            if door.__BREACH_HEALTH <= 0 then
                door:SetNotSolid(true)
                door:SetNoDraw(true)
                door:EmitSound("Metal_Box.Break", 140)
                door:DoorUnlock()
                door:Fire("open", "", 0)
                door:Fire("lock", "", 1.2)
                
                if door:GetClass() == "prop_door_rotating" then
                    local fakeDoor = ents.Create("prop_physics")
                    fakeDoor:SetModel(door:GetModel())
                    fakeDoor:SetPos(door:GetPos())
                    fakeDoor:SetAngles(door:GetAngles())
                    fakeDoor:SetSkin(door:GetSkin())
                    fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD)
                    fakeDoor:Spawn()
                    fakeDoor:GetPhysicsObject():SetVelocity(attacker:GetForward() * 250)
                    
                    timer.Simple(impulse.Config.ExplosionDoorRespawnTime, function()
                        fakeDoor:Remove()
                    end)
                end

                timer.Simple(impulse.Config.ExplosionDoorRespawnTime, function()
                    door:DoorUnlock()
                    door:SetNotSolid(false)
                    door:SetNoDraw(false)
                    door.__BREACH_HEALTH = 80
                    door.IsCharged = false
                end)
            end
        end
    end

    self:GetOwner():FireBullets(bullet, SuppressHostEvents)
end