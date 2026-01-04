AddCSLuaFile()

SWEP.Base = "plutonic_base"
SWEP.Charged = false

function SWEP:CanShoot()
	return self:CanPrimaryAttack() and 
	not self:GetBursting() and 
	not (self.LoweredPos and self:IsSprinting()) and 
	self:GetReloadTime() < CurTime() and 
	self.Charged
end

function SWEP:PrimaryAttack()
	if not self:CanShoot() then return end

	local clip = self:Clip1()

	if self.Primary.Burst and clip >= 3 then
		self:SetBursting(true)
		self.Burst = 3

		local delay = CurTime() + ((self.Primary.Delay * 3) + (self.Primary.BurstEndDelay or 0.3))
		self:SetNextPrimaryFire(delay)
		self:SetReloadTime(delay)
	elseif clip >= 1 then

		if self:GetClass() == "plutonic_apfgun" and self.Mode == 2 then
			if self:Clip1() < 20 then
				self:SetClip1(0)
			else
				self:TakePrimaryAmmo(20)
			end
		elseif self:GetClass() == "plutonic_apfgun" and self.Mode == 1 then
			if self:Clip1() < 3 then
				self:SetClip1(0)
			else
				self:TakePrimaryAmmo(2)
			end
		else
			self:TakePrimaryAmmo(1)
		end

		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self:CalculateSpread())

		self:AddRecoil()
		self:ViewPunch()

		if self.Primary.Sound_World then
			if CLIENT then 
				local owner = self:GetOwner()
				if owner == LocalPlayer() then
					local shouldPlay = impulse and impulse.GetSetting("view_thirdperson", false)

					if shouldPlay == false then
						self:EmitSound(self.Primary.Sound, nil, nil, nil, CHAN_STATIC, SND_NOFLAGS, 0)
					end
				end 
			end
			if SERVER then self:EmitWorldSound(self.Primary.Sound_World) end
		else
			self:EmitSound(self.Primary.Sound, nil, nil, nil, CHAN_WEAPON, nil, 1)
		end
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetReloadTime(CurTime() + self.Primary.Delay)
	else
		self:EmitSound(self.EmptySound)
		self:Reload()
		self:SetNextPrimaryFire(CurTime() + 1)
	end
end

SWEP.IsChargeUp = true
SWEP.ChargingShot = false
SWEP.Primary.ChargeTime = 1


function SWEP:OnChargeStateChanged(state)
end

hook.Add("StartCommand", "Plutonic_StartCommand", function(ply, cmd)
	if not IsValid(ply) or not ply:Alive() then return end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.IsPlutonic then return end

	if wep.IsChargeUp then
		if cmd:KeyDown(IN_SPEED) then
			wep.ChargeTime = 0
			wep.ChargingShot = false
			return
		end
		if cmd:KeyDown(IN_ATTACK) and not wep.ChargingShot then
			wep.ChargeTime = CurTime()
			wep.ChargingShot = true
			wep:OnChargeStateChanged(true)
			if not wep.Primary.Automatic then
				cmd:RemoveKey(IN_ATTACK)
			end
		elseif not cmd:KeyDown(IN_ATTACK) and wep.ChargingShot then
			wep.ChargeTime = 0
			wep.ChargingShot = false
			wep:OnChargeStateChanged(false)
		end
	end
end)

function SWEP:ChargeThink()
	if not self.IsChargeUp then return end

	if self.ChargingShot then
		local charge = math.Clamp((CurTime() - self.ChargeTime) / self.Primary.ChargeTime, 0, 1)
		self.Charged = charge >= 1
		self.Charge = charge
	end
end

function SWEP:Think()

	if CLIENT then
		self:ViewmodelThink()
	end

	self:ChargeThink()
	self:IronsightsThink()
	self:RecoilThink()
	self:IdleThink()
	if self.CustomThink then
		self.CustomThink(self)
	end

	if self:GetBursting() then self:BurstThink() end
	if self:GetReloading() then self:ReloadThink() end

	if not CLIENT then
		return
	end
end

print("loaded!")