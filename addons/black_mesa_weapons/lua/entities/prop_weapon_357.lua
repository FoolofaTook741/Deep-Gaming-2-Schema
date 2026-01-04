AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Magnum"
ENT.Author = ""
ENT.Information = "RPG"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-8, 4.0, 1), Vector(6, -2.0, -1)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_357.mdl")

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
        activator:Give("weapon_357_nch")
        if not activator.FirstPickUp357 then
            activator:SelectWeapon("weapon_357_nch")
        end
        activator:GiveAmmo(6, "bmsw_357")
        self:Remove()
    end
end