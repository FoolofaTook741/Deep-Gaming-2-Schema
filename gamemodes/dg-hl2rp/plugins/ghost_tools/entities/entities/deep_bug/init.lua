AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/bo/weapons/tactical beacon.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Durability = 5
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if activator:Team() == TEAM_CP and activator:GetTeamClass() == CLASS_GHOST then
		self:Remove()
		activator:Notify("You have picked up a motion sensor.")
		activator:GiveInventoryItem("item_audiobug", 1, true)
	else
		activator:Notify("You cannot interact with this item.")
	end
end

function ENT:OnTakeDamage(dmginfo)
	local id = self:GetCreationID()
	local dmg = dmginfo:GetDamage()
	self.Durability = self.Durability - dmg
	if self.Durability <= 0 then
		self:Remove()
		local pos = self:GetPos()
		for k,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_CP and (v:GetTeamClass() == CLASS_GHOST) then
				v:SendCombineMessage("AUDIO BUGGING DEVICE #" .. id .. " DESTROYED.", Color(80, 60, 0))
			end
		end
	end
end
