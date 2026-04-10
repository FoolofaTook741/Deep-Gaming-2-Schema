AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.S."
SWEP.Category = "Deep Gaming [Plutonic]"
SWEP.ViewModelOffset = Vector(0, 0, -2)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/psmg/w_psmg.mdl")
SWEP.ViewModel = Model("models/weapons/psmg/c_psmg.mdl")
SWEP.ViewModelFOV = 65

SWEP.CenteredPos = Vector(-5, -3, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/hlvr/psmg/smg1_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "CUST.PSMG.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"psmg/smg1_fire1.wav"}
})

SWEP.Primary.Sound = Sound("CUST.PSMG.Single")

SWEP.Primary.Recoil = 1 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.Delay = RPM(540)
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "SMG1"
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
SWEP.Spread.IronsightsMod = 0.86 -- multiply
SWEP.Spread.CrouchMod = 0.9 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.69, -6, -0.575)
SWEP.IronsightsAng = Angle(0, 0, -0.25)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 0.5

SWEP.SoundString = "psmg/smg1_fire1.wav"
SWEP.WorldModelString = "models/weapons/psmg/w_psmg.mdl"
SWEP.ViewModelString = "models/weapons/psmg/c_psmg.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end