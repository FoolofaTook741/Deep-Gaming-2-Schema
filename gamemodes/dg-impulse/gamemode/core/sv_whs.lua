local SHIELD_MODEL = "models/hunter/tubes/circle4x4.mdl"
local SHIELD_MAT   = "effects/bluelaser2"
local SHIELD_SCALE = 0.55

local function shieldLocalPos(ply)
    return Vector(52, 0, ply:Crouching() and 25 or 40)
end

function meta:DrawWallhammerShield(wep)
    if not IsValid(self) or not IsValid(wep) then return end
    local ply = self

    if wep:GetClass() ~= "plutonic_osish" or ply.ShieldActive ~= true or (ply.IsWeaponRaised and not ply:IsWeaponRaised()) then
        if IsValid(ply.shield) then
            ply.shield:Remove()
            ply.shield = nil
        end
        return
    end

    if not IsValid(ply.shield) then
        local shield = ents.Create("dg_shield")
        if not IsValid(shield) then return end

        shield:SetModel(SHIELD_MODEL)
        shield:SetMaterial(SHIELD_MAT)
        shield:SetModelScale(SHIELD_SCALE, 0)

        shield:CPPISetOwner(ply)
        shield:Spawn()

        shield:SetParent(ply)
        shield:SetLocalAngles(Angle(90, 0, 0))
        shield:SetLocalPos(shieldLocalPos(ply))

        shield:SetNWEntity("dg_shield_owner", ply)

        shield:DrawShadow(false)
        ply.shield = shield
        ply._shieldWasCrouching = ply:Crouching()
        return
    end

    local sh = ply.shield
    if ply._shieldWasCrouching ~= ply:Crouching() then
        ply._shieldWasCrouching = ply:Crouching()
        sh:SetLocalPos(shieldLocalPos(ply))
    end
end


