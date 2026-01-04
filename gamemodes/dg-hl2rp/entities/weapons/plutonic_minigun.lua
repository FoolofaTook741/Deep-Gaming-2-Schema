AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M134"
SWEP.Category = "Deep Gaming [Plutonic]"
SWEP.ViewModelOffset = Vector(10, 10, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/minigun_model/weapons/w_minigun.mdl")
SWEP.ViewModel = Model("models/minigun_model/weapons/c_minigun.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "CUST.M134.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/blast_ar15_50/shoot.wav"}
})

SWEP.Primary.Sound = Sound("CUST.M134.Single")

SWEP.Primary.Recoil = 1.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 3
SWEP.Primary.NumShots = 3
SWEP.Primary.PenetrationScale = 1.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(1440)
SWEP.SpeedReduction = 170

SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 250
SWEP.Primary.DefaultClip = 250

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.3
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 0.05 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-5.45, -9, 1.92)
SWEP.IronsightsAng = Angle(0, 0, -0.25)
SWEP.IronsightsFOV = 1
SWEP.IronsightsSensitivity = 0.9
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 0.4

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
