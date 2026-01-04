AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua") 

include("shared.lua")

function ENT:Initialize()
    self:SetModel(Model("models/hls/alyxports/monitor_medium.mdl"))
    self:SetBodyGroups(0)
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetMoveType(MOVETYPE_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:ResetSequence(self:LookupSequence("close_idle"))
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
       phys:Wake()
    end
end