AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_devilsquid")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.sModel = "models/devilsquid.mdl"
ENT.fMeleeDistance	= 44
ENT.m_fMaxYawSpeed 	= 28
ENT.FlameParticle = "flame_gargantua"

ENT.bIgnitable = false
ENT.CanUseFlame = true
ENT.DamageScales = {
	[DMG_BURN] = 0.1,
	[DMG_DIRECT] = 0.1
}

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/bullsquid/"
ENT.skName = "devilsquid"
ENT.CollisionBounds = Vector(35,35,46)

function ENT:SubInit()
	self:SetSoundPitch(60)
end

function ENT:AttackSpit()
	self:PlaySound("AttackRange")
	local pos = self:GetSpitVelocity()
	for i = 0, 5 do
		local entSpit = ents.Create("obj_spit")
		entSpit:NoCollide(self)
		entSpit:SetPos(self:GetPos() +self:GetForward() *20 +self:GetUp() *20)
		entSpit:SetEntityOwner(self)
		entSpit:SetParticleEffect("magic_spell_fireball")
		function entSpit:OnHit(ent,dist)
			ent:Ignite(ent:IsPlayer() && 1 || 6)
		end
		entSpit:Spawn()
		entSpit:Activate()
		local phys = entSpit:GetPhysicsObject()
		if(phys:IsValid()) then
			phys:SetVelocity(pos +VectorRand() *60)
		end
	end
	if(!self.bPossessed) then
		self.iSpitCount = self.iSpitCount -1
		if self.iSpitCount <= 0 then
			self.nextSpit = CurTime() +math.Rand(4,12)
		end
	end
end