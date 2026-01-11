include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("PinnacleVehicleTerminalOpen", function()
    local term = net.ReadEntity()
    if not IsValid(term) then return end

    local pnl = vgui.Create("VehicleTerminalMenu")
    pnl.Terminal = term
end)