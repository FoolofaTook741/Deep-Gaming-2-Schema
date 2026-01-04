include("shared.lua")

function ENT:Initialize()
end

function ENT:PreDraw()
	local Body = self:GetBody()

	if not IsValid( Body ) then return false end

	Body:DrawModel()

	if ( !self.projTexture ) then
		local ID = Body:LookupAttachment( "muzzle" )
		local Muzzle = Body:GetAttachment( ID )

		self.projTexture = ProjectedTexture()
		self.projTexture:SetPos( Muzzle.Pos )
		self.projTexture:SetAngles( Muzzle.Ang )
		self.projTexture:SetTexture( "effects/flashlight/soft" )
		self.projTexture:SetFarZ( 6000 )
		self.projTexture:SetNearZ( 10 )
		self.projTexture:SetFOV( 30 )
		self.projTexture:SetColor( color_black )
		self.projTexture:SetBrightness( 10 )
		self.projTexture:SetEnableShadows( true )
		self.projTexture:Update()
	end

	return false
end

function ENT:PreDrawTranslucent()
	return false
end

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.25 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-60,0,-10) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )
	end
end

local color_cyan = Color(0, 255, 255)
function ENT:OnFrame()
	self:AnimRotor()
	self:DamageFX()

	local Body = self:GetBody()
	if ( !IsValid( Body ) ) then return end

	if self.projTexture then
		local ID = Body:LookupAttachment( "muzzle" )
		local Muzzle = Body:GetAttachment( ID )

		if Muzzle then
			self.projTexture:SetPos( Muzzle.Pos )
			self.projTexture:SetAngles( Muzzle.Ang )

			if ( self:GetSpotlightEnabled() ) then
				self.projTexture:SetColor( color_cyan )
			else
				self.projTexture:SetColor( color_black )
			end

			self.projTexture:Update()
		end
	end
end

function ENT:OnRemove()
	if ( self.projTexture ) then
		self.projTexture:Remove()
	end
end

function ENT:AnimRotor()
	local RPM = self:GetThrottle() * 2500

	self.RPM = self.RPM and (self.RPM + RPM * RealFrameTime() * 0.5) or 0

	local Rot = Angle( -self.RPM,0,0)
	Rot:Normalize()

	local Body = self:GetBody()

	if not IsValid( Body ) then return end

	Body:ManipulateBoneAngles( 19, Rot )
end

function ENT:PaintCrosshairSquare( Pos2D, Col )
	local X = Pos2D.x + 1
	local Y = Pos2D.y + 1

	local Size = 20

	surface.SetDrawColor( 0, 0, 0, 80 )
	surface.DrawLine( X - Size, Y + Size, X - Size * 0.5, Y + Size )
	surface.DrawLine( X + Size, Y + Size, X + Size * 0.5, Y + Size )
	surface.DrawLine( X - Size, Y + Size, X - Size, Y + Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y - Size * 0.5 )
	surface.DrawLine( X + Size, Y + Size, X + Size, Y + Size * 0.5 )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y - Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size * 0.5, Y - Size )
	surface.DrawLine( X + Size, Y - Size, X + Size * 0.5, Y - Size )

	if Col then
		surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
	else
		surface.SetDrawColor( 255, 255, 255, 255 )
	end

	X = Pos2D.x
	Y = Pos2D.y

	surface.DrawLine( X - Size, Y + Size, X - Size * 0.5, Y + Size )
	surface.DrawLine( X + Size, Y + Size, X + Size * 0.5, Y + Size )
	surface.DrawLine( X - Size, Y + Size, X - Size, Y + Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size, Y - Size * 0.5 )
	surface.DrawLine( X + Size, Y + Size, X + Size, Y + Size * 0.5 )
	surface.DrawLine( X + Size, Y - Size, X + Size, Y - Size * 0.5 )
	surface.DrawLine( X - Size, Y - Size, X - Size * 0.5, Y - Size )
	surface.DrawLine( X + Size, Y - Size, X + Size * 0.5, Y - Size )

	self:PaintCrosshairCenter( Pos2D, Col )
end