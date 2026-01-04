AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Golden Colt Python"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model("models/weapons/w_357.mdl")
SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.CustomMaterial = "gold_tool/australium"
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true
SWEP.MuzzleEffect = "muzzleflash_pistol_deagle"
SWEP.MuzzleFlashAttachment = "muzzle"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = Sound("Weapon_357.Reload")
SWEP.EmptySound = Sound("Weapon_357.Empty")

SWEP.Primary.Sound = Sound("weapons/darsu_eft/rsh12/rsh_12_outdoor_close_oneshot.ogg")
SWEP.Primary.Inside_Sound = Sound("weapons/darsu_eft/rsh12/rsh_12_indoor_close_oneshot.ogg")
SWEP.Primary.Recoil = 40
SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(60)

SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.UseIronsightsRecoil = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.01
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.03 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.6, 0, 0.52)
SWEP.IronsightsAng = Angle(0.2, -0.201, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(70, 0, 0)

SWEP.Attachments = {}

SWEP.SoundString = "weapons/projectmmod_357/fire1.wav"
SWEP.WorldModelString = "models/weapons/w_357.mdl"
SWEP.ViewModelString = "models/weapons/c_357.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end