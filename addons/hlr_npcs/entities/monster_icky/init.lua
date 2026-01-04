AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_icky")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
ENT.sModel = "models/half-life/icky.mdl"
ENT.fMeleeDistance = 90

ENT.bPlayDeathSequence = false

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/icky/"

ENT.m_tbSounds = {
	["Attack"] = "ichy_attack[1-2].wav",
	["Alert"] = "ichy_alert[1-3].wav",
	["Death"] = "ichy_die[1-4].wav",
	["Pain"] = "ichy_pain[1-5].wav",
	["Idle"] = "ichy_idle[1-4].wav"
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEVIOLENT, ACT_DIESIMPLE}
}
ENT.tblAlertAct = {}
ENT.tblCRelationships = {
	[D_NU] = {"monster_g_man", "npc_seagull", "npc_antlion_grub", "npc_barnacle", "monster_roach", "npc_pigeon", "npc_crow"},
	[D_FR] = {"npc_strider","npc_combinegunship","npc_combinedropship", "npc_helicopter"},
	[D_HT] = {"obj_sentrygun", "npc_clawscanner", "npc_headcrab_poison", "npc_stalker"},
	[D_LI] = {"npc_icky"}
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	
	self:SetHealth(GetConVarNumber("sk_ichthyosaur_health"))
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
		local atk = select(2,...)
		local bEnd = tobool(string.find(atk,"end"))
		if bEnd then self.bInAttack = false; return true end
		local bBiteA = tobool(string.find(atk,"bitea"))
		local bBiteB = tobool(string.find(atk,"biteb"))
		local bRight = tobool(string.find(atk,"right"))
		local bLeft = !bBiteA && !bBiteB && !bRight
		
		local fDist = self.fMeleeDistance
		local iDmg
		local iAtt
		local angViewPunch
		if bLeft then
			iDmg = GetConVarNumber("sk_ichthyosaur_dmg_bite_power")
			angViewPunch = Angle(12,6,-2)
		elseif bRight then
			iDmg = GetConVarNumber("sk_ichthyosaur_dmg_bite_power")
			angViewPunch = Angle(12,-6,2)
		else
			iDmg = GetConVarNumber("sk_ichthyosaur_dmg_bite")
			if bBiteA then
				angViewPunch = Angle(12,8,-2)
			else
				angViewPunch = Angle(18,6,-1)
			end
		end
		local hit = self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		if(hit) then self:EmitSound(self.sSoundDir .. "ichy_bite" .. math.random(1,2) .. ".wav",75,100)
		else self:EmitSound("npc/zombie/claw_miss" ..math.random(1,2).. ".wav", 75, 100) end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT || disp == D_FR) then
		local bMelee = (dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) && self:CanSee(self.entEnemy)
		if bMelee then
			self:PlayActivity(ACT_MELEE_ATTACK1,true)
			return
		end
		self:PlayActivity(ACT_SWIM,false)
	end
end
