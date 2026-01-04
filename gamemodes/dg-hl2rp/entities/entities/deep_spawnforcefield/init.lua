AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/hunter/plates/plate2x5.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Think()
	if impulse.Dispatch.GetCityCode() >= CODE_JW && self:GetCollisionGroup() != COLLISION_GROUP_NONE then
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetMaterial("effects/combineshield/comshieldwall2")
	elseif self:GetCollisionGroup() != COLLISION_GROUP_WORLD && impulse.Dispatch.GetCityCode() < CODE_JW then
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetMaterial("effects/combineshield/comshieldwall2")
	end
	if self:GetMaterial() != "effects/combineshield/comshieldwall2" then
		self:SetMaterial("effects/combineshield/comshieldwall2")
	end
	self:NextThink( CurTime() + 1)
    return true
end