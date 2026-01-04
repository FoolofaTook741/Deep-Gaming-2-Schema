AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.R. MK. III"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_rifar3.mdl")
SWEP.ViewModel = Model("models/weapons/v_rifar3.mdl")
SWEP.ViewModelFOV = 68

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.AR3.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/ar2/npc_ar2_altfire.wav"}
})

SWEP.Primary.Sound = Sound("LS2.AR3.Single")

SWEP.Primary.Recoil = 2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 17
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(650)
SWEP.Primary.Tracer = "AR2Tracer"
SWEP.UseIronsightsRecoil = false
SWEP.SpeedReduction = 170

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.01 -- multiply
SWEP.Spread.CrouchMod = 0.35 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.25 -- movement speed effect on spread (additonal)

SWEP.NoIronsights = false

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.LoweredPos = Vector(1.406, -1.609, 1.809)
SWEP.LoweredAng = Angle(-9.849, 9.848, 0)
SWEP.IsAlwaysRaised = false

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.MuzzleFlashAttachment = 2

sound.Add({
	name = "Weapon_Swing",
	sound = "weapons/universal/uni_weapon_draw.wav",
	channel = CHAN_AUTO,
	level = SNDLVL_GUNFIRE
})

sound.Add({
	name = "Magazine.Out",
	sound = "weapons/tfa_mmod/ar2/ar2_magout.wav"
})

-- weapons/700n-close.wav

sound.Add({
	name = "Magazine.In",
	sound = "weapons/tfa_mmod/ar2/ar2_magin.wav"
})

--weapons/700n-eject.wav

sound.Add({
	name = "Weapon_Swing2",
	sound = "weapons/tfa_hl2r/uni/uni_weapon_draw_01.wav"
})

SWEP.Attachments = {}

SWEP.SoundString = "weapons/ar2/npc_ar2_altfire.wav"
SWEP.WorldModelString = "models/mmod/mmod_weapons/weapons/w_ar3.mdl"
SWEP.ViewModelString = "models/mmod/mmod_weapons/weapons/v_ar3.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end