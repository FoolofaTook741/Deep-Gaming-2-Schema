AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.R. MK. I Pulse Orb Attachment"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/ocipr/w_ocipr.mdl")
SWEP.ViewModel = Model("models/weapons/c_ordinalrifle.mdl")
SWEP.ViewModelFOV = 65

SWEP.ViewModelOffset = Vector(2.5, -2, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = ""

SWEP.Primary.Recoil = 0.4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.Damage = 0
SWEP.Primary.HitDelay = 0.1

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.6
SWEP.IronsightsSensitivity = 0.6
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.Primary.Ammo = "AR2AltFire"
SWEP.Primary.Sound = "weapons/irifle/irifle_fire2.wav"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 0

SWEP.ReloadSound = Sound("weapons/projectmmod_ar2/npc_ar2_reload.wav")
SWEP.EmptySound = Sound("Weapon_AR2.Empty")

sound.Add({
	name = "LS2.AR1Orb.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"proto_ar2/irifle_fire2.wav"}
})

sound.Add({
	name = "LS2.AR1Orb.Charging",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"proto_ar2/charging.wav"}
})

--[[function SWEP:PrimaryAttack()
	if not self:CanShoot() then return end

	local clip = self:Clip1()

	if self.Primary.Burst and clip >= 3 then
		self:SetBursting(true)
		self.Burst = 3

		local delay = CurTime() + ((self.Primary.Delay * 3) + (self.Primary.BurstEndDelay or 0.3))
		self:SetNextPrimaryFire(delay)
		self:SetReloadTime(delay)
	elseif clip >= 1 then
		self:EmitSound(Sound("LS2.AR1Orb.Charging"))

			self:SetNextPrimaryFire(CurTime() + 3)
			self:SetNextSecondaryFire(CurTime() + 3)
	
			util.ScreenShake(self.Owner:GetPos(), 3, 4, 1, 2)
	
			local vm = self.Owner:GetViewModel()
			vm:SetSequence("shake")
			vm:SetPlaybackRate(0.5)
		
			timer.Create("ballex3" .. self.Owner:EntIndex(), 0.1, 10, function()
			if IsValid(self) and self.Owner:GetActiveWeapon():GetClass() == "ls_ar1_orb" then
				util.ScreenShake(self.Owner:GetPos(), 3, 4, 1, 2)
				end
			end)
		
			if SERVER then
				timer.Create("ball_chargeend3" .. self.Owner:EntIndex(), 0.3, 1, function()
					if IsValid(self) and self.Owner:GetActiveWeapon():GetClass() == "ls_ar1_orb" then
						self.Owner:ViewPunch(Angle(0, 0, math.Rand(5, 10)))
						self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
						self.Owner:SetAnimation(PLAYER_ATTACK1)
						self.Weapon:EmitSound("NPC_CombineBall.Launch")
						self.Weapon:EmitSound(Sound("LS2.AR1Orb.Single"))
			
						local ent = ents.Create("prop_combine_ball")
						ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 1)
						ent:SetOwner(self.Owner)
						ent:SetSaveValue("m_flRadius",10)
						ent:Activate()
						ent:Spawn()
						ent:SetSaveValue("m_nState", 5)
						ent:SetColor(Color(255,0,0))
                        ent:SetModelScale(1)
						ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 2300)
						ent:Fire("Explode", nil, 2)
			
						local hasHit = false
			
						ent:AddCallback("PhysicsCollide", function(ent, data)
							if not hasHit then 
								local collidedEntity = data.HitEntity
								if IsValid(collidedEntity) and collidedEntity:IsPlayer() then
									hasHit = true
						
									ent:Fire("Explode", nil, 0)
						
									local targets = ents.FindInSphere(ent:GetPos(), 100)
									for _, target in ipairs(targets) do
										if target:IsPlayer() then
											target:EmitSound("weapons/physcannon/energy_disintegrate5.wav")
											target:EmitSound("weapons/physcannon/energy_sing_flyby1.wav")
										end
									end
								end
							end
						end)
						
			
						hook.Add("EntityTakeDamage", "DecreaseCombineBallDamage", function(target, dmginfo)
							if dmginfo:GetInflictor() == ent then
								dmginfo:ScaleDamage(0.5)
							end
						end)
					end
				end)
			end			
	
			timer.Create("ball_chargeendanim3" .. self.Owner:EntIndex(), 2.05, 1, function()
				if IsValid(self) and self.Owner:GetActiveWeapon():GetClass() == "ls_xar2_orb" then
					self:SendWeaponAnim(ACT_VM_IDLE)
				end
			end)

		self:ShootCombineBall()
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	else
		if not self.NoDryFireAnim then
			self:PlayAnim(ACT_VM_DRYFIRE)
			self:QueueIdle()
		end

		self:SetNextPrimaryFire(CurTime() + 1)
    end
end]]--

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(45, 45, 0)

SWEP.SoundString = "weapons/irifle/irifle_fire2.wav"
SWEP.WorldModelString = "models/weapons/w_iiopnirifle.mdl"
SWEP.ViewModelString = "models/weapons/c_iiopnirifle.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end