AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/bo/weapons/acoustic motion sensor deployed.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Durability = 30
	self.thinks = 0
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if activator:Team() == TEAM_CP and activator:GetTeamClass() == CLASS_GHOST then
		self:Remove()
		activator:Notify("You have picked up a motion sensor.")
		activator:GiveInventoryItem("item_motionsensor", 1, true)
	else
		activator:Notify("You cannot interact with this item.")
	end
end

function ENT:Triggered()
	local id = self:GetCreationID()
	if !timer.Exists(id .. "beepcooldown") then
		for k,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
				v:SendCombineMessage("MOTION SENSOR #" .. id .. " TRIGGERED.", Color(255, 233, 0)) 
			end
		end
	end
	timer.Create(id.."beepcooldown", 6, 1, function() timer.Remove(id.."beepcooldown") end)
	self:EmitSound(Sound("motionsensortriggered"))
end

function ENT:Think()
	local triggered = false
	for k,v in pairs(player.GetAll()) do
		if v:IsCP() == false then
			if v:IsNearMotionSensor(self) then
				triggered = true
				break
			end
		end
	end
	if triggered == true then
		self:Triggered()
	end
	if self.thinks == 15 then
		self:EmitSound("scramble/ui_motiontracker_pong1.wav")
		nextbeep = CurTime() + 15
		self.thinks = 0
	end
	self:NextThink(CurTime() + 2)
	self.thinks = self.thinks + 2
	return true
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
				v:SendCombineMessage("MOTION SENSOR #" .. id .. " DESTROYED.", Color(80, 60, 0))
			end
		end
	end
end
