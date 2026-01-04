AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "RPG Missile"
ENT.Author = ""
ENT.Information = "Missile for RPG"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-3.5, -3.5, -9.3), Vector(3.5, 3.5, 9.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_rpgammo.mdl")

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
        activator:GiveAmmo(1, "bmsw_rpgmissile")
        self:Remove()
    end
end