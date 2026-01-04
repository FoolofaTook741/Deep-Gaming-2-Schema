AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_alien_slv")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_alien_slv")
ENT.sModel = "models/half-life/islave.mdl"
ENT.fRangeDistance = 1200
ENT.fMeleeDistance	= 40
ENT.bPlayDeathSequence = true

ENT.skName = "islave"
ENT.CollisionBounds = Vector(15,15,61)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/aslave/"

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT
}
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_SMALL_FLINCH,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

ENT.m_tbSounds = {
	["Attack"] = "slv_zap4.wav",
	["Alert"] = "slv_alert[1-3].wav",
	["Death"] = "slv_die[1-2].wav",
	["Pain"] = "slv_pain[1-2].wav",
	["Idle"] = "slv_word[1-7].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.iZapCount = math.random(1,2)
	self.nextZap = 0
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_islave_dmg_claw")
		local angViewPunch
		local bAttackA = atk == "a"
		local bAttackB = atk == "b"
		local bAttackC = atk == "c"
		if bAttackA then
			angViewPunch = Angle(5,-16,2)
		elseif bAttackB then
			angViewPunch = Angle(4,12,-2)
		else
			angViewPunch = Angle(12,-11,3)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		local bZapStart = atk == "zapstart"
		local bZapEnd = atk == "zapend"
		local bZap = !bZapStart && !bZapEnd
		if bZapStart then
			for i = 1, 2 do
				local pos = self:GetAttachment(i).Pos
				ParticleEffectAttach("alien_slave_hand_glow", PATTACH_POINT_FOLLOW, self, i)
			end
			self.tblentEffects = {}
			local iDist = 320
			local pos = self:GetAttachment(1).Pos
			local forward = self:GetForward()
			local right = self:GetRight()
			local pitch = 100
			for i=0,math.Rand(0.4,0.8),0.2 do
				timer.Simple(i, function()
					if !IsValid(self) || !self.tblentEffects then return true end
					for i = 1, 2 do
						local posEnd
						for _i = 0, 10 do
							local normal
							if i == 1 then normal = Vector(math.Rand(right.x,forward.x),math.Rand(right.y,forward.y),math.Rand(-0.4,-0.5))
							else normal = Vector(math.Rand(-right.x,forward.x),math.Rand(-right.y,forward.y),math.Rand(-0.4,-0.5)) end
							local tracedata = {}
							tracedata.start = pos
							tracedata.endpos = pos +normal *iDist
							tracedata.filter = self
							local tr = util.TraceLine(tracedata)
							if tr.Hit then posEnd = tr.HitPos; break end
						end
						if posEnd then
							local att
							if i == 1 then att = "clawright" else att = "clawleft" end
							local ent = util.ParticleEffectTracer("vortigaunt_beam_charge", self:GetAttachment(i).Pos, posEnd, self:GetAngles(), self, att)
							self:DeleteOnDeath(ent)
							table.insert(self.tblentEffects, ent)
						end
					end
				end)
			end
		elseif bZap then
			if !IsValid(self.entEnemy) && !self.bPossessed then return true end
			local posZapTarget
			local entHit
			if !self.bPossessed then
				local fDist = self.entEnemy:GetPos():Distance(self:GetPos())
				if fDist > 2000 then return true end
				local accuracy = (math.Rand(0.02,0.11) /2000) *fDist
				local pos = self.entEnemy:GetHeadPos() -self.entEnemy:GetVelocity() *accuracy
				local tracedata = {}
				tracedata.start = self:GetCenter()
				tracedata.endpos = pos
				tracedata.filter = self
				local trace = util.TraceLine(tracedata)
				if IsValid(trace.Entity) && (trace.Entity:IsNPC() || trace.Entity:IsPlayer()) then
					posZapTarget = trace.Entity:GetHeadPos()
					if self:Disposition(trace.Entity) <= 2 then entHit = trace.Entity end
				else
					posZapTarget = trace.HitPos
				end
			else
				local entPossessor = self:GetPossessor()
				local trace = entPossessor:GetPossessionEyeTrace()
				if self:GetPos():Distance(trace.HitPos) > 2000 then return true end
				if trace.Hit then
					posZapTarget = trace.HitPos
					local ang = self:GetAngleToPos(posZapTarget)
					if ang.y >= 55 && ang.y <= 305 then return true end
					if IsValid(trace.Entity) && self:IsEnemy(trace.Entity) then entHit = trace.Entity end
				else
					return true
				end
			end
			
			self:StopParticles()
			ParticleEffect("vortigaunt_glow_beam_cp1", posZapTarget, self:GetAngles(), self)
			for i = 1, 2 do
				ParticleEffectAttach("vortigaunt_glow_beam_cp0", PATTACH_POINT_FOLLOW, self, i)
				local att
				if i == 1 then att = "clawright" else att = "clawleft" end
				local ent = util.ParticleEffectTracer("vortigaunt_beam", self:GetAttachment(i).Pos, posZapTarget, self:GetAngles(), self, att)
				self:DeleteOnDeath(ent)
			end
			
			sound.Play(self.sSoundDir .. "slv_shoot1.wav", posZapTarget, 75, 145 ) 
			if entHit then
				util.BlastDamage(self, self, posZapTarget, 30, GetConVarNumber("sk_islave_dmg_zap") *0.5)
				if entHit:IsPlayer() then
					entHit:ViewPunch(Angle(-12, 0, 0)) 
				elseif entHit:GetClass() == "npc_turret_floor" && !entHit.bSelfDestruct then
					entHit:Fire("selfdestruct", "", 0)
					entHit:GetPhysicsObject():ApplyForceCenter(self:GetForward() *10000) 
					entHit.bSelfDestruct = true
				end
			end
			if !self.bPossessed then
				self.iZapCount = self.iZapCount -1
				if self.iZapCount <= 0 then
					self.nextZap = CurTime() +math.Rand(4,12)
				end
			end
		elseif bZapEnd then
			self:StopParticles()
			if !self.tblentEffects then return true end
			for k, v in pairs(self.tblentEffects) do
				if IsValid(v) then
					v:Remove()
				end
			end
			self.tblentEffects = nil
		end
		return true
	end
end

function ENT:OnInterrupt()
	self:StopParticles()
	if !self.tblentEffects then return end
	for k, v in pairs(self.tblentEffects) do
		if IsValid(v) then
			v:Remove()
		end
	end
	self.tblentEffects = nil
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			if self.iZapCount == 0 && CurTime() >= self.nextZap then
				self.iZapCount = math.random(1,3)
			end
			local tr = self:CreateTrace(enemy:GetHeadPos(), nil, self:GetCenter() +self:GetForward() *20)
			local bRange = dist <= self.fRangeDistance && self.iZapCount > 0 && tr.Entity == enemy
			if bRange then
				self:PlayActivity(ACT_RANGE_ATTACK1, true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end