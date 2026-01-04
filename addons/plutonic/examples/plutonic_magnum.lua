AddCSLuaFile()

SWEP.Base = "plutonic_base"


SWEP.PrintName = ".357 Magnum"
SWEP.Category = "Landis: Guns"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.ItemClass = "wep_357"

SWEP.WorldModel = Model("models/weps/w_357.mdl")
SWEP.ViewModel = Model("models/horizons_weapons/v_357.mdl")
SWEP.ViewModelFOV = 75
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, -0)

SWEP.BarrelLength = 7

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_357.Reload")
SWEP.EmptySound = Sound("Weapon_357.Empty")

sound.Add({
	name = "Landis.Weapon_357.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"357/357_fire2.wav","357/357_fire2.wav"}
})

SWEP.Primary.Sound = Sound("Weapon_357.Fire")
SWEP.Primary.Sound_World = Sound("Weapon_357.NPC_Fire")
SWEP.Primary.Recoil = 7.4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 51
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = Plutonic.FireRate.RPM(122)
SWEP.Primary.RecoilUp = 4
SWEP.Primary.RecoilDown = 3
SWEP.Primary.RecoilSide = 0.56

SWEP.ReloadAttach = 1

SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.9 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.SwayLevel = 1
SWEP.SwayIdle = 0.8
SWEP.SwayRightMultiplier = 3.5
SWEP.SwayUpMultiplier = 3.4

SWEP.IronsightsSpeed = 4
SWEP.IronsightsRocking = 20
SWEP.IronsightsPos = Vector(-2.65, -0.915, 1.55)
SWEP.IronsightsAng = Angle(0.5, -0.06, 5)
SWEP.IronsightsFOV = .82
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.BlowbackPos = Vector(0, -16, -15)
SWEP.BlowbackAngle = Angle(32, -1.2, 0)

SWEP.LoweredMidPos = Vector(1, -2.08, -6.641)
SWEP.LoweredMidAng = Angle(12.4, -5.301, -1.299)
 
SWEP.LoweredPos = Vector(1.559, -8.08, -7.641)
SWEP.LoweredAng = Angle(33.4, -5.301, -4)

SWEP.LowerPos = Vector(1, -7.08, -6.641)
SWEP.LowerAngles = Angle(24.4, -5.301, 1.299)

SWEP.CenteredPos = Vector(-2.65, 0.915, -2.55)
SWEP.CenteredAng = Angle(0.5, -0.06, 6)

SWEP.MuzzleEffect = "muzzleflash_pistol_deagle"
SWEP.MuzzleFlashAttachment = nil
SWEP.CannotChamber = true

SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false


SWEP.IronsightsAllowAnim = {
    [ACT_VM_PRIMARYATTACK] = true
}
SWEP.HasPlayedIntro = false
function SWEP:CustomShootEffects()
end

function SWEP:QueueIdle()
end

SWEP.ReloadProceduralCameraFrac = .4

function SWEP:GetReloadAnimation(pos, ang)
	local vm = self.Owner:GetViewModel()

	local bone = "cylinder"

	local tag_view = vm:GetBonePosition(vm:LookupBone(bone))

	local view = (tag_view-pos):GetNormalized():Angle() 

	return view
end