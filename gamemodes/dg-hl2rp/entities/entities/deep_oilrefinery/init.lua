AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_citizen_tech/firetrap_propanecanister01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.finished = false
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end


function ENT:Use( activator, caller )
	local chance = math.random(1, 100)
	local id = self:GetCreationID()
	local ammo
	local droppos = self:GetPos() + Vector(0, 0, 50)
	local players
	local selfpos = self:GetPos()
	local outlets = 0
	local generators = 0
    if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if self.finished == true then
			activator:GiveInventoryItem("util_fuel", 1)
			activator:Notify("You have received 1 can of fuel.")
			self.finished = false
		elseif timer.Exists(id .. "refinery") then
			activator:Notify("The Refinery is already working.")
		elseif !activator:HasInventoryItem("item_crudeoil") then
			activator:Notify("You need to input 1 crude oil.")
		elseif activator:HasInventoryItem("item_crudeoil") then
			if GetPlayerCount() < 10 then
				activator:Notify("There are not enough players to use this machine. (10 minimum).")
			else
				for k, v in pairs(ents.FindByClass("deep_outlet")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 then
						outlets = 1
					end
				end
				for k, v in pairs(ents.FindByClass("deep_generator")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 && v.powered == true then
						generators = 1
					end
				end				
				if (generators == 1 or outlets == 1) && !timer.Exists(id .. "refinery") then
					activator:Notify("Refining process underway, return in 4 minutes.")
					self:EmitSound("ambient/materials/bump1.wav")
					timer.Simple(2, function() self:EmitSound("ambient/machines/lab_loop1.wav") end)
					activator:TakeInventoryItemClass("item_crudeoil")
					timer.Create(id .. "refinery", 240, 0, function()
						self:EmitSound("physics/metal/metal_grate_impact_soft3.wav")
						self:StopSound("ambient/machines/lab_loop1.wav")
						activator:Notify("Refining complete, presss E on the machine to collect!")
						timer.Remove(id .. "refinery")
						self.finished = true
					end)
				elseif generators < 1 and outlets < 1 then
					activator:Notify("No power sources detected.")
				else
					activator:Notify("The refinery is already active.")
				end
			end
		end	
	else
		activator:Notify("You cannot interact with this item.")
	end
    return
end