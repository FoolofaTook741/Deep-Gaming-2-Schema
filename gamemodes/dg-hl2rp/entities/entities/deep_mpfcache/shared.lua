ENT.Base			= "base_anim"
ENT.Type			= "anim"
ENT.PrintName		= "MPF Cache"
ENT.Author			= "Fool of a Took"
ENT.Category 		= "impulse"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "MPF Stockpile"
ENT.HUDDesc = "A cache filled with various type of equipment used by Civil Protection."

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "DrillEndTime")
end