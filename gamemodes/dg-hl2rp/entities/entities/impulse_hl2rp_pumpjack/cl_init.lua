include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 85)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		local ws     = impulse.OilWorkshift
		local active = ws and ws.active or false
		draw.SimpleTextOutlined("CRUDE OIL PUMP JACK", "BudgetLabel", 0, 0, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		if active then
			draw.SimpleTextOutlined("[ PRESS E TO FILL 200L DRUM ]", "DebugFixed", 0, 22, Color(100, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		else
			draw.SimpleTextOutlined("[ INACTIVE - NO WORKSHIFT ]", "DebugFixed", 0, 22, Color(255, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		end
	cam.End3D2D()
end
