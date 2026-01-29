AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M2 Browning Machine Gun"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/arccw/w_50cal_12.mdl")
SWEP.ViewModel = Model("models/weapons/arccw/c_50cal_10.mdl")
SWEP.ViewModelFOV = 65
SWEP.ViewModelOffset = Vector(2.5, 3, -0.25)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/30cal_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.M2.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/r700/rem700_outdoor_close1.ogg"}
})

sound.Add({
	name = "LS2.M2.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/r700/rem700_indoor_close1.ogg"}
})

SWEP.Primary.Sound = Sound("LS2.M2.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.M2.Inside")


SWEP.Primary.Recoil = 3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = RPM(410)
SWEP.SpeedReduction = 170
SWEP.Primary.PenetrationScale = 1.55

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150

SWEP.UseIronsightsRecoil = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 4
SWEP.Spread.IronsightsMod = 0.85 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 16.25 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-5.6, 0, 4.7)
SWEP.IronsightsAng = Angle(0, 3, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

local copyRecoil = SWEP.Primary.Recoil + 0
local copyDelay = SWEP.Primary.Delay + 0

SWEP.Attachments = {
	greased_belt = {
		Cosmetic = {
			Model = "models/props_lab/huladoll.mdl",
			Bone = "v_weapon.m249",
			Pos = Vector(-0.721, -3.537, 3.635),
			Ang = Angle(-29.611, -5.844, -94.676),
			Scale = 0.379,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Delay = RPM(700)
			e.Primary.Recoil = 11
		end,
		ModCleanup = function(e)
			e.Primary.Delay = copyDelay
			e.Primary.Recoil = copyRecoil
		end,
		Behaviour = "grease_belt"
	}
}

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(0, 20, 0)

SWEP.SoundString = "weapons/syndod/30cal_fire.wav"
SWEP.WorldModelString = "models/weapons/arccw/w_50cal_12.mdl"
SWEP.ViewModelString = "models/weapons/arccw/c_50cal_10.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end