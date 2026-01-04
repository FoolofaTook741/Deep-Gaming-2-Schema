AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_agrunt")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_agrunt")
ENT.sModel = "models/half-life/agrunt.mdl"
ENT.fRangeDistance = 824
ENT.fMeleeDistance	= 80
ENT.bPlayDeathSequence = true

ENT.skName = "agrunt"
ENT.CollisionBounds = Vector(18,18,85)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/agrunt/"

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT,
	[HITBOX_CHEST] = ACT_DIE_GUTSHOT,
	[HITBOX_STOMACH] = ACT_DIE_GUTSHOT
}
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_SMALL_FLINCH,
	[HITBOX_HEAD] = ACT_BIG_FLINCH,
	[HITBOX_CHEST] = ACT_BIG_FLINCH,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

ENT.m_tbSounds = {
	["Melee"] = "ag_attack[1-3],wav",
	["Alert"] = "ag_alert[1-5].wav",
	["Death"] = "ag_die[1-5].wav",
	["Pain"] = "ag_pain[1-5].wav",
	["Idle"] = "ag_idle[1-5].wav",
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
	self.bInSchedule = true
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:OnThink()
	if(self:PercentageFrozen() >= 80 || self.bDead || tobool(GetConVarNumber("ai_disabled"))) then return end
	self:UpdateLastEnemyPositions()
	if(!self.bInSchedule) then return end
	if self.bPossessed then
		local ang = (self:GetPos() +self:GetForward() *10.7 +self:GetUp() *29.9 -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
		if ang >= 90 then ang = ang -360 end
		ang = ang +5
		ang = math.Clamp(ang,-30,45)
		self:SetPoseParameter("XR", ang)
	elseif(IsValid(self.entEnemy)) then
		self:FaceEnemy()
		local pos = self:GetPos() +self:GetForward() *10.7 +self:GetUp() *29.9
		local ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
		if ang >= 90 then ang = ang -360 end
		ang = ang +5
		ang = math.Clamp(ang,-30,45)
		self:SetPoseParameter("XR", ang)
	end
	return
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "step") then
		self:EmitSound(self.sSoundDir .. "ag_step" .. math.random(1,4) .. ".wav",75,100)
		return true
	end
	if(event == "mattack") then
		self:EmitSound(self.sSoundDir .. "ag_attack" .. math.random(1,3) .. ".wav",75,100)
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_agrunt_dmg_punch")
		local angViewPunch
		if(atk == "right") then angViewPunch = Angle(3,-24,3)
		else angViewPunch = Angle(-3,26,-3) end
		self:DoMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	end
	if(event == "rattack") then
		local type = select(2,...)
		if(type == "end") then
			self.bInSchedule = false
			return true
		end
		local posAng = self:GetAttachment(1)
		if(self:IsPossessed()) then
			posAng.Ang = (self:GetPossessor():GetPossessionEyeTrace().HitPos -posAng.Pos):GetNormal():Angle()
		end
		local hornet = ents.Create("monster_hornet")
		hornet:SetPhysicsAttacker(self)
		hornet:SetPos(posAng.Pos)
		hornet:SetAngles(posAng.Ang)
		hornet:Spawn()
		hornet:Activate()
		hornet:SetEntityOwner(self)
		
		hornet:EmitSound(self.sSoundDir .. "ag_fire" .. math.random(1,3) .. ".wav", 75, 100)
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:PlayActivity(ACT_MELEE_ATTACK1,true)
				return
			elseif(dist <= self.fRangeDistance && self:CreateTrace(enemy:GetHeadPos(),nil,self:GetAttachment(1).Pos).Entity == enemy) then
				self:PlayActivity(ACT_RANGE_ATTACK1,true)
				self.bInSchedule = true
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
