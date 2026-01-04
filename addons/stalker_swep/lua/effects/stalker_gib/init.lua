	
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/

function EFFECT:Init( data )
	
	local iCount = table.Count( StalkerHeadGibs )
	
	-- Use a random model from the gibs collection
	self.Entity:SetModel( StalkerHeadGibs[ math.random( iCount ) ] )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMaterial( "models/flesh" )
	
	-- Only collide with world/static
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	self.Entity:SetModelScale(0.3)
	
	-- Add Velocity
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
		phys:EnableMotion(true)
		
		phys:Wake()
		phys:SetMaterial( "flesh" )
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( VectorRand() * math.Rand( 20, 50 )/3 )
	end
	
	-- Gib life time
	self.LifeTime = CurTime() + 20
end

function EFFECT:PhysicsCollide(data, physobj)
end
/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	return self.LifeTime > CurTime()
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	self.Entity:DrawModel()

end
