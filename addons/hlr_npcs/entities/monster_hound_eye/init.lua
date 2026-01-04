AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_hound_eye")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_hound_eye")
ENT.sModel = "models/half-life/houndeye.mdl"
ENT.fRangeDistance = 265
ENT.bPlayDeathSequence = true

ENT.skName = "houndeye"
ENT.CollisionBounds = Vector(13,13,45)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/houndeye/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["Attack"] = "he_attack[1-3].wav",
	["AlertAngry"] = "he_alert[1-3].wav", 
	["Death"] = "he_die[1-3].wav",
	["Pain"] = "he_pain[1-5].wav",
	["Idle"] = "he_idle[1-4].wav",
	["Hunt"] = "he_hunt[1-4].wav"
}
ENT.tblAlertAct = {ACT_IDLE_ANGRY}
ENT.iAlertRandom = 3

ENT.Limbs = {
	[HITBOX_RIGHTARM] = "Right Leg",
	[HITBOX_HEAD] = "Head",
	[HITBOX_LEFTARM] = "Left Leg",
	[HITBOX_STOMACH] = "Torso",
	[HITBOX_CHEST] = "Torso",
	[HITBOX_ADDLIMB] = "Hind Leg"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTARM || hitbox == HITBOX_RIGHTARM || hitbox == HITBOX_ADDLIMB) then
		self:SetWalkActivity(ACT_WALK_HURT)
	end
end

function ENT:OnInterrupt()
	self:SetSkin(0)
end	

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		local blast = ents.Create("prop_combine_ball")
		blast:SetPos(self:GetPos())
		blast:SetParent(self)
		blast:Spawn()
		blast:Fire("explode","",0)
		self:EmitSound(self.sSoundDir .. "he_blast" .. math.random(1,3) .. ".wav", 75, 100)
		local iDmgMax = GetConVarNumber("sk_houndeye_dmg_blast")
		local tblEnts = util.BlastDmg(self,self,self:GetPos(),400,iDmgMax,function(ent)
			return (!ent:IsNPC() || self:Disposition(ent) <= 2) && (!ent:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers")))
		end,DMG_SONIC,true)
		for ent, flDist in pairs(tblEnts) do
			if(ent:IsPlayer()) then
				ent:SetDSP(34,false)
			end
		end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(dist <= self.fRangeDistance -180 && self:CanSee(self.entEnemy)) then
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
