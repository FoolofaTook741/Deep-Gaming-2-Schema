AddCSLuaFile()

SWEP.Base = "plutonic_base"


SWEP.PrintName = "H&K MP7A1 (Modified)"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/w_iiopnsmg1.mdl")
SWEP.ViewModel = Model("models/weapons/c_iiopnsmg1.mdl")
SWEP.ViewModelFOV = 62

SWEP.ViewModelOffset = Vector(2.5, -2, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.BarrelLength = 13

SWEP.CSMuzzleFlashes = false

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "" -- "weapons/projectmmod_smg1/smg1_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "CUST.Weapon_MP7.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/projectmmod_smg1/fire1.wav"}
})

SWEP.Primary.Sound = Sound("CUST.Weapon_MP7.Single")
SWEP.Primary.Recoil = 0.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 7.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.018
SWEP.Primary.Delay = RPM(900)

SWEP.ReloadAttach = 1

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 40

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-4.5, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)


SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.95 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.42 -- movement speed effect on spread (additonal)

SWEP.SwayLevel = 0.01
SWEP.SwayIdle = 0.01
SWEP.SwayRightMultiplier = 0.01
SWEP.SwayUpMultiplier = 0.01

SWEP.IronsightsPos = Vector(-6.5, -4, 0.625)
SWEP.IronsightsAng = Angle(0.472, 0.017, 0)
SWEP.IronsightsFOV = 1
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashColor = Color(150, 150, 150)
SWEP.MuzzleFlashShadow = true

SWEP.CannotChamber = true
SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false

SWEP.ReloadAttach = 3

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
local copyspreadmax = SWEP.Spread.Max + 0
local copydelay = SWEP.Primary.Delay + 0

SWEP.Attachments = {
	att_mp7_resin = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "ValveBiped.Bip01_R_Finger4",
			Pos = Vector(-20, 0, 0),
			Ang = Angle(-25, 44, 70),
			Scale = 0.0001,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Recoil = 0.7
			e.Primary.Cone = 0.015
			e.Spread.Max = 0.5
			e.Primary.Delay = RPM(1050)
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyrecoil
			e.Primary.Cone = copycone
			e.Spread.Max = copyspreadmax
			e.Primary.Delay = copydelay
		end,
	}
}

function SWEP:QueueIdle()
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
	self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end