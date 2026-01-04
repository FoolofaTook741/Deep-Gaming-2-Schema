AddCSLuaFile()

SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "The Giant Slayer"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee2"

SWEP.WorldModel = Model("models/weapons/hl2meleepack/w_pickaxe.mdl")
SWEP.ViewModel = Model("models/weapons/hl2meleepack/v_pickaxe.mdl")
SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.Primary.Sound = Sound("WeaponFrag.Roll")
SWEP.Primary.ImpactSound = Sound("Canister.ImpactHard")
SWEP.Primary.Recoil = 2.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Range = 100
SWEP.Primary.StunTime = 0.5
SWEP.Primary.HullSize = 7