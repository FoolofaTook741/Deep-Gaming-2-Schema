include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("PinnacleVehicleTerminalOpen", function()
	vgui.Create("VehicleTerminalMenu")
end)