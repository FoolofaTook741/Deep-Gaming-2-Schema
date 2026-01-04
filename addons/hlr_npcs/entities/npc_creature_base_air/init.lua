AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.AIType = 3
AccessorFunc(ENT, "fSpeed", "FlySpeed", FORCE_NUMBER)
function ENT:OnInit()
	self:SetMoveType(MOVETYPE_FLY)

	self:SetMaxYawSpeed(self.m_fMaxYawSpeed)
	
	self:CapabilitiesClear()
	self:CapabilitiesAdd(bit.bor(CAP_SQUAD,CAP_MOVE_FLY,CAP_SKIP_NAV_GROUND_CHECK))
	
	self.fPossessSpeed = 0
	self.nextBackAwayAct = 0
	self.nextPathGen = 0
end
function ENT:_PossEnd()
	self.velLast = nil
end

function ENT:_PossMovement(entPossessor, bInSchedule)
	local normalAim = entPossessor:GetAimVector()
	if bInSchedule then
		self:TurnDegree(3,normalAim:Angle())
	end
	local bMove
	local moveNormal = Vector(0,0,0)
	if entPossessor:KeyDown(IN_FORWARD) then
		moveNormal = normalAim
		bMove = true
	end
	if entPossessor:KeyDown(IN_BACK) then
		moveNormal = moveNormal +normalAim *-1
		bMove = true
	end
	if entPossessor:KeyDown(IN_MOVERIGHT) then
		moveNormal = moveNormal +normalAim:Angle():Right()
		bMove = true
	end
	if entPossessor:KeyDown(IN_MOVELEFT) then
		moveNormal = moveNormal +normalAim:Angle():Right() *-1
		bMove = true
	end
	if bMove then
		local flSpeed = self:GetFlySpeed()
		local fSpeedAdd = flSpeed *0.2
		if self.fPossessSpeed +fSpeedAdd <= flSpeed then
			self.fPossessSpeed = self.fPossessSpeed +fSpeedAdd
		else
			self.fPossessSpeed = flSpeed
		end
	else self.fPossessSpeed = self.fPossessSpeed *0.98 end
	local velocityCur = self.velLast || self:GetVelocity()
	if bMove && velocityCur:Length() <= 10 then velocityCur = Vector(0,0,0) end
	local velNew = (moveNormal +velocityCur:GetNormal()) *self.fPossessSpeed
	self:SetLocalVelocity(velNew)
	self.velLast = velNew
end

function ENT:GetFixedVelocity(vel, dir)
	local posSelf = self:GetPos()
	local posCenter = posSelf +self:OBBCenter()
	local obbMax = self:OBBMaxs()
	local tbl = {posSelf +Vector(0,0,obbMax.z +2), posSelf, posCenter -self:GetRight() *(obbMax.y +2), posCenter +self:GetRight() *(obbMax.y +2)}
	local tblB = {Vector(0,0,-100), Vector(0,0,100), self:GetRight() *100, self:GetRight() *-100}
	for i = 1, 4 do
		local vecStart = tbl[i]
		local vecEnd = vecStart +dir *100
		local tr = self:CreateTrace(vecEnd, nil, vecStart)
		if tr.Hit then
			vel = vel +tblB[i]
		end
	end
	return vel
end

function ENT:MoveToPosition(pos)
	self.targetPos = pos
	self.currentPath = nil
end

function ENT:ChaseDirect(posTarget)
	local posSelf = self:GetCenter()
	if !posTarget then
		if self.bBackAway then
			local normal = (self.entEnemy:GetPos() -posSelf):GetNormal()
			normal.z = 0
			posTarget = self.entEnemy:NearestPoint(self:GetCenter()) -normal *600 +Vector(0,0,300)
			if posSelf:Distance(posTarget) <= 100 then
				self.bBackAway = false
			end
		end
		if !self.bBackAway then
			if self.posEnemyLast then posTarget = self.posEnemyLast
			else
				posTarget = (self.entEnemy:NearestPoint(self:GetCenter()) +self.entEnemy:OBBCenter() /2)
				if posSelf:Distance(posTarget) <= 120 then
					self.bBackAway = true
					if CurTime() >= self.nextBackAwayAct then
						self:Interrupt()
						self:PlayActivity(ACT_SIGNAL_ADVANCE, true)
						self.nextBackAwayAct = CurTime() +math.Rand(3,10)
					end
				end
			end
		end
	end
	
	local pos = posTarget -posSelf
	velNew = (pos +self:GetVelocity() *30):GetNormal() *self:GetFlySpeed()
	velNew = self:GetFixedVelocity(velNew, (pos +self:GetVelocity() *30):GetNormal())
	self:SetLocalVelocity(velNew)
	local ang
	if IsValid(self.entEnemy) && self:Visible(self.entEnemy) then ang = (self.entEnemy:GetPos() -self:GetPos()):Angle()
	else ang = velNew:Angle() end
	self:TurnDegree(3,ang)
end

function ENT:OnThink()
	if tobool(GetConVarNumber("ai_disabled")) || self:IsPossessed() then return end
	if !self.targetPos && !IsValid(self.entEnemy) then
		local iState = self:GetState()
		if iState <= 2 then
			local posSelf = self:GetCenter()
			local velocity = Vector(0,0,0)
			local trUp = util.TraceLine({start = posSelf, endpos = posSelf -Vector(0,0,380), filter = self})
			if trUp.Hit then 
				velocity = velocity +Vector(0, 0, math.Clamp(380 -posSelf:Distance(trUp.HitPos), 0, 50))
			end
			
			local trDown = util.TraceLine({start = posSelf, endpos = posSelf +Vector(0,0,380), filter = self})
			if trDown.Hit then 
				velocity = velocity -Vector(0, 0, math.Clamp(380 -posSelf:Distance(trUp.HitPos), 0, 50))
			end
			local velSelf = self:GetVelocity()
			velSelf.z = 0
			self:SetLocalVelocity(velocity +velSelf *0.9)
		end
		return
	end
	local velNew = Vector(0,0,0)
	local posSelf = self:GetPos()
	
	local posTarget = self.targetPos
	if posTarget then
		local tr = util.TraceLine({start = self:GetCenter(), endpos = posTarget, filter = self})
		if tr.HitWorld || IsValid(tr.Entity) then
			if GetConVarNumber("sv_customnodegraph_enabled") == 0 then self.targetPos = nil; return end
			local path = self:GeneratePath(posTarget)
			if !path then return end
			if !path[1] then self.targetPos = nil; return end
			posTarget = path[1].pos
		elseif posSelf:Distance(posTarget) <= 120 then self.targetPos = nil; return end
	else
		self:NextThink(CurTime() +0.05)
		self:UpdateLastEnemyPositions()
		local dist = self:OBBDistance(self.entEnemy)
		local bVisible = self:Visible(self.entEnemy) || GetConVarNumber("sv_customnodegraph_enabled") == 0 || !nodegraph.Exists()
		if(!table.IsEmpty(nodegraph.GetAirNodes()) && (!bVisible || dist > 80)) then
			if !bVisible && self.bBackAway then self.bBackAway = false end
			if !self.pathObj || CurTime() >= self.nextPathGen then
				local path = self:GeneratePath(self.entEnemy)
				if self.pathObj then self.nextPathGen = CurTime() +0.1 end
				if path then
					local numPath = #path
					if numPath > 0 && (numPath != 1 || dist > self.entEnemy:NearestPoint(path[1].pos):Distance(path[1].pos)) then
						if self.currentNodePos && self.currentPathTime then
							local estTime
							if numPath > 1 then
								local yawA = (path[1].pos -self:GetPos()):GetNormal():Angle().y
								local yawB = (path[1].pos -path[2].pos):GetNormal():Angle().y
								local yaw = (360 +yawA) -yawB
								local sin = math.abs(math.cos(math.rad(yaw)))
								estTime = 0.8 *sin
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
								self:ChaseDirect()
								return
							end
							local dist = posSelf:Distance(pos)
							if dist > 600 then
								pos = posSelf +(pos -posSelf):GetNormal() *600
								self.pathTargetDistToNode = dist -600
							else self.pathTargetDistToNode = 0 end
							local tr = util.TraceLine({start = pos +Vector(0,0,100), endpos = pos -Vector(0,0,100), mask = MASK_NPCWORLDSTATIC})
							posTarget = tr.HitPos
							self.bDirectChase = false
							
							self.currentPathTime = posSelf:Distance(posTarget) /self:GetFlySpeed()
							if !self.currentNodePos || self.currentNodePos != self.currentPath[1].pos || (self.lastPathCheck && CurTime() -self.lastPathCheck >= 0.65) then
								local tm = CurTime() +self.currentPathTime
								if self.pathTargetDistToNode > 0 then tm = tm +(self.currentPathTime /450) *self.pathTargetDistToNode end
								self.estimPathArrival = tm
							elseif self.estimPathArrival -CurTime() <= -1 then
								if #self.currentPath > 1 then
									local IDCur = self.currentPath[1].ID
									local IDNext = self.currentPath[2].ID
									self.m_tbNodesBlocked[IDCur] = self.m_tbNodesBlocked[IDCur] || {}
									table.insert(self.m_tbNodesBlocked[IDCur], IDNext)
									self.currentPath = nil
									self.pathObj = nil
									self.pathObjTgt = nil
									return
								else
									local iAIType = self:GetAIType()
									local nodeClosest = nodegraph.GetClosestNode(self:GetPos(), iAIType)
									local nodeNext = self.currentPath[1]
									local nodes = nodegraph.GetNodes(iAIType)
									for _, data in pairs(nodeClosest.links) do
										if nodes[data.dest] && nodes[data.dest].pos == nodeNext.pos then
											local IDCur = nodeClosest.ID
											local IDNext = nodeNext.ID
											self.m_tbNodesBlocked[IDCur] = self.m_tbNodesBlocked[IDCur] || {}
											table.insert(self.m_tbNodesBlocked[IDCur], IDNext)
											self.currentPath = nil
											self.pathObj = nil
											self.pathObjTgt = nil
											return
										end
									end
								end
							end
							self.lastPathCheck = CurTime()
							self.currentNodePos = self.currentPath[1].pos
						else self:ChaseDirect() end
					elseif bVisible then self:ChaseDirect() end
				end
			end
		else self:ChaseDirect(); return true end
		if !posTarget then return true end
	end
	self:ChaseDirect(posTarget)
	return true
end