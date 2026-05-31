AddCSLuaFile()

SWEP.Base = "plutonic_base_projectile"

SWEP.PrintName = "M320 GL-HE"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/v92/weapons/bf3/m320/combo.mdl")
SWEP.ViewModel = Model("models/v92/weapons/bf3/m320/combo.mdl")
SWEP.ViewModelFOV = 40
SWEP.ExpEffect = "lvs_explosion_bomb"

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound("LS.M320.Fire")
SWEP.Primary.Recoil = 0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.HitDelay = 0.1

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

SWEP.CenteredPos = Vector(0, 0, 0)
SWEP.CenteredAng = Angle(0,0,0)

sound.Add({
	name = "LS.M320.Fire",
	sound = "v92/weapons/bf3/m320/single_1.wav",
	level = 56,
	pitch = 100
})

function SWEP:Reload()
    self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:ProjectileFire()
	local pos = self:GetPos()
	local owner = self:GetOwner()
    for k,v in pairs(ents.GetAll()) do
        if v:GetClass() == "prop_physics" and v:CPPIGetOwner() and v:GetPos():Distance(pos) < 125 then
            if (owner:IsCP() and !v:CPPIGetOwner():IsCP()) or (!owner:IsCP() and v:CPPIGetOwner():IsCP()) then
                v:Remove()
            end
        end
    end
    util.BlastDamage( self, owner, pos, 125, 45 )
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

function SWEP:PrimaryAttack()
    if self:Clip1() < 1 then
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        return
    end

    self:ThrowAttack()
    self:ViewPunch()

    if self.Primary.Sound ~= "" then
        self:EmitSound(self.Primary.Sound)
    end

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SendWeaponAnim(ACT_VM_THROW)
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:SendWeaponAnim(ACT_VM_DRAW)
end