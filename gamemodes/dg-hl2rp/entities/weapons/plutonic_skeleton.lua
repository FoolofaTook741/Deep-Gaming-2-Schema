AddCSLuaFile()

SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "Skeleton Knife"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "knife"

SWEP.WorldModel = Model("models/weapons/arccw_go/w_eq_throwingknife_thrown.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_eq_throwingknife.mdl")
SWEP.ViewModelFOV = 65

SWEP.CenteredPos = Vector(0, 0, 0)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 4
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.Primary.Sound = Sound("arccw_go/knife/knife_slash1.wav")
SWEP.Primary.ImpactSound = Sound("arccw_go/knife/knife_hit_01.wav")
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.025
SWEP.Primary.Delay = 0.4
SWEP.Primary.Range = 80
SWEP.Primary.StunTime = 0.35
SWEP.Primary.PenetrationScale = 2
SWEP.IsAlwaysRaised = true
SWEP.Primary.FlashTime = 0

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

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(3.5, -1, 0)
			local offsetAng = Angle(0, 0, 180)
			
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

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end