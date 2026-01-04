AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "MP7A1"
SWEP.Category = "Landis: Guns"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Enum = {}
SWEP.Enum.WeaponType = Plutonic.Enum.WeaponType.SubmachineGun

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/horizons_weapons/latest/w_mp7ad.mdl")

SWEP.ViewModel = Model("models/weapons/tfa_ins2/c_mp7.mdl")
SWEP.ViewModelFOV = 62
SWEP.ViewModelOffset = Vector(0, 0, -1)

SWEP.BarrelLength = 9.3
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "Weapon_SMG1.FireSound",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {
		")weapons/mp7/mp7_fp.wav"
	}
})

sound.Add({
	name = "Weapon_SMG1.FireSoundW",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {
		")weapons/mp7/mp7_tp.wav"
	}
})


sound.Add({
	name = "Weapon_SMG1.FireSoundSupp",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = {95, 105},
	sound = {
		")weapons/mp7/mp7_suppressed_fp.wav"
	}
})

sound.Add({
	name = "Weapon_SMG1.FireSoundSuppW",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = {95, 105},
	sound = {
		")weapons/mp7/mp7_suppressed_tp.wav"
	}
})
SWEP.Primary.Sound =  Sound("Weapon_SMG1.FireSound")
SWEP.Primary.Sound_World = Sound("Weapon_SMG1.FireSoundW")

SWEP.Primary.Recoil = 0.23 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.RecoilRecoveryRate = 1
SWEP.IronsightsFireActivity = ACT_VM_PRIMARYATTACK_1
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.028
SWEP.Primary.Delay = Plutonic.FireRate.RPM(870)
SWEP.Primary.Shell = "ShellEject"
SWEP.Primary.ShellScale = 1.5
SWEP.Primary.ShellAttachment = 2
SWEP.Primary.RecoilUp = .5
SWEP.Primary.RecoilDown = .5
SWEP.Primary.RecoilSide = .56

SWEP.Primary.StartFalloff = 1200
SWEP.Primary.FallOff = 1800

SWEP.Primary.PenetrationScale = 0.89

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.65 -- multiply
SWEP.Spread.CrouchMod = 0.65 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.1 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.42 -- movement speed effect on spread (additonal)

SWEP.FireModes = {
	Plutonic.Enum.FireMode.Safety,
	Plutonic.Enum.FireMode.Semi,
	Plutonic.Enum.FireMode.Auto
}

SWEP.IronsightsPos = Vector(-2.821, 0, 1.775)
SWEP.IronsightsAng = Angle(0.032, 0, 0)

SWEP.IronsightsPos_Default = Vector(-2.821, 0, 1.775)
SWEP.IronsightsAng_Default = Angle(0.032, 0, 0)

SWEP.IronsightsFOV = .9

SWEP.IronsightsPos_EOTech = Vector(-2.823, -2, 1.127)
SWEP.IronsightsAng_EOTech = Angle(0, 0, 0)

SWEP.IronsightsPos_Kobra = Vector(-2.823, -2, 1.142)
SWEP.IronsightsAng_Kobra = Angle(0, 0, 0)

SWEP.IronsightsPos_RDS = Vector(-2.823, -2, 1.17)
SWEP.IronsightsAng_RDS = Angle(0, 0, 0)

SWEP.IronsightsPos_2XRDS = Vector(-2.82, -4, 1.124)
SWEP.IronsightsAng_2XRDS = Angle(0, 0, 0)

SWEP.IronsightsPos_C79 = Vector(-2.8215, -4, -0.229 + 1)
SWEP.IronsightsAng_C79 = Angle(0, 0, 0)

SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.BlowbackPos         = Vector(0, -0, -0.0) -- Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackAngle          = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-5.5, -4, -1.65)
SWEP.CenteredAng = Angle(0.472, 0.017, 0)

SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.MuzzleAttachment = "muzzle"

SWEP.LowerPos = Vector(2.72, 0, 0.6)
SWEP.LowerAngles = Angle(-9.801, 23.6, -6.2)

SWEP.ReloadAttach = 3

sound.Add({
	name = "Weapon_SMG.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = "smg1/smg1_fire1.wav"
})

SWEP.ReloadProceduralCameraFrac = .2
function SWEP:GetReloadAnimation(pos, ang)
	local vm = self.Owner:GetViewModel()

	local bone = "mp7_mag"

	local tag_view = vm:GetBonePosition(vm:LookupBone(bone))

	local view = (tag_view-pos):GetNormalized():Angle() 

	return view
end

SWEP.ModificationStation = {
	Icon = Material("vgui/hud/tfa_ins2_mp7"),
	YOffset = -3,
	Size = { 192, 96 },
	Offset = Vector(-5, 1, -3),
	AngOffset = Vector(0, 32, 4)
}

SWEP.Modifications = {
	[Plutonic.Enum.Modification.BarrelExtension] = {
		["suppressor"] = {
			Name = "SOCOM Suppressor",
			Desc = [[A pre-combine military grade suppressor. Designed for maximum durability
while maintaining an extremely quiet and low profile.]],
		}
	},
	[Plutonic.Enum.Modification.Optic] = {
		["holosight"] = {
			Name = "EOTech Holographic Sight",
			Desc = [[A holographic sight designed for close quarters combat.]],
			Icon = Material("entities/sandstorm_si_eotech_exps.png"),
			Cost = {"att_holosight", 1}
		},
		["kobra_sight"] = {
			Name = "Kobra Sight",
			Desc = [[A Russian red dot sight.]],
			Icon = Material("entities/sandstorm_si_kobra.png"),
			Cost = {"att_optic_kobra", 1}
		},
		["rds"] = {
			Name = "RDS Sight",
			Desc = [[A red dot sight.]],
			Icon = Material("entities/sandstorm_si_rds.png"),
			Cost = {"att_optic_rds", 1}
		},
		["holosight_2x"] = {
			Name = "2x Holographic Sight",
			Desc = [[A 2x magnified red dot sight.]],
			Icon = Material("entities/sandstorm_si_eotech_exps.png"),
			Cost = {"att_optic_2xrds", 1}
		},
		["aimpoint"] = {
			Name = "aim potont",
			Desc = [[A holographic sight designed for close quarters combat.]],
			Icon = Material("entities/sandstorm_si_eotech_exps.png"),
			Cost = {"att_holosight", 1}
		},
		["c79"] = {
			Name = "C79 Sight",
			Desc = [[A 3.4x magnified sight.]],
			Icon = Material("entities/sandstorm_si_c79.png"),
			Cost = {"att_optic_c79", 1}
		}
	}
}


SWEP.CanModify = true

SWEP.Attachments = {
	holosight = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_eotech.mdl",
			Bone = "A_Optic",
			Pos = Vector(0,0,0),
			Ang = Angle(0, 0, 90),
			Scale = .75,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_eotech.mdl",
			Bone = "ATTACH_laser",
			BoneMerge = true,
			Offset = Vector(-1,0,5),
			AngOffset = Vector(90,180,90),
			Scale = .75,
			Skin = 0
		},
		Reticule = {
			Size = 1,
			Pos = Vector(45, 0, 0),
			Material = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/eotech_reticle")
		},
		ModSetup = function(e)
			e.IronsightsPos = e.IronsightsPos_EOTech
			e.IronsightsAng = e.IronsightsAng_EOTech
		end,
		ModCleanup = function(e)
			e.IronsightsPos = e.IronsightsPos_Default
			e.IronsightsAng = e.IronsightsAng_Default
		end,
		Behavior = "1x_Sight"
	},
	rds = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_ismc_optic_micro_t1.mdl",
			Bone = "A_Optic",
			Pos = Vector(0,0,0),
			Ang = Angle(0, 0, 90),
			Scale = .75,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_ismc_optic_micro_t1.mdl",
			Bone = "ATTACH_laser",
			BoneMerge = true,
			Offset = Vector(-1,0,5),
			AngOffset = Vector(90,180,90),
			Scale = .75,
			Skin = 0
		},
		Reticule = {
			Size = 2,
			Pos = Vector(0, 1.26, 600),
			Material = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/eotech_reticle")
		},
		ModSetup = function(e)
			e.IronsightsPos = e.IronsightsPos_RDS
			e.IronsightsAng = e.IronsightsAng_RDS
		end,
		ModCleanup = function(e)
			e.IronsightsPos = e.IronsightsPos_Default
			e.IronsightsAng = e.IronsightsAng_Default
		end,
		Behavior = "1x_Sight"
	},
	aimpoint = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",
			Bone = "A_Optic",
			Pos = Vector(0,0,0),
			Ang = Angle(0, 0, 90),
			Scale = .8,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",
			Bone = "ATTACH_laser",
			Offset = Vector(-1,0,0),
			AngOffset = Vector(90,180,90),
			Scale = .8,
			Skin = 0
		},
		Reticule = {
			Size = 16,
			Pos = Vector(-24, 4, 0) ,
			Material = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/eotech_reticle")
		},
		ModSetup = function(e)
			e.IronsightsPos = e.IronsightsPos_C79
			e.IronsightsAng = e.IronsightsAng_C79
		end,
		ModCleanup = function(e)
			e.IronsightsPos = e.IronsightsPos_Default
			e.IronsightsAng = e.IronsightsAng_Default
		end,
		Behavior = "1x_Sight"
	},
	kobra_sight = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_kobra.mdl",
			Bone = "A_Optic", 
			Pos = Vector(0, -.2,0),
			Ang = Angle(0, 0, 90),
			Scale = 1,
			BoneMerge = false,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_kobra.mdl",
			Bone = "ATTACH_laser",
			BoneMerge = true,
			Offset = Vector(-1,0,5),
			AngOffset = Vector(90,180,90),
			Scale = .75,
			Skin = 0
		},
		Reticule = {
			Size = 2,
			Pos = Vector(0, 1.35, 60),
			Material = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/kobra_reticle")
		},
		ModSetup = function(e)
			e.IronsightsPos = e.IronsightsPos_Kobra
			e.IronsightsAng = e.IronsightsAng_Kobra
		end,
		ModCleanup = function(e)
			e.IronsightsPos = e.IronsightsPos_Default
			e.IronsightsAng = e.IronsightsAng_Default
		end,
		Behavior = "1x_Sight"
	},
	holosight_2x = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_aimp2x.mdl",
			Bone = "A_Optic", 
			Pos = Vector(0, -.2,0),
			Ang = Angle(0, 0, 90),
			Scale = 1,
			BoneMerge = false,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_kobra.mdl",
			Bone = "ATTACH_laser",
			BoneMerge = true,
			Offset = Vector(-1,0,5),
			AngOffset = Vector(90,180,90),
			Scale = .75,
			Skin = 0
		},
		Reticule = {
			Size = 2,
			Pos = Vector(0, 1.35, 60),
			Material = Material("models/weapons/insurgency_sandstorm/ins2_sandstorm/kobra_reticle")
		},
		ModSetup = function(e)
			e.IronsightsPos = e.IronsightsPos_Kobra
			e.IronsightsAng = e.IronsightsAng_Kobra
		end,
		ModCleanup = function(e)
			e.IronsightsPos = e.IronsightsPos_Default
			e.IronsightsAng = e.IronsightsAng_Default
		end,
		Behavior = "1x_Sight",
		RenderOverride = function(self, vm, att)

		end
	},
	laser = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/sandstorm_flashlight_laser_rail.mdl",
			Bone = "A_LaserFlashlight",
			Pos = Vector(),
			Ang = Angle(),
			Scale = .8,
			Skin = 0
		},
		ModSetup = function(e)
		end,
		ModCleanup = function(e)
		end,
		Behavior = "dummy"
	},
	suppressor = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/sandstorm_suppressor_sec.mdl",
			Bone = "A_Suppressor",
			Pos = Vector(0,0, 0),
			Ang = Angle(0, 0, 0),
			Scale = .8,
			Skin = 0
		},
		WorldCosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/sandstorm_suppressor_sec.mdl",
			Bone = "ATTACH_Muzzle",
			Offset = Vector(0,0,0),
			AngOffset = Vector(0,0,-90),
			Scale = 1,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Sound = Sound("Weapon_SMG1.FireSoundSupp")
			e.Primary.Sound_World = Sound("Weapon_SMG1.FireSoundSuppW")
			e.MuzzleEffect = "muzzleflash_suppressed"
			e.MuzzleFlashAttachment = "muzzle_supp"
		end,
		ModCleanup = function(e)
			e.Primary.Sound = Sound("Weapon_SMG1.FireSound")
			e.Primary.Sound_World = Sound("Weapon_SMG1.FireSoundW")
			e.MuzzleEffect = "muzzleflash_4"
			e.MuzzleFlashAttachment = "muzzle"
		end,
		Behavior = "silencer"	
	}
}