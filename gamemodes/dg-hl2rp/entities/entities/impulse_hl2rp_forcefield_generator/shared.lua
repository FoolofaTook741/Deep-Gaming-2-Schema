ENT.Base			= "base_anim"
ENT.Type			= "anim"
ENT.PrintName		= "Forcefield Generator"
ENT.Author			= "Bap!"
ENT.Category 		= "impulse"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Forcefield Generator"
ENT.HUDDesc = "Powers nearby forcefields."

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Forcefield")
end