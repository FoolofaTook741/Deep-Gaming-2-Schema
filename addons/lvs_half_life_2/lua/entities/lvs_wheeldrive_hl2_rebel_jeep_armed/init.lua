AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:PostOnSpawn(PObj)
    self:SetBodygroup(1, 1)
end
