AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "USP-9"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ItemClass = "wep_usp"

SWEP.HoldType = "pistol"

SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
SWEP.ViewModel = Model("models/weapons/c_iiopnpistol.mdl")
SWEP.ViewModelFOV = 55
SWEP.IsAlwaysRaised = false
SWEP.QuickDraw = true

SWEP.ViewModelOffset = Vector(2.5, 3, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-5, -4, -3)
SWEP.CenteredAng = Angle(3,0,0)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.BarrelLength = 13

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.USP.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/usp/usp_fire_close.ogg"}
})

sound.Add({
	name = "LS2.USP.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/usp/usp_fire_indoor_close.ogg"}
})

sound.Add({
	name = "LS2.USP.Silenced",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_30dB,
	pitch = {95, 105},
	sound = {"weapons/deagle/p90_sil.wav"}
})

SWEP.CenteredPos = Vector(-4.5, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Primary.Sound = Sound("LS2.USP.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.USP.Inside")
SWEP.Primary.Recoil = 0.6 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.015
SWEP.Primary.Delay = RPM(360)

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.008
SWEP.Spread.Max = 0.03
SWEP.Spread.IronsightsMod = 0.9 -- multiply
SWEP.Spread.CrouchMod = 0.7 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.025 -- movement speed effect on spread (additonal)

SWEP.SwayLevel = 0.01
SWEP.SwayIdle = 0.01
SWEP.SwayRightMultiplier = 0.01
SWEP.SwayUpMultiplier = 0.01

SWEP.IronsightsPos = Vector(-4.27, 2, 1.65)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashColor = Color(150, 150, 150)
SWEP.MuzzleFlashShadow = true

SWEP.CannotChamber = true
SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false

function SWEP:CustomShootEffects()
	self.VTime = CurTime() + 0.1
	self.VLowered = false
end
SWEP.IronsightsAllowAnim = {
    [ACT_VM_PRIMARYATTACK] = true
}
SWEP.HasPlayedIntro = false

local copyps = SWEP.Primary.Sound
local copycone = SWEP.Primary.Cone + 0
local copynum = SWEP.Primary.NumShots + 0
local copybdmg = SWEP.Primary.Damage + 0
local copyrecoil = SWEP.Primary.Recoil + 0
local copyspreadmax = SWEP.Spread.Max + 0
local copyISF = SWEP.IronsightsFOV + 0
local copyISPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyISAng = Angle(SWEP.IronsightsAng.p, SWEP.IronsightsAng.y, SWEP.IronsightsAng.r)

SWEP.Attachments = {
	att_pistol_resin = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "Base",
			Pos = Vector(-16, 0.0, 1.8),
			Ang = Angle(0, 0, 0),

			Scale = 0.85,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Recoil = 0.2
			e.Primary.Cone = 0.015
			e.Spread.Max = 0.01
		end,
		ModCleanup = function(e)
			e.Primary.Sound = Sound("LS2.USP.Single")
			e.Primary.Recoil = copyrecoil
			e.Primary.Cone = copycone
			e.Spread.Max = copyspreadmax
		end,
		Behaviour = "resin",
	},
	att_pistol_silencer = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "Base",
			Pos = Vector(-16, 0.0, 1.8),
			Ang = Angle(0, 0, 0),

			Scale = 0.85,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Sound = Sound("LS2.USP.Silenced")
			e.Primary.Recoil = 0.2
		end,
		ModCleanup = function(e)
			e.Primary.Sound = Sound("LS2.USP.Single")
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "silencer",
	},

t1_reflex = {
	Cosmetic = {
		Model = "models/weapons/arccw_go/atts/t1.mdl",
		Bone = "Base",
		Pos = Vector(2, 0.0, 2.3),
		Ang = Angle(0, 0, 0),
		Scale = 0.85,
		Skin = 0,
	},
	Reticule = {
		Size = 0.25,
		RotationAngle = 180,
		Pos = Vector(0, -0.032, 1.025),
		Material = Material("hud/holosight/go_delta.png"),
		Color = Color(0,255,0,255),
		NoMask = true,
	},
	ModSetup = function(e)
		e.IronsightsPos = Vector(-6.275, 0, 2)
		e.IronsightsAng = Angle(0, 1.5, 0)
		e.IronsightsFOV = 0.6
		e.Primary.Recoil = 0.1
	end,
	ModCleanup = function(e)
		e.IronsightsPos = copyISPos
		e.IronsightsAng = copyISAng
		e.IronsightsFOV = copyISF
		e.Primary.Recoil = copyrecoil
	end,
	Behavior = "reflex_sight",
},
barska_rds = {
	Cosmetic = {
		Model = "models/weapons/arccw_go/atts/barska.mdl",
		Bone = "Base",
		Pos = Vector(2.2, 0.0, 2.25),
		Ang = Angle(0, 0, 0),
		Scale = 0.85,
		Skin = 0,
	},
	Reticule = {
		Size = 0.25,
		RotationAngle = 180,
		Pos = Vector(0, -0.032, 1.025),
		Material = Material("hud/holosight/go_barska.png"),
		Color = Color(0,150,255,255),
		NoMask = true,
	},
	ModSetup = function(e)
		e.IronsightsPos = Vector(-6.25, 0, 2.0)
		e.IronsightsAng = Angle(0, 1.5, 0)

		e.IronsightsFOV = 0.6

		e.Primary.Recoil = 0.1
	end,
	ModCleanup = function(e)
		e.IronsightsPos = copyISPos
		e.IronsightsAng = copyISAng
		e.IronsightsFOV = copyISF
		e.Primary.Recoil = copyrecoil
	end,
	Behavior = "red_dot_sight",
},
}

--[[function SWEP:CustomShootEffects()
    timer.Simple(0,function()
        if self:GetIronsights() then
			
			self:PlayAnim(ACT_VM_PRIMARYATTACK)
		end
	end)
end]]

function SWEP:QueueIdle()
end

SWEP.SoundString = "weapons/projectmmod_pistol/pistolfire2.wav"
SWEP.SilencedSoundString = "weapons/deagle/p90_sil.wav"
SWEP.WorldModelString = "models/weapons/w_pistol.mdl"
SWEP.ViewModelString = "models/weapons/c_pistol.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end