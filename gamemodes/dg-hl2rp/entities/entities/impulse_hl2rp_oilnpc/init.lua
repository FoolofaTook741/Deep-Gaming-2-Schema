AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player/female_02_suit.mdl")
	self:SetBodyGroups("01")
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))

	timer.Simple(1, function()
		if IsValid(self) then self:DoAnimation() end
	end)
end

function ENT:Use(caller, activator)
	if caller:Team() ~= TEAM_CWU then
		caller:Notify("Only Civil Workers Union members may speak with the Oil Refinery Foreman.")
		return
	end

	if impulse.OilNPC_SendMenu then
		impulse.OilNPC_SendMenu(caller)
	end
end

function ENT:SpawnFunction(ply, trace, class)
	if not gamemode.Call("PlayerSpawnSENT", ply, class) then return end

	local angles = (trace.HitPos - ply:GetPos()):Angle()
	angles.r = 0
	angles.p = 0
	angles.y = angles.y + 180

	local ent = ents.Create(class)
	ent:SetPos(trace.HitPos + Vector(0, 0, 2))
	ent:SetAngles(angles)
	ent:Spawn()
	ent:Activate()

	return ent
end