AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/props_lab/citizenradio.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetSkin(0)

    self:SetRadioOn(false)
end

function ENT:Use(ply)
	if (self.nextUse or 0) > CurTime() then return end
	self.nextUse = CurTime() + 2

	local isOn = self:GetRadioOn() or false

	self:SetRadioOn(!isOn)
	self:EmitSound("buttons/button9.wav")

	ply:Notify("You have turned the Festive Radio "..(!isOn and "on" or "off")..".")
end