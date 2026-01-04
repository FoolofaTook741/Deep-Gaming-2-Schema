if ( CLIENT ) then
    SWEP.PrintName      = "Conduit Deployer"
    SWEP.Slot           = 1
    SWEP.SlotPos        = 2
    SWEP.DrawAmmo       = false
    SWEP.DrawCrosshair  = true
end

SWEP.Author            = "Abarden"
SWEP.Purpose           = "Deploy or dismantle energy conduits."
SWEP.Instructions      = "Left-click to place. Right-click to remove."
SWEP.Spawnable         = true
SWEP.AdminOnly         = false

SWEP.ViewModel         = "models/weapons/v_turret.mdl"
SWEP.WorldModel        = "models/props_combine/combine_light001a.mdl"

if CLIENT then
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
                        + holdAng:Forward() * 12 -- forward
                        + holdAng:Right() * 0 -- sideways
                        + holdAng:Up() * -6 -- vertical

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
end

SWEP.Primary = {
    ClipSize    = -1,
    DefaultClip = -1,
    Automatic   = false,
    Ammo        = "None",
}

function SWEP:Initialize()
    self:SetWeaponHoldType("slam")
    self.Conduits = {}
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
	

    local owner = self:GetOwner()
    if #self.Conduits >= 2 then
        self:EmitSound("Engi.Block")
        return
    end

    local tr = owner:GetEyeTrace()
    if tr.HitPos:DistToSqr(owner:GetPos()) > (100*100) then
        self:EmitSound("Engi.Block")
        return
    end

    local ent = ents.Create("pg_energyconduit")
    if not IsValid(ent) then
        self:EmitSound("Engi.Block")
        return
    end

    local ang = Angle(0, owner:EyeAngles().y, 0)
    local pos = Vector(tr.HitPos.x, tr.HitPos.y, owner:GetPos().z)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetMoveType(MOVETYPE_NONE)
    ent:Spawn()
    ent:Activate()

    table.insert(self.Conduits, ent)
    cleanup.Add(owner, "props", ent)

    self:EmitSound("Engi.Place")
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end

    local owner = self:GetOwner()
    local tr    = owner:GetEyeTrace()
    local ent   = tr.Entity

    if not IsValid(ent) or ent:GetClass() ~= "pg_energyconduit" then
        self:EmitSound("Engi.Block")
        return
    end

    self:EmitSound("Engi.Remove")
    local dissolver = ents.Create("env_entity_dissolver")
    dissolver:SetKeyValue("dissolvetype", "3")
    dissolver:SetKeyValue("magnitude", "1")
    dissolver:SetPos(ent:GetPos())
    dissolver:SetOwner(owner)
    dissolver:Spawn()

    local name = "Kill_"..self:EntIndex().."_"..ent:EntIndex()
    ent:SetName(name)
    dissolver:Fire("Dissolve", name, 0)
    dissolver:Fire("kill",    "",    0.1)

    for i,v in ipairs(self.Conduits) do
        if v == ent then
            table.remove(self.Conduits, i)
            break
        end
    end

    self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:OnRemove()
    if SERVER then
        for _, v in ipairs(self.Conduits) do
            if IsValid(v) then v:Remove() end
        end
    end
end
