AddCSLuaFile()

sound.Add({
	name = "Mosin.Single",
	sound = "weapons/mosin_nagant/mosin_fire.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	pitch = {80, 125}
})

sound.Add({
	name = "TFA_INS2.Mosin.Boltback",
	sound = "weapons/mosin_nagant/mosin_boltback.wav",
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,125}
})

sound.Add({
	name = "TFA_INS2.Mosin.BoltRelease",
	sound = "weapons/mosin_nagant/mosin_boltrelease.wav",
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "TFA_INS2.Mosin.BoltLatch",
	sound = "weapons/mosin_nagant/mosin_boltlatch.wav",
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "TFA_INS2.Mosin.Boltforward",
	sound = "weapons/mosin_nagant/mosin_boltforward.wav",
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "TFA_INS2.Mosin.Draw",
	sound = "weapons/mosin_nagant/mosin_draw.wav",
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,105}
})


sound.Add({
	name = "TFA_INS2.Mosin.Roundin",
	sound = {"weapons/mosin_nagant/mosin_bulletin_1.wav","weapons/mosin_nagant/mosin_bulletin_2.wav","weapons/mosin_nagant/mosin_bulletin_3.wav"},
	channel = CHAN_AUTO,
	level = 70,
	pitch = {95,105}
})

sound.Add({
	name = "Weapon_Mini14.Empty",
	sound = "weapons/mni14/mini14_empty.wav",
	channel = CHAN_AUTO,
	pitch = {95,105}
})

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "Mosin-Nagant"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.BlowbackPos = Vector(0, -8.3, -1)
SWEP.BlowbackAngle = Angle(3, -0, 0)

SWEP.WorldModel = Model("models/weapons/w_grub_mosin.mdl")
SWEP.ViewModel = Model("models/weapons/c_ins2_mosin_nagant.mdl")
SWEP.ViewModelOffset = Vector()
SWEP.ViewModelOffsetAng = Angle()
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("")
SWEP.EmptySound = Sound("weapons/mosin_nagant/mosin_empty.wav")

SWEP.Primary.Sound = Sound("Mosin.Single")
SWEP.Primary.Recoil = 8
SWEP.Primary.Damage = 49
SWEP.Primary.PenetrationScale = 1.65
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.0001
SWEP.Primary.Delay = Plutonic.FireRate.RPM(40)
SWEP.Primary.Piercing = true

SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Primary.Shell = "ShotgunShellEject"
SWEP.Primary.ShellScale = 1
SWEP.Primary.ShellAttachment = 2

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.7 -- multiply
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

SWEP.BlowbackPos = Vector(0, -8.3, -1)
SWEP.BlowbackAngle = Angle(3, -0, 0)
SWEP.NoCrosshair = true
SWEP.DoEmptyReloadAnim = true
SWEP.initRT = false

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.BarrelLength = 9

function SWEP:ExtraViewModelDrawn()
end

local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyCone = SWEP.Primary.Cone + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copyVelMod = SWEP.Spread.VelocityMod + 0
local copyDamage = SWEP.Primary.Damage + 0
local copyRPM = SWEP.Primary.Delay + 0
local copyPen = SWEP.Primary.PenetrationScale + 0

SWEP.Attachments = {
	["zoom_optic"] = {
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
			e.IronsightsFOV = 0.15
			if CLIENT then 
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens
			end
			e.IronsightsPos = Vector(0, 0, -20)
			e.IronsightsCrosshair = true
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.IronsightsPos = copyIronPos

			e.IronsightsCrosshair = copyCH
		end,
		Behaviour = "magnifier",
	},
}

function SWEP:CustomShootEffects()
    timer.Simple(0, function()
        timer.Simple(0.15, function()
            if IsValid(self) then
                self:PlayAnim(178)
                self:QueueIdle()
            end
        end)
    end)
end

SWEP.HasPlayedIntro = false
function SWEP:Deploy()
    self.DrawTime = CurTime() + 2
    self.BaseClass.Deploy(self)

    if !self.HasPlayedIntro then
        local vmodel = self.Owner:GetViewModel()
        vmodel:SetSequence(vmodel:LookupSequence("base_draw"))
        self.HasPlayedIntro = true
    end
end

SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false
SWEP.CannotChamber = true

SWEP.LoweredPos = Vector(4,-2,-8)
SWEP.LoweredAng = Angle(10, 35, -12)

SWEP.LowerAngles = Angle(12, -9, -8)
SWEP.LowerPos = Vector(-2, -5, -2)

SWEP.CenteredPos = Vector(-3.41, 2.22, -4.58)
SWEP.CenteredAng = Angle(2.92, 0, 0)

SWEP.ReloadAttach = 2

function SWEP:CustomThink()
end

function SWEP:QueueIdle()
end

SWEP.ReloadProceduralCameraFrac = 1
function SWEP:GetReloadAnimation(pos, ang)
    local vm = self.Owner:GetViewModel()
    local bone = "pump"
    local tag_view = vm:GetBonePosition(vm:LookupBone(bone))
    local view = (tag_view-pos):GetNormalized():Angle() 
    return view
end