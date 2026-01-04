AddCSLuaFile( "shared.lua" )

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_alien_tentacle")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_alien_tentacle")
ENT.sModel = "models/half-life/tentacle.mdl"
ENT.fMeleeDistance = 80

ENT.bPlayDeathSequence = true
ENT.bFlinchOnDamage = false
ENT.tblIgnoreDamageTypes = {DMG_AIRBOAT, DMG_DISSOLVE, DMG_DROWN, DMG_DROWNRECOVER, DMG_FALL, DMG_NERVEGAS, DMG_PHYSGUN, DMG_VEHICLE}
ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/tentacle/"

ENT.m_tbSounds = {
	["Attack"] = "te_strike[1-2].wav",
	["Idle"] = { "te_sing[1-2].wav", "te_move[1-2].wav", "te_roar[1-2].wav", "te_swing[1-2].wav", "te_squirm2.wav", "te_search[1-2].wav", "te_alert[1-2].wav", "te_flies1.wav"},
	["Death"] = "te_death2.wav"
}

ENT.tblAlertAct = {}
ENT.skName = "tentacle"
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetMoveType(MOVETYPE_STEP)
	
	self:SetCollisionBounds(Vector(26, 26, 100), Vector(-26, -26, 0))

	self:SetHealth(GetConVarNumber("sk_tentacle_health"))
	
	self.nextRange = 0
	self.iLevel = 0
	self.nextStrike = 0
	self.nextIgnoreEnemy = 0
	self.nextSing = CurTime() +math.Rand(8, 22)
	self:SetSoundLevel(90)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(self:GetAttackActivity(), false, fcDone, false, true)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:GoToNextLevel(fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:GoToPreviousLevel(fcDone)
end

function ENT:_PossFaceForward(entPossessor, fcDone)
	if fcDone then fcDone(true) end
end

function ENT:_PossMovement(entPossessor)
	local ang = entPossessor:GetAimVector():Angle()
	self:TurnDegree(2, ang)
end

function ENT:EventHandle(sEvent)
	if string.find(sEvent,"mattack") then
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_tentacle_dmg_strike")
		local angViewPunch = Angle(20,0,0)
		local bHit
		self:DoMeleeDamage(fDist,iDmg,angViewPunch,self:LookupAttachment("tip"),function(ent)
			bHit = true
		end,true,false)
		if bHit then self:EmitSound("npc/zombie/claw_strike" ..math.random(1,3).. ".wav", 75, 100)
		else
			local pos = self:GetAttachment(self:LookupAttachment("tip")).Pos
			local tr = util.TraceLine({start = pos +Vector(0,0,20), endpos = pos -Vector(0,0,40), filter = self})
			if tr.Hit then
				local mat = tr.MatType
				local sSound
				if mat == 83 then
					sSound = self.sSoundDir .. "te_hitslosh" .. math.random(1,4) .. ".wav"
				elseif mat == 67 || mat == 68 || mat == 79 || mat == 85 || mat == 78 || mat == 84 || mat == 87 then
					sSound = self.sSoundDir .. "te_hitdirt" .. math.random(1,4) .. ".wav"
				else sSound = self.sSoundDir .. "te_strike" .. math.random(1,2) .. ".wav" end
				self:EmitSound(sSound, 75, 100)
			end
		end
		if !self:IsPossessed() then
			local bEnemyValid = IsValid(self.entEnemy) && self:CanSee(self.entEnemy) && self:OBBDistance(self.entEnemy) <= 400
			if (math.random(1,2) == 1 || bEnemyValid || self.forceFacePos) && (!bEnemyValid || !self:CheckEnemyHeight()) then
				self.forceFacePos = nil
				self:StartEngineTask(GetTaskID("TASK_RESET_ACTIVITY"), 0)
				local bFaceEnemy = bEnemyValid && self:HearEnemy(self.entEnemy) && fDist <= 160
				if !bFaceEnemy then
					if self:CanAttack() then self.posFace = self.posEnemyLastMem
					else self.nextStrike = CurTime() +math.Rand(1,6); return end
				end
				self:PlayActivity(self:GetAttackActivity(), bFaceEnemy, nil, true, true)
			else
				self.nextStrike = CurTime() +math.Rand(1,6)
			end
		elseif self:GetPossessor():KeyDown(IN_ATTACK) then self:StartEngineTask(GetTaskID("TASK_RESET_ACTIVITY"), 0) end
		return
	end
	if string.find(sEvent, "idle") then
		if self:IsPossessed() then return end
		//self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), self:GetIdleActivity())
		self:ScheduleFinished()
		self:SelectSchedule()
		return
	end
end

function ENT:OnThink()
	if tobool(GetConVarNumber("ai_disabled")) || self.bDead then return end
	if !self:IsPossessed() && self.posFace then
		self:TurnDegree(20,(self.posFace -self:GetPos()):Angle())
		local ang = self:GetAngleToPos(self.posFace)
		if ang.y < 20 then self.posFace = nil end
	end
	if !IsValid(self.entEnemy) || self:OBBDistance(self.entEnemy) > 400 then
		if CurTime() >= self.nextSing then
			self.nextSing = CurTime() +math.Rand(8, 22)
			self:PlaySound("Idle")
		end
		return
	end
	if self:HearEnemy(self.entEnemy) then
		self.posEnemyLastMem = self.entEnemy:GetPos() +self.entEnemy:GetVelocity() *0.5
		self.nextIgnoreEnemy = CurTime() +6
	end
end

function ENT:DamageHandle(dmginfo)
	local entAttacker = dmginfo:GetAttacker()
	if !IsValid(self.entEnemy) || entAttacker == self.entEnemy then
		self.posEnemyLastMem = dmginfo:GetDamagePosition()
		self.nextIgnoreEnemy = CurTime() +6
		self.nextStrike = 0
		self.forceFacePos = true
	end
end

function ENT:GoToNextLevel(fcDone)
	if self.iLevel == 3 then fcDone(true); return end
	local actIdle
	local act
	if self.iLevel == 0 then
		act = ACT_SIGNAL1
		actIdle = ACT_IDLE_RELAXED
		self:SetCollisionBounds(Vector(26, 26, 350), Vector(-26, -26, 0))
	elseif self.iLevel == 1 then
		act = ACT_SIGNAL2
		actIdle = ACT_IDLE_ANGRY_MELEE
		self:SetCollisionBounds(Vector(26, 26, 550), Vector(-26, -26, 0))
	elseif self.iLevel == 2 then
		act = ACT_SIGNAL3
		actIdle = ACT_IDLE_ANGRY
		self:SetCollisionBounds(Vector(26, 26, 640), Vector(-26, -26, 0))
	end
	self:SetIdleActivity(actIdle)
	self:PlayActivity(act, false, fcDone, false, true)
	self.iLevel = self.iLevel +1
end

function ENT:GoToPreviousLevel(fcDone)
	if self.iLevel == 0 then fcDone(true); return end
	local actIdle
	local act
	if self.iLevel == 3 then
		act = ACT_SIGNAL_HALT
		actIdle = ACT_IDLE_ANGRY_MELEE
		self:SetCollisionBounds(Vector(26, 26, 550), Vector(-26, -26, 0))
	elseif self.iLevel == 2 then
		act = ACT_SIGNAL_FORWARD
		actIdle = ACT_IDLE_RELAXED
		self:SetCollisionBounds(Vector(26, 26, 350), Vector(-26, -26, 0))
	elseif self.iLevel == 1 then
		act = ACT_SIGNAL_ADVANCE
		actIdle = ACT_IDLE
		self:SetCollisionBounds(Vector(26, 26, 100), Vector(-26, -26, 0))
	end
	self:SetIdleActivity(actIdle)
	self:PlayActivity(act, false, fcDone, false, true)
	self.iLevel = self.iLevel -1
end

function ENT:OnFoundEnemy()
	self.nextIgnoreEnemy = CurTime() +6
end

function ENT:HearEnemy(ent)
	if ent:IsPlayer() then
		return ent:OnGround() && (ent:KeyDown(IN_FORWARD) || ent:KeyDown(IN_BACK) || ent:KeyDown(IN_MOVELEFT) || ent:KeyDown(IN_MOVERIGHT) || ent:KeyDown(IN_JUMP)) && !ent:KeyDown(IN_DUCK) && (!ent:KeyDown(IN_WALK) || ent:KeyDown(IN_SPRINT))
	else
		local pos = self:GetAttachment(self:LookupAttachment("tip")).Pos
		return ent:NearestPoint(pos):Distance(pos) <= 160 || self:GetPos():Distance(pos) >= self:OBBDistance(ent)
	end
	return false
end

function ENT:GetAttackActivity()
	if self.iLevel == 0 then return ACT_MELEE_ATTACK1
	elseif self.iLevel == 1 then return ACT_MELEE_ATTACK2
	elseif self.iLevel == 2 then return ACT_RANGE_ATTACK1_LOW end
	return ACT_RANGE_ATTACK2_LOW
end

local schdFaceLastPos = ai_schedule_slv.New("Face Last Position")
schdFaceLastPos:EngTask("TASK_FACE_LASTPOSITION")
function ENT:FacePosition(pos)
	self:SetLastPosition(pos)

	self:StartSchedule(schdFaceLastPos)
	self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), self:GetIdleActivity())
end

function ENT:SelectSchedule(iNPCState)
	if GetConVarNumber("ai_disabled") == 1 || self:IsPossessed() || self:PercentageFrozen() == 100 || self:GetState() == NPC_STATE_DEAD || CurTime() < self.schdWait then return end
	local iMemory = #self.tblMemory
	local tblEnemies = self:UpdateEnemies()
	local _iMemory = #self.tblMemory
	if iMemory == 0 && _iMemory > 0 then self:OnFoundEnemy(_iMemory); return
	elseif iMemory > 0 && _iMemory == 0 then self:OnAreaCleared() end
	if !IsValid(self.entEnemy) then
		if CurTime() >= self.nextStrike then
			self:PlayActivity(self:GetAttackActivity(), false, nil, false, true)
		elseif self:GetActivity() != self:GetIdleActivity() then
			self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), self:GetIdleActivity())
			self.CurrentSchedule = nil
			local seqEnd = CurTime() +self:SequenceDuration()
			if self.nextStrike < seqEnd then
				self.nextStrike = seqEnd
			end
		end
		return
	end
	
	local iDisposition = self:Disposition(self.entEnemy)
	local posEnemy = self.entEnemy:NearestPoint(self:GetPos() +self.entEnemy:OBBCenter())
	local posSelf = self:NearestPoint(self.entEnemy:GetPos() +self:OBBCenter())
	posEnemy.z = self.entEnemy:GetPos().z
	posSelf.z = self:GetPos().z
	
	local posEnemyPredicted = posEnemy +self.entEnemy:GetVelocity() *0.9
	local fDistPredicted = posEnemyPredicted:Distance(posSelf)
	local fDist = posEnemy:Distance(posSelf)
	
	if iDisposition == 2 then
		self:SetTarget(self.entEnemy)
		self:UpdateEnemyMemory(self.entEnemy, self.entEnemy:GetPos())
		self:SelectScheduleHandle(fDist,fDistPredicted,iDisposition)
		return
	end
	self:SetEnemy(self.entEnemy)
	self:UpdateEnemyMemory(self.entEnemy, self.entEnemy:GetPos())
	self:SelectScheduleHandle(fDist,fDistPredicted,iDisposition)
end

local tblLevelPositions = {[0] = Vector(340.5056, -0.7923, -1.6083), [1] = Vector(333.4515, -8.5794, 264.7265), [2] = Vector(326.3354, -1.4104, 452.9680), [3] = Vector(343.7961, -0.2004, 639.8391)}
function ENT:CheckEnemyHeight()
	local posEnemy = self.entEnemy:GetPos()
	local distZ = self:GetPos().z -posEnemy.z
	if distZ < 0 then distZ = distZ *-1 end
	if self.iLevel < 3 && distZ > tblLevelPositions[self.iLevel +1].z -30 then
		self:GoToNextLevel()
		return true
	elseif self.iLevel > 0 && distZ < tblLevelPositions[self.iLevel -1].z +30 then
		self:GoToPreviousLevel()
		return true
	end
	return false
end

function ENT:CanAttack()
	local pos = self:LocalToWorld(tblLevelPositions[self.iLevel])
	return util.TraceLine({start = pos +Vector(0,0,20), endpos = pos -Vector(0,0,40), filter = self}).Hit
end

function ENT:SelectScheduleHandle(enemy, fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 || iDisposition == 2 then
		if !self:CheckEnemyHeight() then
			local posSelf = self:NearestPoint(self.entEnemy)
			local posEnemy = self.entEnemy:NearestPoint(self)
			fDist = posSelf:Distance(posEnemy)
			local bFaceEnemy = self:HearEnemy(self.entEnemy) && fDist <= 160
			if !bFaceEnemy then
				if self:CanAttack() then self.posFace = self.posEnemyLastMem
				else
					self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), self:GetIdleActivity())
					return
				end
			end
			self:StartEngineTask(GetTaskID("TASK_RESET_ACTIVITY"), 0)
			self:PlayActivity(self:GetAttackActivity(), bFaceEnemy, nil, true, true)
		end
	end
end

function ENT:DoDeath(dmginfo)
	if !dmginfo:IsDamageType(DMG_DISSOLVE) then
		self:SetNPCState(NPC_STATE_DEAD)
		self:SetState(NPC_STATE_DEAD)
		self:SetSchedule(SCHED_DIE)
		timer.Simple(0.1,function()
			if !IsValid(self) then return end
			timer.Simple(self:SequenceDuration() -0.1, function()
				if !IsValid(self) then return end
				self:Remove()
			end)
		end)
	end
end

function ENT:GetEnemies()
	local tblPotentialEnemies = {}
	local bIgnorePlayers = tobool(GetConVarNumber("ai_ignoreplayers")) || self.bIgnorePlayers
	if !bIgnorePlayers then table.Add(tblPotentialEnemies,player.GetAll()) end
	if !self.bIgnoreNPCs then
		table.Add(tblPotentialEnemies,ents.FindByClass("npc_*"))
		table.Add(tblPotentialEnemies,ents.FindByClass("monster_*"))
		table.Add(tblPotentialEnemies,ents.FindByClass("obj_sentrygun"))
	end
	local tblEnemies = {}
	local posSelf = self:GetPos()
	for k, ent in pairs(tblPotentialEnemies) do
		local bNPC = ent:IsNPC()
		local bPlayer = ent:IsPlayer()
		if (bNPC || bPlayer) && !ent:GetNoTarget() then
			local posEnemy = ent:GetPos()
			local fDist = posSelf:Distance(posEnemy)
			local bIsPlayer = bPlayer && !ent:IsPossessing()
			local bIsNPC = bNPC
			local bValid = (bIsNPC && ent != self && ent:Health() > 0) || (bIsPlayer && ent:Alive())
			if bValid && fDist <= self.fViewDistance && !ent.bSelfDestruct && self:HearEnemy(ent) then
				local iDisposition = self:Disposition(ent)
				if self:Visible(ent) && (iDisposition == 1 || iDisposition == 2) && (self:GetAIType() != 5 || ent:WaterLevel() > 1) then
					table.insert(tblEnemies,ent)
				end
			end
		end
	end
	self:AddToMemory(tblEnemies)
	return tblEnemies
end

function ENT:DoMeleeDamage(fDist,iDmg,angViewPunch,iAttachment,funcAdd,bIgnoreAngle,sHitSound)
	local posDmg = self:GetAttachment(iAttachment).Pos
	local posSelf = self:GetPos()
	local bHit
	local tblEnts = ents.FindInSphere(posDmg,fDist)
	local posSelf = self:GetPos()
	for k, v in pairs(ents.FindInSphere(posSelf, posDmg:Distance(posSelf))) do
		if IsValid(v) && (self:IsEnemy(v) || v:IsPhysicsEntity()) && self:IsVisible(v) && v:Health() > 0 then
			local posEnemy = v:GetPos()
			local angToEnemy = self:GetAngleToPos(posEnemy).y
			if (angToEnemy <= 10 && angToEnemy >= 0) || (angToEnemy <= 360 && angToEnemy >= 350) then
				table.insert(tblEnts, v)
			end
		end
	end
	local posSelfCenter = posSelf +self:OBBCenter()
	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(iDmg)
	dmgInfo:SetAttacker(self)
	dmgInfo:SetInflictor(self)
	dmgInfo:SetDamageType(DMG_SLASH)
	for k, v in pairs(tblEnts) do
		if IsValid(v) && (self:IsEnemy(v) || v:IsPhysicsEntity()) && self:IsVisible(v) && v:Health() > 0 then
			local posEnemy = v:GetPos()
			local angToEnemy = self:GetAngleToPos(posEnemy).y
			if bIgnoreAngle || ((angToEnemy <= 70 && angToEnemy >= 0) || (angToEnemy <= 360 && angToEnemy >= 290)) then
				bHit = true
				if funcAdd then funcAdd(v) end
				dmgInfo:SetDamagePosition(v:NearestPoint(posSelfCenter))
				v:TakeDamageInfo(dmgInfo)
				if v:IsPlayer() then v:ViewPunch(angViewPunch) end
				if v:GetClass() == "npc_turret_floor" && !v.bSelfDestruct then
					v:Fire("selfdestruct", "", 0)
					v:GetPhysicsObject():ApplyForceCenter(self:GetForward() *10000) 
					v.bSelfDestruct = true
				end
			end
		end
	end
	if sHitSound == false then return end
	local sSound = sHitSound || "npc/zombie/claw_strike" ..math.random(1,3).. ".wav"
	if bHit then
		self:EmitSound(sSound, 75, 100)
	else
		self:EmitSound("npc/zombie/claw_miss" ..math.random(1,2).. ".wav", 75, 100)
	end
end

function ENT:UpdateMemory()
	local mem = self:GetMemory()
	for ent, data in pairs(mem) do
		local bValid = IsValid(ent)
		local iDisposition = bValid && self:Disposition(ent)
		if !bValid || ent:Health() <= 0 || !self:HearEnemy(ent) || self:OBBDistance(ent) > self.fViewDistance || ent:GetNoTarget() || (ent:IsPlayer() && (!ent:Alive() || tobool(GetConVarNumber("ai_ignoreplayers")))) || (iDisposition != 1 && iDisposition != 2) || (self:GetAIType() == 5 && ent:WaterLevel() < 2) || ent.bSelfDestruct then
			self:RemoveFromMemory(ent)
		end
	end
end

function ENT:UpdateEnemies()
	local num = self.iMemCount
	if self.entEnemy && (!IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:GetNoTarget() || CurTime() >= self.nextIgnoreEnemy || (self:GetAIType() == 5 && self.entEnemy:WaterLevel() < 2) || (self.entEnemy:IsPlayer() && tobool(GetConVarNumber("ai_ignoreplayers"))) || self.entEnemy.bSelfDestruct) then self:RemoveFromMemory(self.entEnemy) end
	self:UpdateMemory()
	self:GetEnemies()
	local fDistClosest = self.fViewDistance
	local posSelf = self:GetPos()
	local enemyLast = self.entEnemy
	local mem = self:GetMemory()
	for ent, data in pairs(mem) do
		local posEnemy = ent:GetPos()
		local fDist = posSelf:Distance(posEnemy)
		if fDist < fDistClosest then
			self.entEnemy = ent
			fDistClosest = fDist
		end
	end
	if self.entEnemy != enemyLast then self:OnPrimaryTargetChanged(self.entEnemy) end
	
	if self.sSquad && self.tblSquadMembers && self.iMemCount > 0 then
		for _, ent in pairs(self.tblSquadMembers) do
			if !IsValid(ent) then self.tblSquadMembers[_] = nil
			else ent:MergeMemory(mem) end
		end
		table.refresh(self.tblSquadMembers)
	end
	if num == 0 && self.iMemCount > 0 then self:OnFoundEnemy(self.iMemCount); return
	elseif num > 0 && self.iMemCount == 0 then self:SetState(NPC_STATE_IDLE); self:OnAreaCleared(); self.tblMemBlockedNodeLinks = {} end
	return mem
end