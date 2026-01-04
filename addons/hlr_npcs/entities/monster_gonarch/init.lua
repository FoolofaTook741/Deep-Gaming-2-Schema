AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_gonarch")
ENT.NPCFaction = NPC_FACTION_HEADCRAB
ENT.iClass = CLASS_HEADCRAB
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_gonarch")
ENT.sModel = "models/half-life/big_mom.mdl"
ENT.fRangeDistance = 1250
ENT.fMeleeDistance	= 40

ENT.bPlayDeathSequence = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE, DMG_POISON}

ENT.skName = "bigmomma"
ENT.CollisionBounds = Vector(80,80,180)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/gonarch/"

ENT.tblAlertAct = {ACT_SIGNAL1}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.m_tbSounds = {
	["Attack"] = "gon_attack[1-3].wav",
	["Alert"] = "gon_alert[1-3].wav",
	["Idle"] = "gon_sack[1-3].wav",
	["Pain"] = "gon_pain[1-3].wav",
	["Death"] = "gon_die1.wav",
	["Foot"] = "gon_step[1-3].wav",
	["ChildDie"] = "gon_childdie[1-3].wav",
	["Birth"] = "gon_birth[1-3].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:SetMoveType(MOVETYPE_STEP)
	
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self:SetHealth(2500)
	
	self.iSpitCount = math.random(2,4)
	self.nextSpit = 0
	self.iBabycrabKilledCount = 0
	self.iBabycrabCount = 0
	self.iBabycrabMax = GetConVarNumber("sk_bigmomma_max_bcrabs")
	if !self:GetSquad() then self:SetSquad(tostring(self) .. "_squad") end
	self.nextBirth = 0
	self.tblBabycrabs = {}
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	local posTr = entPossessor:GetPossessionEyeTrace().HitPos
	if self:GetPos():Distance(posTr) > self.fRangeDistance then fcDone(true); return end
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	if self.iBabycrabCount >= self.iBabycrabMax then fcDone(true); return end
	self:PlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local bSpawn = atk == "spawn"
		if bSpawn then
			local count = 3
			if self.iBabycrabCount +3 > self.iBabycrabMax then count = self.iBabycrabMax -self.iBabycrabCount; self.iBabycrabCount = self.iBabycrabMax
			else self.iBabycrabCount = self.iBabycrabCount +3 end
			local positions = {Vector(25,24,12), Vector(-25,14,12), Vector(-12,-18,12)}
			for i = 1, count do
				local babycrab = ents.Create("monster_babyheadcrab")
				babycrab:SetPos(self:GetPos() +positions[i])
				babycrab:SetAngles(self:GetAngles())
				babycrab:Spawn()
				babycrab:Activate()
				babycrab:MergeMemory(self:GetMemory())
				babycrab.entEnemy = self.entEnemy
				babycrab:SetOwner(self)
				babycrab.entOwner = self
				babycrab:SetSquad(self:GetSquad())
				
				function babycrab:OnDeath(dmginfo)
					if IsValid(self.entOwner) then self.entOwner:OnBabyKilled() end
				end
				table.insert(self.tblBabycrabs, babycrab)
			end
			self.nextBirth = CurTime() +math.Rand(4,14)
			return true
		end
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_bigmomma_dmg_slash")
		local angViewPunch
		local iRight = string.Left(atk,5) == "right"
		local iLeft = string.Left(atk,4) == "left"
		local bAttackA = string.Right(atk,1) == "a"
		local bAttackB = !bAttackA
		local func
		if iRight then
			if bAttackA then
				angViewPunch = Angle(8,-10,2)
			else
				angViewPunch = Angle(-38,20,-4)
				func = function(ent)
					ent:SetVelocity(self:GetForward() *360 +self:GetUp() *400 +self:GetRight() *300)
				end
			end
		else
			if bAttackA then
				angViewPunch = Angle(8,15,-2)
			else
				angViewPunch = Angle(-38,-20,4)
				func = function(ent)
					ent:SetVelocity(self:GetForward() *360 +self:GetUp() *400 +self:GetRight() *-300)
				end
			end
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,nil,nil,func)
		return true
	elseif(event == "rattack") then
		if !IsValid(self.entEnemy) && !self.bPossessed then return true end
		local pos
		if !self.bPossessed then
			local posSelf = self:GetPos()
			pos = self.entEnemy:GetPredictedPos(1)
			local flDist = self:OBBDistance(self.entEnemy)
			if flDist > 1000 then pos = self.entEnemy:GetPos(); if flDist > self.fRangeDistance then return true end end
			pos = ((pos -Vector(0,0,180)) -self:GetPos())
		else
			local entPossessor = self:GetPossessor()
			local posTr = entPossessor:GetPossessionEyeTrace().HitPos
			if self:GetPos():Distance(posTr) > self.fRangeDistance then return true end
			pos = ((posTr -Vector(0,0,180)) -self:GetPos())
		end
		pos = pos:GetNormalized() *400 +Vector(0,0,3000 *(pos:Length() /4000))
		local posSpitball = self:GetPos() +self:GetUp() *190
	
		for i = 0, 5 do
			local spitball = ents.Create("obj_gonarch_spit")
			spitball:SetPos(posSpitball)
			spitball:SetEntityOwner(self)
			spitball:Spawn()
			local phys = spitball:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(pos +VectorRand() *18)
			end
		end
		self.iSpitCount = self.iSpitCount -1
		if self.iSpitCount <= 0 then
			self.nextSpit = CurTime() +math.Rand(4,12)
		end
		return true
	elseif(event == "death") then
		self:EmitSound(self.sSoundDir .. self.tblSourceSounds["Foot"][math.random(1,#self.tblSourceSounds["Foot"])], 75, 90)
		util.ScreenShake(self:GetPos(), 85, 85, 0.4, 1300)  
		return true
	end
end

function ENT:OnBabyKilled()
	if self.bDead then return end
	self.iBabycrabCount = self.iBabycrabCount -1
	self.iBabycrabKilledCount = self.iBabycrabKilledCount +1
	if self.iBabycrabKilledCount >= self.iBabycrabMax *0.5 then
		self.iBabycrabKilledCount = 0
		self:PlaySound("ChildDie")
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		local bCanSee = self:CanSee(enemy)
		local bMelee = (dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) && bCanSee
		if bMelee then
			self:PlayActivity(ACT_MELEE_ATTACK1, true)
			return
		end
		local bBirth = dist <= self.fRangeDistance && CurTime() >= self.nextBirth && self.iBabycrabCount < self.iBabycrabMax
		if bBirth then
			self:PlayActivity(ACT_MELEE_ATTACK2, true)
			return
		end
		if self.iSpitCount == 0 && CurTime() >= self.nextSpit then
			self.iSpitCount = math.random(2,4)
		end
		local bRange = dist <= self.fRangeDistance && self.iSpitCount > 0 && bCanSee
		if bRange then
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end