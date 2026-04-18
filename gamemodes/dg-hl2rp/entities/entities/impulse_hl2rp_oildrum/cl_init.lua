include("shared.lua")

function ENT:Draw()
	local contaminated = self:GetNWBool("Contaminated", false)

	if contaminated then
		render.SetColorModulation(0.65, 0.4, 0.15)
	end
	self:DrawModel()
	if contaminated then
		render.SetColorModulation(1, 1, 1)
	end

	local pos = self:GetPos() + Vector(0, 0, 50)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.07)
		if contaminated then
			draw.SimpleTextOutlined("CONTAMINATED | FILTER FOR 200L / DUMP FOR 50L", "DebugFixed", 0, 0, Color(255, 160, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		else
			draw.SimpleTextOutlined("CRUDE OIL DRUM  -  200L", "DebugFixed", 0, 0, Color(100, 210, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		end
	cam.End3D2D()
end
