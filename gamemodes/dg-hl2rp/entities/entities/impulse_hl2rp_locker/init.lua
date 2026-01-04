AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end
 
function ENT:Use(caller, activator)
	if caller:GetSyncVar(SYNC_ARRESTED, false) then
		return
	end

	if caller:Team() == TEAM_CITIZEN or caller:Team() == TEAM_CWU and caller.GetTeamClass and caller:GetTeamClass() == CLASS_MEDIC then
		net.Start("impulseHL2RPOpenLocker")
		net.Send(caller)
	end

	caller.currentLocker = self
end
