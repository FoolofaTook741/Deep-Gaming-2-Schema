AddCSLuaFile()

hook.Add("Initialize", "impulseLSAmmoRifle", function()
	game.AddAmmoType({
		name = "Rifle",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE_AND_WHIZ,
		force = 5000,
		minsplash = 10,
		maxsplash = 100
	})
	util.PrecacheSound("weapons/darsu_eft/ak/fire_new/vpo209_fire_close.ogg")
	util.PrecacheSound("weapons/darsu_eft/ak/fire_new/vpo209_fire_indoor_close.ogg")
end)

SWEP.Base = "plutonic_base"

SWEP.PrintName = "AK-47"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"
SWEP.MuzzleEffect = "muzzleflash_pistol_cleric"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.WorldModel = Model("models/weapons/w_akm_inss.mdl")
SWEP.ViewModel = Model("models/weapons/v_ak47_bocw.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ReloadSound = "weapon/akm/handling/akm_mag_out_01.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")
sound.Add({
	name = "LS2.AK47.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = "weapons/darsu_eft/ak/fire_new/vpo209_fire_close.ogg"
})

sound.Add({
	name = "LS2.AK47.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = "weapons/darsu_eft/ak/fire_new/vpo209_fire_indoor_close.ogg"
})

SWEP.Primary.Sound = Sound("LS2.AK47.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.AK47.Inside")

SWEP.Primary.Recoil = 2.8 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 11
SWEP.Primary.PenetrationScale = 1.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.015
SWEP.Primary.Delay = RPM(500)

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 1
SWEP.Spread.IronsightsMod = 0.55 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.7 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.015 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.RecoilAcceleration = 1
SWEP.Spread.VelocityMod = 1.2 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-3.883, 0, 0.769)
SWEP.IronsightsAng = Angle(0.28, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.6
SWEP.UseIronsightsRecoil = false

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(45, 45, 0)

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyISF = copyIronFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyCH = SWEP.IronsightsCrosshair
local copyCone = SWEP.Primary.Cone + 0
local copyrecoil = SWEP.Primary.Recoil + 0
local copyDelay = SWEP.Primary.Delay + 0

SWEP.Attachments = {
	att_ak47_resin = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "ValveBiped.Bip01_R_Finger4",
			Pos = Vector(-20, 0, 0),
			Ang = Angle(-25, 44, 70),
			Scale = 0.0001,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Recoil = 2
			e.Primary.Cone = 0.015
			e.Spread.Max = 0.5
			e.Primary.Delay = RPM(900)
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyrecoil
			e.Primary.Cone = copyCone
			--e.Spread.Max = 1
			e.Primary.Delay = copyDelay
		end,
	},
	fortyrndmag = {
		Cosmetic = {
			Model = "sheem",
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
			e.Primary.ClipSize = 45
		end,
		ModCleanup = function(e)
			e.Primary.ClipSize = 30
			if e:Clip1() > 30 then
				e:SetClip1(30)
			end
		end,
		Behaviour = "extendedmagazine"
	},
	rifle_foregrip = {
		Cosmetic = {
			Model = "sheem",
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
			e.Primary.Recoil = 1.25
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = 2.3
		end,
		Behaviour = "foregrip"
	},
	holographic_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/eotech.mdl",
			Bone = "tag_bolt_animate",
			Pos = Vector(1.5, -1.45, 1),
			Ang = Angle(0, 0, 0),
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
			RotationAngle = 180,
			Pos = Vector(0,-0.025,1),
			Material = Material("hud/holosight/go_eotech.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-3.883, 0, 0.6)
			e.IronsightsAng = Angle(0, 0, 0)
			e.IronSightsFOV = 0.5
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-3.883, 0, 0.769)
			e.IronsightsAng = Angle(0.28, 0, 0)
			e.IronsightsFov = copyISF
		end,
		Behaviour = "holo_sight",
	},
}

sound.Add({
	name = "Weapon_iAK47.Single",
	sound = "impulse/ak47_fire.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_150dB,
	pitch = {95, 105}
})

SWEP.SoundString = "weapons/cw_ak47/ak47_wz.wav"
SWEP.WorldModelString = "models/weapons/w_akm_inss.mdl"
SWEP.ViewModelString = "models/weapons/v_ak47_bocw.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
	self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
