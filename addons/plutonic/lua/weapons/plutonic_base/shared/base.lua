--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
-- [ File Details ]
-- Purpose: Loads the inital basic values, loads first!
SWEP.IsPlutonic = true
SWEP.PrintName = "Plutonic Weapon Base"
SWEP.Category = "Plutonic"
SWEP.DrawWeaponInfoBox = false
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.ViewModelFOV = 55
SWEP.UseHands = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.CustomEvents = {}
SWEP.CSMuzzleFlashes = true
SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.13
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")
SWEP.IronsightsRocking = 16
SWEP.SwayFactor = 8
SWEP.Sway = 1
SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.1
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.025
SWEP.Spread.VelocityMod = 0.5
SWEP.IronsightsSpeed = 4
SWEP.IronsightsPos = Vector(-5.9613, -3.3101, 2.706)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.UseIronsightsRecoil = true
SWEP.scopedIn = SWEP.scopedIn or false
SWEP.CanBreachDoors = false
SWEP.SwayScale = 0
SWEP.BobScale = 0
SWEP.Reverb = {}
SWEP.Reverb.Primary = {}
SWEP.Reverb.Primary.IndoorEnabled = false
SWEP.Reverb.Primary.Indoor = Sound("")
SWEP.Reverb.Primary.IndoorRange = 1200
SWEP.Reverb.Primary.OutdoorEnabled = false
SWEP.Reverb.Primary.Outdoor = Sound("")
SWEP.Reverb.Primary.OutdoorRange = 5000
sound.Add(
	{
		name = "Plutonic.Draw",
		sound = {"weapons/ins2/uni/uni_weapon_draw_01.wav", "weapons/ins2/uni/uni_weapon_draw_02.wav", "weapons/ins2/uni/uni_weapon_draw_03.wav"},
		level = 60,
		channel = CHAN_AUTO,
		pitch = {95, 105}
	}
)

sound.Add(
	{
		name = "Plutonic.Raise",
		sound = {"weapons/ins2/uni/uni_lean_in_01.wav", "weapons/ins2/uni/uni_lean_in_02.wav", "weapons/ins2/uni/uni_lean_in_03.wav", "weapons/ins2/uni/uni_lean_in_04.wav"},
		level = 60,
		channel = CHAN_AUTO,
		pitch = {95, 105}
	}
)

sound.Add(
	{
		name = "Plutonic.Sprint",
		channel = CHAN_USER_BASE,
		volume = 0.7,
		level = 45,
		pitch = {95, 110},
		sound = {"weapons/movement/weapon_movement_sprint1.wav", "weapons/movement/weapon_movement_sprint2.wav", "weapons/movement/weapon_movement_sprint3.wav", "weapons/movement/weapon_movement_sprint4.wav", "weapons/movement/weapon_movement_sprint5.wav", "weapons/movement/weapon_movement_sprint6.wav", "weapons/movement/weapon_movement_sprint7.wav", "weapons/movement/weapon_movement_sprint8.wav", "weapons/movement/weapon_movement_sprint9.wav"}
	}
)

sound.Add(
	{
		name = "Plutonic.Walk",
		channel = CHAN_USER_BASE,
		volume = 0.7,
		level = 45,
		pitch = {95, 110},
		sound = {"weapons/movement/weapon_movement_walk1.wav", "weapons/movement/weapon_movement_walk2.wav", "weapons/movement/weapon_movement_walk3.wav", "weapons/movement/weapon_movement_walk4.wav", "weapons/movement/weapon_movement_walk5.wav", "weapons/movement/weapon_movement_walk6.wav", "weapons/movement/weapon_movement_walk7.wav", "weapons/movement/weapon_movement_walk8.wav", "weapons/movement/weapon_movement_walk9.wav"}
	}
)

-- Singularity
function SWEP:OnLowered()
	self:EmitSound("Plutonic.Raise", nil, nil, nil, nil, SND_NOFLAGS, 1)
end

function SWEP:Dirty()
	if Plutonic.IsClient then
		self.VMPos = Vector()
		self.VMAng = Angle()
		self.VMIronsights = 0
		self.VMCrouch = 0
		self.VMBlocked = 1
		self.VMRDBEF = 0
		self.VMBobCycle = 0
		self.VMSwayX = 0
		self.VMDeltaX = 0
		self.VMRoll = 0
		self.VMSwayY = 0
		self.VMDeltaX = 0
		self.VMRattle = 0
		self.VMSprint = 0
		self.VMVel = 0
		self.VMIdle = 0
		self.VMRecoil = Vector()
		self.VMRecoilAng = Angle()
	end
end

function SWEP:IsReliable()
	return self:GetReliable()
end

function SWEP:OnReliable()
	local QueuedAttachments = self.QueuedAttachments or {}
	if QueuedAttachments then
		for attachment, v in pairs(QueuedAttachments) do
			net.Start("Plutonic.AttachmentEquip")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteUInt(self:GetOwner():EntIndex(), 16)
			net.WriteString(attachment)
			net.Broadcast()
		end
	end
end

function SWEP:Initialize()
	Plutonic.IsClient = Plutonic.IsClient or CLIENT
	Plutonic.IsServer = Plutonic.IsServer or SERVER
	if Plutonic.IsClient then
		self.VMPos = Vector()
		self.VMAng = Angle()
		self.VMIronsights = 0
		self.VMCrouch = 0
		self.VMBlocked = 1
		self.VMRDBEF = 0
		self.VMBobCycle = 0
		self.VMSwayX = 0
		self.VMDeltaX = 0
		self.VMDeltaXWeighted = 0
		self.VMRoll = 0
		self.VMSwayY = 0
		self.VMDeltaY = 0
		self.VMDeltaYWeighted = 0
		self.VMRattle = 0
		self.VMSprint = 0
		self.VMVel = 0
		self.VMIdle = 0
		self.VMRecoil = Vector()
		self.VMRecoilAng = Angle()
	end

	self:SetIronsights(false)
	self:SetReloading(false)
	self:SetReloadTime(0)
	self:SetRecoil(0)
	self:SetNextIdle(0)
	self:SetHoldType(self.HoldType)
	if Plutonic.IsServer and self.CustomMaterial then
		self:SetMaterial(self.CustomMaterial)
	end

	if Plutonic.IsClient then
		net.Start("Plutonic.WeaponIsReliable")
		net.WriteEntity(self)
		net.SendToServer()
	end
end

function SWEP:OnReloaded()
	timer.Simple(
		0,
		function()
			self:SetHoldType(self.HoldType)
		end
	)
end

function SWEP:Deploy()
	if self.Attachments then
		for k, v in pairs(self.Attachments) do
			if v.Cosmetic then
				util.PrecacheModel(v.Cosmetic.Model)
			end
		end
	end

	self.IsHolstering = false
	if Plutonic.IsClient then
		self.VMPos = Vector()
		self.VMAng = Angle()
		self.VMIronsights = 0
		self.VMCrouch = 0
		self.VMBlocked = 1 -- The oddball, due to the way it works needs to be set to 1
		self.VMRDBEF = 0
		self.VMBobCycle = 0
		self.VMSwayX = 0
		self.VMDeltaX = 0
		self.VMRoll = 0
		self.VMSwayY = 0
		self.VMDeltaX = 0
		self.VMRattle = 0
		self.VMSprint = 0
		self.VMVel = 0
		self.VMIdle = 0
		self.VMRecoil = Vector()
		self.VMRecoilAng = Angle()
	end

	if self.CustomMaterial and Plutonic.IsClient then
		self:GetOwner():GetViewModel():SetMaterial(self.CustomMaterial)
		self.CustomMatSetup = true
	else
		self:GetOwner():GetViewModel():SetMaterial(self.CustomMaterial)
		self.CustomMatSetup = false
	end

	self.DrawTime = UnPredictedCurTime()
	self:PlayAnim(ACT_VM_DRAW)
	if self:GetOwner():IsPlayer() then
		self:GetOwner():GetViewModel():SetPlaybackRate(1)
	end

	self:EmitSound(Sound("Plutonic.Draw"), nil, nil, nil, nil, SND_NOFLAGS, 1)
	--self:ViewPunch(Angle()) -- shit draw kick, who the fuck wants this
	self:QueueIdle()

	return true
end

function SWEP:ShootBullet(damage, num_bullets, aimcone, override_src, override_dir)
	if self.UseBallistics then
		if Plutonic.IsClient then return end
		local bulllet = ents.Create("plutonic_ballistic")
		bulllet:SetPos(self:GetOwner():GetShootPos())
		bulllet:SetAngles(self:GetOwner():GetAimVector():Angle())
		bulllet:SetOwner(self:GetOwner())
		bulllet:Spawn()
		bulllet:Launch()

		return
	end

	local bullet = {}
	bullet.Num = num_bullets
	bullet.Src = override_src or self:GetOwner():GetShootPos() -- Source
	bullet.Dir = override_dir or self:GetOwner():GetAimVector() -- Dir of bullet
	bullet.Spread = Vector(aimcone, aimcone, 0) -- Aim Cone
	if self.Primary.Tracer then
		bullet.TracerName = "tracer"
		--bullet.TracerName = self.Primary.Tracer
	else
		bullet.TracerName = "tracer"
	end

	if self.Primary.Range then
		bullet.Distance = self.Primary.Range
	end

	bullet.Tracer = self.Primary.TracerEveryX or 1 -- Show a tracer on every x bullets
	bullet.Force = 1 -- Amount of force to give to phys objects
	bullet.Damage = damage
	bullet.AmmoType = "Pistol"
	Plutonic.Framework.FireBullets(self, bullet)
	self:ShootEffects()
end

function SWEP:GetShootSrc()
	local owner = self:GetOwner()
	if not IsValid(owner) then return self:GetPos() end
	if owner:IsNPC() then return owner:GetShootPos() end
	local dir = owner:EyeAngles()
	local offset = Vector(0, 0, 0)
	local src = owner:EyePos()
	src = src + dir:Right() * offset[1]
	src = src + dir:Forward() * offset[2]
	src = src + dir:Up() * offset[3]

	return src
end

function SWEP:ShootEffects()
	Plutonic.BenchmarkStart("ShootEffects")
	
	-- Initialize variables to prevent nil errors
	self.BlowbackPos = self.BlowbackPos or Vector(0, 0, 0)
	self.BlowbackAngle = self.BlowbackAngle or Angle(0, 0, 0)
	self.VMRecoilPos = self.VMRecoilPos or Vector(0, 0, 0)
	self.VMRecoilAng = self.VMRecoilAng or Angle(0, 0, 0)
	
	if Plutonic.IsClient then
		self.CrosshairGapBoost = 16
		self.VMRecoilPos = self.BlowbackPos
		self.VMRecoilAng = self.BlowbackAngle
		self:ProceduralRecoil(1)
	end

	self.VMRecoilFOV = 1
	
	if not self:GetIronsights() or not self.UseIronsightsRecoil then
		if self.PrimaryFireSequence then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				vm:ResetSequenceInfo()
				local seq = vm:LookupSequence(self.PrimaryFireSequence)
				if seq and seq >= 0 then
					vm:SetSequence(seq)
					vm:SendViewModelMatchingSequence(seq)
				end
			end
		else
			if self:Clip1() <= 0 and not self.NoLastShotAnim then
			    self:PlayAnim(ACT_VM_PRIMARYATTACK_EMPTY)
			else
			    self:PlayAnim(ACT_VM_PRIMARYATTACK)
			end
			self:QueueIdle()
		end
	else
		if self.IronsightsFireActivity then
			self:PlayAnim(self.IronsightsFireActivity)
		end
		self.CanDecreaseBlowback = CurTime() + 0.1
	end

	if Plutonic.IsClient then
		self.CrosshairGapBoost = 24
		if not LocalPlayer():ShouldDrawLocalPlayer() and self:GetOwner() == LocalPlayer() then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				local attachment = vm:LookupAttachment(self.MuzzleFlashAttachment or self.IronsightsMuzzleFlashAttachment or "muzzle")
				if attachment and attachment > 0 then
					local posang = vm:GetAttachment(attachment)
					
					if posang then
						local muzzleEffect = self.MuzzleEffect or self.IronsightsMuzzleFlash
						
						if muzzleEffect and isstring(muzzleEffect) and muzzleEffect ~= "" then
							ParticleEffectAttach(muzzleEffect, PATTACH_POINT_FOLLOW, vm, attachment)
						end
					end
				end
			end
		end
	end

	-- World muzzle flash with proper validation
	local vm = self:GetOwner():GetViewModel()
	if IsValid(vm) then
		local att = self.MuzzleFlashAttachment or self.IronsightsMuzzleFlashAttachment or "muzzle"
		att = vm:LookupAttachment(att)
		
		if att and att > 0 then
			local ed = EffectData()
			ed:SetStart(self:GetShootSrc())
			ed:SetOrigin(self:GetShootSrc())
			ed:SetScale(1)
			ed:SetEntity(self.OverrideWMEntity or self)
			ed:SetAttachment(att)
			util.Effect("plutonic_muzzleflash", ed)
		end
	end

	self:PlayAnimWorld(ACT_VM_PRIMARYATTACK)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	
	if Plutonic.IsClient then
		self:PlayAmmoIndicator()
	end

	if self.CustomShootEffects then
		self.CustomShootEffects(self)
	end

	Plutonic.BenchmarkEnd("ShootEffects")
end

function SWEP:IsSprinting()
	return (self:GetOwner():GetVelocity():Length2D() > self:GetOwner():GetRunSpeed() - 50) and self:GetOwner():IsOnGround()
end

function SWEP:PrimaryAttack()

	if self.CombineBallMode and not (self.LoweredPos and self:IsSprinting()) and self:GetReloadTime() < CurTime() then
		local owner = self:GetOwner()

		if self.NextCombineBallFire and CurTime() < self.NextCombineBallFire then return end
		self.NextCombineBallFire = CurTime() + 0.2  -- slight buffer even when ammo is 0

		if owner:GetAmmoCount("AR2AltFire") <= 0 then
			if not self.LastEmptySound or CurTime() > self.LastEmptySound then
				owner:EmitSound("Weapon_Pistol.Empty")
				self.LastEmptySound = CurTime() + 0.5
			end
			print("[Firemode] No AR2AltFire ammo!")
			return
		end

		self.NextCombineBallFire = CurTime() + 3 -- true cooldown when successfully fired
		self:SetNextPrimaryFire(CurTime() + 3)
		self:SetNextSecondaryFire(CurTime() + 3)

		local vm = owner:GetViewModel()

		owner:EmitSound("weapons/cguard/charging.wav")
		util.ScreenShake(owner:GetPos(), 3, 4, 1, 2)

		if IsValid(vm) then
			vm:SetSequence("shake")
			vm:SetPlaybackRate(0.5)
		end

		timer.Create("combineball_shake_" .. owner:EntIndex(), 0.1, 10, function()
			if IsValid(self) and self:GetOwner():GetActiveWeapon() == self then
				util.ScreenShake(owner:GetPos(), 3, 4, 1, 2)
			end
		end)

		if SERVER then
			timer.Create("combineball_fire_" .. owner:EntIndex(), 1.0, 1, function()
				if not IsValid(self) or self:GetOwner():GetActiveWeapon() ~= self then return end

				print("[Firemode] Firing charged Combine Ball!")
				owner:RemoveAmmo(1, "AR2AltFire")

				owner:ViewPunch(Angle(0, 0, math.Rand(5, 10)))
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
				owner:SetAnimation(PLAYER_ATTACK1)
				self:EmitSound("NPC_CombineBall.Launch")
				self:EmitSound("weapons/irifle/irifle_fire2.wav")

				local ent = ents.Create("prop_combine_ball")
				ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 0.5)
				ent:SetOwner(owner)
				ent:SetSaveValue("m_flRadius", 10)
				ent:Activate()
				ent:Spawn()
				ent:SetSaveValue("m_nState", 3)
				ent:GetPhysicsObject():SetVelocity(owner:GetAimVector() * 1150)
				ent:Fire("Explode", nil, 2)

				local hasHit = false

				ent:AddCallback("PhysicsCollide", function(ent, data)
					if hasHit then return end
					local collided = data.HitEntity
					if IsValid(collided) and collided:IsPlayer() then
						hasHit = true
						ent:Fire("Explode", nil, 0)
						local targets = ents.FindInSphere(ent:GetPos(), 100)
						for _, target in ipairs(targets) do
							if target:IsPlayer() then
								target:EmitSound("weapons/physcannon/energy_disintegrate5.wav")
								target:EmitSound("weapons/physcannon/energy_sing_flyby1.wav")
							end
						end
					end
				end)

				hook.Add("EntityTakeDamage", "DecreaseCombineBallDamage_" .. ent:EntIndex(), function(target, dmginfo)
					if dmginfo:GetInflictor() == ent then
						dmginfo:ScaleDamage(0.5)
					end
				end)
			end)
		end

		timer.Create("combineball_animreset_" .. owner:EntIndex(), 2.05, 1, function()
			if IsValid(self) and self:GetOwner():GetActiveWeapon() == self then
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
		end)

		return
	end

	if not self:CanShoot() then return end

	local clip = self:Clip1()
	if self.Primary.Burst and clip >= 3 then
		self:SetBursting(true)
		self.Burst = 3
		local curtime = CurTime()
		local curatt = self:GetNextPrimaryFire()
		local diff = curtime - curatt
		if diff > engine.TickInterval() or diff < 0 then
			curatt = curtime
		end

		local delay = (self.Primary.Delay * 3) + (self.Primary.BurstEndDelay or 0.3)
		self:SetNextPrimaryFire(curatt + delay)
		self:SetReloadTime(delay)
	elseif clip >= 1 then
		self:TakePrimaryAmmo(1)
		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self:CalculateSpread())
		self:AddRecoil()
		self:ViewPunch()
		if self.Primary.Sound_World then
			if Plutonic.IsClient then
				local owner = self:GetOwner()
				if owner == LocalPlayer() then
					local shouldPlay = Singularity and Singularity.GetSetting("view_thirdperson", false)
					if shouldPlay == false then
						self:EmitSound(self.Primary.Sound, nil, nil, nil, CHAN_STATIC, SND_NOFLAGS, 0)
					end
				end
			end

			if Plutonic.IsServer then
				self:EmitWorldSound(self.Primary.Sound_World)
			end
		else
			self:EmitSound(self.Primary.Sound)
			--self:EmitSound(self.Primary.Sound, nil, nil, nil, CHAN_WEAPON, nil, 1)
		end

		local curtime = CurTime()
		local curatt = self:GetNextPrimaryFire()
		local diff = curtime - curatt
		if diff > engine.TickInterval() or diff < 0 then
			curatt = curtime
		end

		self:SetNextPrimaryFire(curatt + self.Primary.Delay)
	else
		self:EmitSound(self.EmptySound)
		self:Reload()
		local curtime = CurTime()
		local curatt = self:GetNextPrimaryFire()
		local diff = curtime - curatt
		if diff > engine.TickInterval() or diff < 0 then
			curatt = curtime
		end

		self:SetNextPrimaryFire(CurTime() + 1)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:VM()
	return self:GetOwner():GetViewModel()
end

function SWEP:HolsterThink()
	if self.IsHolstering and self.HolsterTime < CurTime() then
		if Plutonic.IsClient then
			input.SelectWeapon(self.HolsterWep)
		else
			self:GetOwner():SelectWeapon(self.HolsterWep:GetClass())
		end
	end
end

function SWEP:Holster(wep)
    if not IsValid(self) then return true end
    if not IsValid(wep) then return true end
    
    local owner = self:GetOwner()
    if not IsValid(owner) then return true end
    
    if wep:GetClass() == "plutonic_golden357" or wep:GetClass() == "plutonic_goldenak47" then
        local vm = owner:GetViewModel()
        if IsValid(vm) then
            vm:SetMaterial("")
        end
    end
    
    return true
end

function SWEP:OnRemove()
	if self.CustomMaterial and Plutonic.IsClient then
		if not self:GetOwner().GetViewModel then return end -- disconnect errors
		if self:GetOwner() ~= LocalPlayer() then return end
		if not IsValid(self:GetOwner()) then return end
		if not IsValid(self:GetOwner():GetViewModel()) then return end
		self:GetOwner():GetViewModel():SetMaterial("")
	end
end

function SWEP:QueueIdle()
	if self:GetOwner():IsNPC() then return end
	self:SetNextIdle(CurTime() + self:GetOwner():GetViewModel():SequenceDuration() + 0.1)
end

function SWEP:CanShoot()
	return self:CanPrimaryAttack() and not self:GetBursting() and not (self.LoweredPos and self:IsSprinting()) and self:GetReloadTime() < CurTime()
end

function SWEP:ViewPunch()
	if self:GetOwner():IsNPC() then return end
	if IsFirstTimePredicted() and (Plutonic.IsClient or game.SinglePlayer()) then
		self:GetOwner():SetEyeAngles(self:GetOwner():EyeAngles() - Angle(self.Primary.Recoil * (self:GetIronsights() and 0.5 or 1), 0, 0))
	end
end

function SWEP:CanIronsight()
	if self.NoIronsights then return false end

	return not self:IsSprinting() and not self:GetReloading() and self:GetOwner():IsOnGround()
end
