AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)  
	self:SetMoveType(SOLID_VPHYSICS)  
	self:SetSolid(SOLID_VPHYSICS)   
	self:SetUseType(SIMPLE_USE)
	self:GetPhysicsObject():Wake()
end

function ENT:Use(ply)
    ply:Notify("You drank the water, and have restored "..self.HungerValue.." hunger.")
    self:Remove()
end
