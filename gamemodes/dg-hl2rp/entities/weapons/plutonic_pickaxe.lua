AddCSLuaFile()

SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "Pickaxe"
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
SWEP.Primary.Recoil = 3.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 30 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.Primary.HitDelay = 0.4
SWEP.Primary.Range = 100
SWEP.Primary.StunTime = 0.8
SWEP.Primary.HullSize = 7
SWEP.Primary.FlashTime = 0

function SWEP:PrePrimaryAttack()
    local vm = self.Owner:GetViewModel()
    if not IsValid(vm) then return end

    local seq = vm:LookupSequence("misscenter1")

    if seq > 0 then
        vm:SendViewModelMatchingSequence(seq)
        self.NextIdle = CurTime() + vm:SequenceDuration(seq)
    end
end

function SWEP:PrimaryAttack()
    if self.PrePrimaryAttack then
        self:PrePrimaryAttack()
    end

    self:EmitSound(self.Primary.Sound)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local hitDelay = self.Primary.HitDelay or 0.3
    timer.Simple(hitDelay, function()
        if IsValid(self) and IsValid(self:GetOwner()) then
            self:ClubAttack()
            self:ViewPunch()
        end
    end)

    local vm = self.Owner:GetViewModel()
    if IsValid(vm) then
        local seqDuration = vm:SequenceDuration()
        self:SetNextIdle(CurTime() + seqDuration)
    end

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end