include("shared.lua")

function ENT:UpdatePoseParameters(steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter)
    self:SetPoseParameter("vehicle_steer", steer)

    if ( throttle > 0.25 ) then
        if ( !self.bMoving ) then
            self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
            self:EmitSound("vehicles/apc/apc_firstgear_loop1.wav", 80, 100, LVS.EngineVolume)
            self.bMoving = true
        end
    else
        if ( self.bMoving ) then
            self:StopSound("vehicles/apc/apc_firstgear_loop1.wav")
            self:EmitSound("vehicles/apc/apc_slowdown_fast_loop5.wav", 80, 100, LVS.EngineVolume)

            timer.Simple(1.5, function()
                if ( IsValid(self) ) then
                    self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
                end
            end)

            self.bMoving = false
        end
    end
end
