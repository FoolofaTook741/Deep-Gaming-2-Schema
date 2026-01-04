AddCSLuaFile( "shared.lua" )

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_RACEX","monster_geneworm")
ENT.NPCFaction = NPC_FACTION_RACEX
ENT.iClass = CLASS_RACEX
util.AddNPCClassAlly(CLASS_RACEX,"monster_geneworm")
ENT.sModel = "models/opfor/geneworm.mdl"
ENT.fRangeDistance = 700
ENT.fViewDistance = 4000
ENT.fMeleeDistance = 460
ENT.fHearDistance = 0
ENT.possOffset = Vector(200, 0, 450)
ENT.AIType = 3

ENT.skName = "geneworm"
ENT.bIgnitable = false
ENT.bFlinchOnDamage = false
ENT.bPlayDeathSequence = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE, DMG_POISON}
ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/geneworm/"

ENT.m_tbSounds = {
	["Attack"] = "geneworm_beam_attack.wav",
	["Melee"] = "geneworm_big_attack_forward.wav",
	["Angry"] = "geneworm_shot_in_eye.wav",
	["Death"] = "geneworm_death.wav",
	["Entry"] = "geneworm_entry.wav",
	["PainA"] = "geneworm_final_pain1.wav",
	["PainB"] = "geneworm_final_pain2.wav",
	["PainC"] = "geneworm_final_pain3.wav",
	["PainD"] = "geneworm_final_pain4.wav",
	["EasterEgg"] = "i'm a scat man.mp3",
	["dsbossit"] = "dsbossit.wav",
	["Idle"] = "geneworm_idle[1-4].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetMoveType(MOVETYPE_NONE)

	self:SetHealth(GetConVarNumber("sk_geneworm_health"))
	self:SetSoundLevel(0.2)
	
	self.nextAttack = 0
	self.iEndFlinch = 0
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	local yaw = (self:GetAngles() -(entPossessor:GetPossessionEyeTrace().HitPos -self:GetPos()):Angle()).y
	yaw = math.NormalizeAngle(yaw)
	local act = ((yaw <= 20 && yaw > 0) || (yaw >= -20 && yaw < 0)) && ACT_RANGE_ATTACK2_LOW || yaw < -20 && ACT_RANGE_ATTACK1 || yaw > 20 && ACT_RANGE_ATTACK2
	self:PlayActivity(act,false,fcDone)
end

function ENT:_PossAttackThink(entPossessor, iInAttack)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	local yaw = (self:GetAngles() -(entPossessor:GetPossessionEyeTrace().HitPos -self:GetPos()):Angle()).y
	yaw = math.NormalizeAngle(yaw)
	local act = ((yaw <= 20 && yaw > 0) || (yaw >= -20 && yaw < 0)) && ACT_RANGE_ATTACK1_LOW || yaw < -20 && ACT_MELEE_ATTACK1 || yaw > 20 && ACT_MELEE_ATTACK2
	self:PlayActivity(act,false,fcDone)
end

function ENT:_PossFaceForward(entPossessor, fcDone)
	if fcDone then fcDone(true) end
end

function ENT:_PossMovement(entPossessor)
end
local cvGB = CreateConVar("sk_geneworm_chance_special","0.01",FCVAR_ARCHIVE)
function ENT:InitSandbox()
		for k, v in pairs(player:GetAll()) do
			v:SetGravity(1)
	local posStart = self:GetPos() +Vector(0,0,40)
	local posEnd = posStart -self:GetForward() *1400
	local tr = util.TraceLine({start = posStart, endpos = posEnd, filter = self})
	if tr.Hit then
		self:SetPos(tr.HitPos)
		if math.ceil(tr.HitNormal.x) -tr.HitNormal.x == 0 && math.ceil(tr.HitNormal.y) -tr.HitNormal.y == 0 && math.ceil(tr.HitNormal.z) -tr.HitNormal.z == 0 then
			self:SetAngles(tr.HitNormal:Angle())
		end
	end
end

	posStart = self:GetCenter()
	posEnd = posStart -Vector(0,0,640)
	tr = util.TraceLine({start = posStart, endpos = posEnd, mask = MASK_NPCWORLDSTATIC})
	if tr.Hit then self:SetPos(tr.HitPos +tr.HitNormal *240) end
	
	if !self:GetSquad() then self:SetSquad(self:GetClass() .. "_sbsquad") end
	local tbl = ents.FindByClass("monster_geneworm")
	if #ents.FindByClass("monster_geneworm") == 1 then 
		local sTrack
		if(math.Rand(0,1) > cvGB:GetFloat()) then sTrack = "music/HL1_song9.mp3"
		else
			self:EmitSound(self.sSoundDir .. "dsbossit.wav", 100, 100)
			sTrack = "npc/geneworm/i'm a scat man.mp3"
			for _, pl in pairs(self:GetPlayersInRange()) do
				pl:Give("weapon_displacer")
				pl:SelectWeapon("weapon_displacer")
				pl:SetAmmunition("uranium",10000)
			end
			local idx = self:EntIndex()
			local hk = "geneworm_special" .. idx
			hook.Add("PlayerSpawn",hk,function(pl)
				pl:Give("weapon_displacer")
				pl:SelectWeapon("weapon_displacer")
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
	end

function ENT:OnFlinch()
	self:SetSkin(0)
	if self:IsPossessed() then self:_PossScheduleDone() end
end

function ENT:OnScheduleSelection()
	self:StartEngineTask(93, ACT_IDLE)
end	

function ENT:OnThink()
	if self.bPoisonSpray then
		local iAtt = 1
		local att = self:GetAttachment(iAtt)
		local effect = EffectData()
		effect:SetStart(att.Pos)
		effect:SetNormal(att.Ang:Forward())
		effect:SetEntity(self)
		effect:SetAttachment(iAtt)
		util.Effect("effect_geneworm_poison",effect)
		
		local posSelf = self:GetPos()
		for k, v in pairs(ents.FindInSphere(att.Pos,self.fRangeDistance +250)) do
			if IsValid(v) && self:Visible(v) && v:VisibleVec(att.Pos) && v != self && (self:IsEnemy(v) || v:IsPhysicsEntity()) then
				local posEnemy = v:GetPos()
				local yaw = self:GetAngles().y -(posEnemy -posSelf):Angle().y
				if yaw < 0 then yaw = yaw +360 end
				if (self.attackDir == 0 && (yaw <= 20 || yaw >= 340)) || (self.attackDir == 1 && yaw <= 75) || (self.attackDir == 2 && yaw >= 285) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage(GetConVarNumber("sk_geneworm_dmg_poison"))
					dmgInfo:SetAttacker(self)
					dmgInfo:SetInflictor(self)
					dmgInfo:SetDamageType(DMG_ACID)
					dmgInfo:SetDamagePosition(v:NearestPoint(att.Pos))
					v:TakeDamageInfo(dmgInfo)
					if v:GetClass() == "npc_turret_floor" && !v.bSelfDestruct then
						v:Fire("selfdestruct", "", 0)
						v:GetPhysicsObject():ApplyForceCenter(self:GetForward() *10000) 
						v.bSelfDestruct = true
					end
				end
			end
		end
	end
	local cboundMin = self:GetRight() *450 +self:GetForward() *700 +Vector(0,0,300)
	local cboundMax = self:GetRight() *-450 -Vector(0,0,240)
	self:SetCollisionBounds(cboundMin, cboundMax)
end

function ENT:GetPlayersInRange()
	return player.GetAll()
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local subevent = select(2,...)
	local subsubevent = select(3,...)
	if(event == "mattack") then
		self:EmitSound(self.sSoundDir .. "geneworm_big_attack_forward.wav", 100, 100)
		local fDist = self.fMeleeDistance
		local iDmg = GetConVarNumber("sk_geneworm_dmg_slash")
		local angViewPunch
		if tobool(subevent == "left") then angViewPunch = Angle(4,-40,3)
		else angViewPunch = Angle(38,0,0) end
		self:DoMeleeDamage(fDist,iDmg,angViewPunch)
		return
	end
	
	if(event == "damaged") then
		self.iEndFlinch = math.Clamp(self.iEndFlinch -1, 0, 4)
		
		if (self.iEndFlinch > 0) then self:PlayActivity(self:GetActivity() != ACT_FLINCH_STOMACH && ACT_FLINCH_STOMACH || ACT_FLINCH_CHEST, false, nil, true, true)
		else self:PlayActivity(ACT_COWER, false, self._PossScheduleDone, true, true); self.bFlinching = false end
		return
	end
	
	if(event == "rattack") then
		if(subevent == "portal") then
			if IsValid(self.entSpritePortal) then self.entSpritePortal:Remove() end
			local entPortal = ents.Create("obj_geneworm_portal")
			entPortal:SetEntityOwner(self)
			entPortal:SetPos(self:GetAttachment(2).Pos)
			entPortal:SetAngles(self:GetAngles())
			entPortal:NoCollide(self)
			entPortal:Spawn()
			entPortal:Activate()
			entPortal:EmitSound("debris/beamstart7.wav", 100, 100)
			
			local phys = entPortal:GetPhysicsObject()
			if IsValid(phys) then
				phys:ApplyForceCenter(self:GetForward() *500)
			end
		elseif (subevent == "poison_start") then
			self.bPoisonSpray = true
		elseif (subevent =="poison_end") then
			self.bPoisonSpray = false
		end
		return
	end
end

function ENT:OnBlinded()
	self.bFlinching = true
	self.bPoisonSpray = false
	
	local fcDone
	if self:IsPossessed() then
		local entPossMan = self:GetPossessor():GetPossessionManager()
		entPossMan.bInSchedule = true
		fcDone = function()
			if IsValid(entPossMan) then
				entPossMan.bInSchedule = false
			end
		end
	end
	self:PlayActivity(ACT_BIG_FLINCH, false)
	self.iEndFlinch = math.random(2,4)
	local entSpritePortal = ents.Create("env_sprite")
	entSpritePortal:SetKeyValue("model", "sprites/boss_glow.vmt")
	entSpritePortal:SetKeyValue("rendermode", "5") 
	entSpritePortal:SetKeyValue("rendercolor", "255 255 255") 
	entSpritePortal:SetKeyValue("scale", "1.2") 
	entSpritePortal:SetKeyValue("spawnflags", "1") 
	entSpritePortal:SetParent(self)
	entSpritePortal:Fire("SetParentAttachment", "portal", 0)
	entSpritePortal:Spawn()
	entSpritePortal:Activate()
	self.entSpritePortal = entSpritePortal
	self:DeleteOnDeath(entSpritePortal)
end

function ENT:DamageHandle(dmginfo)
	local iSkin = self:GetSkin()
	if iSkin == 3 && self.bFlinching then
		if dmginfo:IsExplosionDamage() && dmginfo:GetDamagePosition():Distance(self:GetAttachment(2).Pos) <= 300 then
			if self:Health() -250 > 0 then
				self:PlayActivity(ACT_COWER, false, nil, true)
				self.bFlinching = false
			end
			dmginfo:SetDamage(250)
		else dmginfo:SetDamage(0) end
		return
	else dmginfo:SetDamage(0) end
	if self.lastHitGroupDamage == 4 && iSkin != 1 then
		iSkin = iSkin == 0 && 1 || 3
		self:SetSkin(iSkin)
		if iSkin != 3 then
			local fcDone
			if self:IsPossessed() then
				local entPossMan = self:GetPossessor():GetPossessionManager()
				entPossMan.bInSchedule = true
				fcDone = function()
					if IsValid(entPossMan) then
						entPossMan.bInSchedule = false
					end
				end
			end
			self:PlayActivity(ACT_FLINCH_LEFTARM, false, fcDone)
			self.bPoisonSpray = false
		else self:OnBlinded() end
	elseif self.lastHitGroupDamage == 5 && iSkin != 2 then
		iSkin = iSkin == 0 && 2 || 3
		self:SetSkin(iSkin)
		if iSkin != 3 then
			local fcDone
			if self:IsPossessed() then
				local entPossMan = self:GetPossessor():GetPossessionManager()
				entPossMan.bInSchedule = true
				fcDone = function()
					if IsValid(entPossMan) then
						entPossMan.bInSchedule = false
					end
				end
			end
			self:PlayActivity(ACT_FLINCH_RIGHTARM, false, fcDone)
			self.bPoisonSpray = false
		else self:OnBlinded() end
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)--(fDist,fDistPredicted,iDisposition)
	if disp == 1 || disp == 2 then
		if self:CanSee(self.entEnemy) && CurTime() >= self.nextAttack && !self.bFlinching then
			local bMelee = dist <= self.fMeleeDistance -200
			if bMelee then
				local act
				local yaw = self:GetAngleToPos(self.entEnemy:GetPos()).y
				local act = (yaw <= 20 || yaw >= 340) && ACT_RANGE_ATTACK1_LOW || yaw <= 75 && ACT_MELEE_ATTACK2 || yaw >= 285 && ACT_MELEE_ATTACK1
				if act then
					self:PlayActivity(act, false)
					return
				end
			end
			local bRange = dist <= self.fRangeDistance
			if bRange then
				local act
				local yaw = self:GetAngleToPos(self.entEnemy:GetPos()).y
				if yaw <= 20 || yaw >= 340 then act = ACT_RANGE_ATTACK2_LOW; self.attackDir = 0
				elseif yaw <= 75 then act = ACT_RANGE_ATTACK2; self.attackDir = 1
				elseif yaw >= 285 then act = ACT_RANGE_ATTACK1; self.attackDir = 2 end
				if act then
					self:PlayActivity(act, false)
					return
				end
			end
		end
	end
end
