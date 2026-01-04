AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
ENT.NPCFaction = NPC_FACTION_PLAYER
ENT.iClass = CLASS_PLAYER_ALLY
ENT.bCanAnswerChatter = true
ENT.nHostileOnDamage = 2
ENT.CollisionBounds = Vector(13,13,72)

ENT.bPlayDeathSequence = true

ENT.iBloodType = BLOOD_COLOR_RED
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_SMALL_FLINCH,
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
local schdWalkToLastPosition = ai_schedule_slv.New("WlkLP")
schdWalkToLastPosition:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
schdWalkToLastPosition:EngTask("TASK_WALK_PATH")
schdWalkToLastPosition:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber(self.skHealth))
	
	self.nextLookAtTarget = CurTime() +math.Rand(1,24)
	
	for name, sentences in pairs(self.sentences) do
		local tbl = type(sentences) == "table" && sentences || {sentences}
		for _, sentence in pairs(tbl) do
			local br = string.find(sentence, "[[]")
			if br then
				local _br = string.find(sentence, "[]]", br +1)
				if _br then
					local str = string.sub(sentence, br +1, _br -1)
					local sep = string.find(str, "-")
					if sep then
						local Start = string.sub(str, 1, sep -1)
						Start = tonumber(Start)
						local End = string.sub(str, sep +1, string.len(str))
						End = tonumber(End)
						if Start && End then
							if type(sentences) != "table" then self.sentences[name] = {}
							else self.sentences[name][_] = nil end
							local strStart = string.sub(sentence, 1, br -1)
							local strEnd = string.sub(sentence, _br +1, string.len(sentence))
							for i = Start, End do
								table.insert(self.sentences[name], strStart .. i .. strEnd)
							end
						end
					end
				end
			end
		end
		if type(sentences) == "table" then table.MakeSequential(self.sentences[name]) end
	end
	
	if self._Init then self:_Init() end
	if !self.bGuard then
		self.nextScream = 0
		if self.bHeal then self.nextHeal = 0 end
		return
	end
	self.nextSpeakKill = 0
	self._PossSecondaryAttack = nil
end

function ENT:OnFoundEnemy(iEnemies)
	self:SelectSchedule()
	if !self.sentences["FoundEnemy"] || math.random(1,2) == 1 then return end
	self:SpeakRandomSentence("FoundEnemy",self)
end

function ENT:GetSentenceLength(sSentence)
	sSentence = string.Replace(sSentence,"!","")
	local content = file.Read("scripts/sentences.txt",true)
	local iSenStart = string.find(content,sSentence)
	if !iSenStart then return 0 end
	local iLenStart = string.find(content,"Len ",iSenStart)
	local nl = string.find(content,"\n",iSenStart)
	if(!iLenStart || (nl && iLenStart < nl)) then return 0 end
	iLenStart = iLenStart +4
	local iLenEnd = string.find(content,"}",iLenStart) -1
	local iLenEndB = string.find(content,"%s",iLenStart)
	if iLenEndB && iLenEndB < iLenEnd then
		iLenEnd = iLenEndB -1
	end
	local fLength = string.sub(content,iLenStart,iLenEnd)
	fLength = tonumber(fLength)
	return fLength
end

function ENT:OnUse(entActivator, entCaller, iType, value)
	if tobool(GetConVarNumber("ai_ignoreplayers")) || self.bPossessed then return end
	local iBehavior = self:GetBehavior()
	if iBehavior == 0 then
		if self:IsEnemy(entActivator) then return end
		local sSentence = self:SpeakRandomSentence("Follow")
		self:SetBehavior(1,entActivator)
		self:StopMoving()
		self.entLookTarget = entActivator
		print("sSentence: ",sSentence,self:GetSentenceLength(sSentence))
		self.delayLookStop = CurTime() +self:GetSentenceLength(sSentence)
	elseif iBehavior == 1 then
		local sSentence = self:SpeakRandomSentence("Wait",entActivator)
		self:SetBehavior(0)
		self:StopMoving()
		self.entLookTarget = entActivator
		self.delayLookStop = CurTime() +self:GetSentenceLength(sSentence)
	end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if !self.bGuard then
		if self:GetBodygroup(2) != 1 then fcDone(true); return end
		self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
		return
	end
	self:PlayActivity(ACT_ARM,false,fcDone)
	self.bInSchedule = true
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	if self:GetBodygroup(2) == 1 then
		self:PlayActivity(ACT_DISARM,false,fcDone)
		return
	end
	self:PlayActivity(ACT_ARM,false,fcDone)
	self:SpeakSentence("!SC_HEAL" .. math.random(0,7))
end

function ENT:_PossReload(entPossessor, fcDone)
	if self.nextPossessSentence && CurTime() < self.nextPossessSentence then fcDone(true); return end
	if math.random(1,2) == 1 then
		local sSentence = table.Random(self.sentences["Question"])
		self:SpeakSentence(sSentence, self)
		self.nextAnswer = CurTime() +self:GetSentenceLength(sSentence) +math.Rand(0.4,1.8)
		self.nextPossessSentence = CurTime() +self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8)
	elseif self.sentences["Idle"] || self.sentences["Hear"] || self.sentences["Smell"] then
		local sentences = {}
		if self.sentences["Idle"] then table.Add(sentences, self.sentences["Idle"]) end
		if self.sentences["Hear"] then table.Add(sentences, self.sentences["Hear"]) end
		if self.sentences["Smell"] then table.Add(sentences, self.sentences["Smell"]) end
		local sSentence = table.Random(sentences)
		self:SpeakSentence(sSentence, self)
		self.nextPossessSentence = CurTime() +self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8)
	end
	fcDone(true)
end

function ENT:OnScheduleSelection()
	if !IsValid(self.entLookTarget) || self.bInSchedule || self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	local yaw = -360 -(self:GetAngles().y -(self.entLookTarget:GetPos() -self:GetPos()):Angle().y)
	if yaw < -180 then yaw = yaw +360 end
	if yaw > 75 || yaw < -75 then
		local schdTurn = ai_schedule_slv.New("Turn")
		local task
		if yaw > 0 then task = "TASK_TURN_LEFT"
		else task = "TASK_TURN_RIGHT" end
		local yaw_turn = yaw
		if yaw_turn < 0 then yaw_turn = yaw_turn +360 end
		
		if yaw_turn > 75 then task = "TASK_TURN_LEFT"
		else task = "TASK_TURN_RIGHT" end
		
		schdTurn:EngTask(task, yaw_turn)
		self:StartSchedule(schdTurn)
	end
end

function ENT:FindLookTarget()
	local tblPlayers = player.GetAll()
	local posSelf = self:GetPos()
	local distMin = 250
	local ent
	for k, v in pairs(tblPlayers) do
		if IsValid(v) then
			local flDist = v:GetPos():Distance(posSelf)
			if flDist <= distMin && v:Health() > 0 then
				distMin = flDist
				ent = v
			end
		end
	end
	return ent
end

function ENT:FindAndSetLookTarget(flDelay)
	self.entLookTarget = self:FindLookTarget()
	if IsValid(self.entLookTarget) then
		self.delayLookStop = CurTime() +flDelay
	end
end

function ENT:SpeakRandomSentence(name,listener)
	local r = table.Random(self.sentences[name])
	self:SpeakSentence(r)
	return r
end

function ENT:AnswerChatter()
	self:SpeakRandomSentence("AnswerChatter")
end

function ENT:AllyShotChatter(entAttacker)
	local sSentence = self:SpeakRandomSentence("AnswerAllyShot")
	self.entLookTarget = entAttacker
	self.delayLookStop = CurTime() +self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8)
end

function ENT:OnThink()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	self:UpdateLastEnemyPositions()
	if self.bGuard && self.bInSchedule then
		if self.bPossessed then
			local ang = (self:GetPos() +self:GetForward() *23 +self:GetUp() *54 -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
			if ang >= 90 then ang = ang -360 end
			ang = math.Clamp(ang,-50,50)
			self:SetPoseParameter("XR", ang)
		elseif IsValid(self.entEnemy) then
			self:FaceEnemy()
			local pos = self:GetPos() +self:GetForward() *23 +self:GetUp() *54
			local ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
			if ang >= 90 then ang = ang -360 end
			ang = math.Clamp(ang,-50,50)
			self:SetPoseParameter("XR", ang)
		end
		return
	end
	if self:PercentageFrozen() >= 80 then return end
	if self.delayLookStop && CurTime() >= self.delayLookStop then
		self.delayLookStop = nil
		self.entLookTarget = nil
		self.nextLookAtTarget = CurTime() +math.Rand(6,12)
	end
	
	if !IsValid(self.entLookTarget) then
		if self.nextLookAtTarget && CurTime() >= self.nextLookAtTarget then
			self:FindAndSetLookTarget(math.Rand(4,8))
		end
	end
	local yaw
	if IsValid(self.entLookTarget) then
		if !self:Visible(self.entLookTarget) || self:GetPos():Distance(self.entLookTarget:GetPos()) >= 500 then
			self.entLookTarget = nil
			yaw = 0
		else
			yaw = -360 -(self:GetAngles().y -(self.entLookTarget:GetPos() -self:GetPos()):Angle().y)
			if yaw < -180 then yaw = yaw +360 end
		end
	else yaw = 0 end
	
	local pp_head = math.Clamp(yaw, -75, 75)
	local pp_head_cur = self:GetPoseParameter("head_yaw")
	if pp_head > pp_head_cur then pp_head_cur = math.Clamp(pp_head_cur +15,-75,pp_head)
	elseif pp_head < pp_head_cur then pp_head_cur = math.Clamp(pp_head_cur -15, pp_head, 75) end
	self:SetPoseParameter("head_yaw", pp_head_cur)
	
	if self.nextAnswer && CurTime() >= self.nextAnswer then
		self.nextAnswer = nil
		local tblEnts = {}
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
			if IsValid(v) then
				if v.bCanAnswerChatter && v.AnswerChatter && v != self && !v.delayHide then
					table.insert(tblEnts,v)
				end
			end
		end
		if #tblEnts > 0 then
			local ent = tblEnts[math.random(1,#tblEnts)]
			ent:AnswerChatter()
		end
	end
	if self.bPossessed then return end
	if self:HasCondition(1) && self:HasCondition(32) && CurTime() >= self.nextIdle then
		if math.random(1,12) == 1 then
			if self.sentences["Question"] && math.random(1,2) == 1 then
				local sSentence = self:SpeakRandomSentence("Question",self)
				local length = self:GetSentenceLength(sSentence)
				self.nextAnswer = CurTime() +length +math.Rand(0.4,1.8)
				self.nextIdle = self.nextAnswer +math.Rand(10,23)
				self:FindAndSetLookTarget(length +math.Rand(0.4,0.8))
			else
				if self.sentences["PlayerHealthLow"] && IsValid(self.entLookTarget) && self.entLookTarget:Health() <= self.entLookTarget:GetMaxHealth() *0.75 && math.random(1,3) == 1 then
					local sSentence = self:SpeakRandomSentence("PlayerHealthLow",self)
					self:FindAndSetLookTarget(self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8))
					return
				end
				if self.sentences["Idle"] || self.sentences["Hear"] || self.sentences["Smell"] then
					local sentences = {}
					if self.sentences["Idle"] then table.Add(sentences, self.sentences["Idle"]) end
					if self.sentences["Hear"] then table.Add(sentences, self.sentences["Hear"]) end
					if self.sentences["Smell"] then table.Add(sentences, self.sentences["Smell"]) end
					local sSentence = table.Random(sentences)
					self:SpeakSentence(sSentence, self)
					self.nextIdle = CurTime() +math.Rand(10,23)
					
					self:FindAndSetLookTarget(self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8))
				end
			end
		else
			self.nextIdle = CurTime() +math.Rand(8,12)
		end
	end
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:LocalToWorld(Vector(25.6502, 1.4530, 58.3434))
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:DropWeapon(vel)
	local attPosAng = self:GetAttachment(self:LookupAttachment("gun"))
	
	local entWeapon = ents.Create(self.Weapon)
	entWeapon:SetPos(attPosAng.Pos)
	entWeapon:SetAngles(attPosAng.Ang)
	entWeapon:Spawn()
	entWeapon:Activate()
	local phys = entWeapon:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(vel)
	end
		
	self:SetBodygroup(2,0)
	return true
end

function ENT:OnBehaviorInterrupt(iBehavior)
	if !self.bGuard then return end
	self:PlayActivity(ACT_DISARM, false, self._PossScheduleDone)
	self.bInSchedule = false
end

function ENT:OnInterrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
end

function ENT:OnBehaviorFailed(iBehavior)
	if iBehavior != 1 then return end
	if self.sentences["Stop"] then
		local sSentence = table.Random(self.sentences["Stop"])
		self:SpeakSentence(sSentence,entFollow,nil,self)
	end
	self:SetBehavior(0)
	self:FindAndSetLookTarget(self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8))
end

function ENT:OnCondition(iCondition)
	if self.bDead then return end
	if !self.bFoundPlayer && self:HasCondition(COND_IN_PVS) && self:HasCondition(COND_SEE_PLAYER) then
		local flDelay
		if self.sentences["Hello"] && math.random(1,3) == 1 then
			local sSentence = self:SpeakRandomSentence("Hello",self)
			flDelay = self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8)
		else flDelay = math.Rand(0.6,2) end
		self.bFoundPlayer = true
		self.nextIdle = CurTime() +5
		self:FindAndSetLookTarget(flDelay)
	end
	local iNPCState = self:GetState()
	if iNPCState != 3 && (iCondition == 7 || iCondition == 8 || #self.tblMemory > 0) then
		if iNPCState != 2 then
			self:PlaySound("Alert")
			if #self.tblAlertAct > 0 then
				self:PlayActivity(self.tblAlertAct[math.random(1,#self.tblAlertAct)], true)
			end
		end
		self:SetState(NPC_STATE_COMBAT)
		return
	end
	if iNPCState == 3 && !self:HasCondition(COND_SEE_HATE) && !self:HasCondition(COND_SEE_FEAR) && #self.tblMemory == 0 && (self:HasCondition(COND_ENEMY_UNREACHABLE) || self:HasCondition(COND_ENEMY_DEAD) || self:HasCondition(COND_ENEMY_OCCLUDED)) then
		self:SetState(NPC_STATE_ALERT)
	end
end

function ENT:DamageHandle(dmginfo)
	if self:Health() -dmginfo:GetDamage() <= 0 then return end
	if !self.bWounded then
		if math.random(1,2) == 1 then self.bWounded = true
		elseif self.sentences["Mortal"] && self.sentences["Wound"] then
			timer.Simple(math.Rand(3,6), function() if IsValid(self) && !self.bDead then
				local sSentence = table.Random(self.sentences[math.random(0,2) == 2 && "Mortal" || "Wound"])
				self:SpeakSentence(sSentence)
				self.bWounded = true
			end end)
		end
	end
end

function ENT:DoFollowBehavior(entFollow)
	self:StopMoving()
	local flDistOBB = self:OBBDistance(entFollow)
	if flDistOBB <= 10 && self:EntityIsPushing(entFollow) then
		if self.bInSchedule then self:OnBehaviorInterrupt(1)
		else
			self:SetLastPosition(self:GetPos() +(self:GetPos() -entFollow:GetPos()):GetNormal() *50)
			self:StartSchedule(schdWalkToLastPosition)
		end
	elseif self.bHeal && flDistOBB <= 40 && entFollow:Health() <= entFollow:GetMaxHealth() -20 && CurTime() >= self.nextHeal then
		self:PlayActivity(ACT_ARM, true)
		self:SpeakRandomSentence("Heal")
	end
end

function ENT:OnDamagedByAlliedPlayer(pl,dmginfo,nTimesShot)
	local entAttacker = dmginfo:GetAttacker()
	if self.bGuard then
		if nTimesShot < self.nHostileOnDamage then
			local sSentence = self:SpeakRandomSentence("Shot")
			
			self.entLookTarget = entAttacker
			self.delayLookStop = CurTime() +self:GetSentenceLength(sSentence) +math.Rand(0.4,0.8)
		else self:SpeakRandomSentence("Mad") end
	else
		if CurTime() >= self.nextScream then
			self.nextScream = CurTime() +math.Rand(3,8)
			self:SpeakRandomSentence("Scream")
		elseif self:GetBehavior() == 1 && entAttacker != self.entFollow then
			self:SetBehavior(0)
			self:SpeakRandomSentence("Fear")
		end
	end
	local tblEnts = {}
	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if IsValid(ent) then
			if ent.bCanAnswerChatter && ent.AllyShotChatter && ent != self && !ent:IsEnemy(entAttacker) then
				table.insert(tblEnts,ent)
			end
		end
	end
	if #tblEnts > 0 then
		local ent = tblEnts[math.random(1,#tblEnts)]
		ent:AllyShotChatter(entAttacker)
	end
end