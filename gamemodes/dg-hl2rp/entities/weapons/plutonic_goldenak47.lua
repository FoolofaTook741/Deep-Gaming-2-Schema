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
end)

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Golden AK-47"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_akm_inss.mdl")
SWEP.ViewModel = Model("models/weapons/v_ak47_bocw.mdl")
SWEP.CustomMaterial = "gold_tool/australium"
SWEP.ViewModelFOV = 65

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_pistol_cleric"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/m3_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Primary.Sound = Sound("LS2.AK47.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.AK47.Inside")
SWEP.Primary.Recoil = 3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 20
SWEP.Primary.PenetrationScale = 2.0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.026
SWEP.Primary.Delay = RPM(450)

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-5, -4, -5.5)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
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
SWEP.IronsightsMuzzleFlash = "MuzzleFlash"

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(45, 45, 0)

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyCH = SWEP.IronsightsCrosshair
local copyDMG = SWEP.Primary.Damage + 0
local copyRecoil = SWEP.Primary.Recoil + 0
local copyDelay = SWEP.Primary.Delay + 0
local copyPrimaryClipSize = SWEP.Primary.ClipSize + 0

SWEP.Attachments = {
	hunting_scope = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_optic_m40_test.mdl",
			Bone = "mini_14",
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
			e.IronsightsFOV = 0.65
			e.FOVScoped = 0.3
			if CLIENT then 
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens
			end

			e.Spread.IronsightsMod = 0.2
			e.Primary.Recoil = 1.3 -- base recoil value, SWEP.Spread mods can change this
			e.Primary.MaxRecoil = 2.2

			e.Primary.Delay = RPM(300)

			e.NoCrosshair = true
			e.NoThirdpersonIronsights = true
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.FOVScoped = nil
			e.IronsightsSensitivity = copyIronSens

			e.Spread.IronsightsMod = copyIronMod
			e.Primary.Delay = copyDelay

			e.Primary.Recoil = copyRecoil
			--e.Primary.MaxRecoil = 4

			e.NoCrosshair = false
			e.NoThirdpersonIronsights = false
		end,
		Behaviour = "sniper_sight",
		NeedsHDR = true,
		ScopeTexture = Material("ph_scope/ph_scope_lens3")
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
			e.Primary.ClipSize = copyPrimaryClipSize
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
			e.Primary.Recoil = 1.5
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyRecoil
		end,
		Behaviour = "foregrip"
	}
}

SWEP.SoundString = "weapons/cw_ak47/ak47_wz.wav"
SWEP.WorldModelString = "models/weapons/w_akm_inss.mdl"
SWEP.ViewModelString = "models/weapons/v_ak47_bocw.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end