AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_gonome")
ENT.NPCFaction = NPC_FACTION_HEADCRAB
ENT.iClass = CLASS_HEADCRAB
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_gonome")
ENT.sModel = "models/opfor/gonome.mdl"
ENT.fMeleeDistance	= 60
ENT.fMeleeForwardDistance	= 210
ENT.fRangeDistance = 800

ENT.bPlayDeathSequence = true

ENT.skName = "gonome"
ENT.CollisionBounds = Vector(18,18,100)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/gonome/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT
}

ENT.m_tbSounds = {
	["Attack"] = "gonome_melee[1-2].wav",
	["AttackJump"] = "gonome_jumpattack.wav",
	["Run"] = "gonome_run.wav",
	["Death"] = "gonome_death[2-4].wav",
	["Pain"] = "gonome_pain[1-4].wav",
	["Idle"] = "gonome_idle[1-3].wav",
	["Foot"] = "gonome_step[1-4].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	//self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.iAcidCount = math.random(2,4)
	self.nextAcid = 0
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
		local iDmg
		local iAtt
		local angViewPunch
		if(atk == "jump") then
			if self.bJumpHit then return true end
			angViewPunch = Angle(12,0,0)
			fDist = 40
			iDmg = GetConVarNumber("sk_gonome_dmg_jump")
			local bHit
			self:DealMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,nil,nil,nil,function(ent)
				bHit = true
			end,nil,false)
			if bHit then
				self.bJumpHit = true
				self:EmitSound("npc/zombie/claw_strike" ..math.random(1,3).. ".wav", 75, 100)
			end
			return true
		end
		if(atk == "left") then
			angViewPunch = Angle(-3,24,-3)
			iDmg = GetConVarNumber("sk_gonome_dmg_slash")
		elseif(atk == "right") then
			angViewPunch = Angle(-3,-24,3)
			iDmg = GetConVarNumber("sk_gonome_dmg_slash")
		else
			angViewPunch = Angle(5,0,0)
			iDmg = GetConVarNumber("sk_gonome_dmg_bite")
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		if !IsValid(self.entEnemy) && !self.bPossessed then return true end
		local bAcidStart = atk == "acidstart"
		local bAcidThrow = !bAcidStart
		if bAcidStart then
			self.tblAcidEnts = {}
			for i = 1, 2 do
				local entAcid = ents.Create("obj_gonome_acid")
				entAcid:SetParent(self)
				entAcid:SetEntityOwner(self)
				entAcid:SetOwner(self)
				entAcid:Spawn()
				entAcid:Fire("SetParentAttachment", "hand_right", 0)
				
				self:DeleteOnDeath(entAcid)
				table.insert(self.tblAcidEnts, entAcid)
			end
			return true
		end
		for k, v in pairs(self.tblAcidEnts) do
			local pos
			if IsValid(self.entEnemy) || self.bPossessed then
				local posSelf = self:GetAttachment(1).Pos -Vector(0,0,10)
				local posEnemy
				if !self.bPossessed then posEnemy = self.entEnemy:GetCenter()
				else
					local entPossessor = self:GetPossessor()
					posEnemy = entPossessor:GetPossessionEyeTrace().HitPos
				end
				local fDistZ = posEnemy.z -posSelf.z
				posSelf.z = 0
				posEnemy.z = 0
				local fDist = posSelf:Distance(posEnemy)
				local fDistZMax = math.Clamp((fDist /450) *500, 0, 500)
				fDistZ = math.Clamp(fDistZ, -fDistZMax, fDistZMax)
				fDist = math.Clamp(fDist, 100, 1250)
				pos = self:GetForward() *fDist +self:GetUp() *fDistZ
			else
				pos = self:GetForward() *500 +Vector(0,0,10)
			end
			pos = pos:GetNormalized() *2000 +Vector(0,0,300 *(pos:Length() /2000))
		
			v:SetParent()
			v:PhysicsInit(SOLID_VPHYSICS)
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(pos +VectorRand() *60)
			end
			
			self:DontDeleteOnDeath(v)
			self:DontDeleteOnRemove(v)
		end
		self.iAcidCount = self.iAcidCount -1
		if self.iAcidCount <= 0 then
			self.nextAcid = CurTime() +math.Rand(4,12)
		end
		return true
	end
end

function ENT:OnInterrupt()
	if !self.tblAcidEnts then return end
	for k, v in pairs(self.tblAcidEnts) do
		if IsValid(v) then
			v:Remove()
		end
	end
	self.tblAcidEnts = nil
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local ang = self:GetAngleToPos(enemy:GetPos())
			if ang.y <= 45 || ang.y >= 315 then
				local fTimeToGoal = self:GetPathTimeToGoal()
				if self.bDirectChase && fTimeToGoal <= 0.9 && fTimeToGoal >= 0.6 && distPred <= self.fMeleeForwardDistance then
					self.bJumpHit = false
					self:SetMovementActivity(ACT_RANGE_ATTACK2)
					self.bInSchedule = true
					timer.Simple(1.04, function()
						if IsValid(self) then
							self.bInSchedule = false
						end
					end)
					return
				end
				if self.iAcidCount == 0 && CurTime() >= self.nextAcid then
					self.iAcidCount = math.random(2,4)
				end
				local bRange = dist <= self.fRangeDistance && dist > 150 && self.iAcidCount > 0 && self:CreateTrace(enemy:GetHeadPos(), nil, self:LocalToWorld(Vector(55.4144, -10.6739, 59.6662))).Entity == enemy
				if bRange then
					self:PlayActivity(ACT_RANGE_ATTACK1, true)
					return
				end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end