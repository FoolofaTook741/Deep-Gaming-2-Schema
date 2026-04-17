AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/tubes/circle2x2.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetRenderMode(RENDERMODE_NONE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
end

function ENT:SpawnFunction(ply, trace, class)
	local ent = ents.Create(class)
	ent:SetPos(trace.HitPos)
	local ang = Angle(0, 0, 0)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Touch(ent)
	if not IsValid(ent) then return end
	if ent:IsPlayer() then
		ent:TakeDamage(1, self, self)
		return
	end
	if ent:GetModel() == "models/props_mining/bucket_mining01.mdl" then return end
	if ent.SmeltingFizzled then return end
	if not ent:IsValid() then return end
	if ent:IsPlayer() then return end
	if ent:IsNPC() then return end

	ent.SmeltingFizzled = true
	self:EmitSound("hl1/ambience/steamburst1.wav")

	local isScrap = ent:GetNWBool("IsSmeltingItem", false)

	if isScrap then
		local ws = impulse.SmeltingWorkshift
		if ws and ws.active and not ws.paid then
			ws.smeltCount = ws.smeltCount + 1
			if impulse.SmeltingPushUpdate then
				impulse.SmeltingPushUpdate()
			end
		end
	end

	ent:Remove()
end

hook.Add("PlayerDeath", "DeepSmelterFizzleDeath", function(ply, inflictor, attacker)
	if attacker:GetClass() ~= "deep_smelter" then return end

	timer.Simple(0.1, function()
		if IsValid(ply) then
			ply:EmitSound("npc/combine_soldier/burning.wav")
			ply:Ignite(2, 0)
			timer.Simple(2, function()
				if IsValid(ply) then
					ply:SetRenderMode(RENDERMODE_NONE)
					timer.Simple(0.5, function()
						if IsValid(ply) then
							ply:SetRenderMode(RENDERMODE_NORMAL)
						end
					end)
				end
			end)
		end
	end)
end)