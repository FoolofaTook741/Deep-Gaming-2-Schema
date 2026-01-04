ENT.Base			= "base_anim"
ENT.Type			= "anim"
ENT.PrintName		= "Forcefield"
ENT.Category 		= "impulse"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ForcefieldName")
	self:NetworkVar("Int", 1, "Stage")
	self:NetworkVar("Bool", 2, "FFStatus")
	self:NetworkVar("Bool", 3, "FFEMP")
end