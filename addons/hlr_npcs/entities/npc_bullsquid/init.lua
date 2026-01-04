AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_bullsquid")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"npc_bullsquid")
ENT.sModel = "models/half-life/bullsquid.mdl"
ENT.fRangeDistanceFlame = 160
ENT.fRangeDistance = 1250
ENT.fMeleeDistance	= 50

ENT.bPlayDeathSequence = true
ENT.CanUseFlame = false
ENT.CanUseSpit = true

ENT.skName = "bullchicken"
ENT.CollisionBounds = Vector(35,35,42)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/bullsquid/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEFORWARD,ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["AttackRange"] = "bc_attack[1-3].wav",
	["AttackWhip"] = "bc_attackgrowl[1-3].wav",
	["AttackBite"] = "bc_bite[1-3].wav",
	["Death"] = "bc_die[1-3].wav",
	["Pain"] = "bc_pain[1-2].wav",
	["Idle"] = "bc_idle[1-5].wav",
	["Surprised"] = "bc_pain[3-4].wav",
	["FlameStart"] = "flame_start0[1-2].wav"
}

ENT.Limbs = {
	[HITBOX_RIGHTARM] = "Right Leg",
	[HITBOX_HEAD] = "Head",
	[HITBOX_LEFTARM] = "Left Leg",
	[HITBOX_STOMACH] = "Torso",
	[HITBOX_CHEST] = "Torso",
	[HITBOX_ADDLIMB] = "Hind Leg"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.iSpitCount = math.random(2,4)
	self.nextSpit = 0
	
	if(self.CanUseFlame) then
		self.cspFlame = CreateSound(self, self.sSoundDir .. "flame_run_lp.wav")
		self:StopSoundOnDeath(self.cspFlame)
	end
	self:SubInit()
end

function ENT:SubInit()
end

function ENT:_PossAttackThink(entPossessor,iAttack)
	if(iAttack == IN_RELOAD) then
		if(!entPossessor:KeyDown(IN_RELOAD)) then
			self:StopParticles()
			if(self.cspFlame) then self.cspFlame:Stop() end
			self:PlayActivity(ACT_SPECIAL_ATTACK2,false,self:_PossScheduleDone())
			return
		end
	end
	self:TurnDegree(3,entPossessor:GetAimVector():Angle())
end

function ENT:_PossReload(entPossessor,fcDone)
	self:PlayActivity(ACT_SPECIAL_ATTACK1,false)
	self.bInSchedule = true
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

local tblHeadcrabs = {"npc_headcrab","npc_headcrab_black","npc_headcrab_poison","npc_headcrab_fast","monster_babyheadcrab","monster_head_crab"}
function ENT:OnFoundEnemy()
	if(math.random(1,3) != 1) then return end
	if(!IsValid(self.entEnemy) || !self.entEnemy:IsNPC()) then return end
	if(!table.HasValue(tblHeadcrabs,self.entEnemy:GetClass())) then
		if(bCanSee) then self:PlayActivity(ACT_HOP) end
		return
	end
	self:PlayActivity(ACT_SIGNAL2)
end

function ENT:OnInterrupt()
	self:StopParticles()
	if(self.cspFlame) then self.cspFlame:Stop() end
end

function ENT:DamageHandle(dmginfo)
	if(IsValid(self.entEnemy) || self:IsMoving() || self.bInSchedule || math.random(1,3) != 1) then return end
	local dmgPos = dmginfo:GetDamagePosition()
	local ang = self:GetAngleToPos(dmgPos)
	local bCanSee = ang.y > 90 && ang.y < 270
	if(bCanSee) then
		self:SetLastPosition(dmgPos)
		local schdHop = ai_schedule_slv.New("Surprised Hop")
		schdHop:EngTask("TASK_STOP_MOVING", 0)
		schdHop:EngTask("TASK_STOP_MOVING", 0)
		schdHop:EngTask("TASK_PLAY_SEQUENCE", ACT_HOP)
		schdHop:EngTask("TASK_FACE_LASTPOSITION")
		self:StartSchedule(schdHop)
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local dist = self.fMeleeDistance
		local bWhip = atk == "whip"
		local bBite = !bWhip
		if(bWhip) then
			local dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_whip")
			local angViewPunch = Angle(-7,-36,4)
			self:DealMeleeDamage(dist,dmg,angViewPunch,vector_origin,nil,nil,nil,true)
			return true
		end
		local dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_bite")
		local angViewPunch = Angle(-14,0,0)
		self:DealMeleeDamage(dist,dmg,angViewPunch,Vector(280,0,0),nil,nil,nil,nil,function(ent)
			ent:SetVelocity((self:GetForward() *100) +Vector(0,0,300))
		end)
		if(!self.bPossessed) then self.iSpitCount = math.random(2,4) end
		return true
	end
	if(event == "rattack") then
		local atk = select(2,...)
		if(string.Left(atk,5) == "flame") then
			local dist
			local bValid = IsValid(self.entEnemy)
			if bValid then dist = self:OBBDistance(self.entEnemy) end
			if(!self.bPossessed && (!bValid || !self:ShouldUseFlame() || dist > self.fRangeDistanceFlame || dist <= self.fMeleeDistance || self.entEnemy:Health() <= 0 || self.bDead || self.entEnemy:GetPos().z -self:GetPos().z > 65)) then
				self:PlayActivity(ACT_SPECIAL_ATTACK2, true)
				self.bInSchedule = false
				self:StopParticles()
				if(self.cspFlame) then self.cspFlame:Stop() end
			elseif(atk == "flamerun") then self:FlameAttack()
			else
				self:PlayActivity(ACT_RANGE_ATTACK2, !self.bPossessed)
				if(atk == "flamestart") then
					if(self.cspFlame) then self.cspFlame:Play() end
					if(self.FlameParticle) then ParticleEffectAttach(self.FlameParticle,PATTACH_POINT_FOLLOW,self,1) end
				else self:FlameAttack() end
			end
			return true
		end
		self:AttackSpit()
		return true
	end
end

function ENT:FlameAttack() self:DealFlameDamage(self.fRangeDistanceFlame) end

function ENT:GetSpitVelocity()
	local pos
	if(IsValid(self.entEnemy) || self.bPossessed) then
		local posSelf = self:GetPos()
		local posEnemy
		if !self.bPossessed then posEnemy = self.entEnemy:GetCenter()
		else
			local entPossessor = self:GetPossessor()
			posEnemy = entPossessor:GetPossessionEyeTrace().HitPos
		end
		local fDistZ = posEnemy.z -posSelf.z
		posSelf.z = 0
		posEnemy.z = 0
		local fDist = posSelf:Distance(posEnemy)
		local fDistZMax = math.Clamp((fDist /450) *500, 0, 500)
		fDistZ = math.Clamp(fDistZ, -fDistZMax, fDistZMax)
		fDist = math.Clamp(fDist, 100, 1250)
		pos = self:GetForward() *fDist +self:GetUp() *fDistZ
	else pos = self:GetForward() *500 +Vector(0,0,10) end
	return pos:GetNormalized() *2000 +Vector(0,0,300 *(pos:Length() /2000))
end

function ENT:AttackSpit()
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
		end
	end
end

function ENT:ShouldUseFlame() return true end

function ENT:ShouldUseSpit() return true end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if(bMelee) then
				self:PlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			if(self.CanUseFlame && self:ShouldUseFlame()) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if(dist <= 100 && (ang.y <= 45 || ang.y >= 315) && enemy:GetPos().z -self:GetPos().z <= 65) then
					self:PlayActivity(ACT_SPECIAL_ATTACK1,true)
					self.bInSchedule = true
					return
				end
			end
			if(self.CanUseSpit && self:ShouldUseSpit()) then
				if(self.iSpitCount == 0 && CurTime() >= self.nextSpit) then
					self.iSpitCount = math.random(2,4)
				end
				local tr = self:CreateTrace(enemy:GetHeadPos(),nil,self:GetPos() +self:GetForward() *20 +self:GetUp() *20)
				if(dist <= self.fRangeDistance && self.iSpitCount > 0 && (!IsValid(tr.Entity) || tr.Entity == enemy)) then
					self:PlayActivity(ACT_RANGE_ATTACK1,true)
					return
				end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end