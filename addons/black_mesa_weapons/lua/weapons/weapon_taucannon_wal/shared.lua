DEFINE_BASECLASS("weapon_base_wal_re")
SWEP.Base = "weapon_base_wal_re"

SWEP.PrintName = "'XVL1456' Tau Particle Accelerator"
--SWEP.Description = ""
SWEP.Author = "Wallace"
SWEP.Category = "BMS Weapons"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_gauss.mdl"
SWEP.WorldModel = "models/weapons/w_gauss_mp.mdl"
SWEP.UseHands = true
SWEP.IsAlwaysRaised = true

SWEP.Primary.KnockbackScale = 10

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Damage = 45
-- SWEP.Primary.PenetrationScale = 2.0
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "energyammo"
SWEP.Primary.DefaultClip	= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo = ""

SWEP.Secondary.ClipSize = -1

SWEP.HeatFactor = 0.023
SWEP.PowerAccumulation = 0.105
SWEP.ChargeAnimSpeed = 1

SWEP.TracerName = "gauss_tracer"

SWEP.ConeMax = 0.003
SWEP.ConeMin = 0.001

SWEP.SpinSpeed = 1
SWEP.SpinAng = 0

SWEP.SecondaryFireFrame = false

SWEP.FullyCharged = false

SWEP.BounceMulti = 1.5

SWEP.HoldType = "physgun"
SWEP.HoldTypeSprint = "passive"

function SWEP:SetupDataTables() -- shitty tables, but okay
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Bool", 7, "Charging")
	self:NetworkVar("Bool", 8, "Holding")
	self:NetworkVar("Bool", 9, "Overheated")
	self:NetworkVar("Int", 7, "Power")
end

function SWEP:GetChargePower()
	return math.Clamp(self:GetDTFloat(9),0.0,1.0)	
end

function SWEP:SetChargePower(num)
	if num>1.0 then
		self:SetOverheated(true)
	end
	return self:SetDTFloat(9,num)	
end

sound.Add({
	name = "LS2.G_IDLE.Loop",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {55, 65},
	sound = {"weapons/physcannon/superphys_hold_loop.wav"}
})

sound.Add({
	name = "LS2.G_IDLE2.Loop",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {55, 65},
	sound = {"weapons/physcannon/energy_sing_loop4.wav"}
})
		
function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	self:GetOwOner():EmitSound(Sound("LS2.G_IDLE2.Loop"))
	self:GetOwOner():EmitSound(Sound("LS2.G_IDLE.Loop"))
	return true
end

SWEP.NextAttack = 0
function SWEP:Initialize()
	self.TauChargeSound = CreateSound(self, "weapons/tau/gauss_spinup.wav")
	self.TauChargeSound:SetSoundLevel(60)

	self.TauOverChargeSound = CreateSound(self, "weapons/tau/gauss_overcharging.wav")
	self.TauOverChargeSound:SetSoundLevel(60)

	self.TauPickUpSound = CreateSound(self, "weapons/tau/tau_draw_admire.ogg")
	self.TauPickUpSound:SetSoundLevel(60)

	self:SetHoldType(self.HoldType)

	if CLIENT then
		self:Anim_Initialize()
	end

	if BMSWEP and BMSWEP.DisablePickUpAnimations then return end

	timer.Simple(0, function() -- move it to next frame
		if not self:GetOwOner().FirstPickUpGauss then
			self:SendWeaponAnim( ACT_VM_PICKUP )
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self.NextAttack = CurTime() + 5.66 -- crap
			self:GetOwOner().FirstPickUpGauss = true
			self.TauPickUpSound:PlayEx(1, 100 + CurTime() % 1)
		end
	end)
end

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	local RicoCallback = function(att, tr, dmginfo)
		local ent = tr.Entity
		if SERVER and tr.HitWorld and not tr.HitSky then
			local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.1
			timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
		end

		ParticleEffect( "tau_beam_balls_bounce", tr.HitPos, attacker:EyeAngles(), attacker:GetActiveWeapon() ) -- use original effect on ricochets 
		ParticleEffect( "tau_beam_balls", tr.HitPos, attacker:EyeAngles(), attacker:GetActiveWeapon() )
		
		if tr.HitWorld then
			util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
	end

	attacker.RicochetBullet = true
	if RicoBounces <= 1 and attacker:IsValid() then
		RicoBounces = RicoBounces + 1
		attacker:FireBullets({Src=hitpos, Dir=  hitnormal + normal * 2.5, Spread=Vector(0, 0, 0), Num=1, Damage=damage, Force=1, TracerName = "gauss_rico", Callback=RicoCallback, HullSize=nil, IgnoreEntity=team.GetPlayers(attacker:Team()), Distance=nil})
	end
	attacker.RicochetBullet = nil
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	RicoBounces = 0
	local ent = tr.Entity
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * attacker:GetActiveWeapon().BounceMulti
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end

	local e = EffectData()
	e:SetOrigin(tr.HitPos)
	e:SetMagnitude(0.5)
	e:SetScale(0.5)
	util.Effect("hit_gauss", e)
	
	if tr.HitWorld then
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:TakePrimaryAmmo(2)

	self:SetHoldType(self.HoldType)
	
	self:EmitSound("weapons/tau/single0"..math.random(1,3)..".ogg")
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:GetOwOner():SetAnimation( PLAYER_ATTACK1 )
	self.SpinSpeed = 7.5
	self:SetChargePower(self:GetChargePower() + self.HeatFactor)--0.023

	local owoner = self:GetOwOner()
	owoner:FireBullets({Src=owoner:GetShootPos(), Dir=owoner:GetAimVector(), Spread=Vector(0, 0, 0), Num=self.Primary.NumShots, Damage=self.Primary.Damage, Force=self.Primary.KnockbackScale, TracerName =self.TracerName, Callback=self.BulletCallback, HullSize=self.Primary.HullSize, IgnoreEntity=team.GetPlayers(owoner:Team()), Distance=self.Primary.MaxDistance})

	if not self.SecondaryFireFrame then
		owoner:SetVelocity((-75 * BMSWEP.GaussPushScale or 1) * self.SpinSpeed/5 * owoner:GetAimVector())
	end

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	self:SetNextPrimaryFire(CurTime()+0.2)
end

function SWEP:ScaleChargeAnim()
	self:SendWeaponAnim(ACT_GAUSS_SPINCYCLE)
	self:GetOwOner():GetViewModel():SetPlaybackRate(self.ChargeAnimSpeed)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:GetPrimaryAmmoCount()
	return self:GetOwOner():GetAmmoCount(self.Primary.Ammo)
end

function SWEP:CanPrimaryAttack()
	return not self:GetCharging() and not self:GetOverheated() and self:GetNextPrimaryFire() <= CurTime() and self.NextAttack <= CurTime() and self:GetPrimaryAmmoCount() >= 2
end 

function SWEP:CanSecondaryAttack()
	return self:GetNextPrimaryFire()<=CurTime() and self.NextAttack <= CurTime() and self:GetPrimaryAmmoCount() >= 2
end

local taudmg = 0
function SWEP:Think()
	local ischarging = self:GetCharging()
	if self:GetOwOner() and self:GetOwOner():IsValid() then
		if not ischarging then
			self.TauChargeSound:Stop()
		end
		if ischarging then
			self.TauChargeSound:PlayEx(1, 100 + CurTime() % 1)
			self:SetChargePower(self:GetChargePower() + FrameTime() * self.PowerAccumulation) --0.105
		else
			if self:GetChargePower() <= 0.0 then self:SetHolding(false) self:SetOverheated(false) end
			if (self:GetNextPrimaryFire() < CurTime()-1.1) then
				self:SetChargePower(self:GetChargePower() - FrameTime() * 0.7)
			end
		end
		
		if self.SpinSpeed <= self:GetChargePower() * 20 and ischarging then
			self.SpinSpeed = self:GetChargePower() * 20
		end
		
		if ischarging and self:GetChargePower() >= 0.5 then
			self.TauOverChargeSound:PlayEx(1, 100 + CurTime() % 1)
			if not self.FullyCharged then
				self:EmitSound("weapons/tau/gauss_charged.ogg", SNDLVL_NORM, 100, 0.9, CHAN_ITEM)
				self.FullyCharged = true
			end
		else
			self.TauOverChargeSound:Stop()
			self.FullyCharged = false
		end
	end

	if CLIENT then
		if (self:GetOwOner():KeyPressed(IN_ATTACK) or self:GetOwOner():KeyDown(IN_ATTACK)) and self:GetPrimaryAmmoCount() >= 2 and not (self.NextAttack >= CurTime()) then
			self.SpinSpeed = 3.25
		end
		self:DoSpin()
	end

	if IsFirstTimePredicted() then
		if not self:GetOwOner():KeyDown(IN_ATTACK2) and ischarging then
			self:SetCharging(false)
			self:SendWeaponAnim( ACT_VM_IDLE )
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
	end
	
	if ischarging then
		self:AmmoLogic()
		taudmg = self.Primary.Damage * ((1.35 + (self:GetPower() / 75)) * (1 + self:GetChargePower()))
		self:SetHoldType(self.HoldType)
	--[[else
		if self:GetChargePower() == 0 then
			self:HandleSprint()
		end
		]]
	end

	if not self:GetOverheated() and self:GetHolding() and not ischarging --[[and self:CanSecondaryAttack()]] and self:GetChargePower() >= 0.01 then -- When key has released so tau will the animation to alt attack.
		if self:GetChargePower() >= 0.5 then
			self:SendWeaponAnim(ACT_VM_RELEASE)
			self:GetOwOner():EmitSound("weapons/tau/single_overcharged01.ogg")
			self:SetChargePower(0.05)
			print("Done")
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		elseif self:GetChargePower() then
			print("Done")
			self:SendWeaponAnim( ACT_VM_SECONDARYATTACK)
			self:GetOwOner():EmitSound("weapons/tau/single01.ogg")
			self:SetChargePower(0.05)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
		end
		self:SetNextPrimaryFire(CurTime() + 0.1 * self:GetChargePower()) 
		self:SetCharging(false)

		local owoner = self:GetOwOner()
		owoner:FireBullets({Src=owoner:GetShootPos(), Dir=owoner:GetAimVector(), Spread=Vector(0, 0, 0), Num=self.Primary.NumShots, Damage=taudmg, Force=self.Primary.KnockbackScale, TracerName=self.TracerName, Callback=self.BulletCallback, HullSize=self.Primary.HullSize, IgnoreEntity=team.GetPlayers(owoner:Team()), Distance=self.Primary.MaxDistance})
		self:GetOwOner():ViewPunch(12 * self.SpinSpeed * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))
		self:SetPower(0)
		if not self.SecondaryFireFrame then
			owoner:SetVelocity((-75 * BMSWEP.GaussChargePushScale or 1) * self.SpinSpeed/1.5 * owoner:GetAimVector())
		end
		self:SetOverheated(true)
		self.TauChargeSound:Stop()
		self.TauOverChargeSound:Stop()
	end

	if self:GetHolding() and ischarging and self:GetChargePower() >= 1 and IsValid(self:GetOwOner()) --[[and not self.Exploded]] then
		self:SetChargePower(self:GetChargePower() and 1 or 0)
		self:GetOwOner():EmitSound("weapons/tau/gauss_overcharged.ogg")
		self:SetCharging(false)
		self:SendWeaponAnim(ACT_VM_RELEASE)
		self.TauChargeSound:Stop()
		self.TauOverChargeSound:Stop()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		if SERVER then
			self:OnOvercharge(self:GetOwOner(), 65, DMG_DISSOLVE, self:GetOwOner(), self)
		end
	--	self.Exploded = true
	end

	if not ischarging then
		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
end

function SWEP:Reload()
end

function SWEP:AmmoLogic()
	if (self:GetChargePower()>=0.01) and not  (self:GetChargePower()>=0.03)  then
		self:TakePrimaryAmmo(1)
		self:SetPower(self:GetPower() + 1)
	end
end

function SWEP:TakePrimaryAmmo(amount)
	if SERVER then
		self:GetOwOner():RemoveAmmo(amount, self.Primary.Ammo)
	end
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	if not self:GetCharging() and self:GetChargePower() <= 0 then
		self:ScaleChargeAnim()
		self:SetCharging(true)
		self:SetHolding(true)
	end
end

function SWEP:OnRemove()
	self.TauChargeSound:Stop() 
	self.TauOverChargeSound:Stop()	
	self.TauPickUpSound:Stop()
end

function SWEP:Holster(wep)
	self:SetCharging(false)
	self:SetHolding(false)
	self.TauChargeSound:Stop() 
	self.TauOverChargeSound:Stop()
	self.TauPickUpSound:Stop()
	self.NextAttack = 0
	self:GetOwOner():StopSound("weapons/gluon/wpn_tesla_idle_d.wav")
	self:GetOwOner():StopSound("weapons/gluon/tesla_switch_flip_on.mp3")
	if CLIENT then
		self:Anim_Holster()
	end
	return true
end

function SWEP:SendWeaponAnimation()
end