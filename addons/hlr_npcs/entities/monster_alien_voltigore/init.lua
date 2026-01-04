AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_RACEX","monster_alien_voltigore")
ENT.NPCFaction = NPC_FACTION_RACEX
ENT.iClass = CLASS_RACEX
util.AddNPCClassAlly(CLASS_RACEX,"monster_alien_voltigore")
ENT.sModel = "models/opfor/voltigore.mdl"
ENT.fMeleeDistance = 46
ENT.fRangeDistance = 880


ENT.skName = "voltigore"
ENT.CollisionBounds = Vector(70,70,95)

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.bFlinchOnDamage = false
ENT.sSoundDir = "npc/voltigore/"

ENT.tblAlertAct = {}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["Attack"] = "voltigore_attack_melee[1-2].wav",
	["Range"] = "voltigore_attack_shock.wav",
	["Alert"] = "voltigore_alert[1-3].wav",
	["Death"] = "voltigore_die[1-3].wav",
	["Pain"] = "voltigore_pain[1-4].wav",
	["Idle"] = "voltigore_idle[1-3].wav",
	["Step"] = "voltigore_footstep[1-3].wav",
	["Grunt"] = "voltigore_run_grunt[1-2].wav"
}

function ENT:OnInit()

if (math.random(1,10) > 5) then 
	self.bExplodeOnDeath = true
	self.bPlayDeathSequence = false
else 
	self.bExplodeOnDeath = false
	self.bPlayDeathSequence = true
end
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.nextRange = 0
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:OnFoundEnemy(iEnemies)
	self.nextRange = CurTime() +math.Rand(3,8)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		local bLeft = atk == "left"
		local bBoth = !bLeft
		if bLeft then
			iDmg = GetConVarNumber("sk_voltigore_dmg_slash")
			angViewPunch = Angle(30,-22,16)
		else
			iDmg = GetConVarNumber("sk_voltigore_dmg_slash_both")
			angViewPunch = Angle(38,0,0)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		local atk = select(2,...)
		local bBeamStart = atk == "start"
		local bBeamEnd = !bBeamStart
		if bBeamEnd then
			if self.tblEntsBeams then
				for k, v in pairs(self.tblEntsBeams) do
					if IsValid(v) then
						v:Remove()
					end
				end
			end
			self.bInSchedule = false
			if !IsValid(self.entBeam) then self.entBeam = nil; return true end
			self:DontDeleteOnDeath(self.entBeam)
			self.entBeam:SetParent()
			local phys = self.entBeam:GetPhysicsObject()
			if IsValid(phys) then
				if !self:IsPossessed() then
					local pos = self:GetPos() +self:GetForward() *85 +self:GetUp() *30
					local posEnemy = self.entEnemy:GetCenter()
					local flDist = pos:Distance(posEnemy)
					local vel = self.entEnemy:GetVelocity()
					local posEnemyPred = posEnemy +vel *(flDist /1500)
					local _ang = self:GetAngles()
					local ang = (posEnemyPred -pos):Angle()
					ang.p = math.Clamp(ang.p, _ang.p -45, ang.p)
					ang.y = math.Clamp(ang.y, ang.y -45, ang.y)
					phys:ApplyForceCenter(ang:Forward() *1500)
				else
					local pos = self:GetPos() +self:GetForward() *85 +self:GetUp() *30
					local posEnemy = self:GetPossessor():GetPossessionEyeTrace().HitPos
					local normal = self:GetConstrictedDirection(pos, 45, 45, posEnemy)
					phys:ApplyForceCenter(normal *1500)
				end
			end
			self.entBeam:Wake()
			self.entBeam = nil
			return true
		end
		local pos = self:GetPos() +self:GetForward() *85 +self:GetUp() *30
		self:EmitSound("debris/beamstart2.wav", 75, 150)
		local entBeamVolt = ents.Create("obj_voltigore_beam")
		entBeamVolt:SetPos(pos)
		entBeamVolt:SetParent(self)
		entBeamVolt:Spawn()
		entBeamVolt:Activate()
		self:DeleteOnDeath(entBeamVolt)
		self.entBeam = entBeamVolt
		self.tblEntsBeams = {}
		
		for i = 1, 3 do
			local entBeam = ents.Create("obj_beam")
			entBeam:SetPos(self:GetPos())
			entBeam:SetParent(self)
			entBeam:Spawn()
			entBeam:Activate()
			entBeam:SetAmplitude(5)
			entBeam:SetWidth(6)
			entBeam:SetUpdateRate(0.02)
			entBeam:SetTexture("sprites/volt_beam01")
			entBeam:SetBeamColor(252,0,246,255)
			entBeam:SetStart(self, i)
			entBeam:SetEnd(entBeamVolt)
			entBeam:TurnOn()
			entBeamVolt:DeleteOnRemove(entBeam)
			self:DeleteOnDeath(entBeam)
			table.insert(self.tblEntsBeams, entBeam)
		end
		self.nextRange = CurTime() +math.Rand(3,8)
		return true
	end
end

function ENT:OnInterrupt()
	if IsValid(self.entBeam) then self.entBeam:Remove() end
	self.entBeam = nil
	if !self.tblEntsBeams then return end
	for k, v in pairs(self.tblEntsBeams) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function ENT:OnScheduleSelection()
	self:Interrupt()
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local tr = self:CreateTrace(enemy:GetHeadPos(), nil, self:GetPos() +self:GetForward() *85 +self:GetUp() *30)
			local bRange = dist <= self.fRangeDistance && CurTime() >= self.nextRange && tr.Entity == enemy
			if bRange then
				self.bInSchedule = true
				self:PlayActivity(ACT_RANGE_ATTACK1, true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end