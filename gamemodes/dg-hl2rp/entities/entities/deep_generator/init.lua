AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_vehicles/generatortrailer01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.powered = false
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
    if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if timer.Exists(id .. "generator") then
			activator:Notify("The Generator is already working.")
		elseif !activator:HasInventoryItem("util_fuel") then
			activator:Notify("You need to input 1 can of fuel.")
		elseif activator:HasInventoryItem("util_fuel") then
			activator:TakeInventoryItemClass("util_fuel")
			self.powered = true
			self:EmitSound("vehicles/airboat/fan_blade_idle_loop1.wav")
			timer.Create(id .. "generator", 540, 1, function() 
				self.powered = false
				self:StopSound("vehicles/airboat/fan_blade_idle_loop1.wav")
			end)
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
    owner.Generator = math.max((owner.Generator or 1) - 1, 0)
end
