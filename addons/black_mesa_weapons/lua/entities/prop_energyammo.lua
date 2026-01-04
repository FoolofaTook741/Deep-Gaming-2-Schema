AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Gaus Ammo"
ENT.Author = ""
ENT.Information = "Ammo for gluon and tau cannon"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-5.5, -7.5, -3.3), Vector(5.5, 7.5, 3.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/w_gaussammo.mdl")

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
        activator:GiveAmmo(20, "energyammo")
        self:Remove()
    end
end