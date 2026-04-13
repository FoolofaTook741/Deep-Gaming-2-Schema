include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 50)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleTextOutlined("FINISH CART", "BudgetLabel", 0, 0, Color(255, 200, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined("Drop steel bars here", "DebugFixed", 0, 22, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
	cam.End3D2D()
end
