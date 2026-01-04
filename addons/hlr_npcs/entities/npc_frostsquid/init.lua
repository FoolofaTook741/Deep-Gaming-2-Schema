AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_frostsquid")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.sModel = "models/frostsquid.mdl"
ENT.fMeleeDistance	= 35
ENT.m_fMaxYawSpeed 	= 12

ENT.bFreezable = false
ENT.CanUseFlame = true
ENT.CanUseSpit = true
ENT.DamageScales = {
	[DMG_BURN] = 2,
	[DMG_DIRECT] = 2
}

ENT.iBloodType = BLOOD_COLOR_BLUE
ENT.sSoundDir = "npc/bullsquid/"
ENT.skName = "frostsquid"
ENT.CollisionBounds = Vector(32,32,36)

function ENT:SubInit()
	self:SetSoundPitch(120)
end

function ENT:OnDeath(dmginfo)
	self.bInSchedule = false
end

function ENT:ShouldUseFlame() return self.entEnemy:PercentageFrozen() < 90 end

function ENT:ShouldUseSpit() return self.entEnemy:PercentageFrozen() < 90 end

function ENT:FlameAttack()
	local dist = self.fRangeDistanceFlame
	local posSelf = self:GetPos()
	local posDmg = self:GetAttachment(self:LookupAttachment("attach_mouth"))
	for _, ent in pairs(ents.FindInSphere(posDmg.Pos,dist)) do
		if(ent:IsValid() && (ent:IsNPC() || ent:IsPlayer()) && ent != self && self:IsEnemy(ent) && self:Visible(ent) && ent:GetPos().z -posSelf.z <= 65) then
			local posEnt = ent:GetPos()
			local yaw = self:GetAngleToPos(posEnt,self:GetAimAngles()).y
			if((yaw <= 70 && yaw >= 0) || (yaw <= 360 && yaw >= 290)) then
				ent:SetFrozen(16)
			end
		end
	end
end

function ENT:AttackSpit()
	local pos = self:GetSpitVelocity()
	for i = 0, 5 do
		local entSpit = ents.Create("obj_icesphere")
		entSpit:NoCollide(self)
		entSpit:SetPos(self:GetPos() +self:GetForward() *20 +self:GetUp() *20)
		entSpit:SetEntityOwner(self)
		entSpit:SetSize(math.random(1,3))
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

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	if !self.bInSchedule then return end
	local effect = EffectData()
	effect:SetStart(self:GetAttachment(1).Pos)
	effect:SetNormal(self:GetForward())
	effect:SetEntity(self)
	effect:SetAttachment(1)
	util.Effect("effect_ice_spray",effect)
end