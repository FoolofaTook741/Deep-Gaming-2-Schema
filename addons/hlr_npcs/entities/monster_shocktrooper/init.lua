AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_RACEX","monster_shocktrooper")
ENT.NPCFaction = NPC_FACTION_RACEX
ENT.iClass = CLASS_RACEX
util.AddNPCClassAlly(CLASS_RACEX,"monster_shocktrooper")
ENT.sModel = "models/opfor/strooper.mdl"
ENT.fRangeDistance = 824
ENT.fMeleeDistance	= 60

ENT.bPlayDeathSequence = true

ENT.skName = "strooper"
ENT.CollisionBounds = Vector(18,18,85)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/shocktrooper/"

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_SMALL_FLINCH,
	[HITBOX_HEAD] = ACT_BIG_FLINCH,
	[HITBOX_CHEST] = ACT_BIG_FLINCH,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT,
	[HITBOX_CHEST] = ACT_DIE_GUTSHOT,
	[HITBOX_STOMACH] = ACT_DIE_GUTSHOT
}
ENT.tblAlertAct = {}


ENT.m_tbSounds = {
	["Attack"] = "shock_trooper_attack.wav",
	["Death"] = "shock_trooper_die[1-4].wav",
	["Pain"] = "shock_trooper_pain[1-5].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.nextGrenade = 0
	self.nextBlink = CurTime() +math.Rand(2,8)
	self.nextChase = 0
	self.nextIdle = 0
	self.nextCombatSpeak = 0
end

function ENT:DamageHandle(dmginfo)
	if self.waitEnd then self:TaskComplete(); self.waitEnd = nil end
	if self:GetSequence() == self:LookupSequence("cower") then
		dmginfo:ScaleDamage(0.5)
	end
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
		self.bHurtCritical = true
	end
end

local schdCower = ai_schedule_slv.New("Take Cower") 
schdCower:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0) 
schdCower:EngTask("TASK_WAIT",1)
schdCower:EngTask("TASK_STOP_MOVING",0)
schdCower:EngTask("TASK_PLAY_SEQUENCE", ACT_COWER)
function ENT:OnDanger(vecPos)
	self:SpeakSentence("!ST_GREN0")
	if self.bPossessed then return end
	self.bInSchedule = false
	if IsValid(self.entSporeGrenade) then self.entSporeGrenade:Remove() end
	
	local posSelf = self:GetPos()
	self:SetLastPosition(posSelf +(posSelf -vecPos):GetNormal() *200)
	self:StartSchedule(schdCower)
	return true
end

function ENT:OnFoundEnemy()
	self.nextGrenade = CurTime() +math.Rand(3,12)
	self:SelectSchedule()
	if !IsValid(self.entEnemy) then return end
	if self.entEnemy:IsNPC() && self.entEnemy.GetNPCClass && self.entEnemy:GetNPCClass() == CLASS_XENIAN then
		self:SpeakSentence("!ST_MONST0")
	else
		self:SpeakSentence("!ST_ALERT" .. math.random(0,2))
	end
end

function ENT:OnDeath(dmginfo)
	local pos = self:GetAttachment(2).Pos
	local entShockroach = ents.Create("monster_shockroach")
	entShockroach:SetPos(pos)
	entShockroach:SetAngles(Angle(0,self:GetAngles().y,0))
	entShockroach:NoCollide(self)
	entShockroach:SetOwner(self)
	entShockroach:Spawn()
	entShockroach:Activate()
	
	self:SetBodygroup(1,1)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
	self.bInSchedule = true
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK2,false,fcDone)
end

function ENT:AnswerChatter()
	local sSentence = "!ST_ANSWER0"
	self:SpeakSentence(sSentence)
end

function ENT:OnThink()
	if self:PercentageFrozen() >= 80 || self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	self:UpdateLastEnemyPositions()
	if CurTime() >= self.nextBlink then
		self.nextBlink = CurTime() +math.Rand(2,8)
		self:SetSkin(1)
		local iDelay = 0.1
		for i = 2, 0, -1 do
			timer.Simple(iDelay, function()
				if IsValid(self) && !self.bDead then
					self:SetSkin(i)
				end
			end)
			iDelay = iDelay +0.1
		end
	end
	if !self.bInSchedule then
		if self.nextAnswer && CurTime() >= self.nextAnswer then
			self.nextAnswer = nil
			local tblEnts = {}
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
				if IsValid(v) then
					if v:GetClass() == "monster_shocktrooper" && v != self && !v.delayHide then
						table.insert(tblEnts,v)
					end
				end
			end
			if #tblEnts > 0 then
				local ent = tblEnts[math.random(1,#tblEnts)]
				ent:AnswerChatter()
			end
		end
		if CurTime() >= self.nextIdle then
			if math.random(1,12) == 1 then
				local sSentence
				local length
				local speechChance = math.random(1,12)
				if math.random(1,2) == 1 then
					sSentence = "!ST_QUEST0"
					length = self:GetSentenceLength(sSentence)
					self.nextAnswer = CurTime() +length +math.Rand(0.4,1.8)
					self.nextIdle = self.nextAnswer +math.Rand(10,23)
				else
					if speechChance <= 4 then
						sSentence = "!ST_IDLE0"
					elseif speechChance <= 8 then
						sSentence = "!ST_CHECK0"
					else 
						sSentence = "!ST_CLEAR0"
					end
					length = self:GetSentenceLength(sSentence)
					self.nextIdle = CurTime() +length +math.Rand(0.4,1.8)
				end
				self:SpeakSentence(sSentence)
			else
				self.nextIdle = CurTime() +math.Rand(8,12)
			end
		end
		return
	end
	if self.bPossessed then
		local ang = (self:GetPos() +self:GetForward() *10.7 +self:GetUp() *29.9 -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
		if ang >= 90 then ang = ang -360 end
		ang = ang +5
		ang = math.Clamp(ang,-45,45)
		self:SetPoseParameter("XR", ang)
	elseif IsValid(self.entEnemy) then
		self:FaceEnemy()
		local pos = self:GetPos() +self:GetForward() *10.7 +self:GetUp() *29.9
		local ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
		if ang >= 90 then ang = ang -360 end
		ang = ang +5
		ang = math.Clamp(ang,-45,45)
		self:SetPoseParameter("XR", ang)
	end
	return
end

function ENT:Flinch()
end

function ENT:TaskStart_TASK_CHECK_FAIL(data)
	self:TaskComplete()
	if !self:HasCondition(35) then return end
	self:TaskComplete()
	self:TaskComplete()
	self:SelectSchedule()
end

function ENT:Task_TASK_CHECK_FAIL(data)
end

function ENT:TaskStart_TASK_WAIT(data)
	self.waitEnd = CurTime() +data
end

function ENT:Task_TASK_WAIT(data)
	if CurTime() < self.waitEnd && IsValid(self.entEnemy) && !self:Visible(self.entEnemy) then return end
	self.waitEnd = nil
	self:TaskComplete()
end

function ENT:OnInterrupt()
	if IsValid(self.entSporeGrenade) then self.entSporeGrenade:Remove(); self.entSporeGrenade = nil end
end

function ENT:Flinch(hitgroup)
end

function ENT:OnFlinch(entAttacker)

	self:Interrupt()
	self:SpeakSentence("!ST_COVER0")
	
	local act = entAttacker:IsPlayer() && self.tblFlinchActivities[self.lastHitGroupDamage] || self.tblFlinchActivities[HITGROUP_GENERIC] || self.tblFlinchActivities[HITBOX_GENERIC]
	local schdHide = ai_schedule_slv.New("Hide")
	if act then schdHide:EngTask("TASK_PLAY_SEQUENCE", act) end
	schdHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
	schdHide:AddTask("TASK_CHECK_FAIL")
	schdHide:EngTask("TASK_WAIT_FOR_MOVEMENT")
	schdHide:AddTask("TASK_WAIT", math.Rand(4,5))
	self:StartSchedule(schdHide)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_strooper_dmg_slash")
		local angViewPunch
		local bRight = atk == "right"
		if bRight then
			angViewPunch = Angle(3,-24,3)
		else
			angViewPunch = Angle(-3,26,-3)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		if(atk == "shoot") then
			if !self.bPossessed then
				if !IsValid(self.entEnemy) then self.bInSchedule = false; return true end
				local flDist = self:OBBDistance(self.entEnemy)
				if self.entEnemy:Health() <= 0 || !self:CanSee(self.entEnemy) || flDist > self.fRangeDistance || flDist <= self.fMeleeDistance || CurTime() >= self.nextGrenade then self.bInSchedule = false; return true end
			elseif !self:GetPossessor():KeyDown(IN_ATTACK) then self:_PossScheduleDone(); return true end
			self:PlayActivity(ACT_RANGE_ATTACK1, self.bPossessed)
			return true
		end
		if(atk == "grenadestart") then
			self:SpeakSentence("!ST_THROW0")
			local entSpore = ents.Create("obj_spore")
			entSpore:SetEntityOwner(self)
			entSpore:SetParent(self)
			entSpore:SetGrenade(true)
			entSpore:Spawn()
			entSpore:Activate()
			entSpore:Fire("SetParentAttachment", "grenade", 0)
			self:DeleteOnDeath(entSpore)
			self.entSporeGrenade = entSpore
			return true
		end
		if(atk == "grenadethrow") then
			local entSpore = self.entSporeGrenade
			if !IsValid(entSpore) then return true end
			if (!self.posEnemyLast && !IsValid(self.entEnemy) && !self.bPossessed) then entSpore:Remove(); return true end
			self:DontDeleteOnDeath(entSpore)
			entSpore:SetParent()
			entSpore:PhysicsInit(SOLID_VPHYSICS)
			entSpore:SetMoveType(MOVETYPE_VPHYSICS)
			entSpore:PhysicsInitSphere(4, "metal_bouncy")
			entSpore:SetCollisionBounds(Vector(4, 4, 4), Vector(-4, -4, -4))
			entSpore.splashDelay = CurTime() +2.4
			local phys = entSpore:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:SetMass(1)
				phys:EnableDrag(false)
				phys:SetBuoyancyRatio(0)
				local posEnemy
				if !self.bPossessed then posEnemy = self.posEnemyLast || self.entEnemy:GetPos()
				else posEnemy = self:GetPossessor():GetPossessionEyeTrace().HitPos end
				local pos = entSpore:GetPos()
				local normal = self:GetConstrictedDirection(pos, 45, 45, posEnemy)
				if pos:Distance(posEnemy) > self.fRangeDistance then posEnemy = pos +normal *self.fRangeDistance end
				normal = normal *500 +Vector(0,0,3000 *((posEnemy -pos):Length() /5000))
				phys:ApplyForceCenter(normal)
			end
			self.entSporeGrenade = nil
			return true
		end
		if !IsValid(self.entEnemy) && !self.bPossessed then return true end
		local pos = self:GetAttachment(1).Pos
		local entPlasma = ents.Create("obj_shockroach_plasma")
		entPlasma:SetPos(pos)
		entPlasma:SetEntityOwner(self)
		entPlasma:Spawn()
		entPlasma:Activate()
		
		local phys = entPlasma:GetPhysicsObject()
		if IsValid(phys) then
			local posEnemyPred
			if !self.bPossessed then
				local posEnemy = self.entEnemy:GetHeadPos()
				local flDist = pos:Distance(posEnemy)
				local vel = self.entEnemy:GetVelocity() *math.Rand(0.5,0.7)
				posEnemyPred = posEnemy +vel *(flDist /2000)
			else posEnemyPred = self:GetPossessor():GetPossessionEyeTrace().HitPos end
			local dir = self:GetConstrictedDirection(pos, 45, 45, posEnemyPred)
			phys:ApplyForceCenter(dir *2000)
		end
		entPlasma:EmitSound("weapons/shock_roach/shock_fire.wav", 75, 100)
		return true
	end
end

function ENT:OnLostEnemy()
	self.nextChase = CurTime() +math.Rand(3,5)
	self:SpeakSentence("!ST_CHARGE0")
end

function ENT:CanThrowGrenade()
	local tracedata = {}
	tracedata.start = self:LocalToWorld(Vector(53.0234, 6.8881, 52.2532))
	tracedata.endpos = self.posEnemyLast || self.entEnemy:GetPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return !tr.Hit || (tr.Entity:IsValid() && tr.Entity == self.entEnemy)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local tr = self:CreateTrace(enemy:GetHeadPos(), nil, self:GetAttachment(1).Pos)
			local bRange = dist <= self.fRangeDistance && tr.Entity == enemy
			if bRange then
				if CurTime() >= self.nextGrenade && dist > 300 then
					self.nextGrenade = CurTime() +math.Rand(3,12)
					if self:CanThrowGrenade() then
						self:PlayActivity(ACT_RANGE_ATTACK2, true)
					end
					return
				end
				self:PlayActivity(ACT_RANGE_ATTACK1, true)
				self.bInSchedule = true
				return
			end
		elseif CurTime() >= self.nextGrenade && self.posEnemyLast && self:GetPos():Distance(self.posEnemyLast) <= self.fRangeDistance && self:VisibleVec(self.posEnemyLast) then
			self.nextGrenade = CurTime() +math.Rand(3,12)
			if self:CanThrowGrenade() then
				self:PlayActivity(ACT_RANGE_ATTACK2, self.posEnemyLast)
			end
			return
		end
		if CurTime() < self.nextChase then return end
		self:ChaseEnemy()
		if CurTime() >= self.nextCombatSpeak then
			self.nextCombatSpeak = CurTime() +math.Rand(3,5)
		if (math.random(1,10) > 5) then
			self:SpeakSentence("!ST_CHARGE0")
		else
			self:SpeakSentence("!ST_TAUNT0")
		end
	end
	elseif(disp == D_FR) then
		self:Hide()
	end
end