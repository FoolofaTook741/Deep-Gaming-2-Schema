include('shared.lua')

function ENT:Draw()
    self:DrawModel()

    local displayName = self:GetNWString("CrateDisplayName", "Order Crate")
    local pos = self:GetPos() + Vector(0,0,30)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
    local bounce = math.sin(CurTime() * 6) * 8
    cam.Start3D2D(pos, ang, 0.2)
        draw.SimpleText(displayName, "terminal32", 0, bounce, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
