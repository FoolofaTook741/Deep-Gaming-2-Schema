AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/hunter/plates/plate3x3.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Active = true
	self.NextActivation = 0
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetContents(CONTENTS_GRATE)
	end
end

function ENT:Think()
	local phys = self:GetPhysicsObject()
	phys:SetContents(CONTENTS_GRATE)
	if self.Active == false then
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetNotSolid(true)
		self:SetMaterial("Models/effects/vol_light001")
	elseif self.Active == true then
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetNotSolid(false)
		self:SetMaterial("effects/combineshield/comshieldwall2")
	end
	self:NextThink( CurTime() + 1)
    return true
end

function ENT:Use(activator)
	if self.NextActivation > CurTime() then
		activator:Notify("You cannot use this right now.")
		return
	end 
	if activator:Team() == TEAM_CP and activator:GetTeamClass() and activator:GetTeamClass() == CLASS_GRID and activator:GetTeamRank() >= RANK_I4 then
		if self.Active == true then
			self.Active = false
			self:SetMaterial("Models/effects/vol_light001")
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetNotSolid(true)
			self:EmitSound("buttons/combine_button5.wav")
			self.NextActivation = CurTime() + 4
		elseif self.Active == false then
			self.Active = true
			self:SetMaterial("effects/combineshield/comshieldwall2")
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetNotSolid(false)
			self:EmitSound("buttons/combine_button5.wav")
			self.NextActivation = CurTime() + 4
		end
	elseif activator:IsCPCommand() then
		if self.Active == true then
			self.Active = false
			self:SetMaterial("Models/effects/vol_light001")
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetNotSolid(true)
			self:EmitSound("buttons/combine_button5.wav")
			self.NextActivation = CurTime() + 4
		elseif self.Active == false then
			self.Active = true
			self:SetMaterial("effects/combineshield/comshieldwall2")
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetNotSolid(false)
			self:EmitSound("buttons/combine_button5.wav")
			self.NextActivation = CurTime() + 4
		end
	end
end