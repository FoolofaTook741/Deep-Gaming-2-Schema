
ENT.Base = "lvs_base_helicopter"

ENT.PrintName = "Combine Gunship"
ENT.Author = "Riggs"
ENT.Information = "Combine Synth Gunship from Half Life 2 + Episodes"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combinegunship.png"

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.DisableBallistics = true

ENT.MDL = "models/blu/combine_gunship.mdl"
ENT.GibModels = {
	"models/gibs/gunship_gibs_engine.mdl",
	"models/gibs/gunship_gibs_eye.mdl",
	"models/gibs/gunship_gibs_headsection.mdl",
	"models/gibs/gunship_gibs_midsection.mdl",
	"models/gibs/gunship_gibs_nosegun.mdl",
	"models/gibs/gunship_gibs_sensorarray.mdl",
	"models/gibs/gunship_gibs_tailsection.mdl",
	"models/gibs/gunship_gibs_wing.mdl",
}

ENT.AITEAM = 1

ENT.MaxHealth = 1600

ENT.MaxVelocity = 2150

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.2
ENT.ThrottleRateDown = 0.2

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearDampingMultiplier = 1.5

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.EngineSounds = {
	{
		sound = "^npc/combine_gunship/engine_whine_loop1.wav",
		--sound_int = "lvs/vehicles/helicopter/loop_interior.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
	{
		sound = "npc/combine_gunship/engine_rotor_loop1.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "Body" )
	self:AddDT( "Bool", "SpotlightEnabled" )
end

function ENT:GetAimAngles()
	local Muzzle = self:GetAttachment( self:LookupAttachment( "muzzle" ) )

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

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 2000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.StartAttack = function( ent )
		if not IsValid( ent.weaponSND ) then return end

		ent.weaponSND:EmitSound("NPC_CombineGunship.CannonStartSound")

		self.ShouldPlaySND = true
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.weaponSND ) then return end

		self.ShouldPlaySND = false

		ent.weaponSND:Stop()
		ent.weaponSND:EmitSound("NPC_CombineGunship.CannonStopSound")
	end
	weapon.Attack = function( ent )
		if not ent:WeaponsInRange() then

			ent.ShouldPlaySND = false

			return true
		end

		ent.ShouldPlaySND = true

		local Body = ent:GetBody()

		if not IsValid( Body ) then return end

		local Muzzle = Body:GetAttachment( Body:LookupAttachment( "muzzle" ) )

		if not Muzzle then return end

		local trace = ent:GetEyeTrace()

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= (trace.HitPos - Muzzle.Pos):GetNormalized()
		bullet.Spread 	= Vector(0.02,0.02,0.02)
		bullet.TracerName = "lvs_pulserifle_tracer_large"
		bullet.Force	= 2000
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
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	self:AddWeapon( weapon )

	local color_red = Color(255,0,0,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/warplaser.png")
	weapon.Ammo = -1
	weapon.Delay = 4
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.05
	weapon.Attack = function( ent )
		if ent:GetAI() and not ent:BellyInRange() then return true end

		ent:SetHeat( 100 )
		ent:SetOverheated( true )

		local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			effectdata:SetEntity( ent:GetBody() )
		util.Effect( "lvs_warpcannon_charge", effectdata )

		timer.Simple( 2, function()
			if not IsValid( ent ) then return end

			local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() )
				effectdata:SetEntity( ent:GetBody() )
			util.Effect( "lvs_warpcannon_fire", effectdata )

			timer.Simple( 0.2, function()
				if not IsValid( ent ) then return end

				ent:FireBellyCannon()
			end )
		end )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetBody()

		if not IsValid( base ) then return end

		local Muzzle = base:GetAttachment( base:LookupAttachment( "bellygun" ) )

		if not Muzzle then return end

		local trace = util.TraceLine( {
			start = Muzzle.Pos,
			endpos = Muzzle.Pos + base:GetAimVector() * 50000,
			mask = MASK_SOLID_BRUSHONLY
		} )

		local Pos2D = trace.HitPos:ToScreen()

		ent:PaintCrosshairSquare( Pos2D, ent:BellyInRange() and color_white or color_red )
		ent:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0

	self:AddWeapon(weapon)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/light.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0

	weapon.StartAttack = function( ent )
		if ent:GetAI() then return end

		ent:EmitSound( "items/flashlight1.wav", 75, 105 )

		if ( ent:GetSpotlightEnabled() ) then
			if ( IsValid(ent._spotlight) ) then
				ent._spotlight:Fire("LightOff", "", 0)
			end

			if ( IsValid(ent._spotlightSprite) ) then
				ent._spotlightSprite:Fire("HideSprite", "", 0)
			end
		else
			if ( IsValid(ent._spotlight) ) then
				ent._spotlight:Fire("LightOn", "", 0)
			end

			if ( IsValid(ent._spotlightSprite) ) then
				ent._spotlightSprite:Fire("ShowSprite", "", 0)
			end
		end

		ent:SetSpotlightEnabled(!ent:GetSpotlightEnabled())
	end

	self:AddWeapon(weapon)
end