AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.AIType = 5
AccessorFunc(ENT,"fSpeedMin","MinSwimSpeed",FORCE_NUMBER)
AccessorFunc(ENT,"fSpeedMax","MaxSwimSpeed",FORCE_NUMBER)
AccessorFunc(ENT,"fActMin","SlowSwimActivity",FORCE_NUMBER)
AccessorFunc(ENT,"fActMax","FastSwimActivity",FORCE_NUMBER)
AccessorFunc(ENT,"fTurnSpeed","TurnSpeed",FORCE_NUMBER)
function ENT:Initialize()
	self:PreInit()
	self:UpdateModel()

	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_FLY)

	self:SetMaxYawSpeed(self.m_fMaxYawSpeed)
	
	self:CapabilitiesAdd(bit.bor(CAP_SQUAD,CAP_MOVE_SWIM,CAP_SKIP_NAV_GROUND_CHECK))
	self:SetUpEnemies()
	self.tblSounds = {}
	self:InitSounds()
	self.tblMemory = {}
	self.iMemCount = 0
	self:ClearBlockedLinks()
	self.tblDeleteOnDeathEnts = {}
	self.tblGestureLayers = {}
	self.lastHitGroupDamage = 0
	self.iDmgCount = 0
	self.nextFlinch = 0
	self.nextIdle = 0
	self.m_lastThink = CurTime()
	self.m_fMaxYawMoveSpeed = self.m_fMaxYawMoveSpeed || self:GetMaxYawSpeed()
	self.m_tmLastSound = CurTime()
	self.schdWait = CurTime() +0.2
	self.nextPathGenSteps = 0
	self.nextTurnOnDmg = 0
	self.m_iSpeakAttenuation = 1
	self.m_posLast = self:GetPos()
	self.m_lastTimeMoved = 0
	self.m_nextEnemySearch = 0
	self.m_nextUpdate = 0
	self.iState = NPC_STATE_IDLE
	self.tblHostilePlayers = {}
	
	self:SetShouldPlayPickupSound(false)
	
	self.nextDirY = 0
	self.nextDirP = 0
	self.iDirectionY = 0
	self.iDirectionP = 0
	self.nextTrace = 0
	self.nextRandomDir = CurTime() +math.Rand(4,12)
	self.nextIdle = CurTime() +math.Rand(4,16)
	self.fPossessSpeed = 0
	self.fTurnSpeed = self.fTurnSpeed || 2
	
	if self.bWander then self.fWanderDelay = 0 end
	self:SetBehavior(0)
	self:SetUseType(SIMPLE_USE)
	self:SetSchedule(SCHED_IDLE_STAND)
	
	if table.HasValue(self.tblIgnoreDamageTypes, DMG_DISSOLVE) then
		self:NoCollide("prop_combine_ball")
	end
	self.tblIncomingGrenades = {}
	
	if(self.UseActivityTranslator) then
		local wep = self:Give("ai_translator")
		if(wep:IsValid()) then wep:SetNoDraw(true); wep:DrawShadow(false) end
	end
	
	if self.tblKeyValues then
		for k, v in pairs(self.tblKeyValues) do
			self:KeyValueHandle(k, v)
		end
	end
	self:OnInit()
	self:InitLimbs()
	self:InitBodyCaps()
	self.m_bInitialized = true
end
function ENT:_PossEnd()
	self.velLast = nil
end

function ENT:_PossFaceForward(entPossessor, fcDone)
	if fcDone then fcDone() end
	local ang = entPossessor:GetAimVector():Angle()
	local normal = Vector(0,0,0)
	local bTurn
	if entPossessor:KeyDown(IN_FORWARD) then
		normal = normal +ang:Forward()
		bTurn = true
	end
	if entPossessor:KeyDown(IN_BACK) && !entPossessor:KeyDown(IN_FORWARD) then
		normal = normal -ang:Forward()
		bTurn = true
	end
	if entPossessor:KeyDown(IN_MOVERIGHT) then
		normal = normal +ang:Right()
		bTurn = true
	end
	if entPossessor:KeyDown(IN_MOVELEFT) then
		normal = normal -ang:Right()
		bTurn = true
	end
	if !bTurn then normal = ang:Forward() end
	self:TurnDegree(self:GetTurnSpeed(), normal:Angle(), true, 42)
end

function ENT:_PossMovement(entPossessor, bInSchedule)
	if self:WaterLevel() == 0 then return end
	local normalAim = entPossessor:GetAimVector()
	if bInSchedule then
		self:_PossFaceForward(entPossessor)
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
	
	local bSpeed = entPossessor:KeyDown(IN_SPEED)
	if bMove then
		local fSpeed
		if bSpeed then fSpeed = self:GetMaxSwimSpeed() else fSpeed = self:GetMinSwimSpeed() end
		local fSpeedAdd = fSpeed *0.2
		if self.fPossessSpeed +fSpeedAdd <= fSpeed then
			self.fPossessSpeed = self.fPossessSpeed +fSpeedAdd
		else
			self.fPossessSpeed = fSpeed
		end
	else self.fPossessSpeed = self.fPossessSpeed *0.98 end
	local velocityCur = self.velLast || self:GetVelocity()
	if bMove && velocityCur:Length() <= 10 then velocityCur = Vector(0,0,0) end
	local velNew = (self:GetAngles():Forward() +velocityCur:GetNormal()) *self.fPossessSpeed
	if self:WaterLevel() < 3 && velNew.z > 0 then velNew.z = 0 end
	self:SetLocalVelocity(velNew)
	if !bInSchedule then
		local act
		if self:GetVelocity():Length() > 40 then
			if !bSpeed then act = ACT_GLIDE
			else act = ACT_SWIM end
		else act = ACT_IDLE end
		self:PlayActivity(act,false)
	end
	self.velLast = velNew
end

function ENT:OnThink()
	if tobool(GetConVarNumber("ai_disabled")) || self.bPossessed || self.bDead || self:WaterLevel() == 0 then return end
	if CurTime() >= self.nextIdle then
		self:PlaySound("Idle")
		self.nextIdle = CurTime() +math.Rand(4,16)
	end
	if !IsValid(self.entEnemy) then
		if CurTime() >= self.nextDirY then
			local trForward = self:CreateTrace(self:GetPos() +self:GetForward() *380)
			if trForward.HitWorld then
				local trRight = self:CreateTrace(self:GetPos() +self:GetRight() *380)
				local trLeft = self:CreateTrace(self:GetPos() +self:GetRight() *-380)
				local tr
				local fDistRight = self:GetPos():Distance(trRight.HitPos)
				local fDistLeft = self:GetPos():Distance(trLeft.HitPos)
				if fDistRight < fDistLeft then self.iDirectionY = 2
				elseif fDistLeft < fDistRight then self.iDirectionY = 1
				else self.iDirectionY = math.random(1,2) end
				self.nextDirY = CurTime() +math.Rand(1.2,2.6)
				self:NextThink(CurTime() +0.2)
				self.nextRandomDir = CurTime() +math.Rand(3,6)
			end
		else
			local ang = self:GetAngles()
			if self.iDirectionY == 1 then ang.y = ang.y -1
			else ang.y = ang.y +1 end
			self:SetAngles(ang)
			self:NextThink(CurTime() +0.01)
		end
		
		if CurTime() >= self.nextDirP then
			local trUp = self:CreateTrace(self:GetPos(), MASK_WATER, self:GetPos() +Vector(0,0,120))
			local fDistUp = self:GetPos():Distance(trUp.HitPos)
			if math.Round(fDistUp) < 120 then
				self.iDirectionP = 2
				self.nextDirP = CurTime() +math.Rand(1.6,2.6)
				self:NextThink(CurTime() +0.2)
			end
			local trDown = self:CreateTrace(self:GetPos() -Vector(0,0,75))
			if trDown.HitWorld then
				self.iDirectionP = 1
				self.nextDirP = CurTime() +math.Rand(1.6,2.6)
				self:NextThink(CurTime() +0.2)
			elseif self:GetAngles().p > 0 then
				self.nextDirP = CurTime() +9999
				self.iDirectionP = 2
			end
		else
			local ang = self:GetAngles()
			if self.iDirectionP == 1 then
				if ang.p > -42 && ang.p < 0 then
					ang.p = ang.p -1
					self:NextThink(CurTime() +0.01)
					if CurTime() >= self.nextTrace then
						self.nextTrace = CurTime() +0.2
						local trUp = self:CreateTrace(self:GetPos(), MASK_WATER, self:GetPos() +Vector(0,0,160))
						local fDistUp = self:GetPos():Distance(trUp.HitPos)
						if math.Round(fDistUp) < 160 then
							self.iDirectionP = 2
						end
					end
				else
					if ang.p < 0 then
						local tr = self:CreateTrace(self:GetPos() -Vector(0,0,75))
						if !tr.HitWorld then
							self.iDirectionP = 2
							self:NextThink(CurTime() +0.2)
						end
					else
						ang.p = ang.p -1
						if ang.p == 0 then self.nextDirP = 0 end
						self:NextThink(CurTime() +0.01)
					end
				end
			else
				ang.p = math.floor(ang.p) +1
				if ang.p == 0 then
					self.nextDirP = 0
				elseif ang.p >= 42 then
					self.iDirectionP = 1
					self:NextThink(CurTime() +0.2)
				end
				self:NextThink(CurTime() +0.01)
			end
			self:SetAngles(ang)
		end
		if CurTime() >= self.nextRandomDir then
			self.nextRandomDir = CurTime() +math.Rand(3,6)
			local rand = math.random(1,2)
			if rand == 1 then
				local trRight = self:CreateTrace(self:GetPos() +self:GetRight() *380)
				local trLeft = self:CreateTrace(self:GetPos() +self:GetRight() *-380)
				local fDistRight = self:GetPos():Distance(trRight.HitPos)
				local fDistLeft = self:GetPos():Distance(trLeft.HitPos)
				if math.Round(fDistRight) < 380 && math.Round(fDistLeft) < 380 then
					rand = 2
				else
					if fDistRight < fDistLeft then self.iDirectionY = 2
					elseif fDistLeft < fDistRight then self.iDirectionY = 1
					else self.iDirectionY = math.random(1,2) end
					self.nextDirY = CurTime() +math.Rand(0.6,3)
				end
			end
			if rand == 2 then
				local trUp = self:CreateTrace(self:GetPos(), MASK_WATER, self:GetPos() +Vector(0,0,380))
				local trDown = self:CreateTrace(self:GetPos() -Vector(0,0,380))
				local fDistUp = self:GetPos():Distance(trUp.HitPos)
				local fDistDown = self:GetPos():Distance(trDown.HitPos)
				if math.Round(fDistUp) == 380 || math.Round(fDistDown) == 380 then
					if fDistUp < fDistDown then self.iDirectionP = 2
					elseif fDistDown < fDistUp then self.iDirectionP = 1
					else self.iDirectionP = math.random(1,2) end
					self.nextDirP = CurTime() +math.Rand(0.6,3)
				end
			end
		end
		self:PlayActivity(ACT_GLIDE,false,nil,nil,true)
		local velNew = self:GetForward() *self:GetMinSwimSpeed()
		if self:WaterLevel() < 3 && velNew.z > 0 then velNew.z = 0 end
		self:SetLocalVelocity(velNew)
		self:SelectSchedule()
		return true
	end
	if self.entEnemy:WaterLevel() < 2 then self.entEnemy = NULL; return end
	self:TurnDegree(self:GetTurnSpeed(), self.entEnemy:GetCenter(), true, 42)
	self:NextThink(CurTime())
	local velNew = self:GetForward() *self:GetMaxSwimSpeed()
	if self:WaterLevel() < 3 && velNew.z > 0 then velNew.z = 0 end
	self:SetLocalVelocity(velNew)
	return true
end