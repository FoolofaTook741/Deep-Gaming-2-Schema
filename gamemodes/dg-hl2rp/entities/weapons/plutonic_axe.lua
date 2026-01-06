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

        self:SetNextIdle(CurTime() + vm:SequenceDuration(seq))
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

function SWEP:ClubAttack()
	local trace = {}
	trace.start = self:GetOwner():GetShootPos()
	trace.endpos = trace.start + self:GetOwner():GetAimVector() * (self.Primary.Range or 85)
	trace.filter = self:GetOwner()
	trace.mask = MASK_SHOT_HULL

	local boxSize = self.Primary.HullSize or 6
	trace.mins = Vector(-boxSize, -boxSize, -boxSize)
	trace.maxs = Vector(boxSize, boxSize, boxSize)

	self:GetOwner():LagCompensation(true)
	local tr = util.TraceHull(trace)
	self:GetOwner():LagCompensation(false)

	if CLIENT then
		debugoverlay.BoxAngles(tr.HitPos, trace.mins, trace.maxs, self:GetOwner():EyeAngles(), 5, Color(200, 0, 0, 100))
	end

	if SERVER and tr.Hit then

		hook.Run("LongswordMeleeHit", self:GetOwner())

		if self.Primary.ImpactSound and not self.Primary.ImpactSoundWorldOnly then
			self:GetOwner():EmitSound(self.Primary.ImpactSound)
		end

		if self.Primary.ImpactEffect then
			local effect = EffectData()
			effect:SetStart(tr.HitPos)
			effect:SetNormal(tr.HitNormal)
			effect:SetOrigin(tr.HitPos)
			util.Effect(self.Primary.ImpactEffect, effect, true, true)
		end

		local ent = tr.Entity
		if IsValid(ent) then
			local newdmg = hook.Run("LongswordCalculateMeleeDamage", self:GetOwner(), self.Primary.Damage, ent)
			hook.Run("LongswordHitEntity", self:GetOwner(), ent)

			local dmg = DamageInfo()
			dmg:SetAttacker(self:GetOwner())
			dmg:SetInflictor(self)
			dmg:SetDamage(newdmg or self.Primary.Damage)
			dmg:SetDamageType(DMG_CLUB)
			dmg:SetDamagePosition(tr.HitPos)

			if ent:GetClass() ~= "prop_ragdoll" then
				dmg:SetDamageForce(self:GetOwner():GetAimVector() * 10000)
			end

			ent:DispatchTraceAttack(dmg, trace.start, trace.endpos)

			if ent:IsPlayer() then
				if self.Primary.FlashTime then
					ent:ScreenFade(SCREENFADE.IN, self.Primary.FlashColor or color_white, self.Primary.FlashTime, 0)
					ent.StunTime = CurTime() + self.Primary.FlashTime
					ent.StunStartTime = CurTime()
				elseif self.Primary.StunTime then
					ent.StunTime = CurTime() + self.Primary.StunTime
					ent.StunStartTime = CurTime()
				end
			end

			if tr.MatType == MAT_FLESH then
				ent:EmitSound("Flesh.ImpactHard")
				local effect = EffectData()
				effect:SetStart(tr.HitPos)
				effect:SetNormal(tr.HitNormal)
				effect:SetOrigin(tr.HitPos)
				util.Effect("BloodImpact", effect, true, true)
			elseif tr.MatType == MAT_WOOD then
				ent:EmitSound("Wood.ImpactHard")
			elseif tr.MatType == MAT_CONCRETE then
				ent:EmitSound("Concrete.ImpactHard")
			elseif self.Primary.ImpactSoundWorldOnly then
				self:GetOwner():EmitSound(self.Primary.ImpactSound)
			end
		elseif self.MeleeHitFallback and self:MeleeHitFallback(tr) then
			return
		elseif self.Primary.ImpactSoundWorldOnly then
			self:GetOwner():EmitSound(self.Primary.ImpactSound)
		end
	end
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end