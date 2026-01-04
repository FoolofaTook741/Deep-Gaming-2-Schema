AddCSLuaFile( "shared.lua" )

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","npc_kingpin")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"npc_kingpin")
ENT.sModel = "models/half-life/kingpin.mdl"
ENT.fMeleeDistance	= 40
ENT.fRangeDistance = 1600
ENT.fRangeDistanceBeam = 1800

ENT.bPlayDeathSequence = true
ENT.bFlinchOnDamage = false
ENT.bIgnitable = false
ENT.bFreezable = false
ENT.tblIgnoreDamageTypes = {DMG_AIRBOAT, DMG_DISSOLVE, DMG_DROWN, DMG_DROWNRECOVER, DMG_FALL, DMG_PHYSGUN, DMG_PREVENT_PHYSICS_FORCE, DMG_VEHICLE}

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/kingpin/"

ENT.m_tbSounds = {
	["AttackBlast"] = "kingpin_teletoss0[1-2].mp3",
	["Melee"] = "kingpin_melee.wav",
	["Alert"] = "kingpin_alert.mp3",
	["Idle"] = { "kingpin_breath0[1-2].mp3", "kingpin_stummyrumble0[1-2].mp3", "kingpin_sneeze.mp3"},
	["Death"] = "kingpin_death0[1-2].mp3",
	["Pain"] = "kingpin_injured0[1-3].mp3",
	["Step"] = "kingpin_step0[1-5].wav"
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITBOX_HEAD] = ACT_DIE_HEADSHOT
}
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE, DMG_POISON}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	--self:SetCollisionBounds(Vector(140, 140, 578), Vector(-140, -140, 0))
	self:SetCollisionBounds(Vector(40, 40, 116), Vector(-40, -40, 0))

	self:CapabilitiesAdd(CAP_MOVE_GROUND || CAP_OPEN_DOORS)

	self:SetHealth(GetConVarNumber("sk_kingpin_health"))
	
	self.nextPsychicAttack = 0
	self.nextThrow = 0
	self.throwDelay = 0
	self.nextPlayerThrow = 0
	self.nextPlayerHealthDrain = 0
	self.entCurThrow = NULL
	self.tblPhysEnts = {}
	
	local shield = ents.Create("prop_dynamic_override")
	shield:SetModel("models/half-life/kingpin_sphereshield.mdl")
	shield:SetPos(self:GetCenter())
	shield:SetParent(self)
	shield:DrawShadow(false)
	shield:Spawn()
	--shield:Activate()
	--self.bShieldActive = true
	--self.entShield = shield
	--self:SetShieldPower(100)
	--self:ActivateShield()
	--self:SetSoundLevel(95)
	self.tblSummonedAllies = {}
	
	--local entBeam = util.ParticleEffectTracer("kingpin_beam_charge2", self:GetAttachment(self:LookupAttachment("clawright")).Pos, {{ent = self, att = "clawleft"}}, self:GetAngles(), self, "clawright", false)
	--timer.Simple(5, function() print("BEAM: ", entBeam) end)
	--self:DeleteOnDeath(entBeam)
end

function ENT:ScaleDamage(dmginfo, hitgroup)
	if hitgroup == HITBOX_HEAD then
		dmginfo:ScaleDamage(2)
	elseif hitgroup == HITBOX_GEAR then dmginfo:SetDamage(0)
	elseif hitgroup == HITBOX_LEFTARM || hitgroup == HITBOX_RIGHTARM || hitgroup == HITBOX_LEFTLEG || hitgroup == HITBOX_RIGHTLEG || hitgroup == HITBOX_ADDLIMB then
		dmginfo:ScaleDamage(0.25)
	end
	if !self:ShieldActive() then return end
	local inflictor = dmginfo:GetInflictor()
	if !IsValid(inflictor) then return end
	local scale = self.shieldPower /100
	local r = 225.6525 *scale
	local dist = self:GetCenter():Distance(inflictor:GetPos() +inflictor:OBBCenter())
	if dist >= r then dmginfo:ScaleDamage(0.05) end
end

function ENT:DisableShield()
	if IsValid(self.entShield) then self.entShield:SetNoDraw(true); self.bShieldActive = false end
end

function ENT:EnableShield()
	if IsValid(self.entShield) then self.entShield:SetNoDraw(false); self.bShieldActive = true end
end

function ENT:ShieldActive()
	return self.bShieldActive
end

function ENT:SetShieldPower(nPower)
	if !IsValid(self.entShield) then return end
	self.shieldPower = math.Clamp(nPower, 0, 100)
	if self.shieldPower == 0 then self.entShield:Remove(); self.entShield = nil; self.bShieldActive = false; return end
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("Kingpin_SetShieldScale", rp)
		umsg.Entity(self.entShield)
		umsg.Short(nPower)
	umsg.End()
end

function ENT:OnFlinch()
	if !self.bInSchedule then return end
	self:StopAttack()
	self:PlayActivity(ACT_SIGNAL_HALT, true)
	self.nextPlayerThrow = CurTime() +math.Rand(8,12)
	self:SelectSchedule()
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if IsValid(self.entEnemy) then 
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
	else
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
	end
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:StopAttack()
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:SetGravity(1)
	end
	self.throwDelay = 0
	self.nextThrow = 0
	self:StopAttackEffects()
	self.bWaitForThrow = false
	self.entParticle = nil
	self.bInSchedule = false
	self:UpdatePhysicsEnts()
	for k, v in pairs(self.tblPhysEnts) do
		v:GetPhysicsObject():EnableGravity(true)
	end
	self.bThrowPlayer = false
end

function ENT:ActivateShield()
	self:SetInvincible(true)
	ParticleEffectAttach("kingpin_psychic_shield_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
end

function ENT:DeactivateShield()
	self:SetInvincible(false)
	self:StopParticles()
end

function ENT:MindControl(ent)
	
end


local velMax = {rpg_missile = 1500, obj_rpg = 1200, npc_grenade_frag = 1024, prop_combine_ball = 1000}
--[[function ENT:Think()
	if true then return end
	if !self.bInSchedule && IsValid(self.entCurThrow) && !IsValid(self.entEnemy) then
		self.entCurThrow:GetPhysicsObject():EnableGravity(true)
		self.entCurThrow = NULL
	end
	if self.bDead then return end
	self:UpdateLastEnemyPositions()
	for _, ent in pairs(ents.GetAll()) do
		local class = ent:GetClass()
		if velMax[class] && self:OBBDistance(ent) <= 800 then
			local velMax = velMax[class]
			local pos = ent:GetPos()
			local vel = ent:GetVelocity()
			local normal = vel:GetNormal()
			local normalDest = (pos -self:GetPos()):GetNormal()
			normal = Vector(math.Approach(normal.x, normalDest.x, 0.1), math.Approach(normal.y, normalDest.y, 0.1), math.Approach(normal.z, normalDest.z, 0.1))
			vel = normal *math.min(vel:Length() *1.5, velMax)
			if class == "rpg_missile" then ent:SetLocalVelocity(vel)
			else
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then phys:SetVelocity(vel) end
			end
		end
	end
	self:NextThink(CurTime())
	if !self.bInSchedule then return true end
	if self.bThrowPlayer then
		if !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:Distance(self) > self.fRangeDistance || !self:Visible(self.entEnemy) then
			self:StopAttack()
			self:PlayActivity(ACT_SIGNAL_HALT, true)
			return true
		end
		local vel = self.entEnemy:GetVelocity()
		vel.x = vel.x *0.8
		vel.y = vel.y *0.8
		vel.z = 100 -(self.entEnemy:GetPos().z -self:GetPos().z)
		if self.entEnemy:OnGround() then
			vel.z = vel.z +200
		end

		local fDist = self:GetCenter():Distance(self.entEnemy:GetPos())
			
		vel = vel +((self:GetPos() +self:OBBMaxs()) -self.entEnemy:GetPos()):GetNormal() *math.Clamp(fDist -100, 0, 20)
		// +SIN/COS
		self.entEnemy:SetLocalVelocity(vel)
		self.entEnemy:SetGravity(0.000001)
		// ONLY GET PLAYER IF SELF HEALTH IS SMALLER THAN 3/4 OF MAX HEALTH
		if fDist <= 200 && CurTime() >= self.nextPlayerHealthDrain then
			self.nextPlayerHealthDrain = CurTime() +0.5
			self.entEnemy:TakeDamage(1, self, self)
			local iHealth = self:Health()
			local iHealthMax = self:GetMaxHealth()
			// DONT LET PLAYER MOVE AWAY FROM FORCE!!!
			// BIGGER SPHERE FOR PLAYER!!
			/*if iHealth >= iHealthMax then
				self:StopAttack()
				self:PlayActivity(ACT_RANGE_ATTACK2_LOW, true)
				//THROW PLAYER
				return
			else*/
				self:SetHealth(iHealth +1)
			//end
			//IF DAMAGED THEN THROW PLAYER
		end
		if CurTime() >= self.nextThrow then
			self:StopAttackEffects()
			self.nextThrow = 0
			self.nextPlayerThrow = CurTime() +math.Rand(8,12)
			self.bThrowPlayer = false
			self:PlayActivity(ACT_RANGE_ATTACK2_LOW, true)
			self.entEnemy:SetGravity(1)
			self.entEnemy:SetLocalVelocity((self.entEnemy:GetCenter() -self:GetCenter()):GetNormal() *2000)
			self.entEnemy:TakeDamage(GetConVarNumber("sk_kingpin_dmg_psychic"), self, self)
			self:DeactivateShield()
		end
		return true
	end
	self:UpdatePhysicsEnts()
	if #self.tblPhysEnts == 0 || !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:Distance(self) > self.fRangeDistance || !self:Visible(self.entEnemy) then
		self:StopAttack()
		self:PlayActivity(ACT_SIGNAL_HALT, true)
		return true
	end
	for k, v in pairs(self.tblPhysEnts) do
		if self.entCurThrow != v || self.bWaitForThrow then
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				local vel = phys:GetVelocity()
				vel.x = vel.x *0.8
				vel.y = vel.y *0.8
				vel.z = 600 -(v:GetPos().z -self:GetPos().z)
				phys:SetVelocity(vel)
				phys:AddAngleVelocity(phys:GetAngleVelocity() *-0.2)
			end
		end
	end

	if self.bWaitForThrow then
		if !IsValid(self.entCurThrow) then
			self:StopAttack()
			self:PlayActivity(ACT_SIGNAL_HALT, true)
			return true
		end
		if CurTime() >= self.throwDelay then
			local yaw = self:GetAngleToPos(self.entCurThrow:GetPos()).y
			if (yaw <= 180 && yaw > 75) || (yaw > 180 && yaw < 285) then
				self.throwDelay = CurTime() +1
				return true
			end
			self:PlayActivity(ACT_RANGE_ATTACK2_LOW, true)
			self.throwDelay = 0
			self.bWaitForThrow = false
			self.nextThrow = CurTime() +math.Rand(1,2)
			self:StopAttackEffects()
			self.entParticle = nil
			self.entCurThrow:EmitSound(self.sSoundDir .. "kingpin_teletoss0" .. math.random(1,2) .. ".mp3", 80, 100)
			local phys = self.entCurThrow:GetPhysicsObject()
			phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
			phys:SetVelocity((self.entEnemy:GetHeadPos() -self.entCurThrow:GetPos()):GetNormal() *1800)
			self:UpdatePhysicsEnts()
			for k, v in pairs(self.tblPhysEnts) do
				if v != self.entCurThrow then
					v:GetPhysicsObject():EnableGravity(true)
				end
			end
			self.bInSchedule = false
			self:DeactivateShield()
		else
			local fDist = self:GetCenter():Distance(self.entCurThrow:GetPos()) -100
			local vel = math.Clamp(fDist, 0, 450)
			
			local pos = ((self:GetPos() +(self:OBBMaxs() *1.3)) -self.entCurThrow:GetPos()):GetNormal() *vel
			pos.z = 100 -(self.entCurThrow:GetPos().z -self:GetPos().z)
			local yaw = self:GetAngleToPos(self.entCurThrow:GetPos()).y
			local mSin = math.sin(CurTime() +1) *100
			local mCos = math.cos(CurTime() +1) *100
			if yaw <= 180 && yaw > 60 then
				pos.x = pos.x +mCos
				pos.y = pos.y +mSin
			elseif yaw > 180 && yaw < 300 then
				pos.x = pos.x +mSin
				pos.y = pos.y +mCos
			end
			
			local phys = self.entCurThrow:GetPhysicsObject()
			phys:SetVelocity(pos)
		end
	elseif CurTime() >= self.nextThrow then
		self.throwDelay = CurTime() +2
		self.bWaitForThrow = true
		local mass = 0
		for _, ent in pairs(self.tblPhysEnts) do
			local phys = ent:GetPhysicsObject()
			local _mass = phys:GetMass()
			if IsValid(phys) && _mass > mass then
				mass = _mass
				self.entCurThrow = ent
			end
		end
		self.entCurThrow:EmitSound(self.sSoundDir .. "kingpin_telepickup0" .. math.random(1,2) .. ".mp3", 80, 100)
		ParticleEffectAttach("kingpin_object_charge", PATTACH_ABSORIGIN_FOLLOW, self.entCurThrow, 0)
		
		local _sName = self.entCurThrow:GetName()
		local sName = _sName
		if string.len(sName) == 0 then
			sName = "KingPin" .. self:EntIndex() .. "_entThrow"
			self.entCurThrow:SetName(sName)
		end
		local entParticle = ents.Create("info_particle_system")
		entParticle:SetPos(self:GetCenter())
		entParticle:SetParent(self)
		entParticle:SetKeyValue("effect_name", "kingpin_psychic_beam")
		entParticle:SetKeyValue("start_active", "1")
		entParticle:SetKeyValue("cpoint1", sName)
		entParticle:Spawn()
		entParticle:Activate()
		self.entCurThrow:SetName(_sName)
		
		self.entParticle = entParticle
	end
end
]]--

function ENT:OnThink()
	if self.bDead then return end
	if self.bInSchedule && self.tblBeams && IsValid(self.entEnemy) then
		local posSelf = self:GetPos()
		local normal = (self.entEnemy:GetCenter() -self.posBeam):GetNormal()
		local dist = self.entEnemy:NearestPoint(self.posBeam):Distance(self.posBeam)
		local speed = math.Clamp((dist /500) *20, 5, 20)
		local posTgt = self.posBeam +normal *speed
		local attA = self:GetAttachment(self:LookupAttachment("clawleft"))
		local attB = self:GetAttachment(self:LookupAttachment("clawright"))
		local pos = (attA.Pos +attB.Pos) *0.5
		local tr = util.TraceLine({start = pos, endpos = posTgt, filter = self})
		if dist > 5 then
			if !tr.Hit then tr = util.TraceLine({start = tr.HitPos +Vector(0,0,100), endpos = tr.HitPos -Vector(0,0,100), mask = MASK_NPCWORLDSTATIC})
			else tr.HitPos = tr.HitPos +Vector(0,0,1) *speed end
		end
		local tblEnts = util.BlastDmg(self, self, tr.HitPos, 25, 2, function(ent)
			return (!ent:IsNPC() || self:Disposition(ent) <= 2) && (!ent:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers")))
		end, DMG_ENERGYBEAM, false)
		if table.Count(tblEnts) > 0 then
			if !self.bHit then
				self.cspBeamHit:Play()
				self.bHit = true
			end
		elseif self.bHit then
			self.cspBeamHit:Stop()
			self.bHit = false
		end
		self.posBeam = tr.HitPos
		self.entTarget:SetPos(self.posBeam)
	end
	self:NextThink(CurTime() +0.02)
	return true
end

function ENT:StopAttackEffects()
	if IsValid(self.entParticle) then
		self.entParticle:Fire("Stop", "", 0)
		self.entParticle:Remove()
	end
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:StopParticles()
	end
	if IsValid(self.entCurThrow) then self.entCurThrow:StopParticles() end
end

function ENT:OnDeath()
	self:UpdatePhysicsEnts()
	for k, v in pairs(self.tblPhysEnts) do
		local phys = v:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
		end
	end
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:SetGravity(1)
	end
	self:StopAttackEffects()
end

function ENT:OnRemove()
	hook.Remove( "PlayerSpawn", "PlayerSpawn_AddRelationship" .. self:EntIndex() )
	hook.Remove( "OnEntityCreated", "OnEntityCreated_AddRelationship" .. self:EntIndex() )
	self:StopSounds()
	for k, v in pairs(self.tblCSPStopOnDeath) do
		v:Stop()
	end
	self:OnDeath()
end

function ENT:UpdatePhysicsEnts()
	for k, v in pairs(self.tblPhysEnts) do
		if !IsValid(v) then self.tblPhysEnts[k] = nil; if v == self.entCurThrow then self:StopAttackEffects() end
		elseif v:GetPos():Distance(self:GetPos()) > self.fRangeDistance then
			v:GetPhysicsObject():EnableGravity(true)
			self.tblPhysEnts[k] = nil
			if v == self.entCurThrow then self:StopAttackEffects() end
		end
	end
	table.refresh(self.tblPhysEnts)
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.fRangeDistance)) do
		if v:IsPhysicsEntity() && !table.HasValue(self.tblPhysEnts,v) then
			local phys = v:GetPhysicsObject()
			local mass = phys:GetMass()
			if mass <= 10000 && mass >= 25 then
				phys:EnableGravity(false)
				table.insert(self.tblPhysEnts,v)
			end
		end
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local subevent = select(2,...)
	if (event == "mattack") then
		local fDist = self.fMeleeDistance
		self:EmitSound(self.sSoundDir .. "kingpin_melee.wav", 100, 100)
		local iDmg = GetConVarNumber("sk_kingpin_dmg_slash")
		local angViewPunch
		local bLeft = tobool(string.find(...,"left"))
		local bRight = tobool(string.find(...,"right"))
		
		if bLeft then
			angViewPunch = Angle(4,30,-3)
		elseif bRight then
			angViewPunch = Angle(4,-30,3)
		else
			angViewPunch = Angle(22,0,0)
		end
		self:DoMeleeDamage(fDist,iDmg,angViewPunch)
		return
	end


	if (event == "rattack") then
		if (subevent == "summon") then
			ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
			local classes = {["npc_devilsquid"] = self:LocalToWorld(Vector(80,0,10)), ["npc_bullsquid"] = self:LocalToWorld(Vector(60,45,10)), ["npc_frostsquid"] = self:LocalToWorld(Vector(60,-45,10)), ["monster_hound_eye"] = self:LocalToWorld(Vector(70,55,20)),["npc_poisonsquid"] = self:LocalToWorld(Vector(100,2,30))}
			local numCritters = 5
			local randomCritter = math.random(5)
			local critterCounter = 1
			for class, pos in pairs(classes) do
				if (critterCounter == randomCritter) then
					local ally = ents.Create(class)
					ally:SetPos(pos)
					ally:SetAngles(self:GetAngles())
					ally:Spawn()
					ally:Activate()
					ally:MergeMemory(self:GetMemory())
					ally:SetSquad(self:GetSquad())
					ally.entEnemy = self.entEnemy
					table.insert(self.tblSummonedAllies,ally)
					
					ally:EmitSound("debris/beamstart" .. math.random(1,2) .. ".wav",100,100)
					
					ParticleEffect("tor_shockwave", pos +Vector(0,0,40), Angle(0,0,0), ally)
					ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
				end
				critterCounter = critterCounter + 1
			end
			self:StopParticles()
			return
		end
		if (subevent == "distance") then
			local attA = self:GetAttachment(self:LookupAttachment("clawleft"))
			local attB = self:GetAttachment(self:LookupAttachment("clawright"))
			local pos = (attA.Pos +attB.Pos) *0.5
			local dir = self:GetConstrictedDirection(pos, 50, 60, self.entEnemy:GetCenter() +self.entEnemy:GetVelocity() *0.85)
			local ent = ents.Create("obj_kingpin_projectile_energy")
			ent:SetEntityOwner(self)
			ent:SetPos(pos)
			ent:SetAngles(dir:Angle())
			ent:SetScale(8)
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:ApplyForceCenter(dir *500)
			end
			return
		end
		if (subevent == "beamanim") then
			self:PlayActivity(ACT_SIGNAL2, true, nil, true)
			return
		end
		if (subevent == "beamstart") then
			self:PlayActivity(ACT_SIGNAL3, true, nil, true)
			local pos = self:GetPos()
			if not IsValid(self.entEnemy) then return end
			local normal = (self.entEnemy:GetPos() -pos):GetNormal()
			local posTgt = pos +normal *250
			local tr = util.TraceLine({start = posTgt +Vector(0,0,100), endpos = posTgt -Vector(0,0,100), mask = MASK_NPCWORLDSTATIC})
			posTgt = tr.HitPos
			self.posBeam = posTgt
			local entTarget = ents.Create("obj_target")
			entTarget:SetPos(self.posBeam)
			entTarget:Spawn()
			entTarget:Activate()
			self:DeleteOnDeath(entTarget)
			self.entTarget = entTarget
			
			self.tblBeams = {}
			self.tblSprites = {}
			for i = 1, 2 do
				local att = i == 1 && "clawleft" || "clawright"
				local entBeam = ents.Create("obj_beam")
				entBeam:SetStart(self, self:LookupAttachment(att))
				entBeam:SetEnd(self.entTarget)
				entBeam:SetTexture("effects/kingpin_beam.vmt")
				entBeam:SetAmplitude(2)
				entBeam:SetUpdateRate(0)--0.25)
				entBeam:Spawn()
				entBeam:Activate()
				entBeam:TurnOn()
				table.insert(self.tblBeams, entBeam)
				self:DeleteOnDeath(entBeam)
				
				local entSprite = ents.Create("env_sprite")
				entSprite:SetKeyValue("model", "sprites/kingpin_glow01.vmt")
				entSprite:SetKeyValue("rendermode", "5") 
				entSprite:SetKeyValue("rendercolor", "0 0 255") 
				entSprite:SetKeyValue("scale", "0.2") 
				entSprite:SetKeyValue("spawnflags", "1") 
				entSprite:SetParent(self)
				entSprite:Fire("SetParentAttachment", att, 0)
				entSprite:Spawn()
				entSprite:Activate()
				table.insert(self.tblSprites, entSprite)
				self:DeleteOnDeath(entSprite)
			end
			local entSprite = ents.Create("env_sprite")
			entSprite:SetPos(self.entTarget:GetPos())
			entSprite:SetKeyValue("model", "sprites/kingpin_glow01.vmt")
			entSprite:SetKeyValue("rendermode", "5") 
			entSprite:SetKeyValue("rendercolor", "0 0 255") 
			entSprite:SetKeyValue("scale", "0.4") 
			entSprite:SetKeyValue("spawnflags", "1") 
			entSprite:SetParent(self.entTarget)
			entSprite:Spawn()
			entSprite:Activate()
			table.insert(self.tblSprites, entSprite)
			self.entTarget:DeleteOnRemove(entSprite)
			
			local csp = CreateSound(self, "npc/stalker/laser_burn.wav")
			csp:Play()
			self.cspBeam = csp
			self:StopSoundOnDeath(csp)
			
			csp = CreateSound(self.entTarget, "npc/stalker/laser_flesh.wav")
			self.cspBeamHit = csp
			self:StopSoundOnDeath(csp)
			return
		end
		if (subevent == "beamloop") then
			if !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || !self:Visible(self.entEnemy) || self:OBBDistance(self.entEnemy) > self.fRangeDistanceBeam then
				self:EnableShield()
				self:PlayActivity(ACT_SIGNAL_ADVANCE, true, nil, true)
				if (self.tblBeams and #self.tblBeams > 0) then
				for _, beam in pairs(self.tblBeams) do beam:Remove() end end
				for _, sprite in pairs(self.tblSprites) do sprite:Remove() end
				self.tblSprites = nil
				self.tblBeams = nil
				self.bInSchedule = false
				self.cspBeam:Stop()
				self.cspBeam = nil
				self.cspBeamHit:Stop()
				self.cspBeamHit = nil
				self.entTarget:Remove()
				self.entTarget = nil
			else
				if self:ShieldActive() then self:DisableShield() end
				self:PlayActivity(ACT_SIGNAL3, true, nil, true)
			end
			return
		end
		if (subevent == "psychic_loop") then
			self:PlayActivity(ACT_RANGE_ATTACK2, true)
		end
		return
	end
end

function ENT:Interrupt()		-- Called on flinch, possession start or ai disabled
	if self.bInSchedule then
		self:EnableShield()
		if self.tblBeams then for _, beam in pairs(self.tblBeams) do beam:Remove() end; self.tblBeams = nil end
		if self.tblSprites then for _, sprite in pairs(self.tblSprites) do sprite:Remove() end; self.tblSprites = nil end
		self.bInSchedule = false
		if self.cspBeam then
			self.cspBeam:Stop()
			self.cspBeam = nil
		end
		if self.cspBeamHit then
			self.cspBeamHit:Stop()
			self.cspBeamHit = nil
		end
		if IsValid(self.entTarget) then
			self.entTarget:Remove()
			self.entTarget = nil
		end
	end
	if self.actReset then self:SetMovementActivity(self.actReset); self.actReset = nil end
	if self:IsPossessed() then self:_PossScheduleDone() end
end

function ENT:SelectScheduleHandle(enemy,fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 then
		if self:CanSee(self.entEnemy) then
			local bMelee = fDist <= self.fMeleeDistance || fDistPredicted <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local bRange = fDist <= self.fRangeDistanceBeam
			local bPlayerThrow = CurTime() >= self.nextPlayerThrow && self.entEnemy:IsPlayer()
			if bRange then
				for _, ent in pairs(self.tblSummonedAllies) do if !IsValid(ent) then self.tblSummonedAllies[_] = nil end end
				if table.Count(self.tblSummonedAllies) < 3 then
					self:PlayActivity(ACT_SIGNAL_FORWARD, true)
					return
				else
					if math.random(1,2) == 1 then self:PlayActivity(ACT_RANGE_ATTACK1, true)
					else
						self.bHit = false
						self:PlayActivity(ACT_SIGNAL1, true)
						self.bInSchedule = true
					end
					return
				end
				return
				--[[/*self:UpdatePhysicsEnts()
				if #self.tblPhysEnts > 0 || bPlayerThrow then
					if bPlayerThrow && (#self.tblPhysEnts == 0 || math.random(1,3) == 1) then
						self.bThrowPlayer = true
						ParticleEffectAttach("kingpin_object_charge_large", PATTACH_ABSORIGIN_FOLLOW, self.entEnemy, 0)
						local _sName = self.entEnemy:GetName()
						local sName = _sName
						if sName == self.entEnemy:Name() then
							sName = "KingPin" .. self:EntIndex() .. "_entThrow"
							self.entEnemy:SetName(sName)
						end
						local entParticle = ents.Create("info_particle_system")
						entParticle:SetPos(self:GetCenter())
						entParticle:SetParent(self)
						entParticle:SetKeyValue("effect_name", "kingpin_psychic_beam")
						entParticle:SetKeyValue("start_active", "1")
						entParticle:SetKeyValue("cpoint1", sName)
						entParticle:Spawn()
						entParticle:Activate()
						self.entEnemy:SetName(_sName)
						self.entParticle = entParticle
					end
					self.nextThrow = CurTime() +math.Rand(3,4)
					self:PlayActivity(ACT_RANGE_ATTACK1_LOW, true)
					self.bInSchedule = true
					return
				end*/]]--
			end
		end
		self:ChaseEnemy()
	elseif iDisposition == 2 then
		self:Hide()
	end
end
