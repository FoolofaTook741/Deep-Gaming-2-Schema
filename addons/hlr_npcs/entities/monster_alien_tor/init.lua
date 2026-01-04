AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_alien_tor")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_alien_tor")
ENT.sModel = "models/tor.mdl"
ENT.fRangeDistance = 1200
ENT.fRangeChargeDistance = 600
ENT.fMeleeDistance	= 75

ENT.bPlayDeathSequence = true

ENT.skName = "tor"
ENT.CollisionBounds = Vector(18,18,100)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/tor/"

ENT.tblAlertAct = {ACT_SIGNAL1}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
}
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_SMALL_FLINCH,
	[HITBOX_STOMACH] = ACT_FLINCH_STOMACH,
	[HITBOX_CHEST] = ACT_FLINCH_STOMACH,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

ENT.m_tbSounds = {
	["Melee"] = "tor-attack[1-2].wav",
	["Alert"] = "tor-alerted.wav",
	["Death"] = "tor-die[1-2].wav",
	["Pain"] = "tor-pain[1-2].wav",
	["Idle"] = "tor-idle[1-3].wav",
	["Discharge"] = "tor-staff-discharge.wav",
	["Summon"] = "tor-summon.wav",
	["Summoned"] = "tor-summoned.wav",
	["TransformStart"] = "tor_dispell.wav",
	["Transform"] = "tor-summoned.wav",
	["Step"] = "tor_foot[1-4].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.iEnergy = self:Health()
	self.discharge = 0
	self.tblSummonedAllies = {}
	if !self:GetSquad() then self:SetSquad(tostring(self) .. "_squad") end
end

local schdCower = ai_schedule_slv.New("Take Cower") 
schdCower:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0) 
schdCower:EngTask("TASK_WAIT", 1)
schdCower:EngTask("TASK_STOP_MOVING",0)
function ENT:OnDanger(vecPos)
	if self.bPossessed then return end
	self.bInSchedule = false
	if IsValid(self.entParticleCharge) then
		self.entParticleCharge:Remove()
	end
	
	local posSelf = self:GetPos()
	self:SetLastPosition(posSelf +(posSelf -vecPos):GetNormal() *200)
	self:StartSchedule(schdCower)
	return true
end

function ENT:OnInterrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
	if IsValid(self.entParticleCharge) then
		self.entParticleCharge:Remove()
	end
	if !self.bTransforming then return end
	self.bTransforming = false
	self.bFlinchOnDamage = true
	self:SetSkin(10)
	function self:_PossJump(entPossessor, fcDone)
		local tr = entPossessor:GetPossessionEyeTrace()
		if IsValid(tr.Entity) && tr.Entity:Health() > 0 && self:IsEnemy(tr.Entity) && self:OBBDistance(tr.Entity) <= self.fRangeChargeDistance then
			self.entPossChargeTarget = tr.Entity
			self:PlayActivity(ACT_RANGE_ATTACK1)
			self.bInSchedule = true
		else fcDone(true) end
	end
end

function ENT:Transform()
	local entPossManager = self:IsPossessed() && self:GetPossessor():GetPossessionManager()
	if IsValid(entPossManager) then
		entPossManager.bInSchedule = true
		self.bInSchedule = true
	end
	self:PlayActivity(ACT_VICTORY_DANCE, false, function()
		self:TaskComplete()
		self.bFlinchOnDamage = true
		self.bTransforming = false
		if IsValid(entPossManager) then
			entPossManager.bInSchedule = false
			self.bInSchedule = false
		end
		function self:_PossJump(entPossessor, fcDone)
			local tr = entPossessor:GetPossessionEyeTrace()
			if IsValid(tr.Entity) && tr.Entity:Health() > 0 && self:IsEnemy(tr.Entity) && self:OBBDistance(tr.Entity) <= self.fRangeChargeDistance then
				self.entPossChargeTarget = tr.Entity
				self:PlayActivity(ACT_RANGE_ATTACK1)
				self.bInSchedule = true
			else fcDone(true) end
		end
	end)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_SIGNAL_FORWARD,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	local Ents = ents.FindInSphere(self:GetPos(), 300)
	local i = 0
	local bIgnorePlayers = tobool(GetConVarNumber("ai_ignoreplayers"))
	for k, v in pairs(Ents) do
		if self:IsEnemy(v) then
			i = i +1
		end
	end
	if i >= 3 || (self:Health() <= 120 && i > 1) then
		self:PlayActivity(ACT_SIGNAL3,false,fcDone)
		return
	end
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	for k, v in pairs(self.tblSummonedAllies) do
		if !IsValid(v) then self.tblSummonedAllies[k] = nil end
	end
	table.refresh(self.tblSummonedAllies)
	if #self.tblSummonedAllies == 2 then fcDone(true); return end
	self:PlayActivity(ACT_RANGE_ATTACK1_LOW,false,fcDone)
end

function ENT:OnScheduleSelection()
	if !self.backAway then return end
	self.backAway = false
	if !IsValid(self.entEnemy) || !self:BackAway(400) then return else return true end
end

local schdBackAway = ai_schedule_slv.New("Back Away") 
schdBackAway:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0) 
schdBackAway:EngTask("TASK_WAIT", 1.4)
schdBackAway:EngTask("TASK_STOP_MOVING",0)
function ENT:BackAway(flDist)
	local posSelf = self:GetPos()
	local normal = (posSelf -self.entEnemy:GetPos()):GetNormal()
	local tr = util.TraceLine({start = posSelf +Vector(0,0,10), endpos = posSelf +normal *flDist, mask = MASK_NPCSOLID_BRUSHONLY})
	if posSelf:Distance(tr.HitPos) <= 350 then return false end
	self:SetLastPosition(tr.HitPos -tr.Normal *(self:OBBMaxs() *0.6))
	self:StartSchedule(schdBackAway)
	return true
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		self:EmitSound(self.sSoundDir .. "tor-test1.wav", 75, 100)
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_tor_dmg_slash")
		local iAtt
		local angViewPunch
		local bStab = atk == "stab"
		local bStaff = atk == "staff"
		
		if bStaff then angViewPunch = Angle(0,24,-3)
		else angViewPunch = Angle(19,-4,2) end
		self:DoMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "dischargeeffect") then
		ParticleEffectAttach("tor_discharge", PATTACH_POINT_FOLLOW, self, 2)
		return true
	elseif(event == "discharge") then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 380)) do
			if (v:IsNPC() || v:IsPlayer() || IsValid(v:GetPhysicsObject())) && self:Visible(v) && self:Disposition(v) <= 2 then
				v:SetVelocity(((v:GetPos() -self:GetPos()):GetNormal() *500) +Vector(0, 0, 300))
			end
		end
		self:DoMeleeDamage(380,GetConVarNumber("sk_tor_dmg_blast"),Angle(0,0,0),nil,nil,true,false)
		self.discharge = self.discharge +(!self.bExhausted && 20 || 15)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		if(atk == "projectile") then
			local pos = self:GetAttachment(1)["Pos"]
			local posPossessionTrace
			if self.bPossessed then
				local entPossessor = self:GetPossessor()
				posPossessionTrace = entPossessor:GetPossessionEyeTrace().HitPos
				local ang = self:GetAngleToPos(posPossessionTrace)
				if ang.y >= 60 && ang.y <= 300 then return true end
			end
			local projectile = ents.Create("obj_tor_projectile")
			projectile:SetDepleted(self.bExhausted)
			projectile:SetPos(pos)
			projectile:Spawn()
			projectile:SetEntityOwner(self)
			projectile:SetSpeed(115)
			projectile:SetEnemy(self.entEnemy)
			if self.bPossessed then
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					local entPossessor = self:GetPossessor()
					phys:ApplyForceCenter((posPossessionTrace -pos):GetNormal() *400)
				end
			end
			return true
		elseif(atk == "Summon") then
			ParticleEffectAttach(!self.bExhausted && "tor_projectile" || "tor_projectile_blue", PATTACH_POINT_FOLLOW, self, 1)
			local pos = self:LocalToWorld(Vector(60,0,10))
			local classes = {"monster_agrunt", "monster_alien_slv","monster_controller"}
			local class = table.Random(classes)
			if class == "monster_controller" then pos = pos +Vector(0,0,80) end
			local ally = ents.Create(class)
			ally:SetPos(pos)
			ally:SetAngles(self:GetAngles())
			ally:Spawn()
			ally:Activate()
			ally:MergeMemory(self:GetMemory())
			ally:SetSquad(self:GetSquad())
			ally.entEnemy = self.entEnemy
			table.insert(self.tblSummonedAllies,ally)
			
			ally:EmitSound("debris/beamstart" .. math.random(1,2) .. ".wav",100,100)
			
			ParticleEffect(!self.bExhausted && "tor_shockwave" || "tor_shockwave_blue", pos +Vector(0,0,40), Angle(0,0,0), ally)
			ParticleEffect(!self.bExhausted && "tor_projectile_vanish" || "tor_projectile_vanish_blue", pos +Vector(0,0,40), Angle(0,0,0), ally)
			self:StopParticles()
			self.backAway = true
			return true
		elseif(string.Left(atk,6) == "charge") then
			local typ = select(2,...)
			local bPossessed = self:IsPossessed()
			local ent = bPossessed && self.entPossChargeTarget || self.entEnemy
			if(string.Right(atk,5) == "start") then
				if !IsValid(ent) || ent:Health() <= 0 then
					self.bInSchedule = false
					if self:IsPossessed() then self:_PossScheduleDone() end
					self:PlayActivity(ACT_RANGE_ATTACK2, false, nil, true)
					return true
				end
				local att = self:GetAttachment(self:LookupAttachment("staff_top"))
				local entParticle = util.ParticleEffectTracer("tor_beam_charge", att.Pos, ent, att.Ang, self, "staff_top", false)
				self.entParticleCharge = entParticle
				self:DeleteOnDeath(entParticle)
			end
			if IsValid(ent) && ent:Health() > 0 && self:CanSee(ent) && self:Health() <= self:GetMaxHealth() *1.5 && (!bPossessed || self:GetPossessor():KeyDown(IN_JUMP)) then
				local fDist = self:OBBDistance(ent)
				if fDist <= self.fRangeChargeDistance then
					if bPossessed then
						self:PlayActivity(ACT_SIGNAL2, true)
						ent:TakeDamage(22, self, self)
						self:SetHealth(self:Health() +22)
						return true
					end
					for k, v in pairs(self.tblSummonedAllies) do
						if IsValid(v) && v:OBBDistance(ent) <= 300 then
							self:PlayActivity(ACT_SIGNAL2, true)
							ent:TakeDamage(1, self, self)
							self:SetHealth(self:Health() +1)
							return true
						end
					end
				end
			end
			if IsValid(self.entParticleCharge) then self.entParticleCharge:Remove() end
			self:PlayActivity(ACT_RANGE_ATTACK2, true, bPossessed && self._PossScheduleDone || function()
				self:TaskComplete()
				self.bInSchedule = false
			end)
			return true
		end
	elseif(event == "transform") then
		ParticleEffect("tor_transform_wave", self:GetCenter(), self:GetAngles(), self)
		for k, v in pairs(self.tblSummonedAllies) do
			if IsValid(v) && self:OBBDistance(v) <= 250 then
				v:SetHealth(v:GetMaxHealth())
			end
		end
		return true
	end
end

function ENT:DamageHandle(dmginfo)
	if !self.bExhausted then
		local iHealth = self:Health()
		local iHealthMax = self:GetMaxHealth()
		local iHealthMin = math.Round(iHealthMax *0.5)
		self:SetHealth(math.Clamp(iHealth -dmginfo:GetDamage(), iHealthMin, iHealth))
		if self:Health() == iHealthMin then
			self.bFlinchOnDamage = false
			self:PlaySound("Pain")
			self.bExhausted = true
			local hitgroup = self.lastHitGroupDamage
			local act = self.tblFlinchActivities[hitgroup] || self.tblFlinchActivities[HITGROUP_GENERIC] || self.tblFlinchActivities[HITBOX_GENERIC]
			self.bTransforming = true
			local entPossManager = self:IsPossessed() && self:GetPossessor():GetPossessionManager()
			if IsValid(entPossManager) then
				entPossManager.bInSchedule = true
				self.bInSchedule = true
			end
			self:PlayActivity(act,false,function()
				self:Transform()
			end,true)
		end
		dmginfo:SetDamage(0)
	end
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	self.discharge = math.max(self.discharge -0.1, 0)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			for k, v in pairs(self.tblSummonedAllies) do
				if !IsValid(v) then self.tblSummonedAllies[k] = nil end
			end
			table.refresh(self.tblSummonedAllies)
			if dist <= 300 then
				for k, v in pairs(self.tblSummonedAllies) do
					if v.entEnemy == enemy && self:OBBDistance(v) <= 500 then
						if self:BackAway(600 -dist) then return end
					end
				end
			end
			if self.discharge <= 50 then
				local bDischarge
				local Ents = ents.FindInSphere(self:GetPos(), 300)
				local i = 0
				local bIgnorePlayers = tobool(GetConVarNumber("ai_ignoreplayers"))
				for k, v in pairs(Ents) do
					if (v:IsNPC() || (v:IsPlayer() && !bIgnorePlayers)) && self:Disposition(v) <= 2 then
						i = i +1
					end
				end
				if i >= 3 || (self:Health() <= 120 && i > 1) then
					bDischarge = true
				end
				if bDischarge then
					self:PlayActivity(ACT_SIGNAL3, true)
					return
				end
			end
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local bSummon
			local iHealth = self:Health()
			local iHealthMax = self:GetMaxHealth()
			if (self.bExhausted && #self.tblSummonedAllies == 0) || #self.tblMemory >= 4 || math.random(1,18) <= math.Round(((iHealthMax -iHealth) /iHealthMax) *10) then bSummon = true end
			if bSummon then
				if #self.tblSummonedAllies == 2 then bRangeParticle = true
				else
					local trace = util.TraceLine({start = self:GetPos() +Vector(0,0,40), endpos = self:LocalToWorld(Vector(80,0,40)), filter = self})
					if !trace.Hit then
						self:PlayActivity(ACT_RANGE_ATTACK1_LOW, true)
						return
					else bRangeParticle = true end
				end
			end
			local bRangeParticle = !bSummon
			local tr = self:CreateTrace(enemy:GetHeadPos(), nil, self:LocalToWorld(Vector(78.8878, 7.2202, 74.3777)))
			bRangeParticle = bRangeParticle && dist <= self.fRangeDistance && (!IsValid(tr.Entity) || tr.Entity == enemy)
			if bRangeParticle then
				if self.bExhausted && dist <= self.fRangeChargeDistance && dist > 300 && self:Health() <= self:GetMaxHealth() *1.5 then
					for k, v in pairs(self.tblSummonedAllies) do
						if v:OBBDistance(enemy) <= 300 then
							self:PlayActivity(ACT_RANGE_ATTACK1, true)
							self.bInSchedule = true
							return
						end
					end
				end
				ParticleEffectAttach(!self.bExhausted && "tor_projectile" || "tor_projectile_blue", PATTACH_POINT_FOLLOW, self, 1)
				self:PlayActivity(ACT_SIGNAL_FORWARD, true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end