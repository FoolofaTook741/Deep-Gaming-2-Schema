include("shared.lua")

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.25 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-10,25,-10) ) )
			effectdata:SetNormal( self:GetUp() )
			effectdata:SetMagnitude( math.Rand(0.5,1.5) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust_fire", effectdata )
	end
end

function ENT:OnFrame()
	self:AnimRotor()
	self:AnimTail()
	self:DamageFX()
end

function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
end

function ENT:OnRemoved()
	self:RemoveLight()
end

function ENT:AnimTail()
	local Steer = self:GetSteer()

	local TargetValue = -(Steer.x + Steer.z * 2) * 10

	self.sm_pp_rudder = self.sm_pp_rudder and (self.sm_pp_rudder + (TargetValue - self.sm_pp_rudder) * RealFrameTime() * 5) or 0

	if !self.sm_pp_rudder_lerp then
		self.sm_pp_rudder_lerp = 0
	end

	self.sm_pp_rudder_lerp = math.Approach( self.sm_pp_rudder_lerp, self.sm_pp_rudder, 0.1 * RealFrameTime() * 500 )

	self:SetPoseParameter("rudder", self.sm_pp_rudder_lerp)
	self:InvalidateBoneCache() 
end

function ENT:AnimRotor()
	local RPM = self:GetThrottle() * 2500

	self.RPM = self.RPM and (self.RPM + RPM * RealFrameTime() * 0.5) or 0

	local Rot1 = Angle( -self.RPM,0,0)
	Rot1:Normalize() 
	
	local Rot2 = Angle(0,0,self.RPM)
	Rot2:Normalize() 

	self:ManipulateBoneAngles( 2, Rot1 )
	self:ManipulateBoneAngles( 5, Rot2 )
	self:ManipulateBoneAngles( 3, Rot2 )
end


ENT.LightMaterial = Material( "effects/lvs/heli_spotlight" )
ENT.GlowMaterial = Material( "sprites/light_glow02_add" )

local LightRedFlashNext = 0
local LightRedFlastInerta = 0
function ENT:PreDrawTranslucent()
	if not self:GetLightsEnabled() then 
		self:RemoveLight()

		return true
	end

	if LightRedFlashNext < CurTime() and math.Round( CurTime() * 2 ) % 2 == 0 then
		local pos = self:GetPos() - self:GetUp() * 48
		local ang = self:GetAngles()
		local pos01 = pos + ang:Right() * 96
		local pos02 = pos - ang:Right() * 96
		local pos03 = pos - ang:Forward() * 256 + ang:Up() * 64
		EmitSound( "buttons/lightswitch2.wav", pos01, 0, CHAN_AUTO, 1, 50, 0, 100 )
		EmitSound( "buttons/lightswitch2.wav", pos02, 0, CHAN_AUTO, 1, 50, 0, 100 )
		EmitSound( "buttons/lightswitch2.wav", pos03, 0, CHAN_AUTO, 1, 50, 0, 100 )
		LightRedFlashNext = CurTime() + 0.15
		LightRedFlastInerta = Lerp( 0.2, LightRedFlastInerta, 8 )
	else
		LightRedFlastInerta = Lerp( 0.1, LightRedFlastInerta, 0 )
	end

	for i = 0, 2 do
		local Light_Red = self:GetAttachment( self:LookupAttachment( "Light_Red" .. i ) )
		if not Light_Red then continue end

		local size = 64 + math.sin( CurTime() * 10 ) * 4
		size = size * LightRedFlastInerta

		render.SetMaterial( self.GlowMaterial )
		render.DrawSprite( Light_Red.Pos, size, size, Color( 255, 0, 0, 255) )

		local Light_Red_Dynamic = DynamicLight( self:EntIndex() + i )
		if Light_Red_Dynamic then
			Light_Red_Dynamic.pos = Light_Red.Pos
			Light_Red_Dynamic.r = 255 * LightRedFlastInerta
			Light_Red_Dynamic.g = 0
			Light_Red_Dynamic.b = 0
			Light_Red_Dynamic.brightness = 1 * LightRedFlastInerta
			Light_Red_Dynamic.Decay = 1000
			Light_Red_Dynamic.Size = 256
			Light_Red_Dynamic.DieTime = CurTime() + 1
		end
	end

	local SpotLight = self:GetAttachment( self:LookupAttachment( "SpotLight" ) )

	if not SpotLight then return true end

	if not IsValid( self.projector ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 6 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( true ) 
		thelamp:SetFarZ( 4096 ) 
		thelamp:SetNearZ( 96 ) 
		thelamp:SetFOV( 60 )
		self.projector = thelamp
	end

	local Dir = SpotLight.Ang:Forward()

	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite( SpotLight.Pos + Dir * 5, 64, 64, Color( 255, 255, 255, 255) )

	render.SetMaterial( self.LightMaterial )
	render.DrawBeam( SpotLight.Pos, SpotLight.Pos + Dir * 256, 64, 0, 0.99, Color( 100, 100, 100, 200) ) 

	if IsValid( self.projector ) then
		self.projector:SetPos( SpotLight.Pos )
		self.projector:SetAngles( SpotLight.Ang )
		self.projector:Update()
	end

	return true
end
