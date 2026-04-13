AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.useDelay = 0

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(caller, activator)
	if self.useDelay >= CurTime() then return end
	if caller:Team() ~= TEAM_CWU then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then
		caller:Notify("There is no active smelting workshift right now.")
		return
	end

	if ws.smeltCount <= 0 then
		caller:Notify("No smelted scrap available yet. Smelt more scrap first.")
		return
	end

	self.useDelay = CurTime() + 2
	ws.smeltCount = ws.smeltCount - 1

	self:EmitSound("buttons/lever5.wav")

	local pipe = self
	timer.Simple(0.8, function()
		if not IsValid(pipe) then return end

		local copper = ents.Create("impulse_hl2rp_copperbar")
		copper:SetPos(pipe:GetPos() + Vector(0, 0, -20))
		copper:Spawn()

		local phys = copper:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end)
end
