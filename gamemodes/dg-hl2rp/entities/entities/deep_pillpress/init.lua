AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/microscope.mdl" )
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
	local droppos = self:GetPos() + Vector(0, 0, 50)
	local selfpos = self:GetPos()
	local outlets = 0
	local generators = 0
    if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if self.finished == true then
			activator:GiveInventoryItem("item_pillbottle", 1)
			activator:Notify("You have received 1 Pill Bottle.")
			self.finished = false
		elseif timer.Exists(id .. "pillpress") then
			activator:Notify("The Refinery is already working.")
		elseif !activator:HasInventoryItem("util_plastic") then
			activator:Notify("You need to input 1 plastic.")
		elseif activator:HasInventoryItem("util_plastic") then
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
			if (generators == 1 or outlets == 1) && !timer.Exists(id .. "pillpress") then
				activator:Notify("Molding underway.")
				self:EmitSound("ambient/materials/bump1.wav")
				timer.Simple(2, function() self:EmitSound("ambient/machines/lab_loop1.wav") end)
				activator:TakeInventoryItemClass("util_plastic")
				timer.Create(id .. "pillpress", 30, 1, function()
					self:StopSound("ambient/machines/lab_loop1.wav")
					activator:Notify("Molding complete, presss E on the machine to collect!")
					timer.Remove(id .. "pillpress")
					self.finished = true
				end)
			elseif generators < 1 and outlets < 1 then
				activator:Notify("No power sources detected.")
			else
				activator:Notify("The pill press is already active.")
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
    owner.PillPresses = math.max((owner.PillPresses or 1) - 1, 0)
end