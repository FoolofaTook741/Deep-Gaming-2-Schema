AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Satchel"
ENT.Author = ""
ENT.Information = "Satchel"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-5.5, -7.5, 1), Vector(5.5, 7.5, 6)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_satchel.mdl")

        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:SetMaterial("material")
            phys:EnableMotion(true)
            phys:SetMass(15)
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        activator:Give("weapon_satchel_nch")
        if not activator.FirstPickUpSatchel then
            activator:SelectWeapon("weapon_satchel_nch")
        end
        activator:GiveAmmo(1, "bmsw_satchel")
        self:Remove()
    end
end