AddCSLuaFile()

SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "Axe"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee2"

SWEP.WorldModel = Model("models/weapons/hl2meleepack/w_axe.mdl")
SWEP.ViewModel = Model("models/weapons/hl2meleepack/v_axe.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 4
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.Primary.Sound = Sound("WeaponFrag.Roll")
SWEP.Primary.ImpactSound = Sound("Canister.ImpactHard")
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 1.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 19 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Delay = 0.9
SWEP.Primary.Range = 85
SWEP.Primary.StunTime = 0.3

function SWEP:PrePrimaryAttack()
    local vm = self.Owner:GetViewModel()
    if not IsValid(vm) then return end

    local seq = vm:LookupSequence("misscenter1")
    if seq and seq > 0 then
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

    local hitDelay = self.Primary.HitDelay or 0.1
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

function SWEP:MeleeHitFallback(tr)
	if tr and tr.MatType == MAT_WOOD then
		if self.Owner.TreeLastPos and self.Owner.TreeLastPos:DistToSqr(self.Owner:GetPos()) < 6200 then
			self.Owner.TreeLastHP = (self.Owner.TreeLastHP or math.random(5, 8)) - 1

			if self.Owner.TreeLastHP < 1 then
				if self.Owner:CanHoldItem("util_wood") then
					self.Owner:GiveInventoryItem("util_wood")
					self.Owner:Notify("You have gained 1 piece of wood.")

					self.Owner.TreeLastPos = self.Owner:GetPos()
					self.Owner.TreeLastHP = math.random(5, 8)
				else
					self.Owner:Notify("You don't have the space to hold wood.")
					self.Owner.TreeLastPos = self.Owner:GetPos()
					self.Owner.TreeLastHP = 5
				end
			end
		else
			self.Owner.TreeLastPos = self.Owner:GetPos()
			self.Owner.TreeLastHP = math.random(5, 8)
		end

		self:EmitSound("Wood.ImpactHard")

		return true
	end

	return false
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end