AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Spas 12"
ENT.Author = ""
ENT.Information = "Spas 12"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-0, -0.0, -3.3), Vector(29, 2.0, 3.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_shotgun.mdl")

        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:SetMaterial("material")
            phys:EnableMotion(true)
            phys:SetMass(19)
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        activator:Give("weapon_spas12_nch")
        if not activator.FirstPickUpShotgun then
            activator:SelectWeapon("weapon_spas12_nch")
        end
        activator:GiveAmmo(8, "bmsw_shotgun")
        self:Remove()
    end
end