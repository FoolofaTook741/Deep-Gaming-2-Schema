AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_panthereye")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_panthereye")
ENT.sModel = "models/half-life/panthereye.mdl"
ENT.fRangeDistance = 350
ENT.fMeleeDistance	= 30
ENT.bPlayDeathSequence = true

ENT.skName = "panthereye"
ENT.CollisionBounds = Vector(35,35,44)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/panthereye/"

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["AttackJump"] = "p_jump[1-2].wav",
	["AttackClawHit"] = "pclaw_strike[1-3].wav",
	["AttackClawMiss"] = "pclaw_miss[1-2].wav",
	["Alert"] = "p_alert[1-3].wav",
	["Death"] = "p_die[1-2].wav",
	["Pain"] = "p_pain[1-2].wav",
	["Idle"] = "p_idle[1-3].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.nextJump = 0
	self:SetSkin(math.random(0,1))
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self.bInJump = false
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	MsgN("Event: ",...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_panthereye_dmg_slash")
		local angViewPunch
		local bPrimary = atk == "clawprimaryleft" || atk == "clawprimaryright"
		local bMain = atk == "clawmain"
		local bSimple = !bPrimary && !bMain
		
		if bPrimary then
			local bLeft = atk == "clawprimaryleft"
			if bLeft then
				angViewPunch = Angle(4,17,-3)
			else
				angViewPunch = Angle(2,-16,2)
			end
		elseif bMain then
			angViewPunch = Angle(8,-14,2)
		else
			angViewPunch = Angle(4,13,-3)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		local bJumpStart = atk == "jumpstart"
		local bJumpPlay = atk == "jumpanim"
		local bJump = !bJumpStart && !bJumpPlay
		if bJumpPlay then
			if !IsValid(self.entEnemy) && !self.bPossessed then return true end
			self:PlayActivity(ACT_RANGE_ATTACK2, true, self._PossScheduleDone)
			if self.bPossessed then self.bInJump = true end
			return true
		end
		if bJumpStart then
			self.bJumpHit = false
			self:SetVelocity((self:GetForward() *28 +self:GetUp() *1.4):GetNormal() *4000)
			return true
		end
		if self.bJumpHit then return true end
		local iAtt
		local fDist = 80
		local iDmg = GetConVarNumber("sk_panthereye_dmg_jump")
		local angViewPunch = Angle(-6,0,0)
		self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,true,nil,function()
			self.bJumpHit = true
		end)
		if self.bJumpHit then
			self:EmitSound("npc/zombie/claw_strike" ..math.random(1,3).. ".wav", 75, 100)
		end
		self.nextJump = CurTime() +math.Rand(4,13)
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
			local tr = self:CreateTrace(enemy:GetHeadPos(), nil, self:GetCenter())
			local bRange = dist <= self.fRangeDistance && dist >= 150 && CurTime() >= self.nextJump && tr.Entity == enemy
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