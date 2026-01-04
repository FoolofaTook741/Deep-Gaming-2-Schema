AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_MILITARY","monster_hecu_marine")
ENT.NPCFaction = NPC_FACTION_MILITARY
ENT.iClass = CLASS_MILITARY
util.AddNPCClassAlly(CLASS_MILITARY,"monster_hecu_marine")
ENT.sModel = "models/half-life/hgrunt.mdl"
ENT.fRangeDistance = 600
ENT.fRangeGrenadeDistance = 880
ENT.fMeleeDistance = 40
ENT.bPlayDeathSequence = true

ENT.skName = "hgrunt"
ENT.CollisionBounds = Vector(13,13,72)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = ""

ENT.m_tbSounds = {
	["Death"] = { "npc/fgrunt/death[1-6].wav", "hgrunt/gr_die[1-3].wav" },
	["Pain"] = { "npc/fgrunt/gr_pain[1-6]", "hgrunt/gr_pain[1-5].wav" },
	["Step"] = "npc/fgrunt/gr_step[1-4].wav",
	["Reload"] = "npc/fgrunt/gr_reload1.wav"
}

ENT.tblDeathActivities = {
	[HITGROUP_GENERIC] = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE},
	[HITGROUP_HEAD] = ACT_DIE_HEADSHOT,
	[HITGROUP_CHEST] = ACT_DIE_GUTSHOT,
	[HITGROUP_STOMACH] = ACT_DIE_GUTSHOT
}
ENT.tblFlinchActivities = {
	[HITGROUP_GENERIC] = ACT_SMALL_FLINCH,
	[HITGROUP_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITGROUP_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITGROUP_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITGROUP_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

local weapons = {
	[0] = {
		iAmmo = 25,
		flRange = 1400,
		flSpread = 0.065,
		dmg = "sk_npc_dmg_9mm",
		iForce = 6,
		iNum = 1,
		att = "muzzle_m4",
		class = "weapon_9mmar",
		soundPrimary = "npc/fgrunt/gr_mgun",
		soundPrimaryCount = 2,
		act = {
			shootCrouching = ACT_SIGNAL_ADVANCE,
			shootStanding = ACT_SIGNAL_ADVANCE,
			reload = ACT_RELOAD
		},
		posLocal = {
			crouching = Vector(42.7640, -6.3547, 40.1813),
			standing = Vector(44.6826, -7.5536, 57.0240)
		}
	},
	[1] = {
		iAmmo = 8,
		flRange = 600,
		flSpread = 0.1,
		dmg = "sk_npc_dmg_buckshot",
		iForce = 8,
		iNum = 5,
		att = "muzzle_shotgun",
		class = "weapon_shotgun_hl",
		soundPrimary = "weapons/sbarrel",
		soundPrimaryCount = 1,
		act = {
			shootCrouching = ACT_SIGNAL_FORWARD,
			shootStanding = ACT_SIGNAL_FORWARD,
			reload = ACT_RELOAD_LOW
		},
		posLocal = {
			crouching = Vector(42.3023, -6.2921, 39.5157),
			standing = Vector(44.1746, -7.4633, 56.3967)
		}
	},
	[2] = {
		iAmmo = 50,
		flRange = 800,
		flSpread = 0.09,
		dmg = "sk_npc_dmg_45mm",
		iForce = 6,
		iNum = 1,
		att = "muzzle_saw",
		class = "weapon_m249",
		soundPrimary = "weapons/m249/saw_fire",
		soundPrimaryCount = 3,
		act = {
			shootCrouching = ACT_SIGNAL_LEFT,
			shootStanding = ACT_SIGNAL_LEFT,
			reload = ACT_SIGNAL_HALT
		},
		posLocal = {
			crouching = Vector(37.8727, -1.4724, 45.0497),
			standing = Vector(40.7865, -1.4842, 62.4636)
		}
	},
	[3] = {
		iAmmo = 7,
		flRange = 900,
		flSpread = 0.03,
		dmg = "sk_npc_dmg_357",
		iForce = 10,
		iNum = 1,
		att = "muzzle_pistol_deagle",
		class = "weapon_eagle",
		soundPrimary = "weapons/deagle/desert_eagle_fire.wav",
		soundPrimaryCount = 0,
		act = {
			shootCrouching = ACT_SIGNAL_GROUP,
			shootStanding = ACT_SIGNAL_GROUP,
			reload = ACT_LOOKBACK_LEFT
		},
		posLocal = {
			crouching = Vector(24.2316, -1.3571, 45.3440),
			standing = Vector(27.1740, -1.3647, 61.6310)
		}
	},
	[4] = {
		iAmmo = 18,
		flRange = 850,
		flSpread = 0.05,
		dmg = "sk_npc_dmg_9mm",
		iForce = 5,
		iNum = 1,
		att = "muzzle_pistol_9mm",
		class = "weapon_9mmhandgun",
		soundPrimary = "weapons/pl_gun3.wav",
		soundPrimaryCount = 0,
		act = {
			shootCrouching = ACT_SIGNAL_GROUP,
			shootStanding = ACT_SIGNAL_GROUP,
			reload = ACT_LOOKBACK_LEFT
		},
		posLocal = {
			crouching = Vector(23.2572, -1.7609, 45.7475),
			standing = Vector(26.1679, -1.7684, 61.9481)
		}
	}
}

AccessorFunc(ENT,"iAmmoMax","MaxAmmo",FORCE_NUMBER)
AccessorFunc(ENT,"iAmmo","Ammo",FORCE_NUMBER)
AccessorFunc(ENT,"flSpread","Spread",FORCE_NUMBER)
function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP,CAP_OPEN_DOORS))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	local iBodygroup = math.random(0,3)
	self:SetBodygroup(1,iBodygroup)
	if iBodygroup == 3 || (iBodygroup != 1 && math.random(1,2) == 1) then
		self:SetSkin(1)
	end
	if !self.iWeapon then self:SetWeapon(math.random(0,4)) end
	
	self.nextIdle = 0
	self.nextCombatSpeak = 0
	self.nextGrenade = 0
end

function ENT:KeyValueHandle(key, value)
	if key == "additionalequipment" then
		for k, v in pairs(weapons) do
			if value == v.class then self:SetWeapon(k); break end
		end
		return
	end
end

function ENT:DamageHandle(dmginfo)
	if self.waitEnd then self:TaskComplete(); self.waitEnd = nil end
	if self:GetSequence() == self:LookupSequence("cower") then
		dmginfo:ScaleDamage(0.5)
	end
end

ENT.Limbs = {
	[HITGROUP_RIGHTARM] = "Right Arm",
	[HITGROUP_LEFTLEG] = "Left Leg",
	[HITGROUP_HEAD] = "Head",
	[HITGROUP_RIGHTLEG] = "Right Leg",
	[HITGROUP_LEFTARM] = "Left Arm",
	[HITGROUP_STOMACH] = HITGROUP_CHEST,
	[HITGROUP_CHEST] = "Torso"
}
function ENT:OnLimbCrippled(hitbox, attacker)
	if hitbox == HITGROUP_LEFTLEG || hitbox == HITGROUP_RIGHTLEG then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
		self.bHurtCritical = true
	end
end

function ENT:OnFoundEnemy()
	self.nextGrenade = CurTime() +math.Rand(8,20)
	self:SelectSchedule()
	if !IsValid(self.entEnemy) then return end
	if self.entEnemy:IsPlayer() then
		self:SpeakSentence("!HG_ALERT" .. math.random(0,6))
	elseif self.entEnemy:IsNPC() && self.entEnemy:IsMonster() then
		self:SpeakSentence("!HG_MONST" .. math.random(0,3))
	end
	local class = self:GetClass()
	for k, v in pairs(self:GetSquadMembers()) do
		if IsValid(v) then
			if v:GetClass() == class then
				v.nextGrenade = CurTime() +math.Rand(6,18)
				end
			end
		end
	end

function ENT:OnDanger(vecPos, iType)
	if self:IsPossessed() then return end
	if iType == 0 then self:SpeakSentence("!HG_GREN" .. math.random(0,6)) end
	self.bInSchedule = false
	if self:IsPossessed() then self:_PossScheduleDone() end
	
	local posSelf = self:GetPos()
	self:SetLastPosition(posSelf +(posSelf -vecPos):GetNormal() *200)
	
	local schdCower = ai_schedule_slv.New("Take Cower") 
	schdCower:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0) 
	schdCower:EngTask("TASK_WAIT",1)
	schdCower:EngTask("TASK_STOP_MOVING",0)
	schdCower:EngTask("TASK_PLAY_SEQUENCE", ACT_COWER)
	self:StartSchedule(schdCower)
	
	if IsValid(self.entGren) then self.entGren:Remove() end
	return true
end

function ENT:AddAmmo(iAm)
	self:SetAmmo(math.Clamp(self:GetAmmo() +iAm, 0, self:GetMaxAmmo()))
end

function ENT:SetWeapon(iWep)
	self.iWeapon = iWep
	self:SetBodygroup(2,iWep)
	if iWep >= 3 then if !self.bHurtCritical then self:SetWalkActivity(ACT_WALK_AIM_RELAXED); self:SetRunActivity(ACT_RUN_RELAXED) end; self:SetIdleActivity(ACT_IDLE_RELAXED)
	else if !self.bHurtCritical then self:SetWalkActivity(ACT_WALK); self:SetRunActivity(ACT_RUN) end; self:SetIdleActivity(ACT_IDLE) end
	local iAmmo = weapons[iWep].iAmmo
	self:SetAmmo(iAmmo)
	self:SetMaxAmmo(iAmmo)
	self:SetSpread(weapons[iWep].flSpread)
	self.fRangeDistance = weapons[iWep].flRange
end

function ENT:GetMuzzlePos()
	return self:GetAttachment(self:LookupAttachment(weapons[self.iWeapon].att))
end

function ENT:AnswerChatter(bAnswerCheck)
	local sSentence = "!HG_ANSWER" .. math.random(0,6)
	self:SpeakSentence(sSentence)
end

function ENT:OnThink()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) then return end
	if IsValid(self.entEnemy) || self:IsPossessed() then
		self:UpdateLastEnemyPositions()
		if self.bInSchedule then
			local ang
			if !self:IsPossessed() then
				self:FaceEnemy()
				local data = weapons[self.iWeapon]
				local up = self:GetActivity() == data.act.shootStanding && data.posLocal.standing.z || data.posLocal.crouching.z
				local pos = self:GetPos() +self:GetForward() *33.5 +self:GetRight() *-14 +self:GetUp() *up
				ang = (pos -self.entEnemy:GetHeadPos()):Angle().p
			else
				ang = (self:GetMuzzlePos().Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
			end
			if ang >= 90 then ang = ang -360 end
			ang = math.Clamp(ang,-45,45)
			self:SetPoseParameter("XR", ang)
		end
	end
	if !self.bInSchedule then
		if self.nextAnswer && CurTime() >= self.nextAnswer then
			self.nextAnswer = nil
			local tblEnts = {}
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
				if IsValid(v) then
					if v:GetClass() == "monster_hecu_marine" && v != self && !v.delayHide then
						table.insert(tblEnts,v)
					end
				end
			end
			if #tblEnts > 0 then
				local ent = tblEnts[math.random(1,#tblEnts)]
				ent:AnswerChatter()
			end
		end
		if CurTime() >= self.nextIdle then
			if math.random(1,12) == 1 then
				local sSentence
				local length
				local speechChance = math.random(1,12)
				if math.random(1,2) == 1 then
					sSentence = "!HG_QUEST" .. math.random(0,11)
					length = self:GetSentenceLength(sSentence)
					self.nextAnswer = CurTime() +length +math.Rand(0.4,1.8)
					self.nextIdle = self.nextAnswer +math.Rand(10,23)
				else
					if speechChance <= 4 then
						sSentence = "!HG_IDLE" .. math.random(0,2)
					elseif speechChance <= 8 then
						sSentence = "!HG_CHECK" .. math.random(0,7)
					else 
						sSentence = "!HG_CLEAR" .. math.random(0,12)
					end
					length = self:GetSentenceLength(sSentence)
					self.nextIdle = CurTime() +length +math.Rand(0.4,1.8)
				end
				self:SpeakSentence(sSentence)
			else
				self.nextIdle = CurTime() +math.Rand(8,12)
			end
		end
		return
	end
end

function ENT:OnDeath(dmginfo)
	self:DropWeapon()
end

function ENT:DropWeapon()
	local pos = self:GetAttachment(self:LookupAttachment("r_hand")).Pos
	local wep = ents.Create(weapons[self.iWeapon].class)
	wep:SetPos(pos)
	wep:SetAngles(self:GetAngles())
	wep:Spawn()
	wep:Activate()
	
	self:SetBodygroup(2,5)
end

function ENT:PlayPrimary(i)
	if self:GetAmmo() == 0 then self:Reload(); return end
	local data = weapons[self.iWeapon]
	local act = i == 0 && data.act.shootCrouching || data.act.shootStanding
	self:PlayActivity(act, !self:IsPossessed())
end

function ENT:PrimaryAttack()
	local attPosAng = self:GetMuzzlePos()
	
	local dir = self:GetAngles()
	dir.p = -self:GetPoseParameter("XR")
	dir = dir:Forward()
	local effectdata = EffectData()
	effectdata:SetStart(attPosAng.Pos)
	effectdata:SetOrigin(attPosAng.Pos)
	effectdata:SetScale(1)
	effectdata:SetAngles(attPosAng.Ang)
	util.Effect("MuzzleEffect", effectdata)
	
	local data = weapons[self.iWeapon]
	local iNum = data.iNum
	local iForce = data.iForce
	local iDmg = GetConVarNumber(data.dmg)
	local flSpread = self:GetSpread()
	local tblBullet = {}
	tblBullet.Num = iNum
	tblBullet.Src = attPosAng.Pos
	tblBullet.Attacker = self
	tblBullet.Dir = dir
	tblBullet.Spread = Vector(flSpread,flSpread,flSpread)
	tblBullet.Tracer = 1
	tblBullet.Force = iForce
	tblBullet.Damage = iDmg
	tblBullet.Callback = function(entAttacker, tblTr, dmg)
		local entVictim = tblTr.Entity
		local iDmg = dmg:GetDamage()
		if tblTr.HitGroup == 1 then
			iDmg = iDmg *10
		elseif tblTr.HitGroup != 0 then
			iDmg = iDmg *0.25
		end
	end
	self:FireBullets(tblBullet)
	self:AddAmmo(-1)
end

function ENT:Reload()
	self:PlayActivity(weapons[self.iWeapon].act.reload, !self:IsPossessed())
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayPrimary(entPossessor:KeyDown(IN_DUCK) && 0 || 1)
	self.bInSchedule = true
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:SpeakSentence("!HG_THROW" .. math.random(0,3))
	local act = self.iWeapon == 0 && math.random(1,3) > 1 && ACT_ARM || ACT_RANGE_ATTACK2
	self:PlayActivity(act,false,fcDone)
	self.bInSchedule = true
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:Flinch()
end

function ENT:TaskStart_TASK_CHECK_FAIL(data)
	self:TaskComplete()
	if !self:HasCondition(35) then return end
	self:TaskComplete()
	self:TaskComplete()
	self:SelectSchedule()
end

function ENT:Task_TASK_CHECK_FAIL(data)
end

function ENT:TaskStart_TASK_WAIT(data)
	self.waitEnd = CurTime() +data
end

function ENT:Task_TASK_WAIT(data)
	if CurTime() < self.waitEnd && IsValid(self.entEnemy) && !self:Visible(self.entEnemy) then return end
	self.waitEnd = nil
	self:TaskComplete()
end

function ENT:Interrupt()
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
	if IsValid(self.entGren) then self.entGren:Remove() end
end

function ENT:Flinch(hitgroup)
end

function ENT:OnFlinch(entAttacker)
	self:Interrupt()
	self:SpeakSentence("!HG_COVER" .. math.random(0,7))
	
	local act = entAttacker:IsPlayer() && (self.tblFlinchActivities[self.lastHitGroupDamage] || self.tblFlinchActivities[HITGROUP_GENERIC] || self.tblFlinchActivities[HITBOX_GENERIC])
	local schdHide = ai_schedule_slv.New("Hide")
	if act then schdHide:EngTask("TASK_PLAY_SEQUENCE", act) end
	schdHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
	schdHide:AddTask("TASK_CHECK_FAIL")
	schdHide:EngTask("TASK_WAIT_FOR_MOVEMENT")
	schdHide:AddTask("TASK_WAIT", math.Rand(4,5))
	self:StartSchedule(schdHide)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		local atk = select(2,...)
		if(atk == "shoot") then
			self:UpdateEnemies()
			local fDist = IsValid(self.entEnemy) && self:OBBDistance(self.entEnemy)
			local bPossessed = self:IsPossessed()
			if (bPossessed && self.entPossessor:KeyDown(IN_ATTACK)) || (!bPossessed && IsValid(self.entEnemy) && fDist <= self.fRangeDistance && fDist > self.fMeleeDistance && self.entEnemy:Health() > 0 && self:Visible(self.entEnemy) && (CurTime() < self.nextGrenade || fDist > self.fRangeGrenadeDistance || fDist < 280 || !self:CanThrowGrenade())) then
				local iShoot = bPossessed && (self:GetPossessor():KeyDown(IN_DUCK) && 0 || 1) || self:CanShoot()
				if iShoot != -1 then self:PlayPrimary(iShoot)
				else
					self.bInSchedule = false
					if bPossessed then self:_PossScheduleDone() end
					local schdAct = ai_schedule_slv.New("Activity Schedule")
					schdAct:EngTask("TASK_SET_ACTIVITY", ACT_IDLE)
					self:StartSchedule(schdAct)
				end
			else
				self.bInSchedule = false
				if bPossessed then self:_PossScheduleDone() end
				local schdAct = ai_schedule_slv.New("Activity Schedule")
				schdAct:EngTask("TASK_SET_ACTIVITY", ACT_IDLE)
				self:StartSchedule(schdAct)
			end
			return true
		elseif(atk == "burstfire") then
			self:PrimaryAttack()
			return true
		elseif(string.Left(atk,7) == "grenade") then
			if(string.Right(atk,4) == "take") then
				local entGren = ents.Create("obj_handgrenade")
				entGren:SetParent(self)
				entGren:SetPos(self:GetAttachment(self:LookupAttachment("l_hand")).Pos)
				entGren:SetExplodeDelay(4)
				entGren:Spawn()
				entGren:Activate()
				entGren:Fire("SetParentAttachment", "l_hand", 0)
				self.entGren = entGren
				self:DeleteOnDeath(entGren)
			elseif(string.Right(atk,8) == "launcher") then
				self:EmitSound("weapons/m4/glauncher" .. (math.random(1,2) == 1 && "2" || "") .. ".wav", 75, 100)
				local pos = self:GetAttachment(self:LookupAttachment("muzzle_m4")).Pos
				local ang = self:GetAngles()
				local entGren = ents.Create("obj_grenade")
				entGren:SetPos(pos)
				entGren:SetAngles(ang)
				entGren:SetEntityOwner(self)
				entGren:Spawn()
				entGren:Activate()
				local phys = entGren:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceCenter(ang:Forward() *550 +ang:Up() *70)
					phys:AddAngleVelocity(Vector(0,600,0))
				end
			else
				if IsValid(self.entGren) then
					local entGren = self.entGren
					if !IsValid(entGren) then return true end
					if (!self.posEnemyLast && !IsValid(self.entEnemy) && !self:IsPossessed()) then entGren:Remove(); return true end
					self:DontDeleteOnDeath(entGren)
					entGren:SetParent()
					entGren:PhysicsInit(SOLID_VPHYSICS)
					entGren:SetMoveType(MOVETYPE_VPHYSICS)
					entGren:PhysicsInitSphere(5)
					local phys = entGren:GetPhysicsObject()
					if IsValid(phys) then
						phys:Wake()
						phys:SetMass(1)
						phys:EnableDrag(false)
						phys:SetBuoyancyRatio(0)
						local posEnemy
						if !self:IsPossessed() then posEnemy = self.posEnemyLast || self.entEnemy:GetPos()
						else posEnemy = self:GetPossessor():GetPossessionEyeTrace().HitPos end
						local pos = entGren:GetPos()
						local normal = self:GetConstrictedDirection(pos, 45, 45, posEnemy)
						if pos:Distance(posEnemy) > self.fRangeDistance then posEnemy = pos +normal *self.fRangeDistance end
						normal = normal *500 +Vector(0,0,400 *((posEnemy -pos):Length() /1000))
						phys:ApplyForceCenter(normal)
					end
					self.entGren = nil
				end
			end
		end
		return true
	elseif(event == "burstsound") then
		local sSound = weapons[self.iWeapon].soundPrimary
		local iCount = weapons[self.iWeapon].soundPrimaryCount
		sSound = iCount == 0 && sSound || sSound .. math.random(1,iCount) .. ".wav"
		self:EmitSound(sSound, 100, 100)
		return true
	elseif(event == "reload") then
		self:SetAmmo(self:GetMaxAmmo())
		return true
	elseif(event == "mattack") then
		local iDmg = GetConVarNumber("sk_hgrunt_dmg_kick")
		local angViewPunch = Angle(-20,0,0)
		self:DealMeleeDamage(self.fMeleeDistance,iDmg,angViewPunch)
		return true
	end
end

function ENT:CanShoot()
	return (self:CanShootCrouching() && 0) || (self:CanShootStanding() && 1) || -1
end

function ENT:CanShootCrouching()
	local posStart = self:LocalToWorld(weapons[self.iWeapon].posLocal.crouching)
	local posEnd = self.entEnemy:GetHeadPos()
	local tr = util.TraceLine({start = posStart, endpos = posEnd, filter = self})
	return !tr.Entity:IsValid() || tr.Entity == self.entEnemy
end

function ENT:CanShootStanding()
	local posStart = self:LocalToWorld(weapons[self.iWeapon].posLocal.standing)
	local posEnd = self.entEnemy:GetHeadPos()
	local tr = util.TraceLine({start = posStart, endpos = posEnd, filter = self})
	return !tr.Entity:IsValid() || tr.Entity == self.entEnemy
end

function ENT:CanThrowGrenade()
	local posEnd = self.posEnemyLast || self.entEnemy:GetPos()
	for k, v in pairs(ents.FindInSphere(posEnd, 320)) do
		local iDisp = self:Disposition(v)
		if IsValid(v) && v:IsNPC() && (iDisp == 3 || iDisp == 4) then
			return false
		end
	end
	local posStart = self:LocalToWorld(Vector(33.9325, 5.9964, 63.0871))
	local tr = util.TraceLine({start = posStart, endpos = posEnd, filter = self})
	return !tr.Hit || (tr.Entity:IsValid() && tr.Entity == self.entEnemy)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(self.entEnemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				return
			end
			local bGrenade = CurTime() >= self.nextGrenade && dist <= self.fRangeGrenadeDistance && dist >= 280 && self:CanThrowGrenade()
			if bGrenade then
				self.nextGrenade = CurTime() +math.Rand(12,20)
				if math.random(1,3) > 1 then
					self:SpeakSentence("!HG_THROW" .. math.random(0,3))
					local act = self.iWeapon == 0 && math.random(1,3) > 1 && ACT_ARM || ACT_RANGE_ATTACK2
					self:PlayActivity(act, true)
					return
				end
			end
			if dist <= self.fRangeDistance then
				local iShoot = self:CanShoot()
				if iShoot != -1 then
					self:PlayPrimary(iShoot)
					self.bInSchedule = true
					return
				end
			end
		elseif CurTime() >= self.nextGrenade -2 && self.posEnemyLast && self:VisibleVec(self.posEnemyLast) then
			local fDistLastPos = self:GetPos():Distance(self.posEnemyLast)
			if fDistLastPos <= self.fRangeGrenadeDistance && fDistLastPos >= 280 then
				self.nextGrenade = CurTime() +math.Rand(12,20)
				if self:CanThrowGrenade() then
					self:SpeakSentence("!HG_THROW" .. math.random(0,3))
					self:PlayActivity(ACT_RANGE_ATTACK2, self.posEnemyLast)
					return
				end
			end
		end
		self:ChaseEnemy()
			if CurTime() >= self.nextCombatSpeak then
		self.nextCombatSpeak = CurTime() +math.Rand(3,5)
	if (math.random(1,10) > 5) then
		self:SpeakSentence("!HG_CHARGE" .. math.random(0,3))
	else
		self:SpeakSentence("!HG_TAUNT" .. math.random(0,5))
	end
end
	elseif(disp == D_FR) then
		self:Hide()
	end
end

concommand.Add("__grunt",function(pl,cmd,args)
	if(!args[1] || tonumber(args[1]) == 0) then
		hook.Remove("Think","heyheheheh")
		return
	end
	local t = 0
	hook.Add("Think","heyheheheh",function()
		if(CurTime() >= t) then
			local tbEnts = ents.FindByClass("monster_hecu_marine")
			local ent = table.Random(tbEnts)
			if(IsValid(ent)) then
				 t = CurTime() +math.Rand(0.1,0.5)
				 ent:SpeakSentence("!HG_DRAG6A")
			end
		end
	end)
end)