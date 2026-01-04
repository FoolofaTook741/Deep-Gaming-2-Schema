AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.H.S."
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/heavyshotgun/w_shotgun_heavy.mdl")
SWEP.ViewModel = Model("models/weapons/heavyshotgun/c_shotgun_heavy.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = Sound("weapons/hlvr/whshotty/shotgun_reload" .. math.random(1,3).. ".wav")
SWEP.EmptySound = Sound("Weapon_AR2.Empty")

sound.Add({
	name = "CUST.OSIHS.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/hlvr/pshotgun/shotgun_fire1.wav"}
})

sound.Add({
	name = "Cock",
	channel = 1,
	volume = 1.0,
	level = 75,
	pitch = {95, 105},
	sound = {"pshotgun/wpn_shotgun_foley_close_chamber_01.wav"}
})

sound.Add({
	name = "Magazine.ShIn",
	channel = 1,
	volume = 1.0,
	level = 75,
	pitch = {95, 105},
	sound = {"pshotgun/wpn_shotgun_foley_rack_forward_01.wav"}
})

sound.Add({
	name = "Magazine.ShOut",
	channel = 1,
	volume = 1.0,
	level = 75,
	pitch = {95, 105},
	sound = {"pshotgun/wpn_shotgun_foley_open_chamber_01.wav"}
})

SWEP.Primary.Sound = Sound("CUST.OSIHS.Single")

SWEP.Primary.Recoil = 1.4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 10
SWEP.Primary.Cone = 0.115 -- base spread value
SWEP.Primary.Delay = RPM(160)
SWEP.Primary.Tracer = "AR2Tracer"
SWEP.SpeedReduction = 160

SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.7 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.4 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.16 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"
SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

SWEP.UseIronsightsRecoil = false

SWEP.SoundString = "weapons/hlvr/pshotgun/wpn_combine_shotgun_fire_body_01.wav"
SWEP.WorldModelString = "models/weapons/heavyshotgun/w_shotgun_heavy.mdl"
SWEP.ViewModelString = "models/weapons/heavyshotgun/c_shotgun_heavy.mdl"local CopyViewModelOrigin = SWEP.ViewModelFOV

function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
