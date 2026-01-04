AddCSLuaFile()

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "Rock"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.IsAlwaysRaised = true

SWEP.HoldType = "grenade"

SWEP.WorldModel = Model("models/props_debris/concrete_chunk05g.mdl")
SWEP.ViewModel = Model("models/props_debris/concrete_chunk05g.mdl")
SWEP.ViewModelFOV = 50

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = ""
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1

SWEP.Primary.Ammo = "Rock"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/props_debris/concrete_chunk05g.mdl")
SWEP.Projectile.FireSound = Sound("WeaponFrag.Roll")
SWEP.Projectile.HitSound = Sound("physics/concrete/rock_impact_hard2.wav")
SWEP.Projectile.Touch = false
SWEP.Projectile.ForceMod = 1.2

function SWEP:ProjectileFire()
	local pos = self:GetPos()
	local owner = self:GetOwner()
	util.BlastDamage(owner, owner, pos, 300, 45)
end