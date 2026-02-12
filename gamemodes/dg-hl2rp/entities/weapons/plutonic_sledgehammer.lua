AddCSLuaFile()

SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "Sledgehammer"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee2"

SWEP.WorldModel = Model("models/weapons/tfa_nmrih/w_me_sledge.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_nmrih/v_me_sledge.mdl")
SWEP.ViewModelFOV = 60

SWEP.CenteredPos = Vector(0, 0, 0)
SWEP.CenteredAng = Angle(0,0,0)
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
SWEP.Primary.Damage = 40 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.2
SWEP.Primary.HitDelay = 0.4
SWEP.Primary.Range = 120
SWEP.Primary.StunTime = 3.8
SWEP.Primary.HullSize = 7
SWEP.Primary.FlashTime = 0

function SWEP:PrePrimaryAttack()
    local vm = self.Owner:GetViewModel()
    if not IsValid(vm) then return end

    local seq = vm:LookupSequence("Attack_Charge_Begin")
    if seq and seq > 0 then
        vm:SendViewModelMatchingSequence(seq)
        vm:SetPlaybackRate(1.0) 
        self.NextIdle = CurTime() + vm:SequenceDuration(seq)
    end
end

function SWEP:PrimaryAttack()
    if self.PrePrimaryAttack then
        self:PrePrimaryAttack()
    end

    self:EmitSound(self.Primary.Sound)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local hitDelay = self.Primary.HitDelay or 0.8
    timer.Simple(hitDelay, function()
        if IsValid(self) and IsValid(self:GetOwner()) then
            self:ClubAttack()
            self:ViewPunch()

            local vm = self.Owner:GetViewModel()
            if IsValid(vm) then
                local endSeq = vm:LookupSequence("Attack_Charge_End")
                if endSeq > 0 then
                    vm:SendViewModelMatchingSequence(endSeq)
                    self.NextIdle = CurTime() + vm:SequenceDuration(endSeq)
                end
            end
        end
    end)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end


if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(4, -1, 0)
			local offsetAng = Angle(-25, 0, 180)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

SWEP.WorldModelString = "models/weapons/tfa_nmrih/w_me_sledge.mdl"
SWEP.ViewModelString = "models/weapons/tfa_nmrih/v_me_sledge.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end