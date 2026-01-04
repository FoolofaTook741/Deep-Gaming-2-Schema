AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_XENIAN","monster_controller")
ENT.NPCFaction = NPC_FACTION_XENIAN
ENT.iClass = CLASS_XENIAN
ENT.sModel = "models/half-life/controller.mdl"
ENT.fRangeDistance = 1250

ENT.bPlayDeathSequence = false

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/controller/"

ENT.m_tbSounds = {
	["Attack"] = "con_attack[1-3].wav",
	["Alert"] = "con_alert[1-3].wav",
	["Death"] = "con_die[1-2].wav",
	["Pain"] = "con_pain[1-3].wav",
	["Idle"] = "con_idle[1-5].wav"
}

ENT.tblAlertAct = {}

function ENT:OnInit()
	self.BaseClass.OnInit(self)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(13, 13, 64), Vector(-13, -13, 0))

	self:SetHealth(120)
	self:SetFlySpeed(GetConVarNumber("sk_controller_fly_speed"))
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self.bInSchedule = true
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		local atk = select(2,...)
		local bProjectileStart = atk == "projectilestart"
		local bProjectileEnd = atk == "projectileend"
		local bShoot = string.find(atk,"shoot")
		local bProjectile = !bProjectileStart && !bProjectileEnd && !bShoot
		if bProjectile then
			local sProjectile = string.Trim(string.sub(atk,string.find(atk,"projectile") +10,string.len(atk)))
			local iProjectile = tonumber(sProjectile)
			if (!IsValid(self.entEnemy) && !self.bPossessed) || iProjectile > self.projectileCount then return true end
			if !self.bPossessed then
				local tr = self:CreateTrace(self.entEnemy:GetCenter(), nil, self:GetCenter() +self:GetForward() *20)
				if tr.Entity != self.entEnemy then return true end
			end
			local pos = self:GetAttachment((iProjectile % 2) +3).Pos
			local projectile = ents.Create("obj_con_projectile_energy")
			projectile:SetPos(pos)
			projectile:SetEntityOwner(self)
			projectile:Spawn()
			projectile:Activate()
			local phys = projectile:GetPhysicsObject()
			if IsValid(phys) then
				local posVelocity
				if !self.bPossessed then
					posVelocity = (self.entEnemy:GetCenter() -pos +self.entEnemy:GetVelocity() *0.35):GetNormal() *1600 +VectorRand() *math.Rand(0,160)
				else
					local entPossessor = self:GetPossessor()
					posVelocity = (entPossessor:GetPossessionEyeTrace().HitPos -pos):GetNormal() *2800
				end
				phys:ApplyForceCenter(posVelocity)
			end
			return true
		end
		if bProjectileStart then
			self.projectileCount = math.random(3,8)
			self.tblSprites = {}
			local att = {"hand_left", "hand_right"}
			for i = 1, 2 do
				local sprite = ents.Create("env_sprite")
				sprite:SetKeyValue("rendermode", "9")
				sprite:SetKeyValue("rendercolor", "255 141 15")
				sprite:SetKeyValue("model", "sprites/orangecore2.spr")
				sprite:SetKeyValue("scale", "0.4")
				sprite:SetKeyValue("spawnflags", "1")
				sprite:SetPos(self:GetPos())
				sprite:SetParent(self)
				sprite:Spawn()
				sprite:Activate()
				sprite:Fire("SetParentAttachment", att[i], 0)
				
				table.insert(self.tblSprites, sprite)
				self:DeleteOnRemove(sprite)
			end
			return true
		end
		if bProjectileEnd then
			if !self.tblSprites then return true end
			for k, v in pairs(self.tblSprites) do
				v:Remove()
			end
			self.tblSprites = nil
			self.projectileCount = nil
			return true
		end
		if bShoot then
			local bShootStart = atk == "shootstart"
			if bShootStart then
				self.tblSprites = {}
				local att = {"hand_left", "hand_right"}
				for i = 1, 2 do
					local sprite = ents.Create("env_sprite")
					sprite:SetKeyValue("rendermode", "9")
					sprite:SetKeyValue("rendercolor", "255 141 15")
					sprite:SetKeyValue("model", "sprites/orangecore2.spr")
					sprite:SetKeyValue("scale", "0.4")
					sprite:SetKeyValue("spawnflags", "1")
					sprite:SetPos(self:GetPos())
					sprite:SetParent(self)
					sprite:Spawn()
					sprite:Activate()
					sprite:Fire("SetParentAttachment", att[i], 0)
					
					table.insert(self.tblSprites, sprite)
					self:DeleteOnDeath(sprite)
				end
			else
				if self.tblSprites then
					for k, v in pairs(self.tblSprites) do
						if IsValid(v) then v:Remove() end
					end
					self.tblSprites = nil
				end
				if !IsValid(self.entEnemy) && !self.bPossessed then return true end
				local pos = self:GetAttachment(1).Pos
				local projectile = ents.Create("obj_con_projectile_energy_large")
				projectile:SetPos(pos)
				projectile:SetHoming(true)
				projectile:SetEntityOwner(self)
				projectile:SetEnemy(self.entEnemy)
				projectile:Spawn()
				projectile:Activate()
				local phys = projectile:GetPhysicsObject()
				if IsValid(phys) then
					local posVelocity
					if !self.bPossessed then
						posVelocity = (self.entEnemy:GetCenter() -pos):GetNormal() *1000
					else
						local entPossessor = self:GetPossessor()
						posVelocity = (entPossessor:GetPossessionEyeTrace().HitPos -pos):GetNormal() *1000
					end
					phys:ApplyForceCenter(posVelocity)
				end
			end
		end
		return true
	end
end

function ENT:Interrupt()
	if self.tblSprites then
		for k, v in pairs(self.tblSprites) do
			if IsValid(v) then
				v:Remove()
			end
		end
		self.tblSprites = nil
	end
	if !self.bInSchedule then return end
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
end

function ENT:OnScheduleSelection()
	self:Interrupt()
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT || disp == D_FR) then
		local bRange = dist <= self.fRangeDistance && self:CanSee(enemy)
		if bRange then
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			self.bInSchedule = true
			return
		end
	end
end