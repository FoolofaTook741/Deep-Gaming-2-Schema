AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.R. MK. I"
SWEP.Category = "Deep Gaming [Plutonic]"
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-3, -2, -4)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/ocipr/w_ocipr.mdl")
SWEP.ViewModel = Model("models/weapons/c_ordinalrifle.mdl")
SWEP.ViewModelFOV = 65

SWEP.ViewModelOffset = Vector(2.5, -2, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_smg"

SWEP.MuzzleFlashSize = 125
SWEP.MuzzleFlashBrightness = 6
SWEP.MuzzleFlashColor = Color(18, 140, 20)

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/hlvr/irifle/reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "LS2.AR1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/hlvr/irifle/fire1.wav"}
})

SWEP.Primary.Sound = Sound("LS2.AR1.Single")

SWEP.Primary.Recoil = 1.35 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.PenetrationScale = 1.4
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(465)
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 35

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.025
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.6 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.2 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.6
SWEP.IronsightsSensitivity = 0.6
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 1.2

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyDMG = SWEP.Primary.Damage + 0
SWEP.Attachments = {
}

SWEP.SoundString = "weapons/hlvr/irifle/fire1.wav"
SWEP.WorldModelString = "models/weapons/ocipr/w_ocipr.mdl"
SWEP.ViewModelString = "models/weapons/c_ordinalrifle.mdl"

SWEP.FireModes = {
    {
        Name = "regular",
        On = function(self)
            self.Primary.Automatic = true
        end,
        Off = function(self) end
    },
	{
		Name = "pulse orb",
		On = function(self)
		self.CombineBallMode = true
		self.Primary.Automatic = false
		end,
		Off = function(self)
			self.NextCombineBallFire = 0
			self.LastEmptySound = 0
			self.CombineBallMode = false
		end
	},
}

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end