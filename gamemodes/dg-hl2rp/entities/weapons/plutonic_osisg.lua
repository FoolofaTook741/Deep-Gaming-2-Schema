AddCSLuaFile()

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "O.S.I.S."
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Shotgun = true

SWEP.HoldType = "smg"

SWEP.WorldModel = "models/hla/shotgun/w_shotgun.mdl"
SWEP.ViewModel = "models/hla/shotgun/c_shotgun.mdl"
SWEP.ViewModelFOV = 55
SWEP.ViewModelOffset = Vector(8, 15, -4)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-14, 0, -3)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.MuzzleFlashAttachment = "attachment_muzzle"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadShellSound = "weapons/shotgun/shotgun_reload2.wav"
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

sound.Add({
	name = "CUST.OSIS.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/hla_shotty/wep_shotgun_gunshot.wav"}
})

SWEP.Primary.Sound = Sound("CUST.OSIS.Single")

SWEP.Primary.Recoil = 3.25 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 8
SWEP.Primary.Cone = 0.067
SWEP.Primary.Delay = RPM(180)

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Primary.ReloadSpeed = 0.35
SWEP.ShellInsertDelay = 0.45

SWEP.QuickDraw = true

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0.035
SWEP.Spread.Max = 0.095
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.15 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-6.35, 4, 1.4)
SWEP.IronsightsAng = Angle(-0.35, 0, 0)
SWEP.IronsightsFOV = 0.63
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15

local copyps = SWEP.Primary.Sound
local copycone = SWEP.Primary.Cone + 0
local copynum = SWEP.Primary.NumShots + 0
local copybdmg = SWEP.Primary.Damage + 0
local copyrecoil = SWEP.Primary.Recoil + 0
--local copypen = SWEP.Primary.PenetrationScale + 0

SWEP.Attachments = {
	slug_rounds = {
		Cosmetic = {
			Model = "models/hunter/plates/plate.mdl",
			Bone = "meeman",
			Pos = Vector(5.099, -4, -0.9),
			Ang = Angle(0, 77.5, 0),
			Scale = 0.85,
			Skin = 0
			--World = {
			--	Pos = Vector(11, 1.5, -6),
			--	Ang = Angle(0, 180, 90),
			--	Scale = 0.85
			--}
		},
		ModSetup = function(e)
            e.Primary.Damage = 34
			e.Primary.Cone = 0.02
            e.Primary.NumShots = 1
		end,
		ModCleanup = function(e)
            e.Primary.Damage = copybdmg
            e.Primary.NumShots = copynum
			e.Primary.Cone = copycone
		end,
		Behaviour = "slugs",
	}
}

SWEP.SoundString = "weapons/hla_shotty/wep_shotgun_gunshot.wav"
SWEP.WorldModelString = "models/hla/shotgun/w_shotgun.mdl"
SWEP.ViewModelString = "models/hla/shotgun/c_shotgun.mdl"
local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end