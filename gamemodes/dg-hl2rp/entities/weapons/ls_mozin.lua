AddCSLuaFile()

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "Moszinn-Nagant"
SWEP.Category = "[Deep Gaming] Longsword"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_grub_mosin.mdl")
SWEP.ViewModel = Model("models/weapons/c_ins2_mosin_nagant.mdl")
SWEP.ViewModelOffset = Vector()
SWEP.ViewModelOffsetAng = Angle()
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.Shotgun = false

SWEP.ReloadSound = Sound("")
SWEP.EmptySound = Sound("weapons/mosin_nagant/mosin_empty.wav")

--SWEP.Primary.Sound = Sound("Weapon_Mosin.Single")
SWEP.Primary.Recoil = 9.5
SWEP.Primary.Damage = 65
SWEP.Primary.PenetrationScale = 1.8
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.0001
SWEP.Primary.Delay = 3
SWEP.Primary.Piercing = true
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.04 -- multiply
SWEP.Spread.CrouchMod = 0.94 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.07 -- movement speed effect on spread (additonal)
SWEP.IronsightsSpeed = 3.5
SWEP.IronsightsPos = Vector(-3.090000, -2.000000, 1.590000)
SWEP.IronsightsAng = Angle(0.035000, 0.020000, 0.000000)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 1
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.NoCrosshair = true
SWEP.DoEmptyReloadAnim = true

function SWEP:ExtraViewModelDrawn()
end

local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyCone = SWEP.Primary.Cone + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copyVelMod = SWEP.Spread.VelocityMod + 0
local copyDamage = SWEP.Primary.Damage + 0
local copyRPM = SWEP.Primary.Delay + 0
local copyPen = SWEP.Primary.PenetrationScale + 0

SWEP.Attachments = {
    ["zoom_optic"] = {
        Cosmetic = {
            Model = "models/weapons/tfa_ins2/upgrades/a_optic_mosin.mdl",
            Bone = "A_Optic",
			Pos = Vector(0, -0.5, 0),
			Ang = Angle(90, 0, 90),
            Scale = 1,
            Skin = 0
            --World = {
            --    Pos = Vector(11, 1.5, -6),
            --    Ang = Angle(0, 180, 90),
            --    Scale = 0.85
            --}
        },
        Scope = {
            SubMaterial = 1,
            FOV = 12.5
        },
        Reticule = {
            Size = 2,
            Pos = Vector(1, 0, 1.5),
            Material = Material("models/weapons/insurgency_sandstorm/ins2_ismc/nightforce_reticule"),
            NoMask = false
        },
		ModSetup = function(e)
			local fov = .4
			e.IronsightsFOV = fov
			if CLIENT then 
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens * (fov / 0.8)
			end
			e.IronsightsPos = Vector(-3.055, -2.000000, .745)
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.IronsightsPos = Vector(-3.090000, -2.000000, 1.590000)
		end,
    }
}


function SWEP:CustomShootEffects()
    timer.Simple(0,function()
        timer.Simple(0.5,function()
			if IsValid(self) then
            	self:PlayAnim(178)
            	self:QueueIdle()
			end
        end)
    end)
end

SWEP.LoweredPos = Vector(4,-2,-8) --Vector(0, -16, -13)
SWEP.LoweredAng = Angle(10, 35, -12)

--[[sound.Add({
	name = "Weapon_Mosin.Single",
	sound = "weapons/mosin_nagant/mosin_fire.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105}
})

sound.Add({
	name = "TFA_INS2.Mosin.Boltback",
	sound = "weapons/mosin_nagant/mosin_boltback.wav",
	channel = CHAN_WEAPON,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "TFA_INS2.Mosin.BoltRelease",
	sound = "weapons/mosin_nagant/mosin_boltrelease.wav",
	channel = CHAN_WEAPON,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "TFA_INS2.Mosin.BoltLatch",
	sound = "weapons/mosin_nagant/mosin_boltlatch.wav",
	channel = CHAN_WEAPON,
	level = 70,
	pitch = {95,105}
})]]--

