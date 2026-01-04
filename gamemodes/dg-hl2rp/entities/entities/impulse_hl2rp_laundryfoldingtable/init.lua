AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/controlroom_desk001a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger(true)
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "impulse_hl2rp_laundryitem" then
		ent.isFoldable = true
	end
end
