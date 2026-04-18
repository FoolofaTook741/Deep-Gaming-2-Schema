include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 65)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.09)
		local ws        = impulse.OilWorkshift
		local active    = ws and ws.active or false
		local reservoir = ws and (ws.reservoirLiters or 0) or 0
		local hasOil    = active and reservoir >= 200

		draw.SimpleTextOutlined("OIL BARREL DISPENSER", "BudgetLabel", 0, -10, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		if not active then
			draw.SimpleTextOutlined("[ NO ACTIVE WORKSHIFT ]", "DebugFixed", 0, 10, Color(255, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		elseif not hasOil then
			draw.SimpleTextOutlined("[ RESERVOIR EMPTY - FILL IN OUTLANDS ]", "DebugFixed", 0, 10, Color(255, 180, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		else
			draw.SimpleTextOutlined("[ PRESS E  |  " .. reservoir .. "L AVAILABLE ]", "DebugFixed", 0, 10, Color(100, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		end
	cam.End3D2D()
end
