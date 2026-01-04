AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_archer")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
ENT.sModel = "models/half-life/archer.mdl"
ENT.fRangeDistance = 800
ENT.fMeleeDistance = 60

ENT.bPlayDeathSequence = true

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/archer/"

ENT.m_tbSounds = {
	["Attack"] = "arch_attack[1-2].wav",
	["AttackBite"] = "arch_bite[1-2].wav",
	["Alert"] = "arch_alert[1-2].wav",
	["Death"] = "arch_die[1-3].wav",
	["Pain"] = "arch_pain[1-4].wav",
	["Idle"] = "arch_idle[1-3].wav"
}

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()

	self:SetCollisionBounds(Vector(12, 12, 12), Vector(-12, -12, 0))
	
	self:SetHealth(GetConVarNumber("sk_archer_health"))
	self.iBurstCount = math.random(2,4)
	self.nextBurst = 0
	self:SetMinSwimSpeed(80)
	self:SetMaxSwimSpeed(180)
	self:SetSlowSwimActivity(ACT_GLIDE)
	self:SetFastSwimActivity(ACT_SWIM)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if self:WaterLevel() == 0 then return end
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	if self:WaterLevel() == 0 then return end
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		if(atk == "rattack") then
			local tblBullet = {}
			tblBullet.Num = 1
			tblBullet.Src = self:GetPos() +self:GetForward() *10
			tblBullet.Attacker = self
			tblBullet.Dir = self:GetForward()
			if !self:IsPossessed() then tblBullet.Spread = Vector(0.03,0.03,0)
			else tblBullet.Spread = Vector(0,0,0) end
			tblBullet.Tracer = 0
			tblBullet.Force = 3
			tblBullet.Damage = GetConVarNumber("sk_archer_dmg_shoot")
			tblBullet.Callback = function(entAttacker, tblTr, dmg)
				local entVictim = tblTr.Entity
				local iDmg = dmg:GetDamage()
				if tblTr.HitGroup == 1 then
					iDmg = iDmg *10
				elseif tblTr.HitGroup != 0 then
					iDmg = iDmg *0.25
				end
				entVictim:EmitSound("physics/surfaces/underwater_impact_bullet" .. math.random(1,3) .. ".wav", 75, 100)
			end
			self:EmitSound("player/pl_drown" .. math.random(1,3) .. ".wav", 75, 100)
			self:FireBullets(tblBullet)
			self.iBurstCount = self.iBurstCount -1
			if self.iBurstCount <= 0 then self.nextBurst = CurTime() +math.Rand(4,12) end
		else
			local fDist = self.fMeleeDistance
			local iDmg = GetConVarNumber("sk_archer_dmg_bite")
			local angViewPunch
			if atk == "bitea" then
				angViewPunch = Angle(-20,-6,2)
			else
				angViewPunch = Angle(-16,4,-1)
			end
			self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT || disp == D_FR) then
		if self:CanSee(self.entEnemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			if self.iBurstCount == 0 && CurTime() >= self.nextBurst then
				self.iBurstCount = math.random(2,4)
			end
			local bRange = dist <= self.fRangeDistance && dist >= 100 && self.iBurstCount > 0
			if bRange then
				self:PlayActivity(ACT_RANGE_ATTACK1, true)
				return
			end
		end
		self:PlayActivity(ACT_SWIM,false)
	end
end
