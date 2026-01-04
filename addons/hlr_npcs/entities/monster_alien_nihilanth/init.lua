AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_alien_nihilanth")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
ENT.sModel = "models/half-life/nihilanth.mdl"
ENT.fRangeDistance = 20000
ENT.m_fMaxYawSpeed = 2
ENT.possOffset = Vector(-300, 0, 950)
ENT.AIType = 3

ENT.bPlayDeathSequence = true
ENT.bSpecialDeath = true
ENT.bFlinchOnDamage = false
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE, DMG_POISON}

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/nihilanth/"

ENT.m_tbSounds = {
	["Attack"] = "nil_attack[1-3].wav",
	["Recharge"] = "nil_recharge[1-3].wav",
	["Death"] = "nil_die1.wav",
	["Pain"] = "nil_pain[1-3].wav",
	["Idle"] = "nil_laugh[1-2].wav"
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}
ENT.tblAlertAct = {}

function ENT:OnInit()
	self:SetMoveType(MOVETYPE_FLY)
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()

	self:SetCollisionBounds(Vector(300,160,590), Vector(-300,-160,-590))

	self:CapabilitiesAdd(bit.bor(CAP_MOVE_FLY,CAP_SKIP_NAV_GROUND_CHECK))

	self:SetHealth(GetConVarNumber("sk_nihilanth_health"))
	
	self.tblForceEnts = {}
	if(!self:GetSquad()) then self:SetSquad(tostring(self) .. "_squad") end
	
	for i = 1, 20 do
		self:CreateForceProjectile()
	end
	self.fEnergy = 1500
	self.dmgForce = 0
	self:SetSoundLevel(100)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if self.countForceDeplete then
		self.countForceDeplete = self.countForceDeplete +1
		if self.countForceDeplete == 5 then self:ForceDepleted() end
	end
	self:PlayActivity(!self.bForceDepleted && ACT_RANGE_ATTACK1 || ACT_RANGE_ATTACK2,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	if self.countForceDeplete then
		self.countForceDeplete = self.countForceDeplete +1
		if self.countForceDeplete == 5 then self:ForceDepleted() end
	end
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	if !self:CanRecharge() then fcDone(true); return end
	self:PlayActivity(ACT_RELOAD,false,fcDone)
end

function ENT:_PossFaceForward(entPossessor, fcDone)
	if fcDone then fcDone(true) end
end

function ENT:_PossMovement(entPossessor)
	local vel
	if entPossessor:KeyDown(IN_JUMP) then vel = Vector(0,0,175)
	elseif entPossessor:KeyDown(IN_DUCK) then vel = Vector(0,0,-200)
	else vel = self:GetVelocity() *0.95 end
	self:SetLocalVelocity(vel)
	local ang = entPossessor:GetAimVector():Angle()
	self:TurnDegree(1, ang)
end
local cvGB = CreateConVar("sk_nihilanth_chance_special","0.01",FCVAR_ARCHIVE)
function ENT:InitSandbox()
	if !self:GetSquad() then self:SetSquad(self:GetClass() .. "_sbsquad") end
	for k, v in pairs(player:GetAll()) do
		v:ConCommand("playgamesound nihilanth/nil_freeman.wav")
	end
	
	if #ents.FindByClass("monster_alien_nihilanth") == 1 then
		local sTrack
		if(math.Rand(0,1) > cvGB:GetFloat()) then sTrack = "music/HL1_song24.mp3"
		else
			sTrack = "nihilanth/ghostbusters.mp3"
			for _, pl in pairs(self:GetPlayersInRange()) do
				pl:Give("weapon_egon")
				pl:SelectWeapon("weapon_egon")
				pl:SetAmmunition("uranium",10000)
			end
			local idx = self:EntIndex()
			local hk = "nihilanth_special" .. idx
			hook.Add("PlayerSpawn",hk,function(pl)
				pl:Give("weapon_egon")
				pl:SelectWeapon("weapon_egon")
				pl:SetAmmunition("uranium",10000)
			end)
			self:CallOnRemove(hk,function()
				hook.Remove("PlayerSpawn",hk)
			end)
		end
		local cspSoundtrack = CreateSound(self,sTrack)
		cspSoundtrack:SetSoundLevel(0.2)
		cspSoundtrack:Play()
		self:StopSoundOnDeath(cspSoundtrack)
	end
	self:CallOnRemove("rmv", function()
		for k, v in pairs(player:GetAll()) do
			v:SetGravity(1)
		end
	end)
	
	local pos = self:GetPos() +Vector(0,0,1000)
	local trace = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() +Vector(0,0,1000), filter = self})
	if trace.HitWorld then
		pos = trace.HitPos
	end 
	for i = 1,3 do
		local trace = util.TraceLine({start = pos, endpos = pos +Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-0.25,-1)) *5000, filter = self})
		if trace.HitWorld then
			local SpawnAngles = trace.HitNormal:Angle()
			SpawnAngles.pitch = SpawnAngles.pitch +90
			local entCrystal = ents.Create("obj_crystal")
			entCrystal:SetPos(trace.HitPos -trace.HitNormal * 14)
			entCrystal:SetAngles(SpawnAngles)
			entCrystal:Spawn()
			entCrystal:NoCollide(self)
			
			self:DeleteOnRemove(entCrystal)
		end 
	end
	
	self.delayApplyGravity = 0
	self:SetPos(self:GetPos() +Vector(0,0,590))
end

function ENT:CreateForceProjectile()
	local entForce = ents.Create("obj_nil_force")
	entForce:SetPos(self:GetPos())
	entForce:SetEntityOwner(self)
	entForce:SetRadius(math.Rand(300,400))
	entForce:SetHeight(math.Rand(200,400))
	entForce:SetSpeed(math.Rand(500,600))
	entForce:SetDelay(math.Rand(0,6))
	entForce:SetDirection(math.random(1,2))
	entForce:Spawn()
	
	self:DeleteOnRemove(entForce)
	table.insert(self.tblForceEnts, entForce)
	return entForce
end

function ENT:RemoveForceProjectile()
	if !IsValid(self.tblForceEnts[1]) then return end
	self.tblForceEnts[1]:Absorb()
	table.remove(self.tblForceEnts,1)
end

function ENT:OnThink()
	if self.bDead then return end
	self:UpdateLastEnemyPositions()
	if self.delayApplyGravity && CurTime() >= self.delayApplyGravity then
		local posSelf = self:GetPos()
		for k, v in pairs(player:GetAll()) do
			local posPly = v:GetPos()
			local flDist = posSelf:Distance(posPly)
			local flGravMin = (600 /GetConVarNumber("sv_gravity")) *0.04
			if flDist <= 6000 then
				v:SetGravity(flGravMin)
			else
				local iGravity = math.Clamp((math.Clamp(2000 -(flDist -6000), 0, 2000) /2000) *flGravMin +(flDist -6000) /2000, flGravMin, 1)
				v:SetGravity(iGravity)
			end
			self.delayApplyGravity = CurTime() +0.3
		end
	end
	
	if !IsValid(self.entEnemy) then
		local iState = self:GetState()
		if iState <= 2 then
			local velocity = Vector(0,0,0)
			local posSelf = self:GetPos()
			local tr = util.TraceLine({start = posSelf, endpos = posSelf -Vector(0,0,600), filter = self}) 
			if tr.HitWorld then 
				velocity = velocity +Vector(0, 0, 1)
			end
			
			local tr = util.TraceLine({start = posSelf, endpos = posSelf +Vector(0,0,600), filter = self}) 
			if tr.HitWorld then 
				velocity = velocity -Vector(0, 0, 1)
			end
			
			self:SetLocalVelocity(velocity *50)
		end
		return
	end
	
	local fDistZ = self.entEnemy:GetPos().z -self:GetPos().z
	local velocity
	if fDistZ >= -1100 then
		velocity = Vector(0,0,fDistZ +1200):GetNormal() *175
	elseif fDistZ <= -1300 then
		velocity = Vector(0,0,fDistZ -1200):GetNormal() *200
	else
		velocity = self:GetVelocity() *0.85
	end
	self:SetLocalVelocity(velocity)
end

function ENT:SummonAlly(pos,class)
	local npc = ents.Create(class)
	npc:SetPos(pos)
	npc:SetAngles(self:GetAngles())
	npc:Spawn()
	npc:Activate()
	npc:MergeMemory(self:GetMemory())
	npc.entEnemy = self.entEnemy
	npc:SetSquad(self:GetSquad())
	npc:SetOwner(self)
	
	npc:EmitSound("debris/beamstart" .. math.random(1,2) .. ".wav",100,100)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("rendermode", "5")
	sprite:SetKeyValue("model", "sprites/exit1_anim.vmt")
	sprite:SetKeyValue("scale", "1")
	sprite:SetKeyValue("spawnflags", "1")
	sprite:SetPos(pos)
	sprite:Spawn()
	sprite:Activate()
	sprite:Fire("kill","",0.3)
end

function ENT:GetPlayersInRange()
	return player.GetAll()
end


function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		if !IsValid(self.entEnemy) && !self:IsPossessed() then return true end
		local atk = select(2,...)
		local bProjectileSmall = atk == "projectilesmall"
		local bSummonAllies = atk == "summonallies"
		local bSummonStart = atk == "summonstart"
		if bProjectileSmall then
			for i = 3,4 do
				local pos = self:GetAttachment(i).Pos
				local projectile = ents.Create("obj_nil_projectile_energy")
				projectile:SetPos(pos)
				projectile:SetEntityOwner(self)
				projectile:SetHoming(false)
				projectile:Spawn()
				projectile:Activate()
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					local normal
					if !self:IsPossessed() then normal = (self.entEnemy:GetCenter() -pos +self.entEnemy:GetVelocity() *0.75):GetNormal()
					else normal = (self:GetPossessor():GetPossessionEyeTrace().HitPos -pos):GetNormal() end
					phys:ApplyForceCenter(normal *1000)
				end
			end
			return true
		elseif bSummonAllies then
			local iControllers = math.random(3,5)
			local iControllerCount = 0
			for i = 1, 8 do
				local pos = self:GetPos() +(VectorRand() *math.Rand(600, 800))
				local tracedata = {}
				tracedata.start = self:GetPos()
				tracedata.endpos = pos
				tracedata.filter = {self}
				local trace = util.TraceLine(tracedata)
				if !trace.Hit then
					self:SummonAlly(pos, "monster_controller")
					
					sound.Play("debris/beamstart" .. math.random(1,2) .. ".wav", pos)
					iControllerCount = iControllerCount +1
					if iControllers >= iControllerCount then break end
				end
			end
			local classes = {"monster_agrunt", "monster_alien_slv"}
			for i = 1, 3 do
				local pos = self:GetPos() +(VectorRand() *math.Rand(600, 800))
				local tracedata = {}
				tracedata.start = self:GetPos()
				tracedata.endpos = tracedata.start +VectorRand() *5000 -Vector(0,0,10000)
				tracedata.filter = {self}
				local trace = util.TraceLine(tracedata)
				if trace.HitWorld then
					pos = trace.HitPos +trace.HitNormal *20
					self:SummonAlly(pos, classes[math.random(1,#classes)])
					sound.Play("debris/beamstart" .. math.random(1,2) .. ".wav", pos)
				end
			end
			return true
		elseif bSummonStart then
			local entShake = ents.Create("env_shake")
			entShake:SetKeyValue("amplitude","4")
			entShake:SetKeyValue("radius","5000")
			entShake:SetKeyValue("duration","30")
			entShake:SetKeyValue("frequency","2.5")
			entShake:Spawn()
			entShake:Activate()
			entShake:Fire("StartShake","",0)
			entShake:Fire("StopShake","",5.9)
			entShake:Fire("kill","",6)
			
			self:DeleteOnRemove(entShake)
			for k,v in pairs(self:GetPlayersInRange()) do
				v:ConCommand("playgamesound npc/antlion/rumble1.wav")
				v:ConCommand("playgamesound ambient/levels/intro/rhumble_1_42_07.wav")
				v:ConCommand("playgamesound ambient/levels/labs/teleport_mechanism_windup1.wav")
				v:ConCommand("playgamesound ambient/levels/citadel/portal_open1_adpcm.wav")
			end
			return true
		end
		local pos = self:GetPos() +self:GetForward() *50
		local projectile = ents.Create("obj_nil_projectile_energy_large")
		projectile:SetPos(pos)
		projectile:SetEntityOwner(self)
		projectile:SetEnemy(self.entEnemy)
		projectile:Spawn()
		projectile:Activate()
		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			local normal
			if !self:IsPossessed() then normal = (self.entEnemy:GetCenter() -pos +self.entEnemy:GetVelocity() *0.75):GetNormal()
			else normal = (self:GetPossessor():GetPossessionEyeTrace().HitPos -pos):GetNormal() end
			phys:ApplyForceCenter(normal *1000)
		end
		return true
	elseif(event == "recharge") then
		local tblCrystals = {}
		for k, v in pairs(ents.FindByClass("obj_crystal")) do
			if self:CrystalVisible(v) then table.insert(tblCrystals,v) end
		end
		if #tblCrystals == 0 then return true end
		local countForceCrystal = math.ceil((20 -#self.tblForceEnts) /#tblCrystals)
		for k, v in pairs(tblCrystals) do
			if #self.tblForceEnts < 20 then
				local delay = 0
				for i = 1, countForceCrystal do
					timer.Simple(delay, function() if IsValid(self) && IsValid(v) && #self.tblForceEnts < 20 then
						local entForce = self:CreateForceProjectile()
						entForce:SetPos(v:GetPos() +v:GetUp() *60)
						
						self.dmgForce = 20 -#self.tblForceEnts
						self.fEnergy = (#self.tblForceEnts /20) *1500
					end end)
					delay = delay +0.15
				end
			end
		end
		self.delaySummon = nil
		self.countForceDeplete = nil
		return true
	elseif(event == "idle") then
		if !self.bForceDepleted then return end
		self:StartEngineTask(93, ACT_IDLE_ANGRY)
		self:ScheduleFinished()
		return true
	end
end

function ENT:CrystalVisible(entCrystal)
	local tr = util.TraceLine({start = self:GetHeadPos(), endpos = entCrystal:GetPos() +entCrystal:GetUp() *entCrystal:OBBCenter().z, filter = self})
	return !IsValid(tr.Entity) || tr.Entity == entCrystal
end

function ENT:CanRecharge()
	if self.bForceDepleted then return false end
	local tblCrystals = ents.FindByClass("obj_crystal")
	if #self.tblForceEnts < 14 && #tblCrystals > 0 then
		local bVisible
		for k, v in pairs(tblCrystals) do
			if self:CrystalVisible(v) then return true end
		end
	end
	return false
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT || disp == D_FR) then
		local bRecharge = self:CanRecharge()
		if bRecharge then
			self:StopMoving()
			self:PlayActivity(ACT_RELOAD, true)
			return
		end
		local bCanSee = self:CanSee(enemy)
		local bRange = dist <= self.fRangeDistance && bCanSee
		local bSummon = dist <= self.fRangeDistance && self.delaySummon && CurTime() >= self.delaySummon
		if bSummon then
			self.delaySummon = nil
			self:StopMoving()
			self:PlayActivity(ACT_MELEE_ATTACK1,true)
			if self.countForceDeplete then
				self.countForceDeplete = self.countForceDeplete +1
				if self.countForceDeplete == 5 then self:ForceDepleted() end
			end
			return
		end
		if bRange then
			if self.countForceDeplete then
				self.countForceDeplete = self.countForceDeplete +1
				if self.countForceDeplete == 5 then self:ForceDepleted() end
			end
			if !self.bForceDepleted then self:StopMoving() end
			self:PlayActivity(!self.bForceDepleted && ACT_RANGE_ATTACK1 || ACT_RANGE_ATTACK2, true)//, nil, self.bForceDepleted)
			return
		end
	end
end

function ENT:ForceDepleted()
	self.bForceDepleted = true
	self.countForceDeplete = nil
	local entCore = ents.Create("obj_nil_force_core")
	entCore:SetParent(self)
	entCore:Spawn()
	entCore:Activate()
	entCore:Fire("SetParentAttachment", "head", 0)
	self:SetIdleActivity(ACT_IDLE_ANGRY)
	
	self:DeleteOnRemove(entCore)
end

function ENT:GetDamageScale(dmginfo, dmgPos)
	local dmg = dmginfo:GetDamage()
	local dmgPos = self:WorldToLocal(dmginfo:GetDamagePosition())
	dmg = dmginfo:IsExplosionDamage() && dmg || dmg *0.5
	local dmgPos = dmgPos
	local vecHullMin = self:OBBMins()
	local vecHullMax = self:OBBMaxs()
	if !self.bForceDepleted then return dmg end
	if dmgPos.z >= vecHullMax.z -30 && dmgPos.x >= vecHullMin.x +30 && dmgPos.x <= vecHullMax.x -30 && dmgPos.y >= vecHullMin.y +30 && dmgPos.y <= vecHullMax.y -30 then
		dmg = dmg *2
	end
	return dmg
end

local schdFlinch = ai_schedule_slv.New("Hurt")
schdFlinch:EngTask("TASK_SMALL_FLINCH", 0)
function ENT:DamageHandle(dmginfo)
	if self.bForceDepleted then
		dmginfo:SetDamage(self:GetDamageScale(dmginfo))
	elseif self.dmgForce < 20 then
		self.fEnergy = self.fEnergy -self:GetDamageScale(dmginfo)
		dmginfo:SetDamage(0)
		local fEnergyMax = 1500
		local dmgForce = math.floor((fEnergyMax -self.fEnergy) /fEnergyMax *20)
		if self.fEnergy <= 0 then
			self.dmgForce = 20
			if #self.tblForceEnts > 0 then
				for i = 1, #self.tblForceEnts do
					self:RemoveForceProjectile()
				end
			end
			self.delaySummon = CurTime() +math.Rand(5,8)
			self.countForceDeplete = 0
		elseif dmgForce > self.dmgForce then
			for i = 1, dmgForce -self.dmgForce do
				self:RemoveForceProjectile()
			end
			self.dmgForce = dmgForce
			
			self.iDmgCount = self.iDmgCount +math.random(0,2)
			if self.iDmgCount >= 6 || dmginfo:IsDamageType(DMG_BLAST) then
				self.iDmgCount = 0
				if CurTime() >= self.nextFlinch && math.random(1,3) < 3 then
					self:StopMoving()
					self:StartSchedule(schdFlinch)
					self:PlaySound("Pain")
					self:OnFlinch()
				end
				self.nextFlinch = CurTime() +math.Rand(3,12)
			end
		end
	else dmginfo:SetDamage(0) end
end

function ENT:OnDeath(dmginfo)
	local entShake = ents.Create("env_shake")
	entShake:SetKeyValue("amplitude","4")
	entShake:SetKeyValue("radius","5000")
	entShake:SetKeyValue("duration","30")
	entShake:SetKeyValue("frequency","2.5")
	entShake:Spawn()
	entShake:Activate()
	entShake:Fire("StartShake","",0)
	entShake:Fire("kill","",6)
	self:DeleteOnRemove(entShake)

	local cspDeath = ents.Create("ambient_generic")
	cspDeath:SetKeyValue("message","ambience/alien_minddrill.wav")
	cspDeath:SetKeyValue("health","10")
	cspDeath:SetKeyValue("spawnflags","17")
	cspDeath:Spawn()
	cspDeath:Activate()
	cspDeath:Fire("PlaySound","",0)
	self:DeleteOnRemove(cspDeath)
	
	self:SetLocalVelocity(Vector(0,0,0))
	local function DeathGib()
		if !IsValid(self) then
			timer.Destroy("Nihilanth_DeathGibTimer" .. self:EntIndex())
			return
		end
		local entGib = ents.Create("obj_nil_death_gib")
		entGib:SetPos(self:GetPos() +Vector(0,0,375))
		entGib:Spawn()
		entGib:Activate()
		entGib:SetOwner(self)
		
		entGib:Fire("kill","",5)
		self:DeleteOnRemove(entGib)
	end
	timer.Create("Nihilanth_DeathGibTimer" .. self:EntIndex(), 0.4, 100, DeathGib)
	self:StartDeath()
end

function ENT:StartDeath()
	local function CreateSprite(size, pos)
		if !IsValid(self) then return end
		local entShake = ents.Create("env_sprite")
		entShake:SetKeyValue("spawnflags","3")
		entShake:SetKeyValue("GlowProxySize","2")
		entShake:SetKeyValue("scale","25")
		entShake:SetKeyValue("framerate","10")
		entShake:SetKeyValue("model","sprites/Fexplo1.spr")
		entShake:SetKeyValue("rendercolor","77 210 130")
		entShake:SetKeyValue("renderamt","255")
		entShake:SetKeyValue("rendermode","5")
		entShake:SetKeyValue("renderfx","14")
		entShake:SetPos(pos)
		entShake:Spawn()
		entShake:Activate()
		entShake:Fire("kill","",6)
		
		self:EmitSound( self.sSoundDir .. "beamstart8.wav", 100, 100 )
	end
	local pos = self:GetPos()
	local forward = self:GetForward()
	local right = self:GetRight()
	
	CreateSprite(15,pos +forward *800)
	local delay = 1
	for i = 0, 30 do
		local spawnpos = pos +forward *math.Rand(-650,650) +right *math.Rand(-650,650)
		timer.Simple(delay, function() CreateSprite(15,spawnpos) end)
		delay = delay +math.Rand(0.18, 0.75)
	end
	
	timer.Simple(18, function() if IsValid(self) then self:Death() end end)
	
	local function GetRandomPos(posStart)
		return util.TraceLine({start = self:GetPos(), endpos = posStart +Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)) *32768, filter = self}).HitPos
	end
	
	for iAtt = 3, 4 do
		for i = 1, 3 do
			local entBeamTarget = ents.Create("info_target")
			entBeamTarget:SetName(tostring(self) .. "_laser" .. entBeamTarget:EntIndex() .. "_target")
			entBeamTarget:SetPos(self:GetPos())
			entBeamTarget:Spawn()
			entBeamTarget:Activate()
			
			local entBeam = ents.Create("env_beam")
			entBeam:SetName(tostring(self) .. "_laser" .. entBeam:EntIndex())
			entBeam:SetKeyValue("life","0.2")
			entBeam:SetKeyValue("Radius","99999")
			entBeam:SetKeyValue("LightningEnd",tostring(self) .. "_laser" .. entBeamTarget:EntIndex() .. "_target")
			entBeam:SetKeyValue("LightningStart",tostring(self) .. "_laser" .. entBeam:EntIndex())
			entBeam:SetKeyValue("NoiseAmplitude","10")
			entBeam:SetKeyValue("renderamt","255")
			entBeam:SetKeyValue("rendercolor","0 75 255")
			entBeam:SetKeyValue("BoltWidth","10")
			entBeam:SetKeyValue("texture","sprites/laserbeam.spr")
			entBeam:SetKeyValue("spawnflags","5")
			entBeam:SetKeyValue("StrikeTime","0")
			entBeam:SetKeyValue("TextureScroll","35")
			entBeam:Spawn()
			entBeam:Activate()
			entBeam:SetPos(GetRandomPos(entBeamTarget:GetPos()))
			
			self:DeleteOnRemove(entBeamTarget)
			self:DeleteOnRemove(entBeam)
		end
	end
end

function ENT:Death()
	for k, v in pairs(self:GetPlayersInRange()) do
		local tr = util.TraceLine({start = self:GetCenter(), endpos = v:GetCenter(), filter = self})
		if !IsValid(tr.Entity) || tr.Entity == v && v:EntInViewCone(self, 75) then
			v:FadeScreen(Color(0,210,0,255), 0.5, 0.5)
		end
	end
	
	local csp = CreateSound(self,self.sSoundDir .. "beamstart6.wav")
	csp:SetSoundLevel(self.fSoundLevel)
	csp:Play()
	self:Remove()
end