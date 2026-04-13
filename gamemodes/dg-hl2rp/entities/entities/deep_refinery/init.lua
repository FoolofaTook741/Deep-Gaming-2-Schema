AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
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
	local ws = impulse.SmeltingWorkshift
	if ws and ws.active then
		if self.smeltingCopperReady then
			self.smeltingCopperReady = false
			activator:GiveInventoryItem("item_steelbar", 1)
			activator:Notify("You collected a steel bar from the refinery.")
			return
		elseif self.smeltingCopperActive then
			activator:Notify("The refinery is already processing copper. Please wait.")
			return
		end
	end
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
			if chance < 70 then
				activator:GiveInventoryItem("util_metalplate", 1)
				activator:Notify("You have received 1 metal plate.")
			elseif chance < 96 then
				activator:GiveInventoryItem("util_pipe", 1)
				activator:Notify("You have received 1 metal pipe.")
			else
				activator:GiveInventoryItem("util_refinedmetalplate", 1)
				activator:Notify("You have received 1 refined metal plate.")
			end
			self.finished = false
		elseif timer.Exists(id .. "refinery") then
			activator:Notify("The Refinery is already working.")
		elseif !activator:HasInventoryItem("item_rawmetal") then
			activator:Notify("You need to input 1 raw metal.")
		elseif activator:HasInventoryItem("item_rawmetal") then
			if GetPlayerCount() < 10 then
				activator:Notify("There are not enough players to use this machine. (10 minimum).")
			else
				if !timer.Exists(id .. "refinery") then
					for k, v in pairs(ents.FindByClass("deep_outlet")) do
						local dist = selfpos:Distance(v:GetPos())
						if dist < 300 then
							outlets = 1
						end
					end
					for k, v in pairs(ents.FindByClass("deep_generator")) do
						local dist = selfpos:Distance(v:GetPos())
						if dist < 300 and v.powered then
							generators = 1
						end
					end
					if outlets >= 1 then
						activator:Notify("Refining process underway, return in 60 seconds.")
						self:EmitSound("ambient/machines/spinup.wav")
						timer.Simple(2, function() self:EmitSound("ambient/machines/spin_loop.wav") end)
						activator:TakeInventoryItemClass("item_rawmetal")
						timer.Create(id .. "refinery", 60, 1, function()
							self:EmitSound("ambient/machines/spindown.wav")
							self:StopSound("ambient/machines/spin_loop.wav")
							activator:Notify("Refining complete, press E on the machine to collect!")
							timer.Remove(id .. "refinery")
							self.finished = true
						end)
					elseif generators >= 1 then
						activator:Notify("Refining process underway, return in 60 seconds.")
						self:EmitSound("ambient/machines/spinup.wav")
						timer.Simple(2, function() self:EmitSound("ambient/machines/spin_loop.wav") end)
						activator:TakeInventoryItemClass("item_rawmetal")
						timer.Create(id .. "refinery", 60, 1, function()
							self:EmitSound("ambient/machines/spindown.wav")
							self:StopSound("ambient/machines/spin_loop.wav")
							activator:Notify("Refining complete, press E on the machine to collect!")
							timer.Remove(id .. "refinery")
							self.finished = true
						end)
					else
						activator:Notify("No power source available.")
					end
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

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.RefineryCount = math.max((owner.RefineryCount or 1) - 1, 0)
end