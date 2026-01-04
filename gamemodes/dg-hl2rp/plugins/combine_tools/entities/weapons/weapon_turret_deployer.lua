
    SWEP.PrintName      = "Turret Deployer"
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.DrawAmmo       = false
    SWEP.DrawCrosshair  = true

    SWEP.ViewModel      = "models/weapons/v_turret.mdl"
    SWEP.WorldModel     = "models/combine_turrets/floor_turret.mdl"

    function SWEP:DrawWorldModel()
        local ply = self:GetOwner()
        if IsValid(ply) and ply:IsPlayer() then
            local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
            if bone then
                local m = ply:GetBoneMatrix(bone)
                if m then
                    local handPos, handAng = m:GetTranslation(), m:GetAngles()
                    local yaw = handAng.y
                    local holdAng = Angle(0, yaw, 0)

                    local mins, maxs = self:GetModelBounds()
                    local centerLocal = (mins + maxs) * 0.5

                    local basePos = handPos
                        + holdAng:Forward() * 12
                        + holdAng:Right() * 0
                        + holdAng:Up() * -6

                    local worldCenter = basePos
                        - holdAng:Forward() * centerLocal.x
                        - holdAng:Right() * centerLocal.y
                        - holdAng:Up() * centerLocal.z

                    self:SetRenderOrigin(worldCenter)
                    self:SetRenderAngles(holdAng)
                    self:DrawModel()
                    self:SetRenderOrigin(nil)
                    self:SetRenderAngles(nil)
                    return
                end
            end
        end

        self:DrawModel()
    end

SWEP.Author         = "Abarden"
SWEP.Purpose        = "Deploy Combine turrets."
SWEP.Instructions   = "Left-click to place; Right-click to pick up."
SWEP.Spawnable      = true
SWEP.AdminOnly      = false

SWEP.Primary = {
    ClipSize        = -1,
    DefaultClip     = -1,
    Automatic       = false,
    Ammo            = "None",
}


function SWEP:Initialize()
    self:SetWeaponHoldType("slam")
    self.Turret = nil
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ply = self:GetOwner()
    local tr  = ply:GetEyeTrace()

    if IsValid(self.Turret) then
        self:EmitSound("Engi.Block")
        return
    end

    if tr.HitPos:DistToSqr(ply:GetPos()) > (100 * 100) then
        self:EmitSound("Engi.Block")
        return
    end

    -- spawn the turret
    local turret = ents.Create("pg_turret")
    if not IsValid(turret) then
        self:EmitSound("Engi.Block")
        return
    end

    local ang = Angle(0, ply:EyeAngles().y, 0)
    local pos = Vector(tr.HitPos.x, tr.HitPos.y, ply:GetPos().z)

    turret:SetPos(pos)
    turret:SetAngles(ang)
    turret:SetMoveType(MOVETYPE_NONE)
    turret:Spawn()
    turret:Activate()
    turret:SetOwner(ply)

    cleanup.Add(ply, "props", turret)
    self.Turret = turret

    self:EmitSound("Engi.Place")
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    if not IsValid(self.Turret) then return end

    self:EmitSound("Engi.Remove")
    local dissolver = ents.Create("env_entity_dissolver")
    dissolver:SetKeyValue("dissolvetype", "3")
    dissolver:SetKeyValue("magnitude", "1")
    dissolver:SetPos(self.Turret:GetPos())
    dissolver:SetOwner(self:GetOwner())
    dissolver:Spawn()

    local name = "Kill_" .. self:EntIndex() .. "_" .. self.Turret:EntIndex()
    self.Turret:SetName(name)
    dissolver:Fire("Dissolve", name, 0)
    dissolver:Fire("kill",    "",    0.1)

    self.Turret = nil
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:OnRemove()
    if SERVER then
        self:SecondaryAttack()
    end
end
