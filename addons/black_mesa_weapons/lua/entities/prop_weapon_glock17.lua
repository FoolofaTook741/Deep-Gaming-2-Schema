AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Glock 18"
ENT.Author = ""
ENT.Information = "Glock 18"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
--[[
if CLIENT then
    local mins, maxs = Vector(-4, 0.0, -5.3), Vector(4, 2.0, 1.3)
    function ENT:Draw()
        self:DrawModel()
        render.DrawBox( self:GetPos(), self:GetAngles(), mins, maxs, Color(255,0,0))
    end
end
]]
if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-4, 0.0, -5.3), Vector(4, 2.0, 1.3)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/w_glock.mdl")

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
        activator:Give("weapon_glock17_nch")
        if not activator.FirstPickUpGlock then
            activator:SelectWeapon("weapon_glock17_nch")
        end
        activator:GiveAmmo(18, "bmsw_9mm")
        self:Remove()
    end
end