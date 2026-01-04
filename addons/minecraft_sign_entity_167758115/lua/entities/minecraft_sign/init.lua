//********************************//
//     Minecraft Sign Entity      //
//			 (c) McKay			  //
//********************************//

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

resource.AddFile("resource/fonts/minecraft.ttf")
resource.AddFile("models/MCModelPack/entities/sign.mdl")
resource.AddFile("materials/vgui/entities/minecraft_sign.vmt")
resource.AddFile("materials/models/sparkle.vmt")
resource.AddFile("materials/models/MCModelPack/sign.vmt")

util.AddNetworkString("MinecraftSignTextChange")
net.Receive("MinecraftSignTextChange", function( len )
		local sign = net.ReadEntity()
		local newText = net.ReadString()
		SaveText( nil, sign, { text = newText } )
	end )

function ENT:Initialize()
	self:SetModel( "models/MCModelPack/entities/sign.mdl" )

    //no movement
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )   
	// Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false ) //freeze the block
		phys:Wake()
	end
	
	self:SetUseType( SIMPLE_USE )
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	
	//orient facing the player
	local base = Vector( -1, 0, 0 ) //North vector
	local thevector = SpawnPos - ply:GetPos()
	local angle = GetAngleBetweenVectors( base, thevector )
	ent:SetAngles( Angle( 0, angle, 0) )
	
	ent:Spawn()
	ent:Activate()

	return ent
end

//***************************************
//	OnTakeDamage
//***************************************

function ENT:OnTakeDamage( dmginfo )
	// React physically when shot/getting blown
	self.Entity:TakePhysicsDamage( dmginfo )
	
	if (self.health <= 0) then return end;
	self.health = self.health - dmginfo:GetDamage();
	if (self.health <= 0) then
		self:RemoveSpecial();
	end
end

//***************************************
//	Remove with particle effects
//***************************************

function ENT:RemoveSpecial()
	//can't touch this (anymore)
	self:SetNotSolid( true )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetNoDraw( true )
	
	if ( self.health != -1 ) then
		//create particle effect
		local effect = EffectData();
		local pos = self:GetPos();
		local aabb_min, aabb_max = self:WorldSpaceAABB();
		local zadd = math.abs(aabb_min.z - aabb_max.z)/2
		pos.z = pos.z + zadd;
		effect:SetOrigin( pos )
		effect:SetNormal( Vector(0,0,1) );
		effect:SetEntity( self )
		util.Effect( "mc-sparkle", effect, true, true );
		
		//properly remove after 0.2 seconds
		timer.Simple( 0.2, function() if ( IsValid( self ) ) then self:Remove() end end )
	else
		self:Remove()
	end
end

//***************************************
//	OnSpawn - sounds and health values
//***************************************

function ENT:OnSpawn( ID, hitEntity )
	self.spawned = true
end
