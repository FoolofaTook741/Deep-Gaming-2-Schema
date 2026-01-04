AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(100,0,15), Angle(0,-90,0) )
	DriverSeat:SetCameraDistance( 0.2 )

	for i = 1, 4 do
		local Seat = self:AddPassengerSeat( Vector(0,0,15), Angle(0,-90,0) )
		Seat:SetCameraDistance( 0.2 )
	end

	self:AddEngineSound( Vector(0,0,0) )

	local rotorsDestroyed = 0

	--self:AddRotor( pos, angle, radius, turn_speed_and_direction )
	self.Rotor = self:AddRotor( Vector(25,-200,200), Angle(0,0,0), 100, -4000 )
	self.Rotor:SetRotorEffects( true )
	self.Rotor:SetHP( 100 )
	function self.Rotor:OnDestroyed( base )
		base:DestroySteering( 2.5 )
		base:ManipulateBoneScale( 12, Vector(0,0,0) )

		self:EmitSound( "physics/metal/metal_box_break2.wav" )

		rotorsDestroyed = rotorsDestroyed + 1

		if rotorsDestroyed >= 2 then
			base:DestroyEngine()
		end
	end

	self.TailRotor = self:AddRotor( Vector(25,200,200), Angle(0,0,0), 100, -4000 )
	self.TailRotor:SetRotorEffects( true )
	self.TailRotor:SetHP( 100 )
	function self.TailRotor:OnDestroyed( base )
		base:DestroySteering( -2.5 )
		base:ManipulateBoneScale( 7, Vector(0,0,0) )

		self:EmitSound( "physics/metal/metal_box_break2.wav" )

		rotorsDestroyed = rotorsDestroyed + 1

		if rotorsDestroyed >= 2 then
			base:DestroyEngine()
		end
	end

	self:AddDS( {
		pos = Vector(-218,4,-1.8),
		ang = Angle(0,0,0),
		mins = Vector(-45,-15,-40),
		maxs =  Vector(75,15,60),
		Callback = function( tbl, ent, dmginfo )
			if dmginfo:GetDamage() <= 0 then return end

			ent.TailRotor:TakeDamageInfo( dmginfo )
		end
	} )

	self:SetSkin(1)
	self:SetBodygroup(5, 1)
end

function ENT:GetMissileOffset()
	return Vector(-60,0,0)
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/helicopter/start.wav" )
	end
end

function ENT:OnCollision( data, physobj )
	if self:IsPlayerHolding() then return false end

	if data.Speed > 60 and data.DeltaTime > 0.2 then
		local VelDif = data.OurOldVelocity:Length() - data.OurNewVelocity:Length()

		if VelDif > 200 then
			local part = self:FindDS( data.HitPos - data.OurOldVelocity:GetNormalized() * 25 )

			if part then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage( 200 )
				dmginfo:SetDamageType( DMG_CRUSH )
				part:Callback( self, dmginfo )
			end
		end
	end

	return false
end

function ENT:OnTick()
	self:AnimBody()
	
	local RPM = self:GetThrottle()
	if RPM >= 1 then
		self:SetBodygroup(3, 1)
		self:SetBodygroup(4, 1)
	else
		self:SetBodygroup(3, 0)
		self:SetBodygroup(4, 0)
	end
end

function ENT:AnimBody()
	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	local FT = FrameTime()

	local LocalAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() )
	local AngVel = PhysObj:GetAngleVelocity()
	local Steer = self:GetSteer()

	self._smVelL = self._smVelL and self._smVelL + (VelL - self._smVelL) * FT * 10 or VelL
	self._smSteer = self._smSteer and self._smSteer + (Steer - self._smSteer) *  FT * 0.2 or Steer

	local accel = self._smVelL.x * 0.0015 + self._smSteer.y * 2 + self._smVelL.z * 0.008
	local sway = -self._smVelL.y * 0.002 - self._smSteer.x * 5

	accel = accel
	sway = sway * 5

	accel = math.Clamp(accel, -5, 5)

	self:ManipulateBoneAngles(self:LookupBone("wing_r"), Angle(0,accel,0))
	self:ManipulateBoneAngles(self:LookupBone("wing_l"), Angle(0,-accel,0))

	accel = accel * 15
	accel = math.Clamp(accel, -10, 60)

	self:ManipulateBoneAngles(self:LookupBone("turbine_r_base"), Angle(0,0,accel - 5))
	self:ManipulateBoneAngles(self:LookupBone("turbine_l_base"), Angle(0,0,accel - 5))

	sway = sway * 5
	sway = math.Clamp(sway, 0, 25)

	self:ManipulateBoneAngles(self:LookupBone("turbine_r_brige"), Angle(0,sway,0))
	self:ManipulateBoneAngles(self:LookupBone("turbine_l_brige"), Angle(0,sway,0))
end
