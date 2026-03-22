ENT.Base = "lvs_base_helicopter"
ENT.PrintName = "Combine Hunter-Chopper"
ENT.Author = "Riggs"
ENT.Information = "Combine Attack Helicopter from Half Life 2 + Episodes"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/combine_helicopter.png"

ENT.AITEAM = 1
ENT.AdminSpawnable = false
ENT.DisableBallistics = true
ENT.ForceAngleDampingMultiplier = 1.8
ENT.ForceAngleMultiplier = 1.2
ENT.ForceLinearDampingMultiplier = 2.2
ENT.GibModels = {"models/gibs/helicopter_brokenpiece_01.mdl", "models/gibs/helicopter_brokenpiece_02.mdl", "models/gibs/helicopter_brokenpiece_03.mdl", "models/gibs/helicopter_brokenpiece_06_body.mdl", "models/gibs/helicopter_brokenpiece_04_cockpit.mdl", "models/gibs/helicopter_brokenpiece_05_tailfan.mdl"}
ENT.MDL = "models/Combine_Helicopter.mdl"
ENT.MaxHealth = 1600
ENT.MaxVelocity = 1600
ENT.Spawnable = true
ENT.ThrottleRateDown = 0.15
ENT.ThrottleRateUp = 0.15
ENT.ThrustDown = 0.7
ENT.ThrustRate = 1.0
ENT.ThrustUp = 1.3
ENT.TurnRatePitch = 1
ENT.TurnRateRoll = 0.75
ENT.TurnRateYaw = 3
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.EngineSounds = {
	{
		sound = "^npc/attack_helicopter/aheli_rotor_loop1.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
	{
		sound = "npc/attack_helicopter/aheli_wash_loop3.wav",
		sound_int = "lvs/vehicles/helicopter/loop_interior.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 75,
		UseDoppler = true,
	}
}

function ENT:OnSetupDataTables()
	self:AddDT("Bool", "LightsEnabled")
end

function ENT:GetAimAngles()
	local Gun = self:GetAttachment(self:LookupAttachment("gun"))
	if not Gun then return end
	local trace = self:GetEyeTrace()
	local AimAngles = self:WorldToLocalAngles((trace.HitPos - Gun.Pos):GetNormalized():Angle())
	return AimAngles
end

function ENT:WeaponsInRange()
	local AimAngles = self:GetAimAngles()
	return math.abs(AimAngles.y) < 45 and AimAngles.p < 90 and AimAngles.p > -35
end

function ENT:SetPoseParameterTurret()
	local AimAngles = self:GetAimAngles()
	self:SetPoseParameter("weapon_yaw", AimAngles.y)
	self:SetPoseParameter("weapon_pitch", -AimAngles.p)
end

function ENT:HandleShoot(FireInput, active)
	if not self:WeaponsInRange() then
		self._doAttack = nil
		self.charging = nil
	end

	self.charge = self.charge or 0
	if self.charging then
		self.charge = math.min(self.charge + FrameTime() * 60, 100)
		if self.charge >= 100 then self.charging = nil end
	else
		if FireInput and self.charge > 0 then
			self:ShootGun()
		else
			if FireInput then
				self:ChargeGun()
			else
				self.charge = math.max(self.charge - FrameTime() * 200, 0)
			end
		end
	end

	local Fire = FireInput and active and self.charge > 0 and not self.charging
	if not IsValid(self.weaponSND) then return end
	if self._oldFire != Fire then
		self._oldFire = Fire
		if Fire then
			if self.weaponSND.snd_chrg then
				self.weaponSND.snd_chrg:Stop()
				self.weaponSND.snd_chrg = nil
			end

			self.weaponSND:Play()
		else
			self.weaponSND:Stop()
		end
	end

	if not active then return end
	if Fire then self:SetHeat(1 - self.charge / 100) end
end

function ENT:ChargeGun()
	self._doAttack = true
	self.charging = true
	if not IsValid(self.weaponSND) then return end
	self.weaponSND.snd_chrg = CreateSound(self, "NPC_AttackHelicopter.ChargeGun")
	self.weaponSND.snd_chrg:Play()
end

function ENT:FinishShoot()
	self._doAttack = nil
	self.charging = nil
	if not IsValid(self.weaponSND) then return end
	self.weaponSND:Stop()
	if self.weaponSND.snd_chrg then
		self.weaponSND.snd_chrg:Stop()
		self.weaponSND.snd_chrg = nil
	end
end

function ENT:ShootGun()
	local T = CurTime()
	if (self.NextFire or 0) > T then return end
	self.NextFire = T + 0.01
	self.charge = self.charge - 0.5
	local Muzzle = self:GetAttachment(self:LookupAttachment("muzzle"))
	if not Muzzle then return end
	local trace = self:GetEyeTrace()
	local bullet = {}
	bullet.Src = Muzzle.Pos
	bullet.Dir = (trace.HitPos - Muzzle.Pos):GetNormalized()
	bullet.Spread = Vector(0.1, 0.1, 0.1)
	bullet.TracerName = "lvs_pulserifle_tracer"
	bullet.Force = 1000
	bullet.HullSize = 6
	bullet.Damage = 4
	bullet.Velocity = 15000
	bullet.Attacker = self:GetDriver()
	bullet.Callback = function(att, tr, dmginfo)
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		util.Effect("AR2Impact", effectdata, true, true)
	end

	self:LVSFireBullet(bullet)
	local effectdata = EffectData()
	effectdata:SetOrigin(Muzzle.Pos)
	effectdata:SetNormal(Muzzle.Ang:Forward())
	effectdata:SetEntity(self)
	util.Effect("lvs_pulserifle_muzzle", effectdata)
end

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0.1
	weapon.HeatRateDown = 0.5
	weapon.StartAttack = function(ent) ent:ChargeGun() end
	weapon.FinishAttack = function(ent) ent:FinishShoot() end
	weapon.Attack = function(ent) end
	weapon.OnThink = function(ent, active)
		ent:SetPoseParameterTurret()
		ent:HandleShoot(ent._doAttack and active and ent:WeaponsInRange(), active)
	end

	weapon.OnSelect = function(ent) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	self:AddWeapon(weapon)
	weapon = {}
	weapon.Icon = Material("lvs/weapons/bomb.png")
	weapon.UseableByAI = false
	weapon.Ammo = 128
	weapon.Delay = 0.5
	weapon.HeatRateUp = -0.4
	weapon.HeatRateDown = 0.4
	weapon.StartAttack = function(ent)
		local Driver = ent:GetDriver()
		local projectile = ents.Create(ent.BombClass or "lvs_helicopter_hl2_combine_hunter_bomb")
		projectile:SetPos(ent:LocalToWorld(Vector(-50, 0, -25)))
		projectile:SetAngles(ent:GetAngles())
		projectile:SetParent(ent)
		projectile:Spawn()
		projectile:Activate()
		projectile:SetAttacker(IsValid(Driver) and Driver or ent)
		projectile:SetEntityFilter(ent:GetCrosshairFilterEnts())
		projectile:SetSpeed(ent:GetVelocity())
		projectile:SetDamage(150)
		projectile:SetRadius(250)
		self._ProjectileEntity = projectile
	end

	weapon.FinishAttack = function(ent)
		if not IsValid(ent._ProjectileEntity) then return end
		ent._ProjectileEntity:Enable()
		ent._ProjectileEntity:EmitSound("NPC_AttackHelicopter.DropMine")
		ent:AddGestureSequence(ent:LookupSequence("deploy"))
		ent:TakeAmmo()
		ent:SetHeat(ent:GetHeat() + 0.2)
		if ent:GetHeat() >= 1 then ent:SetOverheated(true) end
	end

	self:AddWeapon(weapon)
	weapon = {}
	weapon.Icon = Material("lvs/weapons/dropship_grabber.png")
	weapon.UseableByAI = true
	weapon.Ammo = 16
	weapon.Delay = 30
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.025
	weapon.StartAttack = function(ent)
		ent:EmitSound("NPC_AttackHelicopter.MegabombAlert")
		ent:TakeAmmo()
		local Driver = ent:GetDriver()
		timer.Simple(3, function()
			if not IsValid(ent) then return end
			timer.Create("lvs_combine_megabomb_" .. ent:EntIndex(), 0.5, 16, function()
				if not IsValid(ent) then return end
				ent:AddGestureSequence(ent:LookupSequence("deploy"))
				for i = 1, 2 do
					local projectile = ents.Create(ent.BombClass or "lvs_helicopter_hl2_combine_hunter_bomb")
					projectile:SetPos(ent:LocalToWorld(Vector(-50, i == 1 and 50 or -50, -25)))
					projectile:SetAngles(ent:GetAngles())
					projectile:SetParent(ent)
					projectile:Spawn()
					projectile:Activate()
					projectile:SetAttacker(IsValid(Driver) and Driver or ent)
					projectile:SetSpeed(ent:GetVelocity() + ent:GetRight() * (i == 1 and -256 or 256))
					projectile:SetDamage(150)
					projectile:SetRadius(250)
					projectile:Enable()
					projectile:EmitSound("NPC_AttackHelicopter.DropMine")
				end

				timer.Simple(0.25, function()
					if not IsValid(ent) then return end
					ent:AddGestureSequence(ent:LookupSequence("deploy"))
					projectile = ents.Create(ent.BombClass or "lvs_helicopter_hl2_combine_hunter_bomb")
					projectile:SetPos(ent:LocalToWorld(Vector(-50, 0, -25)))
					projectile:SetAngles(ent:GetAngles())
					projectile:SetParent(ent)
					projectile:Spawn()
					projectile:Activate()
					projectile:SetAttacker(IsValid(Driver) and Driver or ent)
					projectile:SetSpeed(ent:GetVelocity())
					projectile:SetDamage(150)
					projectile:SetRadius(250)
					projectile:Enable()
					projectile:EmitSound("NPC_AttackHelicopter.DropMine")
				end)
			end)
		end)
	end

	self:AddWeapon(weapon)
	weapon = {}
	weapon.Icon = Material("lvs/weapons/light.png")
	weapon.UseableByAI = false
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.StartAttack = function(ent)
		if not ent.SetLightsEnabled then return end
		if ent:GetAI() then return end
		ent:SetLightsEnabled(not ent:GetLightsEnabled())
		ent:EmitSound("items/flashlight1.wav", 75, 105)
	end

	self:AddWeapon(weapon)
end
