AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_stukabat")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"npc_stukabat")
ENT.sModel = "models/half-life/stukabat.mdl"
ENT.fRangeDistance	= 440
ENT.bPlayDeathSequence = true
ENT.bFlinchOnDamage  = false

ENT.skName = "stukabat"
ENT.CollisionBounds = Vector(20,20,20)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/stukabat/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}
ENT.tblCRelationships = {
	[D_NU] = {"monster_g_man", "npc_seagull", "npc_antlion_grub", "npc_barnacle", "monster_roach", "npc_pigeon", "npc_crow"},
	[D_FR] = {"npc_strider","npc_combinegunship","npc_combinedropship", "npc_helicopter"},
	[D_HT] = {"obj_sentrygun", "npc_clawscanner", "npc_headcrab_poison", "npc_stalker"},
	[D_LI] = {"player"}
}

ENT.m_tbSounds = {
	["Attack"] = "stkb_fire[1-2].wav",
	["Alert"] = "stkb_deploy[1-2].wav",
	["Death"] = "stkb_die1.wav",
	["Idle"] = {"stkb_idle1.wav","stkb_idletpick[1-2].wav"},
	["Wing"] = "stkb_wings[1-3].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.nextCoolDown = 0
	self.attackCoolDown = 0
	self.nextRandDir = 0
	self.nextScheduleSel = 0
	self.nextTakeOff = CurTime() +math.Rand(0,45)
	self:SetHealth(GetConVarNumber("sk_stukabat_health"))
	self:SetState(NPC_STATE_ALERT)
end

function ENT:_PossJump(entPossessor, fcDone)
	if self.nextPossJump then if CurTime() < self.nextPossJump then fcDone(true); return else self.nextPossJump = nil end end
	if self:InAir() then self.bLanding = true
	else self:TakeOff() end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if !self:InAir() then fcDone(true); return end
	self:SetPlaybackRate(1)
	self.bInSchedule = true
	self:PlayActivity(ACT_RANGE_ATTACK1)
	self.moveStraight = CurTime() +2.25
end

function ENT:OnStateChanged(old, new)
	if new != NPC_STATE_COMBAT then
		if self:InAir() then self.nextLand = CurTime() +math.Rand(6,30) end
		if new == NPC_STATE_IDLE then
			self:SetState(NPC_STATE_ALERT)
		end
	end
end

function ENT:TakeOff()
	self.takingOff = true
	self:PlayActivity(ACT_LEAP)
	self.nextLand = CurTime() +math.Rand(8,30)
	self.bPlayIdle = false
end

function ENT:LandStart()
	self.nextLand = nil
	self.bLandStart = true
	self.moveStraight = nil
end

function ENT:Land()
	local ang = self:GetAngles()
	ang.p = 0
	self:SetAngles(ang)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesRemove(bit.bor(CAP_MOVE_FLY,CAP_SKIP_NAV_GROUND_CHECK))
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self:SetPlaybackRate(1)
	self:PlayActivity(ACT_LAND, nil, self:IsPossessed() && self._PossScheduleDone || nil)
	self.bLanding = false
	self.bInAir = false
	self.bPlayIdle = true
	self.nextTakeOff = CurTime() +math.Rand(10,35)
	self:SetAIType(2)
end

function ENT:InAir()
	return self.bInAir
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "takeoff") then
		if self:IsPossessed() then self:_PossScheduleDone() end
		self.takingOff = false
		self.bInAir = true
		self:SetAIType(3)
		self:StopMoving()
		self:SetMoveType(MOVETYPE_FLY)
		self:CapabilitiesRemove(CAP_MOVE_GROUND)
		self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY,CAP_SKIP_NAV_GROUND_CHECK))
		self.bWaitMoveUp = true
		return true
	elseif(event == "rattack") then
		local att = self:GetAttachment(self:LookupAttachment("bomb"))
		local ent = ents.Create("obj_stukabat_acid")
		ent:SetEntityOwner(self)
		ent:SetPos(att.Pos)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceCenter(Vector(0,0,-1000) +self:GetForward() *250)--(self.entEnemy:GetCenter() -att.Pos):GetNormal() *1000)
		end
		return true
	elseif(event == "attackend") then
		if self:IsPossessed() then self:_PossScheduleDone() end
		self.bInSchedule = false
		return true
	end
end

function ENT:GetPredictedLandPos()
	local pos = self:GetPos()
	local vel = self:GetVelocity()
	local ang = self:GetAngles()
	ang.p = 0
	while ang.p < 35 do
		ang.p = ang.p +1
		local fDist = vel *ang:Forward() *0.01
		pos = pos +fDist *ang:Forward()
	end
	ang.p = 35
	local posTrDownStart = pos +ang:Forward() *32768
	local trDown = util.TraceLine({start = pos, endpos = posTrDownStart, filter = self})
	local posTrDownLandStart = trDown.HitPos -trDown.Normal *100
	local trDownLandStart = util.TraceLine({start = posTrDownLandStart, endpos = posTrDownLandStart -Vector(0,0,120), filter = self})
	return trDownLandStart.HitPos
end

function ENT:CanLand()
	local pos = self:GetPos()
	local vel = self:GetVelocity()
	local ang = self:GetAngles()
	ang.p = 0
	while ang.p < 35 do
		ang.p = ang.p +1
		local fDist = vel *ang:Forward() *0.01
		pos = pos +fDist *ang:Forward()
	end
	ang.p = 35
	local posTrDownStart = pos +ang:Forward() *32768
	local trDown = util.TraceLine({start = pos, endpos = posTrDownStart, filter = self})
	local posTrDownLandStart = trDown.HitPos -trDown.Normal *100
	local trDownLandStart = util.TraceLine({start = posTrDownLandStart, endpos = posTrDownLandStart -Vector(0,0,120), filter = self})
	return trDownLandStart.HitWorld && trDownLandStart.MatType && trDownLandStart.MatType != 88 && !util.IsInWater(trDownLandStart.HitPos)
end

function ENT:Interrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
end

function ENT:OnPrimaryTargetChanged(enemy)
	self.attackCoolDown = 0
	if !self:InAir() then self.nextTakeOff = 0 else self.nextLand = nil end
end

function ENT:OnDeath(dmginfo)
	if self:InAir() then
		self.bPlayDeathSequence = false
		self.bFallToDeath = true
		self.fallDeathDmgInfo = dmginfo
		self.fallDeathAttacker = dmginfo:GetAttacker()
	end
	local ang = self:GetAngles()
	ang.p = 0
	self:SetAngles(ang)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesRemove(bit.bor(CAP_MOVE_FLY,CAP_SKIP_NAV_GROUND_CHECK))
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self.bLanding = false
	self.bInAir = false
	self.bPlayIdle = true
end

function ENT:OnThink()
	if self.bDead then
		if self.bFallToDeath then
			local pos = self:GetPos()
			local tr = util.TraceLine({start = pos, endpos = pos -Vector(0,0,150), filter = self})
			if tr.Hit || self:GetVelocity():Length() == 0 then
				self.bPlayDeathSequence = true
				self.tblDeathActivities[HITBOX_GENERIC] = ACT_DIEVIOLENT
				self.fallDeathDmgInfo:SetAttacker(self.fallDeathAttacker)
				self:DoDeath(self.fallDeathDmgInfo)
				self.bFallToDeath = false
			else self:PlayActivity(ACT_SIGNAL_ADVANCE,false,true,nil,true) end
		end
		return
	end
	local bPossessed = self:IsPossessed()
	if !bPossessed then
		if !self.takingOff && !self:InAir() && CurTime() >= self.nextTakeOff then
			self:TakeOff()
		end
		self:UpdatePath()
		self:UpdateNPCState()
		self:UpdateLastEnemyPositions()
	end
	if !self:InAir() then return end
	if CurTime() >= self.nextIdle then
		if math.random(1,self.idleChance) <= 2 then
			self:PlaySound("Idle")
		end
		self.nextIdle = CurTime() +math.Rand(6,16)
	end
	local ang = self:GetAngles()
	local pos = self:GetPos()
	local deg
	local right = self:GetRight()
	local forward = self:GetForward()
	local speed
	if !self.bInSchedule then
		if CurTime() >= self.nextScheduleSel || (self.enemyValid && !bEnemyValid) then self:SelectSchedule(); self.nextScheduleSel = CurTime() +0.4; bEnemyValid = IsValid(self.entEnemy) end
		self:PlayActivity(math.floor(ang.p) <= 0 && ACT_FLY || ACT_GLIDE,false,true,nil,true)
		if self.bWaitMoveUp then
			if self:GetCycle() <= 0.5 then
				self:SetPos(self:GetPos() +Vector(0,0,20))
				self.bWaitMoveUp = false
			end
		end
	end
	if !bPossessed then
		local bEnemyValid = IsValid(self.entEnemy)
		speed = bEnemyValid && 360 || 240
		if bEnemyValid then self:SetPlaybackRate(1.2) else self:SetPlaybackRate(1) end
		if ang.p <= 0 then speed = ((1 -((ang.p *-1) /140))) *speed
		else speed = ((ang.p /35) *0.5 +1) *speed end
		if self.bLandStart && self:CanLand() then
			self.bLanding = true
			self.bLandStart = false
		end
		local trUp, trDown
		if self.bLanding then
			local trDown = util.TraceLine({start = pos, endpos = pos -Vector(0,0,100), filter = self})
			if ang.p < 42 then
				--if !trDown.HitWorld then ang.p = math.floor(ang.p) +1 end
				ang.p = math.floor(ang.p) +1
			end
			if self:GetPos():Distance(trDown.HitPos) <= 75 then
				self:Land()
				self:NextThink(CurTime())
				return true
			end
		else
			local wLevel = self:WaterLevel()
			trDown = util.TraceLine({start = pos, endpos = pos -Vector(0,0,300), mask = bit.bor(MASK_SOLID,MASK_WATER), filter = self})
			trUp = util.TraceLine({start = pos, endpos = pos +Vector(0,0,240), mask = bit.bor(MASK_SOLID,MASK_WATER), filter = self})
			if trDown.Hit && trUp.Hit then
				local distA, distB = pos:Distance(trDown.HitPos), pos:Distance(trUp.HitPos)
				self.trBlocked = self.trBlocked || distA < distB && 2 || 1
				if self.trBlocked == 1 then if distA > 100 then trDown.Hit = false end
				elseif distB > 100 then trUp.Hit = false end
			end
			if trDown.Hit || wLevel > 0 then ang.p = ang.p -35 end
			if trUp.Hit && wLevel == 0 then ang.p = ang.p +35 end
			if !trDown.Hit && !trUp.Hit || trDown.Hit && trUp.Hit then ang.p = 0 elseif self.dirRand then self.tmRandDir = 0 end
			
			local trForward = util.TraceLine({start = pos, endpos = pos +forward *380, filter = self})
			if trForward.Hit then
				if !self.forceDir then
					local _ang = trForward.HitNormal:Angle()
					local yaw = math.AngleDifference(ang.y, _ang.y)
					if yaw > 0 then ang.y = ang.y -8; self.forceDir = 1
					else ang.y = ang.y +8; self.forceDir = 2 end
					self.forceDirForward = self:GetForward()
				end
				local _dist = pos:Distance(trForward.HitPos)
				dist = (!dist || dist && dist > _dist) && _dist || dist
			elseif self.forceDir then self.forceDir = nil end
			if self.dirRand then
				if CurTime() >= self.tmRandDir then self.tmRandDir = nil; self.dirRand = nil; self.nextRandDir = CurTime() +math.Rand(5,12)
				else
					if self.dirRand == 1 then ang.y = ang.y -8 elseif self.dirRand == 2 then ang.y = ang.y +8
					elseif self.dirRand == 3 then ang.p = ang.p -8 else ang.p = ang.p +8 end
				end
			elseif CurTime() >= self.nextRandDir then
				self.tmRandDir = CurTime() +math.Rand(1,3)
				self.dirRand = math.random(1,4)
			end
		end
		local dist
		if !self.forceDir then
			local trLeft = util.TraceLine({start = pos, endpos = pos -right *380, filter = self})
			if trLeft.Hit then
				ang.y = ang.y -8
				dist = pos:Distance(trLeft.HitPos)
				if self.dirRand then self.tmRandDir = 0 end
			end
			local trRight = util.TraceLine({start = pos, endpos = pos +right *380, filter = self})
			if trRight.Hit then
				ang.y = ang.y +8
				local _dist = pos:Distance(trRight.HitPos)
				dist = (!dist || dist && dist > _dist) && _dist || dist
				if self.dirRand then self.tmRandDir = 0 end
			end
		else
			local tr = util.TraceLine({start = pos, endpos = pos +self.forceDirForward *380, filter = self})
			ang.y = ang.y +(self.forceDir == 1 && -8 || 8)
			dist = pos:Distance(tr.HitPos)
		end
		if dist && dist <= 250 then deg = math.min((250 -dist) /50 +1, 8) end
		--self.entEnemy = Entity(1)
		if self.attackCoolDown > 0 && CurTime() >= self.nextCoolDown then self.attackCoolDown = self.attackCoolDown -1; self.nextCoolDown = CurTime() +0.2 end
		if bEnemyValid then
			self.enemyValid = true
			if !self.bInSchedule && !self.bLandStart && !self.bLanding then
				if self.entEnemy:Health() > 0 && self.attackCoolDown < 40 then
					local bIndirect, _pos = self:GetNextChasePos()
					if bIndirect != nil then
						_pos = bIndirect && _pos || self.entEnemy:GetPos()
						if bIndirect then deg = 6 end
						if !self.moveStraight || CurTime() > self.moveStraight then
							local _ang = (_pos -pos):Angle()
							ang.y = _ang.y
							if bIndirect then
								ang.p = _ang.p
							end
						end
						if !bIndirect then
							if !self:Visible(self.entEnemy) then
								self.enemyValid = false
								self.currentPath = nil
								self:RemoveFromMemory(self.entEnemy)
								self:SetState(NPC_STATE_LOST)
							else
								local distZ = _pos.z -(pos.z +self.entEnemy:OBBMaxs().z)
								if distZ < -500 && !trDown.Hit then ang.p = ang.p +35
								elseif distZ >= -400 && !trUp.Hit then ang.p = ang.p -35
								else ang.p = 0 end
								_pos.z = 0
								pos.z = 0
								local dist = _pos:Distance(pos)
								if dist <= self.fRangeDistance then
									local yaw = self:GetAngleToPos(_pos).y
									if yaw <= 110 then
										self:SetPlaybackRate(1)
										self.bInSchedule = true
										self:PlayActivity(ACT_RANGE_ATTACK1, true)
										self.moveStraight = CurTime() +2.25
										self.attackCoolDown = self.attackCoolDown +20
									end
								end
							end
						end
					else self.enemyValid = false end
				end
			end
		elseif self.nextLand && CurTime() >= self.nextLand then self:LandStart() end
	else
		local entPossessor = self:GetPossessor()
		local bRun = entPossessor:KeyDown(IN_SPEED)
		speed = bRun && 360 || 240
		deg = bRun && 3 || 1
		if bRun then self:SetPlaybackRate(1.2) else self:SetPlaybackRate(1) end
		if self.bLanding then
			local trDown = util.TraceLine({start = pos, endpos = pos -Vector(0,0,100), filter = self})
			if ang.p < 42 then
				--if !trDown.HitWorld then ang.p = math.floor(ang.p) +1 end
				ang.p = math.floor(ang.p) +1
			end
			if self:GetPos():Distance(trDown.HitPos) <= 75 then
				self:Land()
				self:NextThink(CurTime())
				return true
			end
			if entPossessor:KeyPressed(IN_JUMP) then self:_PossScheduleDone(); self.bLanding = false; self.nextPossJump = CurTime() +0.2 end
		else
			local normalAim = entPossessor:GetAimVector()
			local normal = normalAim
			local _ang = normal:Angle()
			if entPossessor:KeyDown(IN_BACK) then _ang.y = _ang.y +180; _ang.p = 360 -_ang.p end
			if entPossessor:KeyDown(IN_MOVERIGHT) then _ang.y = _ang.y -90 end
			if entPossessor:KeyDown(IN_MOVELEFT) then _ang.y = _ang.y +90 end
			ang = _ang
		end
	end
	self:TurnDegree(deg || 1, ang, true, 35)
	self:SetLocalVelocity(self:GetForward() *speed)
	self:NextThink(CurTime())
	return true
end

function ENT:GetNextChasePos()
	local bVisible = self:GetMemory()[self.entEnemy].visible
	local posLast
	if !bVisible then
		self:UpdateLastEnemyPositions()
		posLast = self:GetLastEnemyPosition()
	end
	local dist = posLast && self:NearestPoint(posLast):Distance(posLast) || self:OBBDistance(self.entEnemy)
	if posLast && dist <= 50 then
		posLast = nil
		local dir = self:GetLastEnemyMovement()
		local mem = self:GetMemory()
		if !mem[self.entEnemy].lost && dir then
			local center = self:OBBCenter()
			local posStart = self:GetPos() +center
			local posEnemyLast = mem[self.entEnemy].lastPos
			mem[self.entEnemy].lost = true
			mem[self.entEnemy].lastPos = nodegraph.GetClosestNode(posStart +dir *800, self:GetAIType()).pos
			posLast = mem[self.entEnemy].lastPos
			self.currentPath = nil
			self.pathObj = nil
		elseif !bVisible then
			self.currentPath = nil
			self:RemoveFromMemory(self.entEnemy)
			self:SetState(NPC_STATE_LOST)
			return
		end
	end
	if posLast then bVisible = self:VisibleVec(posLast) end
	if !bVisible || dist > 800 then	-- && > 550 && !self:HasCondition(35) then???
		local path = self:GeneratePath(posLast || self.entEnemy)
		if path then
			local numPath = #path
			if numPath > 0 && (numPath != 1 || (posLast && dist > posLast:Distance(path[1].pos)) || (!posLast && dist > self.entEnemy:NearestPoint(path[1].pos):Distance(path[1].pos))) then
				if self.currentNodePos && self.currentPathTime then
					local estTime
					if numPath > 1 then estTime = path[1].pos:Distance(self:GetPos()) /self:GetVelocity():Length()
					else estTime = 0.8 end
					if (self.currentNodePos == path[1].pos && self.currentPathTime > 0 && self.currentPathTime <= estTime) then --|| self:NearestPoint(path[1].pos):Distance(path[1].pos) <= 85 then
						table.remove(self.currentPath, 1)
						numPath = numPath -1
						path = self.currentPath
					end
				end
				if numPath > 0 then
					local pos = path[1].pos
					if bVisible && self:NearestPoint(pos):Distance(pos) > dist then
						return false
					end
					local posSelf = self:GetPos()
					local dist = posSelf:Distance(pos)
					if dist > 600 then
						pos = posSelf +(pos -posSelf):GetNormal() *600
						self.pathTargetDistToNode = dist -600
					else self.pathTargetDistToNode = 0 end
					self.bDirectChase = false
					return true, pos
				else return false end
			elseif bVisible then return false end
		else return false end
	else return false end
end