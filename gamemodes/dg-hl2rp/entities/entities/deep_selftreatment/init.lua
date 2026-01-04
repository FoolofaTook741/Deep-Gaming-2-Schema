AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Items/HealthKit.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function GetTotalMedics()
	local medics = 0
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CWU && v:GetTeamClass() == CLASS_MEDIC then
			medics = medics + 1
		end
	end
	return medics
end


function ENT:Use( activator, caller )
	if activator:Team() != TEAM_ZOMBIE then
		if activator:Team() == TEAM_CWU and activator:GetTeamClass() == CLASS_MEDIC then
			if activator:Health() < 100 then
				activator:SetHealth(90 * (1 - (activator.Antiheal or 0)))
				activator:FixLegs()
				self:EmitSound("hl1/fvox/boop.wav")
			elseif activator:Health() >= 100 then
				activator:Notify("You do not need to use this device.")
				self:EmitSound("hl1/fvox/fuzz.wav")
			end
		elseif GetTotalMedics() <= 0 then
			if activator:Health() < activator:GetMaxHealth() && activator:GetMoney() >= 75 then
				activator:TakeMoney(75)
				activator:SetHealth(activator:GetMaxHealth() * (1 - (activator.Antiheal or 0)))
				activator:FixLegs()
				self:EmitSound("hl1/fvox/boop.wav")
				activator:Notify("You have spent 75 credits to treat your wounds.")
			elseif activator:Health() >= 100 then
				activator:Notify("You do not need to use this device.")
				self:EmitSound("hl1/fvox/fuzz.wav")
			else
				activator:Notify("You need 75 credits to use this device.")
				self:EmitSound("hl1/fvox/fuzz.wav")
			end
		else
			if activator:Health() < activator:GetMaxHealth() && activator:GetMoney() >= 250 then
				activator:TakeMoney(250)
				activator:SetHealth(activator:GetMaxHealth() * (1 - (activator.Antiheal or 0)))
				activator:FixLegs()  
				self:EmitSound("hl1/fvox/boop.wav")
				activator:Notify("You have spent 250 credits to treat your wounds.")
				for k,v in pairs(player.GetAll()) do
					if v:Team() == TEAM_CWU and v:GetTeamClass() == CLASS_MEDIC then
						local amount = math.floor(100/GetTotalMedics())
						v:GiveMoney(amount)
						v:Notify("You have received " .. amount .. " credits from the self treatment station.")
					end
				end
			elseif activator:Health() >= 100 then
				activator:Notify("You do not need to use this device.")
				self:EmitSound("hl1/fvox/fuzz.wav")
			else
				activator:Notify("You need 250 credits to use this device. There are medics available, find them instead.")
				self:EmitSound("hl1/fvox/fuzz.wav")
			end
		end
	else
		activator:Notify("You cannot interact with this item.")
		self:EmitSound("hl1/fvox/fuzz.wav")
	end
    return
end