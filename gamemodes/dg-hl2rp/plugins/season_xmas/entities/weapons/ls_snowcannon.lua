AddCSLuaFile()

hook.Add("Initialize", "impulseLSAmmoSnowball", function()
	game.AddAmmoType({
		name = "snowball"
	})
end)

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "Snowball Cannon"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "rpg"

SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")
SWEP.ViewModel = Model("models/weapons/c_rpg.mdl")
SWEP.CustomMaterial = "models/debug/debugwhite"
SWEP.ViewModelFOV = 43

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.DoFireAnim = true

SWEP.Primary.Sound = Sound("weapons/mortar/mortar_fire1.wav")
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = RPM(260)
SWEP.Primary.HitDelay = 0.1

SWEP.Primary.Ammo = "snowball"
SWEP.Primary.ClipSize = 1000
SWEP.Primary.DefaultClip = 1000

SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl")
SWEP.Projectile.Touch = true
SWEP.Projectile.FireSound = Sound("weapons/snowball/snowball_impact02.wav")
SWEP.Projectile.ForceMod = 2

function SWEP:ProjectileFire(owner, hit)
	if hit and IsValid(hit) and hit:IsPlayer() then
		hit:ScreenFade(1, nil, 0.25, 0)
	end
end