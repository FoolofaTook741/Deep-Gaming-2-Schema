AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_friendly")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"npc_friendly")
ENT.sModel = "models/half-life/mrfriendly.mdl"
ENT.fMeleeDistance	= 70
ENT.fRangeDistance = 300
ENT.bPlayDeathSequence = true

ENT.skName = "friendly"
ENT.CollisionBounds = Vector(35,35,32)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/friendly/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.m_tbSounds = {
	["AttackMelee"] = "fr_attack.wav",
	["AttackRange"] = "fr_groan[1-2].wav",
	["Alert"] = "fr_groan1[1-2]wav",
	["Death"] = "fr_groan[1-2].wav",
	["Pain"] = "fr_groan[1-2].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.countAttackVomit = math.random(1,3)
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
		local iDmg = GetConVarNumber("sk_friendly_dmg_whip")
		local iAtt
		local angViewPunch
		if(atk == "left") then
			angViewPunch = Angle(-30,24,-3)
		elseif(string.Left(atk,5) == "right") then
			local bPower = atk == "rightpower"
			if !bPower then
				angViewPunch = Angle(-16,-28,3)
			else
				angViewPunch = Angle(30,-12,3)
			end
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		if(atk == "vomitdmg") then
			self:DealMeleeDamage(self.fRangeDistance,0,Angle(0,0,0),nil,nil,nil,false,nil,function(ent)
				local dmgInfo = DamageInfo()
				dmgInfo:SetDamage(2)
				dmgInfo:SetAttacker(self)
				dmgInfo:SetInflictor(self)
				dmgInfo:SetDamageType(DMG_ACID)
				dmgInfo:SetDamagePosition(ent:NearestPoint(self:GetCenter()))
				ent:TakeDamageInfo(dmgInfo)
				ent:EmitSound("npc/bullsquid/bc_acid" .. math.random(1,2) .. ".wav", 75, 100)
			end)
			return true
		end
		local pos = self:GetForward() *400 +Vector(0,0,10)
		pos = pos:GetNormalized() *400 +Vector(0,0,300 *(pos:Length() /2000))
		
		ParticleEffectAttach("mrfriendly_vomit", PATTACH_POINT_FOLLOW, self, 1)
		self.countAttackVomit = self.countAttackVomit -1
		if self.countAttackVomit <= 0 then
			self.nextVomit = CurTime() +math.Rand(4,16)
		end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			if self.nextVomit && CurTime() >= self.nextVomit then
				self.nextVomit = nil
				self.countAttackVomit = math.random(1,3)
			end
			local bRange = dist <= self.fRangeDistance && self.countAttackVomit > 0
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