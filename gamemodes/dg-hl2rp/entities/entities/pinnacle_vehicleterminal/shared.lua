ENT.Base			= "base_gmodentity" 
ENT.Type			= "anim"
ENT.PrintName		= "Vehicle Terminal"
ENT.Author			= "Thrawn"
ENT.Purpose			= ""
ENT.Instructions	= "Press E"
ENT.Category 		= "Pinnacle"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Vehicle Terminal"
ENT.HUDDesc = "This can be used by Combine personnel."
ENT.Emped = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NetworkedUser")
	self:NetworkVar("Bool", 0, "ConvictIndex")
	self:NetworkVar("Bool", 1, "OverwatchIndex")
	self:NetworkVar("Bool", 1, "EMPed")
end

function ENT:IsEMPed()
	return self.Emped
end