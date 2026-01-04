function SWEP:ClipPercent()
	return self:Clip1() / self.Primary.ClipSize
end

Plutonic.Enum.WeaponType = {
	SubmachineGun = 1,
	AutomaticRifle = 2,
	MarksmanRifle = 3,
	Pistol = 5,
	Sniper = 6,
	Shotgun = 7
}

local indicatorIO = {}
indicatorIO[Plutonic.Enum.WeaponType.SubmachineGun] = {
	[1] = function(self)
		local cp = self:ClipPercent()

		return cp <= 0.4, 1 - (cp / 0.4)
	end,
	[2] = "Plutonic.SMG_LowAmmo",
	[3] = "Plutonic.SMG_Dry"
}

indicatorIO[Plutonic.Enum.WeaponType.Pistol] = {
	[1] = function(self)
		local cp = self:ClipPercent()

		return cp <= 0.6, 1 - (cp / 0.6)
	end,
	[2] = "Plutonic.Pistol_LowAmmo",
	[3] = "Plutonic.Pistol_Dry"
}

indicatorIO[Plutonic.Enum.WeaponType.AutomaticRifle] = {
	[1] = function(self)
		local cp = self:ClipPercent()

		return cp <= 0.4, 1 - (cp / 0.4)
	end,
	[2] = "Plutonic.Rifle_LowAmmo",
	[3] = "Plutonic.Rifle_Dry"
}

function SWEP:ShouldPlayAmmoIndicator()
	return false
end

--indicatorIO[self.Enum.WeaponType][1](self)
function SWEP:PlayAmmoIndicator()
	if not self.Enum then return end
	if not self.Enum.WeaponType then return end
	local bShouldPlay, fVolume = self:ShouldPlayAmmoIndicator()
	if bShouldPlay then
		local snd = indicatorIO[self.Enum.WeaponType][2]
		if self:Clip1() <= 0 then
			snd = indicatorIO[self.Enum.WeaponType][3]
			fVolume = 1
		end

		self.GonnaAdjustVol = true
		self.RequiredVolume = fVolume
		self:EmitSound(snd, nil, nil, fVolume, SND_CHANGE_VOL)
	end
end