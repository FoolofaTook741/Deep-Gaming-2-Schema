sound.Add(
	{
		name = "Plutonic.SMG_LowAmmo",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 60,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_indicator_smg.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.SMG_Dry",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 88,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_dry_smg.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Pistol_LowAmmo",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 60,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_indicator_handgun.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Pistol_Dry",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 88,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_dry_handgun.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Shotgun_LowAmmo",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 60,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_indicator_shotgun.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Shotgun_Dry",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 88,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_dry_shotgun.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Rifle_LowAmmo",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 60,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_indicator_ar.wav"
	}
)

sound.Add(
	{
		name = "Plutonic.Rifle_Dry",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 88,
		pitch = {95, 105},
		sound = "weapons/tfa/lowammo_dry_ar.wav"
	}
)

-- based off of TFA base
Plutonic.Hooks.Add(
	"EntityEmitSound",
	function(soundData)
		local ent = soundData.Entity
		local modified
		local weapon
		if ent:IsWeapon() then
			weapon = ent
		elseif ent:IsNPC() or ent:IsPlayer() then
			weapon = ent:GetActiveWeapon()
		end

		if IsValid(weapon) and weapon.IsPlutonic then
			if weapon.GonnaAdjuctPitch then
				soundData.Pitch = soundData.Pitch * weapon.RequiredPitch
				weapon.GonnaAdjuctPitch = false
				modified = true
			end

			if weapon.GonnaAdjustVol then
				soundData.Volume = soundData.Volume * weapon.RequiredVolume
				weapon.GonnaAdjustVol = false
				modified = true
			end
		end

		return modified
	end
)