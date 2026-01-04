AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_RACEX","npc_pitdrone")
ENT.NPCFaction = NPC_FACTION_RACEX
ENT.iClass = CLASS_RACEX
util.AddNPCClassAlly(CLASS_RACEX,"npc_pitdrone")
ENT.sModel = "models/opfor/pit_drone.mdl"
ENT.fMeleeDistance	= 65
ENT.fRangeDistance = 1000

ENT.bPlayDeathSequence = true

ENT.skName = "pitdrone"
ENT.CollisionBounds = Vector(13,13,72)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/pitdrone/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["AttackMelee"] = "pit_drone_melee_attack[1-2].wav",
	["AttackSpike"] = "pit_drone_attack_spike[1-2].wav",
	["Alert"] = "pit_drone_alert[1-3].wav",
	["Death"] = "pit_drone_die[1-3].wav",
	["Pain"] = "pit_drone_pain[1-4].wav",
	["Idle"] = "pit_drone_idle[1-3].wav",
	["Hunt"] = "pit_drone_hunt[1-3].wav",
	["Reload"] = "pit_drone_reload1.wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.iSpikes = math.random(3,6)
	self:SetBodygroup(1,self.iSpikes)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if self.iSpikes <= 0 then fcDone(true); return end
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_RELOAD,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		local bLeft = atk == "left"
		local bRight = atk == "right"
		local bBoth = atk == "both"
		if bLeft then
			iDmg = GetConVarNumber("sk_pitdrone_dmg_slash")
			angViewPunch = Angle(10,18,-3)
		elseif bRight then
			iDmg = GetConVarNumber("sk_pitdrone_dmg_slash")
			angViewPunch = Angle(10,-18,3)
		else
			iDmg = GetConVarNumber("sk_pitdrone_dmg_slash_both")
			angViewPunch = Angle(20,0,0)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		if !self:IsPossessed() && !IsValid(self.entEnemy) then return true end
		local pos = self:GetPos() +self:GetForward() *13 +self:GetUp() *36
		local vecTarget
		if !self:IsPossessed() then
			vecTarget = self.entEnemy:GetHeadPos()
		else
			local entPossessor = self:GetPossessor()
			local trace = entPossessor:GetPossessionEyeTrace()
			vecTarget = trace.HitPos
		end
		
		local angTarget = self:GetAngles() -(vecTarget -pos):Angle()
		while angTarget.y < 0 do angTarget.y = angTarget.y +360 end
		while angTarget.y < 0 do angTarget.y = angTarget.y +360 end
		if (angTarget.y >= 55 && angTarget.y <= 305) || angTarget.p > 50 || (angTarget.p < -50 && angTarget.p > -310) then return true end
		local normal = (vecTarget -pos):GetNormal()
		local ang = normal:Angle()
		local vecVel = normal *2400
		
		local entSpike = ents.Create("obj_pitdrone_spike")
		entSpike:SetPos(pos)
		entSpike:SetEntityOwner(self)
		entSpike:Spawn()
		entSpike:SetAngles(ang)
		local phys = entSpike:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(vecVel)
		end
		
		self.iSpikes = self.iSpikes -1
		self:SetBodygroup(1,self.iSpikes)
		if self.iSpikes == 0 then
			self.delayReload = CurTime() +math.Rand(5,15)
		end
		return true
	elseif(event == "reload") then
		self.iSpikes = 6
		self:SetBodygroup(1, 6)
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
			if dist <= self.fRangeDistance && self.delayReload && CurTime() >= self.delayReload then
				self.delayReload = nil
				self:PlayActivity(ACT_RELOAD, true)
				return
			end
			local bRange = dist <= self.fRangeDistance && self.iSpikes > 0 && self:CreateTrace(enemy:GetHeadPos(), nil, self:GetPos() +self:GetForward() *13 +self:GetUp() *36).Entity == enemy
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