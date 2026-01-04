AddCSLuaFile( "shared.lua" )

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_alien_leech")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_alien_leech")
ENT.sModel = "models/half-life/leech.mdl"
ENT.fMeleeDistance = 60

ENT.bPlayDeathSequence = true

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/leech/"

ENT.m_tbSounds = {
	["Alert"] = "leech_alert[1-2].wav",
	["Bite"] = "leech_bite[1-3].wav"
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEFORWARD, ACT_DIESIMPLE}
}
ENT.tblAlertAct = {}

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(2,2,2), Vector(-2,-2,0))
	
	self:SetHealth(GetConVarNumber("sk_leech_health"))
	
	self:SetMinSwimSpeed(120)
	self:SetMaxSwimSpeed(300)
	self:SetSlowSwimActivity(ACT_GLIDE)
	self:SetFastSwimActivity(ACT_SWIM)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if self:WaterLevel() == 0 then return end
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(sEvent)
	if string.find(sEvent,"mattack") then
		local fDist = self.fMeleeDistance
		local iDmg = 1
		local angViewPunch = Angle(1,0,0)
		self:DoMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,false)
		return
	end
end

function ENT:SelectScheduleHandle(enemy,fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 || iDisposition == 2 then
		local bMelee = (fDist <= self.fMeleeDistance || fDistPredicted <= self.fMeleeDistance) && self:CanSee(self.entEnemy)
		if bMelee then
			self:PlayActivity(ACT_MELEE_ATTACK1, true)
			return
		end
		self:PlayActivity(ACT_SWIM,false)
	end
end
