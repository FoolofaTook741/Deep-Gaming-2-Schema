AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/mosi/fallout4/props/junk/components/copper.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:StartTouch(ent)
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "deep_refinery" then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end

	if ent.smeltingCopperActive or ent.smeltingCopperReady then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(Vector(math.random(-100, 100), math.random(-100, 100), 200))
		end
		return
	end

	ent.smeltingCopperActive = true
	self:Remove()

	ent:EmitSound("ambient/machines/spinup.wav")
	timer.Simple(2, function()
		if IsValid(ent) then
			ent:EmitSound("ambient/machines/spin_loop.wav")
		end
	end)

	local refineryID = ent:EntIndex()
	timer.Create("SmeltingRefinery_" .. refineryID, 30, 1, function()
		if not IsValid(ent) then return end
		ent:StopSound("ambient/machines/spin_loop.wav")
		ent:EmitSound("ambient/machines/spindown.wav")
		ent.smeltingCopperActive = false
		ent.smeltingCopperReady = true

		for _, ply in ipairs(player.GetAll()) do
			if ply:Team() == TEAM_CWU then
				ply:Notify("A refinery has finished processing copper. Press E to collect the steel bar.")
			end
		end
	end)
end
