AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Golden IMI Desert Eagle"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model("models/tasty/w-d50.mdl")
SWEP.ViewModel = Model("models/tasty/d50.mdl")
SWEP.CustomMaterial = "gold_tool/australium"
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 3, -0.25)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/tt_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.Deagle.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sr25/sr25_fire_outdoor_close.ogg"}
})

sound.Add({
	name = "LS2.Deagle.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sr25/sr25_fire_indoor_close.ogg"}
})

SWEP.Primary.Sound = Sound("LS2.Deagle.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.Deagle.Inside")
SWEP.Primary.Recoil = 12 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 45
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.009
SWEP.Primary.Delay = RPM(240)

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7

SWEP.UseIronsightsRecoil = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.008
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.9 -- multiply
SWEP.Spread.CrouchMod = 0.6 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.025 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4, 0, 1.3)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.25

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(70, 0, 0)

SWEP.SoundString = "weapons/deagle/deagle.wav"
SWEP.WorldModelString = "models/tasty/w-d50.mdl"
SWEP.ViewModelString = "models/tasty/d50.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end