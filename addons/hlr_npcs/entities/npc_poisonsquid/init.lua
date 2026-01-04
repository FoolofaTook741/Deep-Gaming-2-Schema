AddCSLuaFile("shared.lua") --This is so the shared file works! Isn't that something?

include('shared.lua')

local _R = debug.getregistry() --I have no clue what the point of this is!
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_poisonsquid") --So he will make friends with the Xen people!
ENT.NPCFaction = NPC_FACTION_XENIAN --Also so he can make friends with Xen!
ENT.sModel = "models/poisonsquid.mdl" --This is his model!
ENT.fMeleeDistance	= 44 --This is the calculation for where he can hurt you!
ENT.m_fMaxYawSpeed 	= 28 --Yaw haw haw!
ENT.FlameParticle = "flame_gargantua" --This is the effect that comes out when he breathes fire!

ENT.bIgnitable = false --He can't burn to death!
ENT.bFreezable = false --He can't be frozen!
ENT.CanUseFlame = true --He can breathe fire!
ENT.DamageScales = { --A message!
	[DMG_BURN] = 0.1,
	[DMG_DIRECT] = 0.1 --These are his damage calculations!
}

ENT.iBloodType = BLOOD_COLOR_BLUE --What color his blood is!
ENT.sSoundDir = "npc/bullsquid/" --Where his sound comes from!
ENT.skName = "poisonsquid" --His name for his stats! Check the file hlr_sh_concommands inside hlr_init to learn more!
ENT.CollisionBounds = Vector(35,35,46) --How he collides with the world.

function ENT:SubInit()
	self:SetSoundPitch(30) --Optional thing where you can change the pitch of his voice!
end  --You need this for when a category ends!

function ENT:AttackSpit()
	self:PlaySound("AttackRange")
	local pos = self:GetSpitVelocity()
	for i = 0, 5 do
		local entSpit = ents.Create("obj_bullsquid_spit")
		entSpit:NoCollide(self)
		entSpit:SetPos(self:GetPos() +self:GetForward() *20 +self:GetUp() *20)
		entSpit:SetEntityOwner(self)
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
		end --So is this stuff above, but for when he is possessed by a player!
	end
end --The reason for three ends is because each end represents something else.