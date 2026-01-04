function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

    --self.PostStartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment + 1 )

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()


	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

function EFFECT:Think( )
	self.Life = self.Life + FrameTime() * 9 -- Effect should dissipate before the next one.
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment ) -- self.PostStartPos experemental

	return (self.Life < 1)
end

local Beam = Material("effects/tau_beam")
local BeamTwo = Material("trails/electric")
function EFFECT:Render()
    local Times = 100 --12
    render.SetMaterial( Beam )
    render.StartBeam( 2 + Times );
    // add start
    self.Dir = (self.EndPos - self.StartPos):GetNormal()
    self.Inc = (self.EndPos - self.StartPos):Length() / Times
    local RAng = self.Dir:Angle()
    RAng:RotateAroundAxis(RAng:Right(),90)

    for i = 0, Times do
        // get point
        local point = ( self.StartPos + self.Dir * ( i * self.Inc ) )
        render.AddBeam(
            point,
            5,
            CurTime() + ( 1 / Times ) * i,
            Color(255,132,0,255)
        )
    end
    render.EndBeam()
	local texcoord = math.Rand(0, 1)
	local norm = (self.StartPos - self.EndPos) * self.Life
	local nlen = norm:Length()

	local alpha = (1 - self.Life)
	render.SetMaterial(BeamTwo)
	for i = 1, 3 do
		render.DrawBeam(self.StartPos + (VectorRand() * 1.5), self.EndPos + (VectorRand() * 3), 6, texcoord, texcoord + nlen / 128, Color(255, 160, 50, 170 * alpha))
	end
end