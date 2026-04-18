include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 75)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		local ws        = impulse.OilWorkshift
		local deposited = ws and (ws.oilDeposited or 0) or 0
		local oilGoal   = ws and (ws.scaledGoal or 2000) or 2000
		local goalMet   = ws and ws.goalMet or false
		local active    = ws and ws.active or false

		local progColor = goalMet and Color(50, 255, 50) or (active and Color(150, 200, 255) or Color(160, 160, 160))

		draw.SimpleTextOutlined("REFINED OIL COLLECTION", "BudgetLabel", 0, -10, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined(deposited .. "L  /  " .. oilGoal .. "L", "BudgetLabel", 0, 12, progColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
	cam.End3D2D()
end