--- it have bugs :D
function EFFECT:Init(data)
	self.EndPos = data:GetOrigin()
    self.Scale = data:GetScale() or 1
    self.Delay = 0.2 * self.Scale
    self.EndTime = CurTime()+self.Delay
	sound.Play("weapons/gluon/hit"..math.random(1,5)..".ogg", self.EndPos, 100, math.Rand(95, 100))
       local emi = ParticleEmitter( self.EndPos )
        for i = 1,math.floor(10*self.Scale) do
        local particle = emi:Add( "sprites/light_glow02_add", self.EndPos)
        particle:SetVelocity(VectorRand()*math.random(500,800))
        particle:SetDieTime( 0.5 )
        particle:SetStartAlpha( math.Rand(230, 250) )
        particle:SetStartSize( math.Rand( 4, 8 ) )
        particle:SetEndSize( 0.5 )
        particle:SetEndAlpha( 0 )
        particle:SetAirResistance( 2000 )
        particle:SetRoll( math.Rand( 1, 90 ) )
        particle:SetRollDelta( math.random( 0, 5 ) )
        particle:SetGravity( Vector( 0, 0, -600 ) )
        particle:SetCollide( true )
        particle:SetBounce( 0.5 )
        particle:SetColor( 60, math.random(140,170), math.random(220,255) )
        end
    emi:Finish() emi = nil collectgarbage("step", 64)
end

function EFFECT:Think()
	return CurTime() < self.EndTime
end

function EFFECT:Render()
end
