include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 55)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleTextOutlined("RECYCLE TUB", "BudgetLabel", 0, 0, Color(100, 220, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined("Drop recyclables here", "DebugFixed", 0, 22, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
	cam.End3D2D()
end
