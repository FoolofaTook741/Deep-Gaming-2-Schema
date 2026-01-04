AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_RACEX","monster_shockroach")
ENT.NPCFaction = NPC_FACTION_RACEX
ENT.iClass = CLASS_RACEX
util.AddNPCClassAlly(CLASS_RACEX,"monster_shockroach")
ENT.sModel = "models/opfor/shockroach.mdl"
ENT.fRangeDistance	= 235
ENT.bPlayDeathSequence = true

ENT.skName = "shockroach"
ENT.CollisionBounds = Vector(10,10,20)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/shockroach/"

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.m_tbSounds = {
	["Attack"] = "shock_jump[1-2].wav",
	["Alert"] = "shock_angry.wav",
	["Death"] = "shock_die.wav",
	["Idle"] = "shock_idle[1-3].wav",
	["Pain"] = "shock_flinch.wav"
}

local schdBackAway = ai_schedule_slv.New("Back Away")
schdBackAway:EngTask("TASK_GET_PATH_TO_LASTPOSITION")
schdBackAway:EngTask("TASK_WAIT", 0.2)

local schdFaceEnemy = ai_schedule_slv.New("Face Enemy")
schdFaceEnemy:EngTask("TASK_FACE_ENEMY")

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.fEnergy = 60
	self.nextEnergyDrain = CurTime() +2
	self:SetState(NPC_STATE_ALERT)
end

function ENT:OnStateChanged(old, new)
	if new == NPC_STATE_IDLE then self:SetState(NPC_STATE_ALERT) end
end

function ENT:AddEnergy(fEnergySub)
	if self.fEnergy +fEnergySub <= 0 then
		self.fEnergy = 0
		self:TakeDamage(self:Health(), self, self)
		return
	end
	self.fEnergy = self.fEnergy +fEnergySub
end

function ENT:GetEnergy()
	return self.fEnergy
end

function ENT:SetEnergy(fEnergy)
	if fEnergy <= 0 then
		self.fEnergy = 0
		self:TakeDamage(self:Health(), self, self)
		return
	end
	self.fEnergy = fEnergy
end

function ENT:OnThink()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	self:UpdateLastEnemyPositions()
	if CurTime() >= self.nextEnergyDrain then
		self.nextEnergyDrain = CurTime() +2
		self:AddEnergy(-math.random(3,5))
	end
	if self:PercentageFrozen() >= 80 then return end
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) && self:OBBDistance(v) <= 40 && !v:HasWeapon("weapon_shockrifle") && !v:IsPossessing() then
			v:Give("weapon_shockrifle")
			self:Remove()
			return
		end
	end
end

function ENT:OnFoundEnemy()
	if math.random(1,3) != 1 then return end
	self:PlayActivity(ACT_SIGNAL1)
	self:PlaySound("Alert")
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local bJumpStart = atk == "jumpstart"
		local bJumpEnd = atk == "jumpend"
		local bJump = !bJumpStart && !bJumpEnd
		if bJumpStart then
			local pos 
			if IsValid(self.entEnemy) && !self.bPossessed then
				local posEnemy = self.entEnemy:GetHeadPos()
				local posSelf = self:GetPos()
				local fDistZ = posEnemy.z -posSelf.z
				fDistZ = math.Clamp(fDistZ, 16, 85)
				posEnemy.z = 0
				posSelf.z = 0
				local fDist = posEnemy:Distance(posSelf)
				fDist = math.Clamp(fDist, 10, self.fRangeDistance)
				pos = self:GetForward() *fDist *10 +self:GetUp() *fDistZ *4
			else
				pos = self:GetForward() *1800 +self:GetUp() *220
			end
			self:SetVelocity(pos)
			return true
		end
		if bJumpEnd then
			self:AddEnergy(math.Rand(-6,-12))
			self.bBitten = false
			return true
		end
		if self.bBitten then return true end
		local fDist = 20
		local iDmg = GetConVarNumber("sk_shockroach_dmg_bite")
		local angViewPunch = Angle(-3,0,0)
		self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,nil,nil,function()
			self.bBitten = true
		end,nil,false)
		if self.bBitten then self:EmitSound( self.sSoundDir .. "shock_bite.wav", 75, 100) end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(!self:IsOnGround()) then return end
		if (dist <= 50 || (self.bBackAway && dist < 120)) && (!self.nextRange || CurTime() < self.nextRange) then
			local tr = self:CreateTrace(self:GetCenter() +(self:GetPos() -enemy:GetPos()):GetNormal() *120, nil, self:GetCenter())
			local pos
			if tr.Hit then pos = tr.HitPos -tr.Normal *(self:OBBMaxs().y *2 +20)
			else pos = tr.HitPos end
			if self:GetPos():Distance(pos) > 60 then
				self:SetLastPosition(pos)
				self:StartSchedule(schdBackAway)
				self.bBackAway = true
				self.nextRange = self.nextRange || CurTime() +3
				return
			end
		end
		if self.bBackAway then self:StopMoving(); self:StartSchedule(schdFaceEnemy); self.bBackAway = false; return end
		local ang = self:GetAngleToPos(enemy:GetPos())
		local bRange = dist <= self.fRangeDistance && (ang.y <= 45 || ang.y >= 315) && self:CanSee(enemy)
		if bRange then
			self.nextRange = nil
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end