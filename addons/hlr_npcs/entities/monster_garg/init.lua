AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_garg")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
util.AddNPCClassAlly(CLASS_XENIAN,"monster_garg")
ENT.sModel = "models/gargantua.mdl"
ENT.fRangeDistance = 350
ENT.fRangeDistanceStomp = 1250
ENT.fRangeDistanceThrow = 2600
ENT.fMeleeDistance	= 115
ENT.m_fMaxYawSpeed = 8
ENT.bIgnitable = false

ENT.bPlayDeathSequence = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE, DMG_POISON}

ENT.skName = "gargantua"
ENT.CollisionBounds = Vector(60,60,210)

ENT.iBloodType = false
ENT.sSoundDir = "npc/garg/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}

ENT.m_tbSounds = {
	["Attack"] = "gar_attack[1-3].wav",
	["Alert"] = "gar_alert[1-3].wav",
	["Breathe"] = "gar_breathe[1-3].wav",
	["Death"] = "gar_die[1-2].wav",
	["Pain"] = "gar_pain[1-3].wav",
	["Idle"] = "gar_idle[1-5].wav",
	["Foot"] = "gar_step[1-2].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:SetHealth(8000)
	
	local entSpriteEye = ents.Create("env_sprite")
	entSpriteEye:SetKeyValue("model","sprites/glow01.spr")
	entSpriteEye:SetKeyValue("rendermode","5") 
	entSpriteEye:SetKeyValue("rendercolor","255 47 52") 
	entSpriteEye:SetKeyValue("scale","0.2") 
	entSpriteEye:SetKeyValue("spawnflags","1") 
	entSpriteEye:SetParent(self)
	entSpriteEye:Fire("SetParentAttachment","head",0)
	entSpriteEye:Spawn()
	entSpriteEye:Activate()
	
	self:DeleteOnRemove(entSpriteEye)
	self.nextStomp = 0
	self.nextCarThrow = 0
	
	self.cspFlame = CreateSound(self,self.sSoundDir .. "gar_flamerun1.wav")
	self:StopSoundOnDeath(self.cspFlame)
	self:SetSoundLevel(100)

end

function ENT:OnInterrupt()
	if(self.bInSchedule) then
		self.cspFlame:Stop()
		self:EmitSound(self.sSoundDir .. "gar_flameoff1.wav", 75, 100)
	end
	self:StopParticles()
end

function ENT:_PossAttackThink(entPossessor,iAttack)
	if(iAttack == IN_ATTACK) then
		if(!entPossessor:KeyDown(IN_ATTACK)) then
			self.cspFlame:Stop()
			self:EmitSound(self.sSoundDir .. "gar_flameoff1.wav", 75, 100)
			self:_PossScheduleDone()
			self:StopParticles()
			return
		end
	end
	self:TurnDegree(3,entPossessor:GetAimVector():Angle())
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK2_LOW,false)
	self.bInSchedule = true
	ParticleEffectAttach("flame_gargantua", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("flame_gargantua", PATTACH_POINT_FOLLOW, self, 3)
	self:PlaySound("Attack")
	self.cspFlame:Play()
	self:EmitSound(self.sSoundDir .. "gar_flameon1.wav", 75, 100)
end

function ENT:OnFoundEnemy()
	self.nextStomp = CurTime() +math.Rand(4,12)
	self.nextCarThrow = CurTime() +math.Rand(2,8)
	self:SelectSchedule()
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	if !self.bInSchedule || !IsValid(self.entEnemy) then return end
	self:TurnDegree(20,(self.entEnemy:GetPos() -self:GetPos()):Angle())
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		if(atk == "left") then
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_one_slash")
			angViewPunch = Angle(-4, 26, -6)
		elseif(atk == "right") then
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_one_slash")
			angViewPunch = Angle(-4, -26, 6)
		else
			iDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_both_slash")
			angViewPunch = Angle(30, 0, 0)
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "shake") then
		util.ScreenShake(self:GetPos(),85,85,0.4,1500)
		return true
	end
	if(event == "mattack") then
		local atk = select(2,...)
		if(atk == "flamedmg") then
			if(!self.bInSchedule) then return true end
			local fDist = IsValid(self.entEnemy) && self:OBBDistance(self.entEnemy)
			if(!self:IsPossessed() && (!IsValid(self.entEnemy) || fDist > self.fRangeDistance || fDist <= self.fMeleeDistance || self.entEnemy:Health() <= 0 || !self:Visible(self.entEnemy))) then
				self:StopParticles()
				self.bInSchedule = false
				self.cspFlame:Stop()
				self:EmitSound(self.sSoundDir .. "gar_flameoff1.wav", 75, 100)
				return true
			end
			self:DealFlameDamage(self.fRangeDistance,GetConVarNumber("sk_gargantua_dmg_fire"))
			return true
		end
		if(atk == "flamerun") then
			if !self.bInSchedule then return true end
			self:PlayActivity(ACT_RANGE_ATTACK2_LOW, !self:IsPossessed())
			return true
		end
		local fDist = self.fMeleeDistance
		local iDmg
		local angViewPunch
		if(atk == "right") then
			iDmg = GetConVarNumber("sk_gargantua_dmg_slash")
			angViewPunch = Angle(4,-70,5)
		elseif(atk == "smash") then
			iDmg = GetConVarNumber("sk_gargantua_dmg_smash")
			angViewPunch = Angle(39,4,-4)
		elseif(atk == "kick") then
			for k, v in ipairs(ents.FindInSphere(self:GetMeleePos(), 70)) do
				if v:IsPhysicsEntity() && self:Visible(v) then
					local phys = v:GetPhysicsObject()
					if phys:IsMoveable() then
						local posEnt = v:GetPos()
						local angToEnt = self:GetAngleToPos(posEnt).y
						if (angToEnt <= 70 && angToEnt >= 0) || (angToEnt <= 360 && angToEnt >= 290) then
							v:SetPhysicsAttacker(self)
							phys:ApplyForceCenter((self:GetForward() *900000 +self:GetUp() *90000))
							phys:AddAngleVelocity(Vector(0,600,0))
						end
					end
				end
			end
			self:DealMeleeDamage(self.fMeleeDistance,GetConVarNumber("sk_gargantua_dmg_kick"),Angle(-48,0,0),nil,nil,nil,nil,nil,function(ent)
				ent:SetVelocity((self:GetForward() *440) +Vector(0, 0, 420))
			end)
			return true
		else
			-- bite (Not implemented)
			return true
		end
		self:DealMeleeDamage(fDist,iDmg,angViewPunch)
		return true
	elseif(event == "rattack") then
		self:EmitSound( self.sSoundDir .. "gar_stomp1.wav", 75, 100)
		util.ScreenShake( self:GetPos(), 100, 100, 0.5, 1500 )  
		local entTracer = ents.Create( "obj_garg_tracer" )
		entTracer:NoCollide("monster_garg")
		entTracer:NoCollide("monster_babygarg")
		entTracer:SetPos(self:LocalToWorld(Vector(42, 24, 12)))
		entTracer:SetAngles(self:GetAngles())
		entTracer:SetEntityOwner(self)
		entTracer:SetEnemy(self.entEnemy)
		entTracer:Spawn()
		self.nextStomp = CurTime() +math.Rand(4,12)
		return true
	end
end

function ENT:CanUseTracer()
	local tr = util.TraceLine({start = self:GetPos() +Vector(0,0,20), endpos = self.entEnemy:GetPos() +Vector(0,0,20), filter = self})
	return !IsValid(tr.Entity) || tr.Entity == self.entEnemy
end

function ENT:CanKick(ent)
	if !ent:IsPhysicsEntity() || !self:Visible(ent) then return false end
	local phys = ent:GetPhysicsObject()
	if !phys:IsMoveable() || phys:GetMass() <= 1000 then return false end
	return true
end

local schdRunToLastPosition = ai_schedule_slv.New("Chase Enemy")
schdRunToLastPosition:EngTask("TASK_GET_PATH_TO_LASTPOSITION")
schdRunToLastPosition:EngTask("TASK_WAIT", 0.2)
function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if bMelee then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				self.chaseObjectStop = nil
				return
			end
			local bFlame = dist <= self.fRangeDistance
			if bFlame then
				self:PlayActivity(ACT_RANGE_ATTACK2_LOW, true)
				self.chaseObjectStop = nil
				self.bInSchedule = true
				ParticleEffectAttach("flame_gargantua", PATTACH_POINT_FOLLOW, self, 2)
				ParticleEffectAttach("flame_gargantua", PATTACH_POINT_FOLLOW, self, 3)
				self:PlaySound("Attack")
				self.cspFlame:Play()
				self:EmitSound(self.sSoundDir .. "gar_flameon1.wav", 75, 100)
				return
			end
			local bStomp = dist <= self.fRangeDistanceStomp && CurTime() >= self.nextStomp && self:CanUseTracer()
			if bStomp then
				self:PlayActivity(ACT_RANGE_ATTACK1, true)
				self.chaseObjectStop = nil
				return
			end
		end
		if self:Visible(enemy) then
			local bCanThrow = CurTime() >= self.nextCarThrow
			local entTarget
			if !bCanThrow && !self.bDontThrow then
				for k, ent in pairs(ents.FindInSphere(self:GetMeleePos(),400)) do
					if self:CanKick(ent) && self:EntInViewCone(ent, 45) then
						bCanThrow = true
						entTarget = ent
					end
				end
			end
			if bCanThrow then
				self.bDontThrow = nil
				if !IsValid(entTarget) then
					local mass = 199
					for k, ent in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
						if ent:IsPhysicsEntity() && self:Visible(ent) then
							local phys = ent:GetPhysicsObject()
							if phys:IsMoveable() then
								local _mass = phys:GetMass()
								if _mass > mass && _mass <= 1000 then
									entTarget = ent
									mass =_mass
								end
							end
						end
					end
				end
				if IsValid(entTarget) then
					local tblFilter = ents.GetAll()
					for k, v in pairs(tblFilter) do
						if v == entTarget then table.remove(tblFilter, k); break end
					end
					local posEnt = entTarget:GetPos() +entTarget:OBBCenter()
					local pos = util.TraceLine({start = posEnt -(enemy:GetPos() -posEnt):GetNormal() *(entTarget:BoundingRadius() +10), endpos = posEnt, filter = tblFilter}).HitPos
					pos = pos -(posEnt -pos):GetNormal() *(self:OBBMaxs().y +30)
					if self:NearestPoint(pos):Distance(pos) <= 30 then
						self:PlayActivity(ACT_MELEE_ATTACK2, true)
						self.nextCarThrow = CurTime() +math.Rand(6,10)
						self.chaseObjectStop = nil
						return
					end
					self:SetLastPosition(pos)
					self:StartSchedule(schdRunToLastPosition)
					self.chaseObjectStop = self.chaseObjectStop || CurTime() +5
					if !self:HasCondition(35) && CurTime() < self.chaseObjectStop then return end
					self:ClearCondition(35)
					self.nextCarThrow = CurTime() +math.Rand(10,18)
					self.bDontThrow = true
					self.chaseObjectStop = nil
				end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end