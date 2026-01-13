local SHIELD_MODEL = "models/hunter/tubes/circle4x4.mdl"
local SHIELD_MAT   = "effects/bluelaser2"
local SHIELD_SCALE = 0.55

function meta:DrawWallhammerShield(wep)
    if not IsValid(self) or not IsValid(wep) then return end

    local ply = self

    -- remove if not valid conditions
    if wep:GetClass() ~= "plutonic_osish" or ply.ShieldActive ~= true or (ply.IsWeaponRaised and not ply:IsWeaponRaised()) then
        if IsValid(ply.shield) then
            ply.shield:Remove()
            ply.shield = nil
        end
        return
    end

    -- spawn once
    if not IsValid(ply.shield) then
        local shield = ents.Create("dg_shield")
        if not IsValid(shield) then return end

        shield:SetModel(SHIELD_MODEL)
        shield:SetMaterial(SHIELD_MAT)
        shield:SetModelScale(SHIELD_SCALE, 0)

        shield:CPPISetOwner(ply)
        shield:Spawn()

		shield:SetParent(ply)
		shield:SetLocalPos(Vector(40, 0, ply:Crouching() and 25 or 40))
		shield:SetLocalAngles(Angle(90, 0, 0))

        shield:SetNWEntity("dg_shield_owner", ply)

        shield:DrawShadow(false)
        shield:DrawShadow(false)

        shield:SetCollisionGroup(COLLISION_GROUP_NONE)

        local phys = shield:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
            phys:Wake()
        end

        ply.shield = shield
    end

    local forward = ply:GetForward()
	local z = ply:Crouching() and 25 or 40
	ply.shield:SetLocalPos(Vector(52, 0, z))
	ply.shield:SetLocalAngles(Angle(90, 0, 0))

    --ply.shield:SetPos(pos)
    --ply.shield:SetAngles(ang)
end
