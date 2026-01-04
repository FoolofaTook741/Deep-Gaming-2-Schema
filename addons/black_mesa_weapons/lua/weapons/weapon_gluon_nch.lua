AddCSLuaFile()

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 75

	killicon.Add("weapon_gluon_wal", "killicons/weapon_gluon_wal", Color(255,127,39))
end

SWEP.PrintName = "Gluon Cannon"
SWEP.Author = "Wallace"
SWEP.Category = "BMS Weapons (NO c_hands)"

SWEP.Spawnable = true

SWEP.Base = "weapon_base_wal_re"

SWEP.ViewModel = "models/weapons/bms_wal/v_egon.mdl"
SWEP.WorldModel = "models/weapons/bms_wal/w_egon.mdl"
SWEP.UseHands		= true
SWEP.IsAlwaysRaised = true

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "energyammo"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo = ""

SWEP.Primary.MaxDistance = 2048

SWEP.TracerName = "egon_tracer"

SWEP.ConeMax = 0.001
SWEP.ConeMin = 0.001

SWEP.HoldType = "physgun"
SWEP.HoldTypeSprint = "passive"

SWEP.ForceToIdle = true
SWEP.NextAttack = 0
function SWEP:Initialize()
	self.FiringSound = CreateSound(self, "weapons/gluon/special1.wav")
	self.FiringSound:SetSoundLevel(85)
	self:SetHoldType(self.HoldType)

	if BMSWEP and BMSWEP.DisablePickUpAnimations then return end

	timer.Simple(0, function() -- move it to next frame
		if not self:GetOwOner().FirstPickUpEgon then
			self:SendWeaponAnim( ACT_VM_PICKUP )
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self.NextAttack = CurTime() + 4.33 -- crap
			self:GetOwOner().FirstPickUpEgon = true
		end
	end)
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetPrimaryAmmoCount() < 1 then return end

	self:SetHoldType(self.HoldType)

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self:GetOwOner():RemoveAmmo(1, self.Primary.Ammo)
	end

	local owoner = self:GetOwOner()
	owoner:FireBullets({Src=owoner:GetShootPos(), Dir=owoner:GetAimVector(), Spread=Vector(0, 0, 0), Num=self.Primary.NumShots, Damage=self.Primary.Damage, Force=self.Primary.KnockbackScale, TracerName=self.TracerName, Callback=self.BulletCallback, HullSize=self.Primary.HullSize, IgnoreEntity=team.GetPlayers(owoner:Team()), Distance=self.Primary.MaxDistance})

	if self:GetGunMode() ~= 1 then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK)
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		if IsFirstTimePredicted() then
			if CLIENT then
				util.ScreenShake( Vector(0, 0, 0), 5, 5, 0.6, 512 )
			end
		end
		self:SetGunMode(1)
	end
end

function SWEP:GetPrimaryAmmoCount()
	return self:GetOwOner():GetAmmoCount(self.Primary.Ammo)
end

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoCount() < 1 then return end
	if not (self.NextAttack <= CurTime()) then return end
	
	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
	self.FiringSound:Stop()
end

function SWEP:Holster(wep)
	self.FiringSound:Stop()
	return true
end

function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:SendWeaponAnim(ACT_VM_IDLE)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	return true
end

function SWEP:SetGunMode(mode)
	self:SetDTInt(1, mode)
end

function SWEP:GetGunMode(mode)
	return self:GetDTInt(1)
end

function SWEP:SendWeaponAnimation()
end

function SWEP:Think()
	if self:GetGunMode() == 1 and CurTime() >= self:GetNextPrimaryFire() + 0.1 then
		self:EmitSound("weapons/gluon/special2.ogg")
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:SetGunMode(0)
		self:SetNextPrimaryFire(CurTime() + 0.25)
	end

	if not (self:GetGunMode() == 1) then
		self:HandleSprint()
	end

	local owoner = self:GetOwOner()
	if owoner and owoner:IsValid() then
		local frametime = FrameTime()
		if self:GetGunMode() == 1 then
			self.FiringSound:PlayEx(1, 100 + CurTime() % 1)
		else
			self.FiringSound:Stop()
		end
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	if dmginfo then
		dmginfo:SetDamageType( bit.bor( DMG_ENERGYBEAM, DMG_DISSOLVE ) )
	end

	local e = EffectData()
	e:SetOrigin(tr.HitPos)
	e:SetMagnitude(1)
	e:SetScale(1)
	util.Effect("hit_egon", e)

	if tr.HitWorld then
		if SERVER then
			for _, ent in pairs(ents.FindInSphere(tr.HitPos, 16)) do
				if ent == attacker then
					dmginfo:SetDamage(dmginfo:GetDamage() * 0.5)
					dmginfo:SetAttacker(attacker)
					dmginfo:SetInflictor(attacker:GetActiveWeapon())
					ent:TakeDamageInfo(dmginfo)
				end
			end
		end
		util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
end