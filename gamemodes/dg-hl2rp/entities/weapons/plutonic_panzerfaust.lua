AddCSLuaFile()

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "M320 GL-AP"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/v92/weapons/bf3/m320/combo.mdl")
SWEP.ViewModel = Model("models/v92/weapons/bf3/m320/combo.mdl")
SWEP.ViewModelFOV = 40

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound("v92/weapons/bf3/m320/single_1.wav")
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1
SWEP.ExpEffect = "lvs_explosion_bomb"

SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "v92/weapons/bf3/m320/shell_insert1.wav"

SWEP.Primary.Ammo = "SMG1_Grenade"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/Items/AR2_Grenade.mdl")
SWEP.Projectile.FireSound = Sound("ambient/explosions/explode_9.wav")
SWEP.Projectile.Touch = true
SWEP.Projectile.ForceMod = 4
SWEP.DontRemoveOnEmpty = true
SWEP.Reloadable = true

function SWEP:ProjectileFire()
	local pos = self:GetPos()
	local owner = self:GetOwner()
    util.BlastDamage( self, owner, pos, 250, 99 )
	local effectdata = EffectData()
end

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(45, 45, 0)

SWEP.SoundString = "v92/weapons/bf3/m320/single_1.wav"
SWEP.WorldModelString = "models/v92/weapons/bf3/m320/combo.mdl"
SWEP.ViewModelString = "models/v92/weapons/bf3/m320/combo.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end