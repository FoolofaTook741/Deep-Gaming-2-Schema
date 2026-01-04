AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_PLAYER","monster_otis")
ENT.NPCFaction = NPC_FACTION_PLAYER
ENT.iClass = CLASS_PLAYER_ALLY
util.AddNPCClassAlly(CLASS_PLAYER_ALLY,"monster_otis")
ENT.sModel = "models/opfor/otis.mdl"
ENT.bGuard = true
ENT.skHealth = "sk_otis_health"
ENT.Weapon = "weapon_eagle"
ENT.sSoundDir = "npc/otis/"
ENT.fRangeDistance = 800
ENT.fFollowAttackDistance = 800
ENT.fFollowDistance = 175
ENT.iAmmo = 7

ENT.skName = "otis"

ENT.m_tbSounds = {
	["Foot"] = "ot_step[1-4].wav",
	["Reload"] = "desert_eagle_reload.wav",
	["Pain"] = "ot_pain[1-3].wav",
	["Death"] = "ot_die[1-3].wav"
}

ENT.sentences = {
	["FoundEnemy"] = "!OT_ATTACK[0-3]",
	["Follow"] = "!OT_OK[0-6]",
	["Wait"] = "!OT_WAIT[0-6]",
	["Idle"] = "!OT_IDLE[0-6]",
	["Hear"] = "!OT_HEAR[0-1]",
	["Smell"] = "!OT_SMELL[0-2]",
	["Question"] = "!OT_QUESTION[0-6]",
	["AnswerChatter"] = "!OT_ANSWER[0-20]",
	["AnswerAllyShot"] = "!OT_SCARED[0-1]",
	["PlayerHealthLow"] = {"!OT_CUREA", "!OT_CUREB", "!OT_CUREC"},
	["Hello"] = "!OT_HELLO[0-3]",
	["Mortal"] = "!OT_MORTAL[0-1]",
	["Wound"] = "!OT_WOUND[0-1]",
	["Shot"] = "!OT_SHOT[0-5]",
	["Mad"] = "!OT_MAD[0-3]"
}

function ENT:_Init()
	self:SetBodygroup(2,math.random(0,1))
end

function ENT:OnDeath(dmginfo)
	if self:GetBodygroup(1) == 1 && math.random(1,3) != 3 then
		self:DropWeapon(dmginfo:GetDamageForce())
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	print("EVENT: ",event)
	if(event == "rattack") then
		local atk = select(2,...)
		self:UpdateEnemies()
		local bEnemyValid = IsValid(self.entEnemy) && self.entEnemy:Health() > 0 && self:CanSee(self.entEnemy) && !self:GunTraceBlocked() && self:OBBDistance(self.entEnemy) <= self.fRangeDistance
		local bShootgun = atk == "shootgun"
		if !bShootgun && self.iAmmo <= 0 then
			if atk == "reloadend" then
				self.iAmmo = 7
				if bEnemyValid || self.bPossessed then
					self:PlayActivity(ACT_RANGE_ATTACK1, !self.bPossessed)
					return true
				end
			else
				self:PlayActivity(ACT_RELOAD, false)
				return true
			end
		end
		if (!bEnemyValid && !self.bPossessed) || (self.bPossessed && !self.entPossessor:KeyDown(IN_ATTACK)) then
			if self.bPossessed then
				self:PlayActivity(ACT_DISARM, false, self._PossScheduleDone)
				return true
			end
			self:PlayActivity(ACT_DISARM, false)
			self.bInSchedule = false;
			return true;
		end
		if bShootgun then
			self:PlayActivity(ACT_RANGE_ATTACK1, !self.bPossessed)
			return true
		end
		local attPosAng = self:GetAttachment(1)
		attPosAng.Pos = attPosAng.Pos -Vector(0,0,5)

		local dir = self:GetAngles()
		dir.p = -self:GetPoseParameter("XR")
		dir = dir:Forward()
		self:EmitSound(self.sSoundDir .. "desert_eagle_fire.wav", 100, 100 )
		local effectdata = EffectData()
		effectdata:SetStart(attPosAng.Pos)
		effectdata:SetOrigin(attPosAng.Pos)
		effectdata:SetScale(1)
		effectdata:SetAngles(attPosAng.Ang)
		util.Effect("MuzzleEffect", effectdata)
		
		local tblBullet = {}
		tblBullet.Num = 1
		tblBullet.Src = attPosAng.Pos
		tblBullet.Attacker = self
		tblBullet.Dir = dir
		tblBullet.Spread = Vector(0.03,0.03,0)
		tblBullet.Tracer = 1
		tblBullet.Force = 4
		tblBullet.Damage = GetConVarNumber("sk_npc_dmg_357")
		tblBullet.Callback = function(entAttacker, tblTr, dmg)
			local entVictim = tblTr.Entity
			local iDmg = dmg:GetDamage()
			if tblTr.HitGroup == 1 then
				iDmg = iDmg *10
			elseif tblTr.HitGroup != 0 then
				iDmg = iDmg *0.25
			end
			if entVictim:IsNPC() && entVictim:Health() -iDmg <= 0 && CurTime() >= self.nextSpeakKill then
				self.nextSpeakKill = CurTime() +math.Rand(8,20)
				if math.random(1,2) == 1 then
					self:SpeakSentence("!OT_KILL" .. math.random(0,6))
				end
			end
		end
		self:FireBullets(tblBullet)
		self.iAmmo = self.iAmmo -1
		return true
	end
	if(event == "bodygroup") then
		local bgroup = string.Explode(" ",select(2,...))
		local subgroup = bgroup[2]
		bgroup = bgroup[1]
		if(bgroup && subgroup) then
			bgroup = tonumber(bgroup)
			subgroup = tonumber(subgroup)
			if(bgroup && subgroup) then
				self:SetBodygroup(bgroup,subgroup)
			end
		end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		local bRange = dist <= self.fRangeDistance && self:CanSee(enemy) && !self:GunTraceBlocked()
		if bRange then
			self:PlayActivity(ACT_ARM, true)
			self.bInSchedule = true
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end