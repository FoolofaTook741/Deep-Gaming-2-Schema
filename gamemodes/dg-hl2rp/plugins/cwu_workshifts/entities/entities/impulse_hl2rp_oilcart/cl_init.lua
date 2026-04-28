include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos  = self:GetPos() + Vector(0, 0, 65)
	local ang  = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.08)
		local drums  = self:GetNWInt("Drums", 0)
		local pushed = self:GetNWBool("Pushed", false)
		local col    = pushed and Color(255, 210, 50) or Color(100, 255, 100)
		local status = pushed and "[ BEING PUSHED ]" or "[ PRESS E TO PUSH ]"
		draw.SimpleTextOutlined("OIL CART  " .. drums .. "/4", "BudgetLabel", 0, -10, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined(status, "DebugFixed", 0, 10, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
	cam.End3D2D()
end
