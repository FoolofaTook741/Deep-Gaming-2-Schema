AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "RPG"
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
        local mins, maxs = Vector(-23.5, -3.0, -3.3), Vector(20.5, 9.0, 3.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_rpg.mdl")

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
        activator:Give("weapon_rpg_nch")
        if not activator.FirstPickUpRPG then
            activator:SelectWeapon("weapon_rpg_nch")
        end
        activator:GiveAmmo(1, "bmsw_rpgmissile")
        self:Remove()
    end
end