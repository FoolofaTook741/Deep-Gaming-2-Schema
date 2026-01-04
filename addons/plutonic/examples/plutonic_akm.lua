AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "AKM"
SWEP.Category = "Landis: Guns"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"
SWEP.CanModify = true
SWEP.WorldModel = Model("models/horizons_weapons/latest/w_akmg.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_ins2/v_akm.mdl")
SWEP.ViewModelFOV =  75
SWEP.ViewModelOffset = Vector(0,0,0)
SWEP.ViewModelFlip = false

SWEP.Enum = {}
SWEP.Enum.WeaponType = Plutonic.Enum.WeaponType.AutomaticRifle
SWEP.BarrelLength = 11

SWEP.SwayLevel = 1.4
SWEP.SwayRightMultiplier = 2
SWEP.SwayUpMultiplier = 2
SWEP.SwayIdle = 1
SWEP.SwayBob = 2.7

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("weapons/smg1/smg1_reload.wav")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

local path = "weapons/tfa_ins2/akm/"
local pref = "TFA_INS2.AKM"
Plutonic.AddWeaponSound = function(name, path, type, volume, pitch)
	type = type or "Generic"
	volume = volume or 1
	pitch = pitch or 100
	sound.Add({
		name = name,
		channel = CHAN_WEAPON,
		volume = volume,
		level = Plutonic.Enum.Sound[type],
		pitch = pitch,
		sound = path
	})
end


Plutonic.AddWeaponSound(pref .. ".Fp", path .. "akm_fp.wav", "GunShot")
Plutonic.AddWeaponSound(pref .. ".FpSilenced", path .. "akm_fp_silenced.wav", "GunShotSilenced")
Plutonic.AddWeaponSound(pref .. ".Boltback", path .. "handling/ak74_boltback.wav")
Plutonic.AddWeaponSound(pref .. ".Boltrelease", path .. "handling/ak74_boltrelease.wav")
Plutonic.AddWeaponSound(pref .. ".Empty", path .. "handling/ak74_empty.wav")
Plutonic.AddWeaponSound(pref .. ".MagRelease", path .. "handling/ak74_magrelease.wav")
Plutonic.AddWeaponSound(pref .. ".Magin", path .. "handling/ak74_magin.wav")
Plutonic.AddWeaponSound(pref .. ".Magout", path .. "handling/ak74_magout.wav")
Plutonic.AddWeaponSound(pref .. ".MagoutRattle", path .. "handling/ak74_magout_rattle.wav")
Plutonic.AddWeaponSound(pref .. ".ROF", {path .. "handling/ak74_fireselect_1.wav", path .. "handling/ak74_fireselect_2.wav"})
Plutonic.AddWeaponSound(pref .. ".Rattle", path .. "handling/ak74_rattle.wav")

SWEP.Primary.Sound = Sound(pref .. ".Fp")
SWEP.Primary.Sound_World = Sound("Weapon_AKM.NPC_Fire")
SWEP.Primary.Recoil = .99 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.MaxRecoil = 6
SWEP.Primary.RecoilRecoveryRate = 4
SWEP.Primary.Damage = 15.5
SWEP.Primary.PenetrationScale = 1.68
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.025
SWEP.Primary.Delay = Plutonic.FireRate.RPM(600)
SWEP.Primary.Piercing = true

SWEP.Primary.RecoilUp = 0.5
SWEP.Primary.RecoilDown = 0.5
SWEP.Primary.RecoilSide = 0.8

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 2
SWEP.Spread.IronsightsMod = 0.55 -- multiply
SWEP.Spread.CrouchMod = 0.75 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.7 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.0945 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.RecoilAcceleration = 1
SWEP.Spread.VelocityMod = 0.2 -- movement speed effect on spread (additonal)
SWEP.IronsightsPos = Vector(-3.41, 0, 1.42)
SWEP.IronsightsAng = Angle(0.24, 0.005, 0)

SWEP.IronsightsMiddlePos = Vector(-4.400000, -3.000000, -3.6)
SWEP.IronsightsMiddleAng = Angle(4, -4, -0)

SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.IronsightsFireActivity = ACT_VM_PRIMARYATTACK_1
SWEP.BlowbackPos = Vector(0, -1, 0)
SWEP.BlowbackAngle = Angle(0, -0, 0)

SWEP.Reverb = {}
SWEP.Reverb.Primary = {}

SWEP.Reverb.Primary.IndoorEnabled = true
SWEP.Reverb.Primary.Indoor = Sound("weapons/tfa_csgo/ak47/ak47-1-distant.wav")
SWEP.Reverb.Primary.IndoorRange = 12000

SWEP.Reverb.Primary.OutdoorEnabled = true
SWEP.Reverb.Primary.Outdoor = Sound("weapons/tfa_csgo/ak47/ak47-1-distant.wav")
SWEP.Reverb.Primary.OutdoorRange = 50000

local ShootAnims = {
	"shoot1",
	"shoot2",
	"shoot3"
}

SWEP.PrimaryFireSequence =nil

SWEP.MuzzleEffect = "muzzleflash_3"
SWEP.MuzzleFlashAttachment = "muzzle_supp"

SWEP.LoweredPos = Vector(2.119, .4, 1.1)
SWEP.LoweredAng = Angle(-12.7, 29.7, -5.9)

SWEP.LoweredMidPos = Vector(2.119,-1.921,.8)
SWEP.LoweredMidAng = Angle(-1.7, 18.7, 2.9)

SWEP.LowerAngles = Angle(23, -9, -2.4)
SWEP.LowerPos = Vector(-2, -8.6, -3)

SWEP.CenteredPos = Vector(-3.41, 2.22,  -4.58)
SWEP.CenteredAng = Angle(2.92,0, 0)

SWEP.UseSprintSequence = false

local copyIronsights = SWEP.IronsightsPos + Vector(0, 0, 0)

sound.Add({
	name = "Weapon_iAK47.Single",
	sound = "impulse/ak47_fire.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105}
})
SWEP.ModificationStation = {
	Icon = Material("entities/tfa_new_inss_mk18.png"),
	YOffset = -74,
	Size = { 212, 212 },
	Offset = Vector(-1, 1, -3),
	AngOffset = Vector(0, 32, 4)
}


SWEP.Modifications = {
	[Plutonic.Enum.Modification.Rail] = {
		["rail_mount"] = {
			Name = "Upper Picatinny Rail Mount",
			Desc = "A rail mount that allows for the attachment of optics."
		}
	},
	[Plutonic.Enum.Modification.Optic] = {
		["kobra_sight"] = {
			Name = "Kobra Sight",
			Desc = "A Russian red dot sight."
		}
	}
}

SWEP.Attachments = {
	["kobra_sight"] = {
		Cosmetic = {
			Model = "models/weapons/insurgency_sandstorm/upgrades/w_sandstorm_optic_kobra.mdl",
			Bone = "A_Optic", 
			Pos = Vector(0, 0.25, -2.4),
			Ang = Angle(0, 0, 90),
			Scale = 1,
			BoneMerge = false,
			Skin = 0
		},
		Requires = {
			["rail_mount"] = true
		},
		Reticule = {
			Size = 1,
			Pos = Vector(50, 0, 0)
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-3.49, 4, 0.17)
		end,
		ModCleanup = function(e)
			e.IronsightsPos = copyIronsights
		end,
		Behavior = "1x_Sight"
	},
	["rail_mount"] = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/rail_01.mdl",
			Bone = "ak_frame", 
			Pos = Vector(0, 2.9, 2.76),
			Ang =Angle(0, 270, 0),
			Scale = 1.2,
			Skin = 0
		},
		ModSetup = function(e)
		end,
		ModCleanup = function(e)
		end,
		Behavior = "dummy"
	}
}

sound.Add({
	name = "Weapon_i2AK47.Single",
	sound = "horizons_weapons/ak47/ak47-single.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105}
})
SWEP.ReloadProceduralCameraFrac = .4
SWEP.DoEmptyReloadAnim = true

function SWEP:GetReloadAnimation(pos, ang, t)
	local vm = self.Owner:GetViewModel()
	local tag_view = vm:GetBonePosition(vm:LookupBone("Magazine"))
	local reload_empty = vm:GetSequence() == vm:LookupSequence("base_reload_empty")

	if (reload_empty and t > .9) then
		
		local bolt = vm:GetBonePosition(vm:LookupBone("ak_bolt"))
		tag_view = LerpVector(math.min((t - .9) * 40, 1), tag_view, bolt)
	end

	local view = (tag_view-pos):GetNormalized():Angle()

	return view
end