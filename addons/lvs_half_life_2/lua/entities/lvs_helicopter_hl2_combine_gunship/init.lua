AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

local color_cyan = Color(0, 255, 255)
function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(200,0,0), Angle(0,-90,0) )
	DriverSeat:SetCameraDistance( 0.2 )
	DriverSeat.HidePlayer = true

	self:AddEngineSound( Vector(-133,0,55) )

	self:DrawShadow( false )

	local Body = ents.Create( "lvs_gunship_body" )
	Body:SetPos( self:GetPos() )
	Body:SetAngles( self:GetAngles() )
	Body:Spawn()
	Body:Activate()
	Body:SetParent( self )
	Body:SetSkin( 1 )
	self:DeleteOnRemove( Body )
	self:TransferCPPI( Body )
	self:SetBody( Body )

	local Rotor = self:AddRotor( Vector(-133,0,55), Angle(0,0,0), 0, 4000 )
	Rotor:SetRotorEffects( true )

	local ID = Body:LookupAttachment( "muzzle" )
	local Muzzle = Body:GetAttachment( ID )
	self.weaponSND = self:AddSoundEmitter( Body:WorldToLocal( Muzzle.Pos ), "npc/combine_gunship/gunship_weapon_fire_loop6.wav", "npc/combine_gunship/gunship_fire_loop1.wav" )
	self.weaponSND:SetSoundLevel( 110 )
	self.weaponSND:SetParent( Body, ID )

	self._spotlight = ents.Create( "point_spotlight" )
	if ( IsValid(self._spotlight) ) then
		self._spotlight:SetPos(Muzzle.Pos)
		self._spotlight:SetAngles(Muzzle.Ang)
		self._spotlight:SetParent( Body, ID )
		self._spotlight:SetKeyValue("spotlightlength", "1500")
		self._spotlight:SetKeyValue("spotlightwidth", "150")
		self._spotlight:AddSpawnFlags(2)
		self._spotlight:SetColor(color_cyan)
		self._spotlight:Spawn()
		self._spotlight:Activate()
		self._spotlight:Fire("LightOff", "", 0)
	end

	local sprite = ents.Create( "env_sprite" )
	if ( IsValid(sprite) ) then
		sprite:SetPos( Muzzle.Pos )
		sprite:SetParent( Body, ID )
		sprite:RemoveSpawnFlags(1)
		sprite:SetKeyValue( "rendermode", 9 )
		sprite:SetKeyValue( "model", "sprites/light_ignorez.vmt" )
		sprite:SetKeyValue( "scale", 1.5 )
		sprite:SetColor(color_cyan)
		sprite:Spawn()
		sprite:Activate()
		sprite:Fire("HideSprite", "", 0)

		self._spotlightSprite = sprite
	end
end

function ENT:SetRotor( PhysRot )
	local Body = self:GetBody()

	if not IsValid( Body ) then return end

	if self._oldPhysRot ~= PhysRot then
		self._oldPhysTor = PhysRot

		if PhysRot then
			Body:SetSkin( 1 )
		else
			Body:SetSkin( 0 )
		end
	end
end

function ENT:OnTick()
	local PhysRot = self:GetThrottle() < 0.85

	if not self:IsEngineDestroyed() then
		self:SetRotor( PhysRot )
	end

	self:AnimBody()
	self:BodySounds()
end

function ENT:BodySounds()
	local T = CurTime()

	if (self._nextBodySND or 0) > T then return end

	self._nextBodySND = T + 2

	local HP = self:GetHP()

	if self._oldHPsnd ~= HP then
		if isnumber( self._oldHPsnd ) then
			if self._oldHPsnd > HP and math.abs(self._oldHPsnd - HP) > 100 then
				self:EmitSound("NPC_CombineGunship.Pain")
			end
		end

		self._oldHPsnd = HP
	end

	local trace = self:GetEyeTrace()

	local SeeEnemy = IsValid( trace.Entity ) and trace.Entity ~= self._oldEnemySND and trace.Entity.LVS and self:IsEnemy( trace.Entity )

	if SeeEnemy then
		self._oldEnemySND = trace.Entity
		self:EmitSound("NPC_CombineGunship.SeeEnemy")
	end
end

function ENT:AnimBody()
	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	local Body = self:GetBody()

	if not IsValid( Body ) then return end

	local FT = FrameTime()

	local LocalAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() )
	local AngVel = PhysObj:GetAngleVelocity()
	local Steer = self:GetSteer()

	self._smLocalAngles = self._smLocalAngles and self._smLocalAngles + (LocalAngles - self._smLocalAngles) * FT * 4 or LocalAngles
	self._smVelL = self._smVelL and self._smVelL + (VelL - self._smVelL) * FT * 10 or VelL
	self._smAngVel = self._smAngVel and self._smAngVel + (AngVel - self._smAngVel) * FT * 10 or AngVel
	self._smSteer = self._smSteer and self._smSteer + (Steer - self._smSteer) *  FT * 0.2 or Steer

	Body:SetPoseParameter("flex_vert", self._smSteer.y * 10 + self._smLocalAngles.p * 0.5 )
	Body:SetPoseParameter("flex_horz", self._smAngVel.z * 0.25 - self._smSteer.x * 10 + self._smLocalAngles.y * 0.5 )
	Body:SetPoseParameter("fin_accel", self._smVelL.x * 0.0015 + self._smSteer.y * 2 + self._smVelL.z * 0.008 )
	Body:SetPoseParameter("fin_sway", -self._smVelL.y * 0.007 - self._smSteer.x * 5 )
	Body:SetPoseParameter("antenna_accel", self._smVelL.x * 0.005 )
	Body:SetPoseParameter("antenna_sway", -self._smVelL.y * 0.005 )
end

function ENT:FireBellyCannon()
	local base = self:GetBody()

	if not IsValid( base ) then return end

	local Muzzle = base:GetAttachment( base:LookupAttachment( "bellygun" ) )

	if not Muzzle then return end

	local traceTarget = util.TraceLine( {
		start = Muzzle.Pos,
		endpos = Muzzle.Pos + base:GetAimVector() * 50000,
		filter = self:GetCrosshairFilterEnts()
	} )

	local traceBrush = util.TraceLine( {
		start = Muzzle.Pos,
		endpos = Muzzle.Pos + base:GetAimVector() * 50000,
		mask = MASK_SOLID_BRUSHONLY,
	} )

	local Driver = self:GetDriver()

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( IsValid( Driver ) and Driver or self )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamage( 500 )
	dmginfo:SetDamageType( DMG_DISSOLVE )
	dmginfo:SetDamagePosition( traceBrush.HitPos )

	util.BlastDamageInfo( dmginfo, traceBrush.HitPos, 500 )

	local HitEnt = traceTarget.Entity

	if not IsValid( HitEnt ) then return end

	dmginfo:SetDamage( 5000 )

	HitEnt:TakeDamageInfo( dmginfo )
end
