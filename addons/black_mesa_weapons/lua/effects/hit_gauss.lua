function EFFECT:Init(data)
	self.EndPos = data:GetOrigin()
    self.Scale = data:GetScale() or 1
    self.Delay = 0.2 * self.Scale
    self.EndTime = CurTime()+self.Delay
	
	local emi = ParticleEmitter( self.EndPos )
	for i = 1,math.floor(20 * self.Scale) do
        local particle = emi:Add( "sprites/light_glow02_add", self.EndPos)
        particle:SetVelocity(VectorRand()*math.random(200,500))
        particle:SetDieTime( 2 )
        particle:SetStartAlpha( math.Rand(230, 250) )
        particle:SetStartSize( math.Rand( 8, 16 ) )
        particle:SetEndSize( 0 )
        particle:SetEndAlpha( 0 )
        particle:SetAirResistance( 200 )
        particle:SetRoll( math.Rand( 1, 90 ) )
        particle:SetRollDelta( math.random( 0, 5 ) )
        particle:SetGravity( Vector( 0, 0, -600 ) )
        particle:SetCollide( true )
        particle:SetBounce( 0.5 )
        particle:SetColor( math.random(198,212), math.random(102,120),0 )
	end
    emi:Finish() emi = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return CurTime() < self.EndTime
end

function EFFECT:Render()
end