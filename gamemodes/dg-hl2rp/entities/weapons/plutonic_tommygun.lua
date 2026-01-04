AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M1918 Thompson SMG"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.ViewModelOffset = Vector(-3, 2, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/syndod/w_thompsom.mdl")
SWEP.ViewModel = Model("models/weapons/syndod/v_thompsom.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/ppsh_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "LS2.TOMMY.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/syndod/thompson_fire.wav"}
})

SWEP.Primary.Sound = Sound("LS2.TOMMY.Single")

SWEP.Primary.Recoil = 0.85 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.005
SWEP.Primary.Delay = RPM(720)

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.3
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.6 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.0 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.15, -9, 2.2)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 1
SWEP.IronsightsSensitivity = 1
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.1

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end