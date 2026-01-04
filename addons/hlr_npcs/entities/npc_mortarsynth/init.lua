AddCSLuaFile( "shared.lua" )

include('shared.lua')
util.AddNPCClassAlly(CLASS_COMBINE,"npc_mortarsynth")
local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_COMBINE","npc_mortarsynth")
ENT.NPCFaction = NPC_FACTION_COMBINE
ENT.iClass = CLASS_COMBINE

ENT.sModel = "models/synth_mortar.mdl"
ENT.fRangeDistance = 1250

ENT.bExplodeOnDeath = true
ENT.bPlayDeathSequence = false

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/mortarsynth/"

ENT.m_tbSounds = {}
ENT.m_tbSounds["Attack"] = "attack_shoot.wav"

ENT.tblDeathActivities = {}
ENT.tblAlertAct = {}

function ENT:OnInit()
	self.BaseClass.OnInit(self)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(13, 13, 12), Vector(-13, -13, -20))

	self:SetHealth(GetConVarNumber("sk_mortarsynth_health"))
	self:SetFlySpeed(GetConVarNumber("sk_controller_fly_speed"))
	self.nextAttack = 0
	local cspLoop = CreateSound(self, self.sSoundDir .. "hover.wav")
	cspLoop:Play()
	self:StopSoundOnDeath(cspLoop)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self.bInSchedule = true
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

local combine = {"npc_turret_floor","npc_rollermine","npc_combine_s","npc_manhack","npc_clawscanner","npc_sniper","npc_helicopter","npc_combinegunship","npc_combine_camera","npc_cscanner","npc_turret_ceiling","npc_strider","npc_stalker","npc_combinedropship","npc_ministrider","npc_hunter","npc_metropolice","npc_turret_ground"}
function ENT:ApplyCustomEntityDisposition(ent)
	if(ent:IsNPC() && (ent:Classify() == CLASS_COMBINE || table.HasValue(combine,ent:GetClass()))) then
		self:AddEntityRelationship(ent,D_LI,100)
		ent:AddEntityRelationship(self,D_LI,100)
		return true
	end
end


function ENT:EventHandle(...)
	local event = select(1,...)
	if (event == "chargestart") then
		local entBeam = util.ParticleEffectTracer("mortarsynth_beam_charge", self:GetAttachment(self:LookupAttachment("arm_right")).Pos, {{ent = self, att = "arm_left"}}, self:GetAngles(), self, "arm_right")
		self:DeleteOnDeath(entBeam)
		self.cspCharge = CreateSound(self, self.sSoundDir .. "attack_charge.wav")
		self.cspCharge:Play()
		self:StopSoundOnDeath(self.cspCharge)
		return
	end
	if (event == "rattack") then
		self.cspCharge:Stop()
		if (!IsValid(self.entEnemy) || self.entEnemy:Health() <= 0) && !self.bPossessed then return end
		local posEnd
		local entHit
		if !self.bPossessed then
			local fDist = self.entEnemy:GetPos():Distance(self:GetPos())
			if fDist > 2000 then return end
			local accuracy = (math.Rand(0.02,0.11) /2000) *fDist
			local pos = self.entEnemy:GetHeadPos() -self.entEnemy:GetVelocity() *accuracy
			local tracedata = {}
			tracedata.start = self:GetCenter()
			tracedata.endpos = pos
			tracedata.filter = self
			local trace = util.TraceLine(tracedata)
			if IsValid(trace.Entity) && (trace.Entity:IsNPC() || trace.Entity:IsPlayer()) then
				posEnd = trace.Entity:GetHeadPos()
				if self:Disposition(trace.Entity) <= 2 then entHit = trace.Entity end
			else posEnd = trace.HitPos end
		else
			local entPossessor = self:GetPossessor()
			local trace = entPossessor:GetPossessionEyeTrace()
			if self:GetPos():Distance(trace.HitPos) > 2000 then return end
			if trace.Hit then
				posEnd = trace.HitPos
				local ang = self:GetAngleToPos(posEnd)
				if ang.y >= 55 && ang.y <= 305 then return end
				if IsValid(trace.Entity) && self:IsEnemy(trace.Entity) then entHit = trace.Entity end
			else return end
		end
		local entA = util.ParticleEffectTracer("mortarsynth_beam", self:GetAttachment(self:LookupAttachment("arm_right")).Pos, posEnd, self:GetAngles(), self)
		local entB = util.ParticleEffectTracer("mortarsynth_beam", self:GetAttachment(self:LookupAttachment("arm_left")).Pos, posEnd, self:GetAngles(), self)
		self:DeleteOnDeath(entA)
		self:DeleteOnDeath(entB)
		if entHit then
			util.BlastDamage(self, self, posEnd, 30, GetConVarNumber("sk_mortarsynth_dmg_beam") *0.5)
			if entHit:IsPlayer() then
				entHit:ViewPunch(Angle(-12, 0, 0)) 
			elseif entHit:GetClass() == "npc_turret_floor" && !entHit.bSelfDestruct then
				entHit:Fire("selfdestruct", "", 0)
				entHit:GetPhysicsObject():ApplyForceCenter(self:GetForward() *10000) 
				entHit.bSelfDestruct = true
			end
		end
		return
	end
end

function ENT:Interrupt()
	if !self.bInSchedule then return end
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
	if self.cspCharge then self.cspCharge:Stop() end
end

function ENT:OnScheduleSelection()
	self:Interrupt()
end

function ENT:SelectScheduleHandle(enemy,fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 || iDisposition == 2 then
		local bRange = fDist <= self.fRangeDistance && self:CanSee(self.entEnemy) && CurTime() >= self.nextAttack
		if bRange then
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			self.bInSchedule = true
			self.nextAttack = CurTime() +math.Rand(0.5,3)
			return
		end
	end
end
