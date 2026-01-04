include("shared.lua")

function ENT:UpdatePoseParameters(steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter)
    self:SetPoseParameter("vehicle_steer", steer)
    self:SetPoseParameter("vehicle_guage", speed_kmh * 0.0025)
end