AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_MILITARY","monster_hwgrunt")
ENT.NPCFaction = NPC_FACTION_MILITARY
ENT.iClass = CLASS_MILITARY
util.AddNPCClassAlly(CLASS_MILITARY,"monster_hwgrunt")
ENT.sModel = "models/half-life/hwgrunt.mdl"
ENT.fRangeDistance = 600
ENT.bPlayDeathSequence = true

ENT.skName = "hwgrunt"
ENT.CollisionBounds = Vector(13,13,72)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/hassault/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEVIOLENT, ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["Shoot"] = "hw_shoot[1-3].wav",
	["Pain"] = "hw_pain[1-3].wav",
	["Death"] = "hw_death[1-6].wav",
	["Alert"] = "hw_attack[1-6].wav",
	["SpinUp"] = "hw_spinup.wav",
	["Spin"] = "hw_spin.wav",
	["SpinDown"] = "hw_spindown.wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:SetHealth(500)

	self:SetSoundPitch(70)
	self:SetSoundLevel(85)
end

function ENT:OnThink()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	if IsValid(self.entEnemy) then self:UpdateLastEnemyPositions()
	elseif !self.bPossessed then return end
	if !self.bInSchedule && !self.bPossessed then return end
	local ang
	if !self.bPossessed then
		self:FaceEnemy()
		local pos = self:GetPos() +self:GetForward() *33.5 +self:GetRight() *-14 +self:GetUp() *39.6
		ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
	else
		ang = (self:GetAttachment(1).Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
	end
	if ang >= 90 then ang = ang -360 end
	ang = math.Clamp(ang,-45,45)
	self:SetPoseParameter("XR", ang)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_ARM,false)
	self.bInSchedule = true
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		local atk = select(2,...)
		self:UpdateEnemies()
		if self:IsPossessed() then
			if !self:GetPossessor():KeyDown(IN_ATTACK) then
				self:PlayActivity(ACT_DISARM, false, self._PossScheduleDone)
				self.bInSchedule = false
			end
		else
			local bEnemyValid = IsValid(self.entEnemy) && self.entEnemy:Health() > 0 && self:Visible(self.entEnemy) && self:OBBDistance(self.entEnemy) <= self.fRangeDistance && !self:GunTraceBlocked()
			if !bEnemyValid then
				self:PlayActivity(ACT_DISARM, false)
				self.bInSchedule = false
				return true
			end
		end
		if(atk == "shoot") then
			self:PlayActivity(ACT_RANGE_ATTACK1, !self.bPossessed)
			return true
		end
		local attPosAng = self:GetAttachment(1)
		attPosAng.Pos = attPosAng.Pos

		local dir = self:GetAngles()
		dir.p = -self:GetPoseParameter("XR")
		dir = dir:Forward()
		self:EmitSound(self.sSoundDir .. "hw_shoot" .. math.random(1,3) .. ".wav", 100, 100 )
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
		tblBullet.Spread = Vector(0.03,0.03,0.03)
		tblBullet.Tracer = 1
		tblBullet.Force = 6
		tblBullet.Damage = math.random(3,8)
		tblBullet.Callback = function(entAttacker, tblTr, dmg)
			local entVictim = tblTr.Entity
			local iDmg = dmg:GetDamage()
			if tblTr.HitGroup == 1 then
				iDmg = iDmg *10
			elseif tblTr.HitGroup != 0 then
				iDmg = iDmg *0.25
			end
		end
		self:FireBullets(tblBullet)
		return true
	end
end

function ENT:OnInterrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:GetAttachment(1).Pos
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		local bRange = dist <= self.fRangeDistance -80 && self:CanSee(enemy) && !self:GunTraceBlocked()
		if bRange then
			self:PlayActivity(ACT_ARM, true)
			self.bInSchedule = true
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end