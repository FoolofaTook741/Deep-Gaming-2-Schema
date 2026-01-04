ENT.Base			= "base_anim"
ENT.Type			= "anim"
ENT.PrintName		= "Festive Radio"
ENT.Author			= "vin"
ENT.Category 		= "impulse - christmas"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Festive Radio"
ENT.HUDDesc = "Plays festive music. Even the Combine like it."
ENT.HUDColour = Color(0, 179, 44)

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "RadioOn")
end