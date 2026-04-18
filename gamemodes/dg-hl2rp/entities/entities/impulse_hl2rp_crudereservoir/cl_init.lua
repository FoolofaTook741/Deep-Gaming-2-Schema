include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local level = self:GetNWInt("ReservoirLevel", 0)
	local pos   = self:GetPos() + Vector(0, 0, 110)
	local ang   = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	local pct = math.Clamp(level / 20000, 0, 1)
	local barColor
	if pct > 0.6 then
		barColor = Color(50, 220, 50)
	elseif pct > 0.25 then
		barColor = Color(220, 200, 50)
	else
		barColor = Color(220, 60, 60)
	end

	cam.Start3D2D(pos, ang, 0.12)
		draw.SimpleTextOutlined("CRUDE OIL RESERVOIR", "BudgetLabel", 0, -14, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined(level .. "L  /  20000L", "BudgetLabel", 0, 10, barColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
	cam.End3D2D()
end
