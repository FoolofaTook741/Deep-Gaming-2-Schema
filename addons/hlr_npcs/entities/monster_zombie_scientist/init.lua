AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_zombie_scientist")
ENT.NPCFaction = NPC_FACTION_HEADCRAB
ENT.iClass = CLASS_ZOMBIE
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_zombie_scientist")
ENT.sModel = "models/half-life/zombie.mdl"
ENT.fMeleeDistance	= 40
ENT.bPlayDeathSequence = true

ENT.skName = "zombie_hl1"
ENT.CollisionBounds = Vector(13,13,72)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/zombie/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT,
	[HITBOX_CHEST] = ACT_DIE_GUTSHOT,
	[HITBOX_STOMACH] = ACT_DIE_GUTSHOT
}


ENT.m_tbSounds = {
	["Melee"] = "zo_attack[1-2].wav",
	["Alert"] = "zo_alert[1-3].wav",
	["Death"] = "zo_pain[1-2].wav",
	["Pain"] = "zo_pain[1-2].wav",
	["Idle"] = "zo_idle[1-4].wav",
	["Foot"] = "zo_step[1-4].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		if(atk == "left") then
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_one_slash")
			angViewPunch = Angle(-4, 26, -6)
		elseif(atk == "right") then
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_one_slash")
			angViewPunch = Angle(-4, -26, 6)
		else
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_both_slash")
			angViewPunch = Angle(30, 0, 0)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if((dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) && self:CanSee(enemy)) then
			self:PlayActivity(ACT_MELEE_ATTACK1,true)
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
