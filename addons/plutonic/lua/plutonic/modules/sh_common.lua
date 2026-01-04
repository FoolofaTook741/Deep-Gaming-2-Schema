Plutonic.Common = {}
Plutonic.Common.Category = "Landis: Guns"
Plutonic.Common.Tracer = "Tracer"
Plutonic.Common.MuzzleEffect = "muzzleflash_1"
Plutonic.WeaponSounds = Plutonic.WeaponSounds or {}
Plutonic.AddWeaponSound = function(name, path, type, volume, pitch)
	type = type or "Generic"
	volume = volume or 1
	pitch = pitch or 100
	sound.Add(
		{
			name = name,
			channel = CHAN_WEAPON,
			volume = volume,
			level = Plutonic.Enum.Sound[type],
			pitch = pitch,
			sound = path
		}
	)
end