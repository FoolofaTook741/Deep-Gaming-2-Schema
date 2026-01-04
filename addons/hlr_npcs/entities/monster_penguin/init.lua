AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sModel = "models/opfor/penguin.mdl"
ENT.fRangeDistance	= 180
ENT.fHearDistance = 100

ENT.bPlayDeathSequence = true
ENT.bSpecialDeath = true

ENT.skName = "snark"
ENT.CollisionBounds = Vector(12,12,12)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/snark/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.m_tbSounds = {
	["Attack"] = "sqk_deploy1.wav",
	["Death"] = "sqk_die1.wav",
	["Hunt"] = "sqk_hunt[1-3].wav"
}
ENT.tblAlertAct = {}

function ENT:OnInit()
	self:NoCollide("monster_penguin")
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:SetMoveType(MOVETYPE_STEP)
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.fEnergy = 60
	self.nextEnergyDrain = CurTime() +2
	self.nextHunt = 0
	self.bGroundWalk = true
	self:SetState(NPC_STATE_ALERT)
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTARM || hitbox == HITBOX_RIGHTARM || hitbox == HITBOX_ADDLIMB) then
		self:SetWalkActivity(ACT_WALK_HURT)
	end
end

function ENT:OnStateChanged(old, new)
	if new == NPC_STATE_IDLE then self:SetState(NPC_STATE_ALERT) end
end

function ENT:HearEnemy()
	return false
end

function ENT:OnFoundEnemy(iEnemies)
	self:SetMovementType(2)
end

function ENT:OnAreaCleared()
	self:SetMovementType(1)
end

function ENT:SetMovementType(iType)
	if iType == 1 then
		if self.bGroundWalk then return end
		local ang = self:GetAngles()
		ang.p = 0
		ang.r = 0
		self:SetAngles(ang)
		self:CapabilitiesAdd(CAP_MOVE_GROUND)
		self:SetMoveType(MOVETYPE_STEP)
		self.bGroundWalk = true
		return
	end
	if !self.bGroundWalk then return end
	self:CapabilitiesRemove(CAP_MOVE_GROUND)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self.bGroundWalk = false
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if !self:CanJump() then fcDone(true); return end
	self:SetMovementType(2)
	self:PlaySound("Attack")
	self.bInJump = true
	self.bBitten = false
	local vel = Angle(0,entPossessor:GetAimVector():Angle().y,0):Forward() *500 +self:GetUp() *300
	local yaw = vel:Angle().y
	self:SetLocalVelocity(vel)
	self:PlayActivity(ACT_JUMP, false, fcDone)
	self:SetMovementType(1)
end

function ENT:AddEnergy(fEnergySub)
	if self.fEnergy +fEnergySub <= 0 then
		self.fEnergy = 0
		self:PlaySound("Death")
		self.bDead = true
		self:SetSchedule( SCHED_DIE )
		return
	end
	self.fEnergy = self.fEnergy +fEnergySub
	local fPitch = self:GetSoundPitch()
	if fPitch < 138 then
		local fPitchAdd = (38 /40) *-fEnergySub
		if fPitch +fPitchAdd > 138 then
			fPitchAdd = fPitch -138
		end
		self:SetSoundPitch(fPitch +fPitchAdd)
	end
end

function ENT:GetEnergy()
	return self.fEnergy
end

function ENT:SetEnergy(fEnergy)
	if fEnergy <= 0 then
		self.fEnergy = 0
		self:PlaySound("Death")
		self.bDead = true
		self:SetSchedule(SCHED_DIE)
		return
	end
	self.fEnergy = fEnergy
end

function ENT:CanJump()
	local posSelf = self:GetPos()
	return util.TraceLine({start = posSelf +Vector(0,0,20), endpos = posSelf -Vector(0,0,36), mask = MASK_NPCWORLDSTATIC}).HitWorld
end

function ENT:OnThink()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) || self:PercentageFrozen() >= 80 then return end
	self:UpdateLastEnemyPositions()
	if self.bInJump then
		self:Event("mattack jump")
	end
	if CurTime() >= self.nextHunt && !self.bPossessed && self:GetSequence() != 2 then
		self.bInJump = false
		self.nextHunt = CurTime() +math.Rand(0.5,0.5)
		if IsValid(self.entEnemy) then
			if !self.bGroundWalk then
				if !self:Visible(self.entEnemy) then
					self:SetMovementType(1)
				elseif self:CanJump() then
					self:SetMovementType(2)
					local posEnemy = self.entEnemy:GetPos()
					local posSelf = self:GetPos()
					local yaw
					if math.random(1,3) <= 3 then self:PlaySound("Hunt", true) end
					self:PlayActivity(ACT_RUN_AGITATED, true)
					if self:OBBDistance(self.entEnemy) <= self.fRangeDistance then
						self:PlaySound("Attack")
						self.bInJump = true
						self.bBitten = false
						self.nextHunt = CurTime() +1
						local vel = (posEnemy -posSelf):GetNormal() *500 +self:GetUp() *300
						yaw = vel:Angle().y
						self:SetLocalVelocity(vel)
					else
						posEnemy.z = 0
						posSelf.z = 0
						local vel = (posEnemy -posSelf):GetNormal() *500 +self:GetUp() *160
						yaw = vel:Angle().y
						self:SetLocalVelocity(vel)
					end
					self:SetAngles(Angle(math.Rand(-30,-20), yaw, math.Rand(-20,20)))
				end
			elseif self.bGroundWalk && self:Visible(self.entEnemy) then
				self:OnFoundEnemy()
			end
		end
	end
	if CurTime() < self.nextEnergyDrain then return end
	self.nextEnergyDrain = CurTime() +2
	self:AddEnergy(math.Rand(-3,-5))
end

function ENT:SetEntityOwner(ent)
	self.entOwner = ent
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local bJumpStart = atk == "jumpstart"
		local bJump = !bJumpStart
		if bJumpStart then
			self.bBitten = false
			local pos 
			if IsValid(self.entEnemy) && !self.bPossessed then
				local posEnemy = self.entEnemy:GetHeadPos()
				local posSelf = self:GetPos()
				local fDistZ = posEnemy.z -posSelf.z
				fDistZ = math.Clamp(fDistZ, 16, 120)
				posEnemy.z = 0
				posSelf.z = 0
				local fDist = posEnemy:Distance(posSelf)
				fDist = math.Clamp(fDist, 10, self.fRangeDistance)
				pos = self:GetForward() *fDist *10 +self:GetUp() *fDistZ *2
			else
				pos = self:GetForward() *1600 +self:GetUp() *180
			end
			return true
		end
		if self.bBitten then return true end
		local fDist = 20
		local iDmg = GetConVarNumber("sk_snark_dmg_bite")
		local angViewPunch = Angle(-2.5,0,0)
		self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,true,nil,function(ent)
			local vel = (ent:GetPos() -self:GetPos()):GetNormal() *-25 +self:GetUp() *160
			self:SetLocalVelocity(vel)
			self.bBitten = true
			timer.Simple(math.Rand(0.4, 1), function() if IsValid(self) && !self.bDead then
				if !self.bPossessed then
					self:SelectSchedule()
				else
					self:_PossScheduleDone()
				end
			end end)
		end)
		if self.bBitten then self:AddEnergy(math.Rand(-2,-8)) end
		return true
	elseif(event == "death") then
		self:DoExplode(GetConVarNumber("sk_penguin_dmg_blast"), 260, IsValid(self.entOwner) && self.entOwner)
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if !self.bGroundWalk then return end
	if(disp == D_HT) then
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
