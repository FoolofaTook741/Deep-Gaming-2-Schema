AddCSLuaFile()

hook.Add("Initialize", "impulseLSAmmoGas", function()
	game.AddAmmoType({
		name = "gas"
	})
end)

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "Smoke Grenade"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "grenade"

SWEP.WorldModel = Model("models/weapons/arccw_go/w_eq_smokegrenade_thrown.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_eq_smokegrenade.mdl")
SWEP.ViewModelFOV = 50

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = ""
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1

SWEP.Primary.Ammo = "gas"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/weapons/arccw_go/w_eq_smokegrenade_thrown.mdl")
SWEP.Projectile.FireSound = Sound("weapons/smokegrenade/sg_explode.wav")
SWEP.Projectile.HitSound = Sound("weapons/smokegrenade/grenade_hit1.wav")
SWEP.Projectile.Touch = false
SWEP.Projectile.ForceMod = 2
SWEP.Projectile.Timer = 15
SWEP.Projectile.RemoveWait = 120

function SWEP:ProjectileFire()
	local sfx = EffectData()
	sfx:SetEntity(self)
	sfx:SetOrigin(self:GetPos())
    sfx:SetColor(150,150,150)
	
	util.Effect("impulse_teargas", sfx, nil, true)

	self:EmitSound("Weapon_TearGas.Hiss")
end

function SWEP:ProjectileRemove()
	self:StopSound("Weapon_TearGas.Hiss")
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end