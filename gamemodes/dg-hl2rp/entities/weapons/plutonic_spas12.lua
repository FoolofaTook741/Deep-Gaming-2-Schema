AddCSLuaFile()

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "Franchi SPAS-12"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ItemClass = "wep_m500"

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/w_spas122.mdl")
SWEP.ViewModel = Model("models/weapons/v_spas122.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.BarrelLength = 40
SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadShellSound = "weapons/projectmmod_shotgun/shotgun_reload" .. math.random(1,4) .. ".wav"
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

sound.Add({
	name = "CUST.SPAS12.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/spas12nomech-1.wav"}
})

SWEP.Primary.Sound = Sound("CUST.SPAS12.Single")
SWEP.Primary.Recoil = 10 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8.4
SWEP.Primary.NumShots = 10
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = RPM(90)

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.05
SWEP.Spread.Max = 0.20
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.SwayLevel = 0.01
SWEP.SwayIdle = 0.01
SWEP.SwayRightMultiplier = 0.01
SWEP.SwayUpMultiplier = 0.01

SWEP.IronsightsPos = Vector(-3.25, 1, 1.4)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.63
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15

SWEP.CenteredPos = Vector(-9.0, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashColor = Color(150, 150, 150)
SWEP.MuzzleFlashShadow = true


SWEP.CannotChamber = true
SWEP.MuzzleFlashAttachment = nil
SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false

SWEP.Shotgun = true

function SWEP:CustomShootEffects()
	self.VTime = CurTime() + 0.1
	self.VLowered = false
end

SWEP.IronsightsAllowAnim = {
    [ACT_VM_PRIMARYATTACK] = true
}
SWEP.HasPlayedIntro = false

--[[function SWEP:CustomShootEffects()
    timer.Simple(0,function()
        if self:GetIronsights() then
			
			self:PlayAnim(ACT_VM_PRIMARYATTACK)
		end
	end)
end]]

local copyps = SWEP.Primary.Sound
local copycone = SWEP.Primary.Cone + 0
local copynum = SWEP.Primary.NumShots + 0
local copybdmg = SWEP.Primary.Damage + 0
local copyrecoil = SWEP.Primary.Recoil + 0
--local copypen = SWEP.Primary.PenetrationScale + 0

SWEP.Attachments = {
	att_spas12_resin = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "ValveBiped.Bip01_R_Finger4",
			Pos = Vector(-20, 0, 0),
			Ang = Angle(-25, 44, 70),
			Scale = 0.0001,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.ClipSize = 8
			e.Primary.Cone = 0.015
			e.Primary.NumShots = 11
		end,
		ModCleanup = function(e)
			e.Primary.ClipSize = copyrecoil
			e.Primary.Cone = copycone
			e.Primary.NumShots = copynum
		end,
	},
	incendiary_rounds = {
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
			e.IncendiaryRounds = true
            e.Primary.Damage = 5
            e.Primary.NumShots = 8
			e.Primary.Sound = Sound("PLT.DragonsBreath")
		end,
		ModCleanup = function(e)
			e.IncendiaryRounds = false
            e.Primary.Damage = copybdmg
            e.Primary.NumShots = copynum
			e.Primary.Sound = copyps
		end,
		Behaviour = "incendiaryrounds",
	},
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
            e.Primary.Damage = 48
			e.Primary.Cone = 0.01
            e.Primary.NumShots = 1
			e.Primary.PenetrationScale = 1.3
			e.Primary.Recoil = 10
		end,
		ModCleanup = function(e)
            e.Primary.Damage = copybdmg
            e.Primary.NumShots = copynum
			e.Primary.Cone = copycone
			e.Primary.PenetrationScale = 1
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "slugs",
	}
}

function SWEP:QueueIdle()
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
