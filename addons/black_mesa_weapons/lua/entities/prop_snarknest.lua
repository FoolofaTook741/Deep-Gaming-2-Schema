AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"

ENT.PrintName = "Snark Nest"
ENT.Author = ""
ENT.Information = "Sharks"
ENT.Category = "BMS Ammo"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        local mins, maxs = Vector(-9.5, -9.5, -0.5), Vector(9.5, 9.5, 9.5)
        self:PhysicsInitBox(mins, maxs)

        self:SetModel("models/weapons/bms_wal/snark_nest.mdl")
        --timer.Simple(0, function() self:ResetSequenceInfo() end)
        self:SetUseType(SIMPLE_USE)
      --  self:SetSequence(0)

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:SetMaterial("material")
            phys:EnableMotion(true)
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        activator:Give("weapon_shark_nch")
        if not activator.FirstPickUpSnark then
            activator:SelectWeapon("weapon_shark_nch")
        end
        activator:GiveAmmo(5, "bmsw_snark")
        self:Remove()
    end
end