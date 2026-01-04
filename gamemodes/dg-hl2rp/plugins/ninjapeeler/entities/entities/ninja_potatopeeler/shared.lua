ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Potato Peeler"

ENT.Spawnable = true 

ENT.HUDName = "Bucket of Potatoes"
ENT.HUDDesc = "Peel potatoes to distribute in the ration stations for a reduction in your sentence."

function ENT:SetupDataTables()
    self:NetworkVar("Bool",false,"potatoMenu")
end

