AddCSLuaFile( "shared.lua" )

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_icky")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
ENT.sModel = "models/ichthyosaur_hlr.mdl"
ENT.fMeleeDistance = 90

ENT.bPlayDeathSequence = false

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/ichthyosaur/"

ENT.m_tbSounds = {
	["Attack"] = "attack_growl[1-3].wav",
	["AttackHit"] = "snap.wav",
	["AttackMiss"] = "snap_miss.wav",
	["Alert"] = "ichy_alert[1-3].wav",
	["Death"] = "ichy_die[1-4].wav",
	["Pain"] = "ichy_pain[1-4].wav",
	["Idle"] = "ichy_idle[1-4].wav"
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}
ENT.tblAlertAct = {}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	
	self:SetHealth(GetConVarNumber("sk_ichthyosaur_health"))
	local cspIdle = CreateSound(self,self.sSoundDir .. "water_breath.wav")
	cspIdle:Play()
	self:StopSoundOnDeath(cspIdle)
	
	self:SetMinSwimSpeed(180)
	self:SetMaxSwimSpeed(240)
	self:SetSlowSwimActivity(ACT_GLIDE)
	self:SetFastSwimActivity(ACT_SWIM)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if self:WaterLevel() == 0 then return end
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_ichthyosaur_dmg_bite_power")
		local angViewPunch = Angle(0,0,0)
		local bHit
		self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,nil,nil,function(ent)
			bHit = true
			if ent:IsPlayer() then
				ent:SetEyeAngles(Angle(math.Rand(-360,360), math.Rand(-360,360), 0))
			end
		end,nil,false)
		if bHit then
			self:PlaySound("AttackHit")
			self:PlayActivity(ACT_RANGE_ATTACK1_LOW, !self.bPossessed, self._PossScheduleDone)
		else
			self:PlaySound("AttackMiss")
			self:PlayActivity(ACT_RANGE_ATTACK2_LOW, !self.bPossessed, self._PossScheduleDone)
		end
		self.bInSchedule = false
		return true
	end
end

function ENT:Interrupt()
	self.bInSchedule = false
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if disp == D_HT || disp == D_FR then
		local bMelee = (dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) && self:CanSee(self.entEnemy)
		if bMelee then
			self.bInSchedule = true
			self:PlayActivity(ACT_MELEE_ATTACK1, true)
			return
		end
		self:PlayActivity(ACT_SWIM,false)
	end
end
