AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.R. MK. II"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_iiopnirifle.mdl")
SWEP.ViewModel = Model("models/weapons/arccw/c_irifle.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true
SWEP.MuzzleEffect = "muzzleflash_ak47"

SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashBrightness = 6
SWEP.MuzzleFlashColor = Color(77, 116, 200)
function SWEP:CustomShootEffects()
	if IsValid(self) then
		if self:GetIronsights() then
			self:PlayAnim(ACT_VM_PRIMARYATTACK)
			self:QueueIdle()
		end
	end
end

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)
SWEP.MuzzleHide = false

SWEP.ReloadSound = Sound("weapons/arccw/ar2_reload.wav")
SWEP.EmptySound = Sound("Weapon_AR2.Empty")

sound.Add({
	name = "LS2.AR2.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/projectmmod_ar2/fire1.wav"}
})

sound.Add({
	name = "LS2.AR2.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/ar2/fire1.wav"}
})

SWEP.Primary.Sound = Sound("LS2.AR2.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.AR2.Inside")

SWEP.Primary.Recoil = 0.225 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01 -- base spread value
SWEP.Primary.Delay = RPM(600)
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.Primary.BulletModel = Model("models/weapons/rifleshell.mdl")

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.08
SWEP.Spread.IronsightsMod = 0.5 -- multiply
SWEP.Spread.CrouchMod = 0.3 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.4 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.16 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyDMG = SWEP.Primary.Damage + 0
local copyCone = SWEP.Primary.Cone + 0
SWEP.Attachments = {
}

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(10, 20, 0)

SWEP.SoundString = "weapons/projectmmod_ar2/fire1.wav"
SWEP.WorldModelString = "models/weapons/w_iiopnirifle.mdl"
SWEP.ViewModelString = "models/weapons/arccw/c_irifle.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end