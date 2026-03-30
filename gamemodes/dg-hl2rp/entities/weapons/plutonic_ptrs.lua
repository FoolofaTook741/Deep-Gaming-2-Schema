AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "PTRS-41"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_grub_ptrs.mdl")
SWEP.ViewModel = Model("models/weapons/reek_doctor/ptrs/c_ptrs.mdl")
SWEP.ViewModelFOV = 55
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-3.5, -3, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/mni14/mini14_magout.wav"
SWEP.EmptySound = "grub_ptrs/cover close.wav"

sound.Add({
	name = "CUST.PTRS.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sv98/sv98_fire_close.ogg"}
})

sound.Add({
	name = "CUST.PTRS.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sv98/sv98_fire_indoor_close.ogg"}
})

SWEP.Primary.Sound = Sound("CUST.PTRS.Single")
SWEP.Primary.Inside_Sound = Sound("CUST.PTRS.Inside")

SWEP.Primary.Recoil = 70 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 49
SWEP.Primary.PenetrationScale = 1.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.002
SWEP.SpeedReduction = 130
SWEP.Primary.Delay = RPM(30)

SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.3
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 0.1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 3.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-3.671, 0, 0.9)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyCone = SWEP.Primary.Cone + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copyVelMod = SWEP.Spread.VelocityMod + 0
local copyDamage = SWEP.Primary.Damage + 0
local copyRPM = SWEP.Primary.Delay + 0
local copyPen = SWEP.Primary.PenetrationScale + 0

local copyISF = SWEP.IronsightsFOV + 0
SWEP.Attachments = {
	hunter_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/hunter.mdl",
			Bone = "DrawCall_16",
			Pos = Vector(0, -4, -2.25),
			Ang = Angle(180, 90, 0),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		Reticule = {
			Size = 1,
			RotationAngle = 0,
			Pos = Vector(0,0,1.2),
			Material = Material("hud/scopes/triple_go.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(3.49, -2, 1.82)
			e.IronsightsAng = Angle(0, 0, -0.25)
			e.IronsightsFOV = 0.5
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(3.5, -2, 2.25)
			e.IronsightsAng = Angle(0, 0, -0.25)
			e.IronsightsFov = copyISF
		end,
		Behaviour = "sniper_sight",
		NeedsHDR = true,
		ScopeTexture = Material("ph_scope/ph_scope_lens3"),
	},
	holographic_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/eotech.mdl",
			Bone = "DrawCall_16",
			Pos = Vector(0, -4, -2.25),
			Ang = Angle(180, 90, 0),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		Reticule = {
			Size = 0.5,
			RotationAngle = 0,
			Pos = Vector(0,0,1),
			Material = Material("hud/holosight/go_eotech.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(3.49, -2, 2)
			e.IronsightsAng = Angle(0, 0, -0.25)
			e.IronSightsFOV = 0.5
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(3.5, -2, 2.25)
			e.IronsightsAng = Angle(0, 0, -0.25)
			e.IronsightsFov = copyISF
		end,
		Behaviour = "holo_sight",
	},
	zoom_optic = {
		Cosmetic = {
			Model = "abv",
			Bone = "none",
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
			local fov = .15
			e.IronsightsFOV = fov
			if CLIENT then 
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens * (fov / 0.8)
			end
			e.IronsightsPos = Vector(-20, -20, -20)
			e.IronsightsCrosshair = true
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.IronsightsPos = copyIronPos

			e.IronsightsCrosshair = copyCH
		end,
		Behaviour = "magnifier",
	}
}

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(0, 20, 0)

SWEP.SoundString = "grub_ptrs/at_ptrs_fire_single_3p_02.wav"
SWEP.WorldModelString = "models/weapons/w_grub_ptrs.mdl"
SWEP.ViewModelString = "models/weapons/reek_doctor/ptrs/c_ptrs.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end