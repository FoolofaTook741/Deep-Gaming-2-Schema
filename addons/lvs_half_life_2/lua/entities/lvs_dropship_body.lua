AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.DoNotDuplicate = true

ENT.AutomaticFrameAdvance = true

ENT._LVS = true

function ENT:PlayAnimation( animation, playbackrate )
	playbackrate = playbackrate or 1

	local sequence = self:LookupSequence( animation )

	self:ResetSequence( sequence )
	self:SetPlaybackRate( playbackrate )
	self:SetSequence( sequence )
end

function ENT:GetAimVector()
	local Parent = self:GetParent()

	if not IsValid( Parent ) or not Parent.GetAimVector then return -self:GetUp() end

	local Muzzle = self:GetAttachment( self:LookupAttachment( "bellygun" ) )

	if not Muzzle then return -self:GetUp() end

	local AimAng = self:WorldToLocalAngles( (Parent:GetEyeTrace().HitPos - Muzzle.Pos):Angle() )

	AimAng.p = math.Clamp( AimAng.p, 45, 90 )

	return self:LocalToWorldAngles( AimAng ):Forward()
end

if SERVER then
	function ENT:Initialize()	
		self:SetModel( "models/combine_dropship.mdl" )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:SetNoDraw( true )
	end

	function ENT:Think()	
		self:NextThink( CurTime() )

		return true
	end
else
	function ENT:Initialize()	
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end