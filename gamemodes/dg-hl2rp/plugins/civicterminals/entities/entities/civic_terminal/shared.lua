ENT.Type                = "anim"
ENT.Base                = "base_gmodentity"

ENT.PrintName           = "Civil Terminal"
ENT.Author              = "Thrawn"
ENT.Category            = "impulse: Citizen Improvements"

ENT.Spawnable           = true
ENT.AdminOnly           = false
ENT.DoNotDuplicate      = true
ENT.DisableDuplicator   = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "State")
    self:NetworkVar("String", 1, "MData")
end