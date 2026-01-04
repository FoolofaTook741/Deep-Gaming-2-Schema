ENT.Base			= "base_anim"
ENT.Type			= "anim"
ENT.PrintName		= "Pre War Cache"
ENT.Author			= "vin, aLoneWitness"
ENT.Category 		= "impulse"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Confiscation Stockpile"
ENT.HUDDesc = "A pre-war cache filled with various combat equipment chained up by the combine."

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "DrillEndTime")
end