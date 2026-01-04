AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMaterial("metal/metalfence007a")
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
	local indx = self:GetCreationID()
	local ind = tostring(indx) 
	local droppos = self:GetPos() + Vector(0,0,25)
	if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if self:WaterLevel() == 0 then
			activator:Notify("The cage must be in water to catch fish.")
		else
			if !timer.Exists(ind .. "cagefishing") then
				activator:Notify("Cage is in water, fishing underway return in 8 minutes!")
				timer.Create(ind .. "cagefishing", 480, 1, function()
					impulse.Inventory.SpawnItem("food_fish", droppos)
					activator:Notify("Fishing complete, get there before someone else does!")
				end)
			elseif timer.Exists(ind .. "cagefishing") then
				activator:Notify("Fishing underway, return in " .. math.floor(timer.TimeLeft(ind .. "cagefishing")) .. " seconds.")
			else
				activator:Notify("An error has occurred.")
			end
		end
	else
		activator:Notify("You cannot interact with this object.")	
	end
end

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.FishCrate = math.max((owner.FishCrate or 1) - 1, 0)
end