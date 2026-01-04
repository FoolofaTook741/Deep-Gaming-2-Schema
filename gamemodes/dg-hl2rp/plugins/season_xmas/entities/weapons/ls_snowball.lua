AddCSLuaFile()

hook.Add("Initialize", "impulseLSAmmoSnowball", function()
	game.AddAmmoType({
		name = "snowball"
	})
end)

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "Snowball"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "grenade"

SWEP.WorldModel = Model("models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl")
SWEP.ViewModel = Model("models/zerochain/props_christmas/snowballswep/zck_c_snowballswep.mdl")
SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound("npc/vort/claw_swing2.wav")
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1

SWEP.Primary.Ammo = "snowball"
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5

SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl")
SWEP.Projectile.Touch = true
SWEP.Projectile.FireSound = Sound("weapons/snowball/snowball_impact02.wav")
SWEP.Projectile.ForceMod = 0.5

function SWEP:ProjectileFire(owner, hit)
	if hit and IsValid(hit) and hit:IsPlayer() then
		hit:ScreenFade(1, nil, 0.25, 0)
	end
end