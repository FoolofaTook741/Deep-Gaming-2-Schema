include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 70)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		local ws       = impulse.OilWorkshift
		local active   = ws and ws.active or false
		local carts    = 0
		for _, e in ipairs(ents.GetAll()) do
			if e:GetClass() == "impulse_hl2rp_oilcart" then carts = carts + 1 end
		end
		draw.SimpleTextOutlined("OIL CART DISPENSER", "BudgetLabel", 0, -10, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		if not active then
			draw.SimpleTextOutlined("[ NO ACTIVE WORKSHIFT ]", "DebugFixed", 0, 10, Color(255, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		elseif carts >= 2 then
			draw.SimpleTextOutlined("[ CARTS IN USE: " .. carts .. "/2 ]", "DebugFixed", 0, 10, Color(255, 180, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		else
			draw.SimpleTextOutlined("[ PRESS E - CARTS: " .. carts .. "/2 ]", "DebugFixed", 0, 10, Color(100, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		end
	cam.End3D2D()
end
