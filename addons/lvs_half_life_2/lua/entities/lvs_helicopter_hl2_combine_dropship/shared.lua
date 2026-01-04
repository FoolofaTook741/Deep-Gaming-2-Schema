
ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "Combine Dropship"
ENT.Author = "Riggs"
ENT.Information = "Combine Synth Dropship from Half Life 2 + Episodes, must be noclipped to enter, or opening the door as the pilot to allow passengers to enter."
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combinedropship.png"

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.DisableBallistics = true

ENT.MDL = "models/combine_dropship_container.mdl"
ENT.GibModels = {
	"models/container_chunk01.mdl",
	"models/container_chunk02.mdl",
	"models/container_chunk03.mdl",
	"models/container_chunk04.mdl",
	"models/container_chunk05.mdl",
}

ENT.AITEAM = 1

ENT.MaxHealth = 6000

ENT.MaxVelocity = 1750

ENT.ThrustUp = 0.7
ENT.ThrustDown = 0.4
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.1
ENT.ThrottleRateDown = 0.1

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.EngineSounds = {
	{
		sound = "NPC_CombineDropship.RotorLoop",
		sound_int = "npc/combine_gunship/dropship_engine_distant_loop1.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		UseDoppler = true,
	},
	{
		sound = "NPC_CombineDropship.OnGroundRotorLoop",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		UseDoppler = true,
	},
	{
		sound = "NPC_CombineDropship.NearRotorLoop",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "Body" )
	self:AddDT( "Bool", "LightsEnabled" )
	self:AddDT( "Bool", "Deploying" )
	self:AddDT( "Bool", "Door" )
end

function ENT:GetAimAngles()
	local Muzzle = self:GetAttachment( self:LookupAttachment( "Muzzle" ) )

	if not Muzzle then return end

	local trace = self:GetEyeTrace()

	local AimAngles = self:WorldToLocalAngles( (trace.HitPos - Muzzle.Pos):GetNormalized():Angle() )

	return AimAngles
end

function ENT:WeaponsInRange()
	return self:AngleBetweenNormal( self:GetForward(), self:GetAimVector() ) < 75
end

function ENT:BellyInRange()
	return self:AngleBetweenNormal( -self:GetUp(), self:GetAimVector() ) < 45
end

function ENT:SetPoseParameterTurret()
	local AimAngles = self:GetAimAngles()

	self:SetPoseParameter("weapon_yaw", AimAngles.y )
	self:SetPoseParameter("weapon_pitch", -AimAngles.p )
end

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 2000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 0.25
	weapon.StartAttack = function( ent )
		if not IsValid( ent.weaponSND ) then return end

		self.ShouldPlaySND = true
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.weaponSND ) then return end

		self.ShouldPlaySND = false

		ent.weaponSND:Stop()
	end
	weapon.Attack = function( ent )
		if not ent:WeaponsInRange() then

			ent.ShouldPlaySND = false

			return true
		end

		ent.ShouldPlaySND = true

		local Muzzle = ent:GetAttachment( ent:LookupAttachment( "Muzzle" ) )

		if not Muzzle then return end

		local trace = ent:GetEyeTrace()

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= (trace.HitPos - Muzzle.Pos):GetNormalized()
		bullet.Spread 	= Vector(0.02,0.02,0.02)
		bullet.TracerName = "lvs_pulserifle_tracer_large"
		bullet.Force	= 10
		bullet.HullSize 	= 6
		bullet.Damage	= 18
		bullet.Velocity = 12000
		bullet.Attacker 	= self:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
			effectdata:SetNormal( tr.HitNormal * 2 )
			effectdata:SetRadius( 10 )
			util.Effect( "cball_bounce", effectdata, true, true )
		end
		self:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( Muzzle.Pos )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_pulserifle_muzzle", effectdata )

		ent:TakeAmmo()
	end
	weapon.OnThink = function( ent, active )
		ent:SetPoseParameterTurret()

		if not IsValid( ent.weaponSND ) then return end

		local ShouldPlay = ent.ShouldPlaySND and active

		if ent._oldShouldPlaySND ~= ShouldPlay then
			ent._oldShouldPlaySND = ShouldPlay
			if ShouldPlay then
				ent.weaponSND:Play()
			else
				ent.weaponSND:Stop()
			end
		end
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnDeselect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav", nil, 90)
	end
	self:AddWeapon( weapon )

	weapon = {}
	weapon.Icon = Material("lvs/weapons/light.png")
	weapon.UseableByAI = false
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.StartAttack = function( ent )
		if not ent.SetLightsEnabled then return end

		if ent:GetAI() then return end

		ent:SetLightsEnabled( not ent:GetLightsEnabled() )
		ent:EmitSound( "items/flashlight1.wav", 75, 105 )
	end
	weapon.OnThink = function( ent, active )
		ent:SetPoseParameterTurret()
	end
	self:AddWeapon( weapon )

	weapon = {}
	weapon.Icon = Material("lvs/engine.png")
	weapon.UseableByAI = false
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 1
	weapon.OnThink = function( ent )
		if not ( ent.deploySound ) then
			ent.deploySound = CreateSound(ent, "NPC_CombineDropship.DescendingWarningLoop")
		end

		if ( ent.deploySound and not ent.deploySound:IsPlaying() ) then
			ent.deploySound:PlayEx(0, 100)
		end

		// Check if we are near the ground, if so open the door, if not close it
		local trace = util.TraceLine({
			start = ent:GetPos(),
			endpos = ent:GetPos() - Vector(0, 0, 100),
			filter = ent
		})

		if ( trace.Hit and not ent:GetDoor() and ent:GetDeploying() ) then
			ent:ResetSequence(ent:LookupSequence("open"))
			ent:EmitSound( "doors/door_metal_thin_move1.wav", 75, 90 )
			ent:SetDoor( true )
		elseif ( !trace.Hit and ent:GetDoor() ) or ( !ent:GetDeploying() and ent:GetDoor() ) then
			ent:ResetSequence(ent:LookupSequence("close"))
			ent:EmitSound( "doors/door_metal_thin_move1.wav", 75, 100 )
			ent:SetDoor( false )
		end
	end
	weapon.StartAttack = function( ent )
		if not ent.SetDeploying then return end

		if ent:GetAI() then return end

		ent:SetDeploying( not ent:GetDeploying() )

		if ( ent.deploySound ) then
			if ( ent:GetDeploying() ) then
				ent.deploySound:ChangeVolume(1, 1)
			else
				ent.deploySound:ChangeVolume(0, 3)
			end
		end
	end

	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0

	self:AddWeapon(weapon)
end