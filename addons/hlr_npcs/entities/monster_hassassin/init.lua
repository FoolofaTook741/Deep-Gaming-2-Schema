AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.iClass = CLASS_MILITARY
ENT.sModel = "models/half-life/hassassin.mdl"
ENT.fRangeDistance = 1650
ENT.fMeleeDistance = 75
ENT.fFollowAttackDistance = 600
ENT.fFollowDistance = 175
ENT.bWander = false
ENT.bFlinchOnDamage = false

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/fassassin/"

ENT.tblSourceSounds = {}

ENT.tblDeathActivities = {}



function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_OPEN_DOORS))

	self:SetHealth(120)
	self.nextAction = math.Rand(8,22)
end

function ENT:GetRandomPos()
	local tblTraces = {}
	local tr
	local bValid = IsValid(self.entEnemy)
	for i = 1, 4 do
		local posEnd = self:GetCenter()
		posEnd = posEnd +Vector(math.Rand(-1,1), math.Rand(-1,1)) *math.Rand(400, 900)
		local tracedata = {}
		tracedata.start = self:GetPos()
		tracedata.endpos = posEnd
		tracedata.filter = self
		local trace = util.TraceLine(tracedata)
		local iDist = self:GetPos():Distance(trace.HitPos)
		if bValid && !self.entEnemy:VisibleVec(trace.HitPos) then
			tr = trace
			break
		end
		table.insert(tblTraces,trace)
	end
	if tr then return tr.HitPos end
	return tblTraces[math.random(1,#tblTraces)].HitPos
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self.bInSchedule = true
	self:PlayActivity(ACT_RANGE_ATTACK1, false, fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1, false, fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK2, false, fcDone)
			local entGrenade = ents.Create("obj_handgrenade")
			entGrenade:SetExplodeDelay(2.5)
			entGrenade:SetEntityOwner(self)
			entGrenade:SetPos(self:GetAttachment(2).Pos)
			entGrenade:Spawn()
			local phys = entGrenade:GetPhysicsObject()
			if IsValid(phys) then
				local fDist = 540
				if self.bPossessed then
					fDist = math.Clamp(self:GetPos():Distance(self.entPossessor:GetPossessionEyeTrace().HitPos),240,800)
				elseif IsValid(self.entEnemy) then
					fDist = math.Clamp(self:GetPos():Distance(self.entEnemy:GetPos()),240,800)
				end
				phys:ApplyForceCenter(self:GetForward() *fDist +self:GetUp() *320)
	end
end

function ENT:_PossJump(entPossessor, fcDone)
	if !self:OnGround() then return end
	self.bPossJumpEnd = false
	self:PlayActivity(ACT_HOP, false)
	self.bInSchedule = true
	self._possfuncJumpEnd = fcDone
end

function ENT:EventHandle(sEvent)
	if string.find(sEvent,"mattack") then
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		local bLeft = string.find(sEvent,"left")
		local bRight = !bLeft
		if bRight then
			iDmg = GetConVarNumber("sk_hassassin_dmg_kick_double")
			angViewPunch = Angle(-30,-26,3)
		else
			iDmg = GetConVarNumber("sk_hassassin_dmg_kick_double")
			angViewPunch = Angle(-38,-6,1)
		end
		self:DoMeleeDamage(fDist,iDmg,angViewPunch)
		return
	end
	if string.find(sEvent,"jump") then
		if string.find(sEvent,"start") then
			self:SetLocalVelocity(self:GetForward() *-1720 +Vector(0, 0, 500) +self:GetRight() *math.Rand(-200,200))
		elseif string.find(sEvent,"loop") then
			local tracedata = {}
			tracedata.start = self:GetPos()
			tracedata.endpos = self:GetPos() -Vector(0,0,75)
			tracedata.filter = self
			local trace = util.TraceLine(tracedata)
			if trace.Hit then self:PlayActivity(ACT_LAND, false, self._possfuncJumpEnd); self.bInSchedule = false
			else
				local act = ACT_HOVER
				if (self.bPossessed && !self.entPossessor:KeyDown(IN_ATTACK)) || (!self.bPossessed && (!IsValid(self.entEnemy) || !self:Visible(self.entEnemy))) then act = ACT_JUMP end
				self:PlayActivity(act, true)
			return end
		end
		return
	end
	if string.find(sEvent,"rattack") then
		if string.find(sEvent,"grenade") then
			self:PlayActivity(ACT_RANGE_ATTACK2, false, fcDone)
			local entGrenade = ents.Create("obj_handgrenade")
			entGrenade:SetExplodeDelay(2.5)
			entGrenade:SetEntityOwner(self)
			entGrenade:SetPos(self:GetAttachment(2).Pos)
			entGrenade:Spawn()
			local phys = entGrenade:GetPhysicsObject()
			if IsValid(phys) then
				local fDist = 540
				if self.bPossessed then
					fDist = math.Clamp(self:GetPos():Distance(self.entPossessor:GetPossessionEyeTrace().HitPos),240,800)
				elseif IsValid(self.entEnemy) then
					fDist = math.Clamp(self:GetPos():Distance(self.entEnemy:GetPos()),240,800)
				end
				phys:ApplyForceCenter(self:GetForward() *fDist +self:GetUp() *320)
			end
			return
		end
		self:UpdateEnemies()
		if !self.bPossessed && (!IsValid(self.entEnemy) || !self:CanSee(self.entEnemy) || self.entEnemy:GetPos():Distance(self:GetPos()) > self.fRangeDistance) || self:GunTraceBlocked() then self.bInSchedule = false; return end
		if string.find(sEvent,"shoot") then
			if self.bPossessed && !self.entPossessor:KeyDown(IN_ATTACK) then self.bInSchedule = false; return end
			self:FaceEnemy()
			if CurTime() >= self.nextAction then self.bInSchedule = false; return end
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			return
		end
		local pos = self:GetPos() +self:GetForward() *33.5 +self:GetRight() *-14 +self:GetUp() *39.6
		local attPosAng = self:GetAttachment(1)
		local ang
		local fSpread
		if !self.bPossessed then
			ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
			if ang >= 90 then ang = ang -360 end
			ang = math.Clamp(ang,-23,45)
			self:SetPoseParameter("XR", ang)
			fSpread = 0.045
		else
			ang = (attPosAng.Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
			if ang >= 90 then ang = ang -360 end
			ang = math.Clamp(ang,-23,45)
			self:SetPoseParameter("XR", ang)
			fSpread = 0.025
		end
		local dir = self:GetAngles()
		dir.p = -ang
		dir = dir:Forward()
		self:EmitSound("weapons/pl_gun" .. math.random(1,2) .. ".wav", 100, 100)
		local effectdata = EffectData()
		effectdata:SetStart(attPosAng.Pos)
		effectdata:SetOrigin(attPosAng.Pos)
		effectdata:SetScale(1)
		effectdata:SetAngles(attPosAng.Ang)
		util.Effect("MuzzleEffect", effectdata)
		
		local tblBullet = {}
		tblBullet.Num = 1
		tblBullet.Src = attPosAng.Pos
		tblBullet.Attacker = self
		tblBullet.Dir = dir
		tblBullet.Spread = Vector(fSpread, fSpread, fSpread)
		tblBullet.Tracer = 1
		tblBullet.Force = 3
		tblBullet.Damage = math.random(6,8)
		self:FireBullets(tblBullet)
		return
		end
	local schdFaceLastPos = ai_schedule_slv.New("Face Last Position")
schdFaceLastPos:EngTask("TASK_FACE_LASTPOSITION")
function ENT:FacePosition(pos)
	self:SetLastPosition(pos)

	self:StartSchedule(schdFaceLastPos)
	self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), self:GetIdleActivity())
	end
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	if !self.bInSchedule || self:GetVelocity().z >= -5 then return end
	local pos = self:GetPos()
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,75),
		filter = self
	})
	if tr.Hit then
		self:PlayActivity(ACT_LAND, false, self._possfuncJumpEnd)
		self.bInSchedule = true
	end
	return
end

function ENT:OnFoundEnemy(iEnemies)
	self.nextAction = CurTime() +math.Rand(10,16)
end

function ENT:DamageHandle(dmginfo)
	self.nextAction = self.nextAction -2
end

function ENT:GunTraceBlocked()
	if self.bPossessed then return false end
	local tracedata = {}
	tracedata.start = self:LocalToWorld(Vector(32.1043, -1.3263, 39.4877))
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

local schdCower = ai_schedule.New("Take Cower") 
schdCower:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0) 
schdCower:EngTask("TASK_WAIT",2)
schdCower:EngTask("TASK_STOP_MOVING",0)
function ENT:OnDanger(vecPos)
	if self.bPossessed || self.bInSchedule then return end
	local posSelf = self:GetPos()
	self:SetLastPosition(posSelf +(posSelf -vecPos):GetNormal() *400)
	self:StartSchedule(schdCower)
	return true
end


local schdMoveAway = ai_schedule_slv.New("RunPosition") 
schdMoveAway:EngTask("TASK_FIND_NEAR_NODE_COVER_FROM_ENEMY", 2500)
schdMoveAway:EngTask("TASK_WAIT_FOR_MOVEMENT",0)
function ENT:SelectScheduleHandle(enemy,fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 then
		if self:CanSee(self.entEnemy) then
			local bMelee = fDistPredicted <= self.fMeleeDistance
			if bMelee then
				local schdMeleeAttack = ai_schedule_slv.New("Attack Enemy Melee")
				schdMeleeAttack:EngTask("TASK_STOP_MOVING", 0)
				schdMeleeAttack:EngTask("TASK_STOP_MOVING", 0)
				schdMeleeAttack:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", ACT_MELEE_ATTACK1)
				--[[if math.random(1,3) == 1 || self:Health() <= 30 then
					schdMeleeAttack:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", ACT_HOP)
					self.bInSchedule = true
				end--]]
				self:StartSchedule(schdMeleeAttack)
				return
			end
			local bRange = fDist <= self.fRangeDistance && !self:GunTraceBlocked()
			if bRange then
				if CurTime() >= self.nextAction then
					self.nextAction = CurTime() +math.Rand(10,16)
					local rand = math.random(1,9)
					if rand <= 3 && fDist <= 1000 then
						self:PlayActivity(ACT_HOP, false)
						return
					else
						if rand <= 8 then
							self:StartSchedule(schdMoveAway)
							return
						elseif fDist <= 800 && fDist >= 240 then
			self:PlayActivity(ACT_RANGE_ATTACK2, true)
				self.bInSchedule = true
							return
						end
					end
				end
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
				self.bInSchedule = true
				return
			end
		self:ChaseEnemy()
	elseif iDisposition == 2 then
		local schdHide = ai_schedule_slv.New("Hide")
		schdHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
		schdHide:AddTask("TASK_CHECK_FAIL")
		schdHide:EngTask("TASK_WAIT_FOR_MOVEMENT")
		schdHide:AddTask("TASK_WAIT", math.Rand(4,5))
		self:StartSchedule(schdHide)
			end
		end
	end

