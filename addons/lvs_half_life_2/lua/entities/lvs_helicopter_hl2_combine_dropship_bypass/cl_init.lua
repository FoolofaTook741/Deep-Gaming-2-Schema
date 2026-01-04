include("shared.lua")

function ENT:PreDraw()
	local Body = self:GetBody()

	if not IsValid( Body ) then return false end

	Body:DrawModel()
	self:DrawModel()
end

ENT.LightMaterial = Material( "effects/lvs/heli_spotlight" )
ENT.GlowMaterial = Material( "sprites/light_glow02_add" )

function ENT:PreDrawTranslucent()
	if not self:GetLightsEnabled() then 
		self:RemoveLight()

		return false
	end

	local SpotLight = self:GetAttachment( self:LookupAttachment( "Gun_Ref" ) )

	if not SpotLight then return end

	if not IsValid( self.projector ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 5 )
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) )
		thelamp:SetEnableShadows( true )
		thelamp:SetFarZ( 2500 )
		thelamp:SetNearZ( 75 )
		thelamp:SetFOV( 75 )
		self.projector = thelamp
	end

	local forward = SpotLight.Ang:Forward()
	local right = SpotLight.Ang:Right()
	local up = SpotLight.Ang:Up()

	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite( SpotLight.Pos - forward * 9 - right * 5 - up * 7.5, 32, 32, Color( 255, 255, 255, 255) )

	render.SetMaterial( self.LightMaterial )
	render.DrawBeam( SpotLight.Pos - forward * 9 - right * 5 - up * 7.5, SpotLight.Pos + forward * 64 - right * 5 - up * 7.5, 32, 0, 0.99, Color( 100, 100, 100, 255) ) 

	if IsValid( self.projector ) then
		self.projector:SetPos( SpotLight.Pos - forward * 9 - right * 5 - up * 7.5 )
		self.projector:SetAngles( SpotLight.Ang )
		self.projector:Update()
	end

	return false
end

function ENT:OnRemoved()
	self:RemoveLight()
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

function ENT:OnFrame()
	self:DamageFX()
end

function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
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