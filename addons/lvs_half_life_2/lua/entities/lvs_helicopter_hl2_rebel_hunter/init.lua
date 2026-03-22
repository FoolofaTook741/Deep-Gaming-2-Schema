AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:PostOnSpawn(PObj)
	self:SetSubMaterial(0, "models/resist/combine_helicopter01")
end
