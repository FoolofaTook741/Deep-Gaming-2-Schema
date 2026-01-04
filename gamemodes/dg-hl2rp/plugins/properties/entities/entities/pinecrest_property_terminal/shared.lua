
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Property Terminal"
ENT.Author = "mage.tearz"
ENT.Category = "Pinecrest: General"
ENT.AutomaticFrameAdvance = true

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "Door" )
    self:NetworkVar( "Int", 1, "SillyOwner" )
    self:NetworkVar( "Int", 2, "PropertyIndex" )
end

if SERVER then
    util.AddNetworkString("impulseHL2RPPropertyQuestComplete")
end

net.Receive("impulseHL2RPPropertyQuestComplete", function() 
    ply = net.ReadPlayer()
end)
