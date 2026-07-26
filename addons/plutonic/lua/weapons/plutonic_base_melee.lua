AddCSLuaFile()
SWEP.Base = "plutonic_base"
SWEP.IsMelee = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Sound = Sound("WeaponFrag.Roll")
SWEP.Primary.ImpactSound = Sound("Canister.ImpactHard")
function SWEP:PrimaryAttack()
	if self.PrePrimaryAttack then
		self.PrePrimaryAttack(self)
	end

	if self.Primary.HitDelay then
		timer.Simple(
			self.Primary.HitDelay,
			function()
				if IsValid(self) and IsValid(self:GetOwner()) then
					self:ClubAttack()
					self:ViewPunch()
				end
			end
		)
	else
		self:ClubAttack()
		self:ViewPunch()
	end

	self:EmitSound(self.Primary.Sound)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	--[[self:PlayAnim(self.HitAnim or ACT_VM_HITCENTER)
	if self.DoFireAnim then
		self:PlayAnim(ACT_VM_PRIMARYATTACK)
	else
		self:PlayAnim(ACT_VM_HITCENTER)
	end
	]]
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Think()
	if CLIENT then
		self:ViewmodelThink()
	end

	self:IdleThink()
	if self.CustomThink then
		self.CustomThink(self)
	end
end

function SWEP:Reload()
	return
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
		self:PlayAnim(ACT_VM_HITCENTER)
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
			if SERVER and ent:IsPlayer() and self.Primary.FlashTime then
			    local activeWep = ent:GetActiveWeapon()
			    local hasLSWep = IsValid(activeWep) and string.find(activeWep:GetClass(), "plutonic_")

			    if not hasLSWep then
			        ent:ScreenFade(SCREENFADE.IN, self.Primary.FlashColour or color_white, self.Primary.FlashTime, 0)
			    end

			    ent.StunTime = CurTime() + self.Primary.FlashTime
			    ent.StunStartTime = CurTime()

			    if not hasLSWep and self.GetMode then
				    local mode = self:GetMode()

				    if mode == 2 and not ent:IsFrozen() then
					    if not ent.StunComboLastHit or (CurTime() - ent.StunComboLastHit) > 5 then
					        ent.StunComboHits = {}
					        ent.Hits = 0
					    end

					    ent.Hits = (ent.Hits or 0) + 1
					    ent.StunComboHits = ent.StunComboHits or {}
					    table.insert(ent.StunComboHits, 2)
					    if #ent.StunComboHits > 2 then
					        table.remove(ent.StunComboHits, 1)
					    end
					    ent.StunComboLastHit = CurTime()

				        if ent.Hits >= 3 then
				            ent:Freeze(true)
				            ent:SetSyncVar(SYNC_STUNNED, true, true)
				            timer.Simple(2, function()
				                if IsValid(ent) then
				                    ent:Freeze(false)
				                    ent.Hits = 0
				                    ent:SetSyncVar(SYNC_STUNNED, false, true)
				                end
				            end)
				        end
				    elseif mode == 3 then
				        local combo = ent.StunComboHits
				        local withinWindow = ent.StunComboLastHit and (CurTime() - ent.StunComboLastHit) <= 3
				        local comboReady = withinWindow and combo and combo[1] == 2 and combo[2] == 2

				        ent.StunComboHits = {}

				        if comboReady and not ent.KnockedOut then
				            hook.Run("StunBatonKnockout", self:GetOwner(), ent)
				        end
				    end
				end
			elseif SERVER and ent:IsPlayer() and self.Primary.StunTime then
			    ent.StunTime = CurTime() + self.Primary.StunTime
			    ent.StunStartTime = CurTime()
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
		elseif self.MeleeHitFallback and self.MeleeHitFallback(self, tr) then
			return
		elseif self.Primary.ImpactSoundWorldOnly then
			self:GetOwner():EmitSound(self.Primary.ImpactSound)
		end
	elseif SERVER then
		self:PlayAnim(ACT_VM_MISSCENTER)
	end
end