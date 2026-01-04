AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Crossbow bolts"
ENT.Author = ""
ENT.Information = "Ammo for Crossbow"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-3.9, -2.9, -0), Vector(4.5, 2.9, 4.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_crossbow_clip.mdl")

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
        activator:GiveAmmo(5, "bmsw_crossbow")
        self:Remove()
    end
end