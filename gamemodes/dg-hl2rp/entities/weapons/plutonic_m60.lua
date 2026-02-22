AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M60 Machine Gun"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_dm60.mdl")
SWEP.ViewModel = Model("models/weapons/v_dm60.mdl")
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


SWEP.Primary.Recoil = 2.6 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.015
SWEP.Primary.Delay = RPM(400)
SWEP.SpeedReduction = 200
SWEP.Primary.PenetrationScale = 1.55

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 75
SWEP.Primary.DefaultClip = 75

SWEP.UseIronsightsRecoil = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-5, -2, -6)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 40
SWEP.Spread.IronsightsMod = 0.85 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.001 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 200 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.6, 0, -1)
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
			e.Primary.Delay = RPM(600)
			e.Primary.Recoil = 4
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
SWEP.WorldModelString = "models/weapons/w_dm60.mdl"
SWEP.ViewModelString = "models/weapons/v_dm60.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end