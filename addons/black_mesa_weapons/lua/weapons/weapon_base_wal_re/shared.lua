
-- Variables that are used on both client and server

SWEP.PrintName		= "Scripted Weapon" -- 'Nice' Weapon name (Shown on HUD)
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= 8			-- Size of a clip
SWEP.Primary.DefaultClip	= 32		-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Delay			= 0.75
SWEP.Primary.NumShots		= 1

SWEP.Secondary.NumShots		= 1
SWEP.Secondary.ClipSize		= 8			-- Size of a clip
SWEP.Secondary.DefaultClip	= 32		-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false		-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"
SWEP.Secondary.Delay		= 0.5

SWEP.ConeMax = 0.075
SWEP.ConeMin = 0.05
SWEP.ConeRamp = 2

SWEP.HoldType = "pistol"
SWEP.HoldTypeSprint = "normal"

SWEP.NextAttack = 0
SWEP.DryFireSound = Sound("Weapon_Pistol.Empty")

function SWEP:SetupDataTables() -- cursed tables, but okay we will deal with that avesome desync
	self:NetworkVar("Bool", 20, "Ironsights")
	self:NetworkVar("Int", 20, "FireMode")
	self:NetworkVar("Float", 20, "NextReload")
	self:NetworkVar("Float", 21, "ReloadStart")
	self:NetworkVar("Float", 23, "ReloadFinish")
	self:NetworkVar("Float", 24, "SwitchDelay") -- special delay between firemodes
	self:NetworkVar("Float", 25, "MuzzleLight") -- bad
end

--[[---------------------------------------------------------
	Name: SWEP:Initialize()
	Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	if CLIENT then
		self:InitSCK()
	end
end

--[[---------------------------------------------------------
	Name: SWEP:PrimaryAttack()
	Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self:GetPrimaryAmmoCount() < 1 then return end

	local owoner = self:GetOwOner()
	self:ShootEffects()
	self:SetHoldType(self.HoldType)
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self:EmitSound(self.Primary.Sound)

	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:CreateMuzzleFlash()
end

function SWEP:GetCone()
	local owoner = self:GetOwOner()
	if not owoner:OnGround() or self.ConeMax == self.ConeMin then return self.ConeMax end

	local basecone = self.ConeMin
	local conedelta = self.ConeMax - basecone

	local multiplier = math.min(owoner:GetVelocity():Length() / 200, 1) * 0.5
	if not owoner:Crouching() then multiplier = multiplier + 0.25 end
	if not self:GetIronsights() then multiplier = multiplier + 0.25 end

	return basecone + conedelta * multiplier ^ self.ConeRamp
end

--[[---------------------------------------------------------
	Name: SWEP:SecondaryAttack()
	Desc: +attack2 has been pressed
-----------------------------------------------------------]]
--[[
function SWEP:SecondaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	-- Play shoot sound
	self:EmitSound("Weapon_Shotgun.Single")

	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet( 150, 9, 0.2, self.Secondary.Ammo )

	-- Remove 1 bullet from our clip
	self:TakeSecondaryAmmo( 1 )

	-- Punch the player's view
	if ( !self:GetOwOner():IsNPC() ) then self:GetOwOner():ViewPunch( Angle( -10, 0, 0 ) ) end

end
]]

--[[---------------------------------------------------------
	Name: SWEP:Reload()
	Desc: Reload is being pressed
-----------------------------------------------------------]]
--[[
function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
end
]]
--[[---------------------------------------------------------
	Name: SWEP:Think()
	Desc: Called every frame
-----------------------------------------------------------]]
SWEP.IdleActivity = ACT_VM_IDLE
function SWEP:Think()
	self:HandleSprint()
	self.SubThink()

	if not pickupfix then
		local weapon = tostring(self:GetClass().."_pick") 
		if not self:GetOwOner().weapon then
			self:SendWeaponAnim( ACT_VM_PICKUP )
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			pickupfix = true
		end
	end

	if CLIENT then
		self:ClientThink()
	end
	if SERVER then
		self:ServerThink()
	end
	if self:GetReloadFinish() > 0 then
		if CurTime() >= self:GetReloadFinish() then
			self:FinishReload()
		end
	elseif self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil -- CurTime() + self:SequenceDuration()
		self:SendWeaponAnim(self.IdleActivity)
	end
end

function SWEP:SubThink()
end

--[[---------------------------------------------------------
	Name: SWEP:Holster( weapon_to_swap_to )
	Desc: Weapon wants to holster
	RetV: Return true to allow the weapon to holster
-----------------------------------------------------------]]
function SWEP:Holster( wep )
	self.NextAttack = 0
	self:SetNextReload(0)
	self:SetReloadFinish(0)
	self:StopPickUpSND()
	--self:SendWeaponAnim(ACT_VM_HOLSTER)
	self:SetIronsights(false)
	if CLIENT and IsValid(self:GetOwOner()) then
		local vm = self:GetOwOner():GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

SWEP.PickupSound = nil
function SWEP:StopPickUpSND()
	if self.PickupSound then
		self:StopSound(self.PickupSound)
	end
end
--[[---------------------------------------------------------
	Name: SWEP:Deploy()
	Desc: Whip it out
-----------------------------------------------------------]]
function SWEP:Deploy()
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self:SetIronsights(false)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	return true
end

--[[---------------------------------------------------------
	Name: SWEP:ShootEffects()
	Desc: A convenience function to create shoot effects
-----------------------------------------------------------]]
function SWEP:ShootEffects()
	--self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )		-- View model animation
	self:GetOwOner():MuzzleFlash()						-- Crappy muzzle light
	self:GetOwOner():SetAnimation( PLAYER_ATTACK1 )		-- 3rd Person Animation
end

--[[---------------------------------------------------------
	Name: SWEP:ShootBullet()
	Desc: A convenience function to shoot bullets
-----------------------------------------------------------]]
--[[]
function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= self:GetOwOner():GetShootPos()			-- Source
	bullet.Dir		= self:GetOwOner():GetAimVector()			-- Dir of bullet
	bullet.Spread	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 5						-- Show a tracer on every x bullets
	bullet.Force	= force || 1						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	self:GetOwOner():FireBullets( bullet )

	self:ShootEffects()

end
]]
function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
--	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:ShootBullets(dmg, numbul, cone)
	local owoner = self:GetOwner()
	self:SendWeaponAnimation()
	self:CreateMuzzleFlash()
	self.SkipAnimation = true
	owoner:DoAttackEvent()

	self:TakePrimaryAmmo(1)
	owoner:LagCompensation(true)
	owoner:FireBullets({Src=owoner:GetShootPos(), Dir=owoner:GetAimVector(), Spread=Vector(cone, cone, 0), Num=numbul, Damage=dmg, Force=self.Primary.KnockbackScale, TracerName=self.TracerName, Callback=self.BulletCallback, HullSize=self.Primary.HullSize, IgnoreEntity=team.GetPlayers(owoner:Team()), Distance=self.Primary.MaxDistance})
	owoner:LagCompensation(false)
end
--[[---------------------------------------------------------
	Name: SWEP:TakePrimaryAmmo()
	Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakePrimaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip1() <= 0 ) then

		if ( self:Ammo1() <= 0 ) then return end

		self:GetOwOner():RemoveAmmo( num, self:GetPrimaryAmmoType() )

	return end

	self:SetClip1( self:Clip1() - num )

end

--[[---------------------------------------------------------
	Name: SWEP:TakeSecondaryAmmo()
	Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakeSecondaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip2() <= 0 ) then

		if ( self:Ammo2() <= 0 ) then return end

		self:GetOwOner():RemoveAmmo( num, self:GetSecondaryAmmoType() )

	return end

	self:SetClip2( self:Clip2() - num )

end

--[[---------------------------------------------------------
	Name: SWEP:CanPrimaryAttack()
	Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	if self:GetReloadFinish() > 0 then return false end
	if not (self.NextAttack <= CurTime()) then return end


	if (self:Clip1() < 1) and self:CanReload() then
		self:Reload()
		return false
	end

	if self:Clip1() < 1 then
		self:EmitSound(self.DryFireSound)
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
--[[---------------------------------------------------------
	Name: SWEP:CanSecondaryAttack()
	Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]

function SWEP:CanSecondaryAttack()
	if self:GetReloadFinish() > 0 then return false end
	if not (self.NextAttack <= CurTime()) then return end


	if (self:Clip2() < 1) and self:CanReload() then
		self:Reload()
		return false
	end

	if self:Clip2() < 1 then
		self:EmitSound(self.DryFireSound)
		self:SetNextSecondaryFire(CurTime() + math.max(0.25, self.Secondary.Delay))
		return false
	end

	return self:GetNextSecondaryFire() <= CurTime()
end
--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
	self:Holster()
end

--[[---------------------------------------------------------
	Name: OwnerChanged
	Desc: When weapon is dropped or picked up by a new player
-----------------------------------------------------------]]
function SWEP:OwnerChanged()
end

--[[---------------------------------------------------------
	Name: Ammo1
	Desc: Returns how much of ammo1 the player has
-----------------------------------------------------------]]
function SWEP:Ammo1()
	return self:GetOwOner():GetAmmoCount( self:GetPrimaryAmmoType() )
end

--[[---------------------------------------------------------
	Name: Ammo2
	Desc: Returns how much of ammo2 the player has
-----------------------------------------------------------]]
function SWEP:Ammo2()
	return self:GetOwOner():GetAmmoCount( self:GetSecondaryAmmoType() )
end

--[[---------------------------------------------------------
	Name: SetDeploySpeed
	Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
-----------------------------------------------------------]]
function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

--[[---------------------------------------------------------
	Name: DoImpactEffect
	Desc: Callback so the weapon can override the impact effects it makes
		 return true to not do the default thing - which is to call UTIL_ImpactTrace in c++
-----------------------------------------------------------]]
function SWEP:DoImpactEffect( tr, nDamageType )
	return false
end

--- DIFF
--[[
function meta:GetPrimaryAmmoCount()
	return self:GetOwner():GetAmmoCount(E_GetTable(self).Primary.Ammo) + self:Clip1()
end

function meta:GetSecondaryAmmoCount()
	return self:GetOwner():GetAmmoCount(E_GetTable(self).Secondary.Ammo) + self:Clip2()
end
]]
function SWEP:GetPrimaryAmmoCount(onreload)
	local owoner = self:GetOwOner()
	local clip = self.Primary.ClipSize > 0 and self:Clip1() or 0
	local subtractclip = onreload and self:Clip1() or 0
	return IsValid(owoner) and (owoner:GetAmmoCount(self.Primary.Ammo) + clip - subtractclip) or 0
end

function SWEP:GetSecondaryAmmoCount(onreload)
	local owoner = self:GetOwOner()
	local clip = self.Secondary.ClipSize > 0 and self:Clip2() or 0 
	local subtractclip = onreload and self:Clip2() or 0
	return IsValid(owoner) and (owoner:GetAmmoCount(self.Secondary.Ammo) + clip - subtractclip) or 0
end

SWEP.ReloadSpeed = 1.0

function SWEP:CanReload()
	return self:GetNextReload() <= CurTime() and self:GetReloadFinish() == 0 and
		(
			self:GetMaxClip1() > 0 and self:Clip1() < self:GetMaxClip1() and self:GetPrimaryAmmoCount(true) > 0
			or self:GetMaxClip2() > 0 and self:Clip2() < self:GetMaxClip2() and self:GetSecondaryAmmoCount(true) > 0
		)
end

function SWEP:Reload()
	local owoner = self:GetOwOner()

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	-- Custom reload function to change reload speed.
	if self:CanReload() then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self:SetReloadStart(CurTime())

		self:SendReloadAnimation()
		self:ProcessReloadEndTime()

		owoner:DoReloadEvent()

		self:EmitReloadSound()
	end
end

function SWEP:EmitReloadSound()
	if self.ReloadSound and IsFirstTimePredicted() then
		self:EmitSound(self.ReloadSound, 75, 100, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed

	self.ReloadTime = self:SequenceDuration() / reloadspeed
	self:SetReloadFinish(CurTime() + self.ReloadTime)
	self:SetNextPrimaryFire(CurTime() + self.ReloadTime)

	if not self.DontScaleReloadSpeed then
		self:GetOwOner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

SWEP.ReloadActivity = ACT_VM_RELOAD
function SWEP:SendReloadAnimation()
	self:SendWeaponAnim(self.ReloadActivity)
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
	--self:SendWeaponAnim(self.IdleActivity or ACT_VM_IDLE)
	--self.IdleAnimation = CurTime() + self:SequenceDuration() * 0.15
	self:SetNextReload(0)
	self:SetReloadStart(0)
	self:SetReloadFinish(0)
	self.SkipAnimation = true
	self:OnFinishReload()

	local owoner = self:GetOwOner()
	if not owoner:IsValid() then return end

	local max1 = self:GetMaxClip1()
	local max2 = self:GetMaxClip2()

	if max1 > 0 then
		local ammotype = self:GetPrimaryAmmoType()
		local spare = owoner:GetAmmoCount(ammotype)
		local current = self:Clip1()
		local needed = max1 - current

		needed = math.min(spare, needed)

		self:SetClip1(current + needed)
		if SERVER then
			owoner:RemoveAmmo(needed, ammotype)
		end
	end

	if max2 > 0 then
		local ammotype = self:GetSecondaryAmmoType()
		local spare = owoner:GetAmmoCount(ammotype)
		local current = self:Clip2()
		local needed = max2 - current

		needed = math.min(spare, needed)

		self:SetClip2(current + needed)
		if SERVER then
			owoner:RemoveAmmo(needed, ammotype)
		end
	end
end

function SWEP:OnFinishReload()
end

--[[
	-- someone can say, track buttons and bla, bla, bla
	-- but, no!
]]
SWEP.NextVisThink = 0
SWEP.SpecialDelay = 0
function SWEP:HandleSprint(bodygpr) 
	if BMSWEP and BMSWEP.DisableSprintAnimations then return end
	if not (self.NextAttack <= CurTime()) then return end
	local owoner = self:GetOwOner()
	if self:GetNextPrimaryFire() >= CurTime() or self:GetReloadFinish() > 0 then return end
	if IsValid(owoner) and owoner:IsOnGround() and owoner:GetVelocity():Length() > 250 and owoner:IsSprinting() then
		if self:GetIronsights() then
			self:SetIronsights(false)
		end
		--local sp = self.SpecialDelay -- must be cached for some reason WARN add ot other weapons
		--if sp and sp <= CurTime() then -- disable whole block while we do own business
		if not self.InteredInSpeed then
			if self.IdleAnimation and not (self.IdleAnimation <= CurTime()) then
				--if self.ForceToIdle then
					self:SendWeaponAnim(self.IdleActivity)
				--end
				self:SendWeaponAnim( ACT_VM_SPRINT_ENTER)
				self:SetHoldType(self.HoldTypeSprint)
				self.IdleAnimation = CurTime() + self:SequenceDuration()
				if bodygpr and (self:GetPrimaryAmmoCount() >= 1) then
					self:GetOwOner():GetViewModel(0):SetBodygroup(2,1)
				end
				self.InteredInSpeed = true -- probably i should set it on data tables
			end
		end
		--[[ -- cringe
		if not self.CutAnims then
			self.IdleAnimation = CurTime() + self:SequenceDuration() * 0.15 -- just make faster transitions 
			self.CutAnims = true
		end
		]]
		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			--if self.ForceToIdle then
				self:SendWeaponAnim(self.IdleActivity)
			--end
			self:SendWeaponAnim(ACT_VM_SPRINT_IDLE)
			self:SetHoldType(self.HoldTypeSprint)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			if bodygpr and (self:GetPrimaryAmmoCount() >= 1) then
				self:GetOwOner():GetViewModel(0):SetBodygroup(2,1)
			end
		end
	--end
	else
		--[[
		if self.SpecialDelay <= CurTime() then -- we dont want start transitions on bhop, right?
			self.SpecialDelay = CurTime() + 0.2
		end
		]]

		if self.InteredInSpeed then
			--if self.ForceToIdle then
				self:SendWeaponAnim(self.IdleActivity)
			--end
			if not self.SkipAnimation then
				self:SendWeaponAnim(ACT_VM_SPRINT_LEAVE)
			end
			self:SetHoldType(self.HoldType)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			if bodygpr and (self:GetPrimaryAmmoCount() >= 1) then
				self:GetOwOner():GetViewModel(0):SetBodygroup(2,1)
			end
			self.SkipAnimation = nil
			self.InteredInSpeed = nil
		end
		
		--if self.ForceToIdle then
			if self.IdleAnimation and self.IdleAnimation <= CurTime() then
				self.IdleAnimation = CurTime() + self:SequenceDuration()
				self:SendWeaponAnim(self.IdleActivity)
				if bodygpr and (self:GetPrimaryAmmoCount() >= 1) then
					self:GetOwOner():GetViewModel(0):SetBodygroup(2,1)
				end
			end
		--end
	end
end