include("shared.lua")

function ENT:Draw()
	render.SetColorModulation(0.05, 0.05, 0.05)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
end
