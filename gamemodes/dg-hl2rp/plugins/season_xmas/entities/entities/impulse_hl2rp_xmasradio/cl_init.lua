include("shared.lua")

local glowMat = Material("sprites/glow04_noz")
function ENT:Draw()
    self:DrawModel()

	local entPos = self:GetPos()
	local entAng = self:GetAngles()
	local pos = self:GetPos()
	local ang = self:GetAngles()

	pos = pos + ang:Up() * 15.3
	pos = pos + ang:Forward() * 8.5
	pos = pos + ang:Right() * 5.7


    render.SetMaterial(glowMat)
    render.DrawSprite((pos + ang:Forward() * 1.2 + ang:Right() * -7 + ang:Up() * -7.7), 4, 4, (self:GetRadioOn() and Color(50, 180, 50) or Color(240, 0, 0)))
end