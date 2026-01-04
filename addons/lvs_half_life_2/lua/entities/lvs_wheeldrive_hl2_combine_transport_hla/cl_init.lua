include("shared.lua")

function ENT:UpdatePoseParameters(steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter)
    self:SetPoseParameter("vehicle_steer", steer)

    if ( throttle > 0.25 ) then
        if not ( self.bMoving ) then
            self:EmitSound("vehicles/apc/apc_firstgear_loop1.wav", 75, 100, LVS.EngineVolume)

            self.bMoving = true
        end
    else
        if ( self.bMoving ) then
            self:StopSound("vehicles/apc/apc_firstgear_loop1.wav")
            self:EmitSound("vehicles/apc/apc_slowdown_fast_loop5.wav", 75, 100, LVS.EngineVolume)

            timer.Simple(1.5, function()
                if ( IsValid(self) ) then
                    self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
                end
            end)

            self.bMoving = false
        end
    end
end

function ENT:OnEngineActiveChanged(bActive)
    if ( bActive ) then
        self:EmitSound("vehicles/apc/apc_start_loop3.wav", 75, 100, LVS.EngineVolume)
    else
        self:StopSound("vehicles/apc/apc_start_loop3.wav")
        self:EmitSound("vehicles/apc/apc_shutdown.wav", 75, 100, LVS.EngineVolume)
    end
end

function ENT:OnRemoved()
    self:StopSound("vehicles/apc/apc_start_loop3.wav")
    self:StopSound("vehicles/apc/apc_shutdown.wav")
    self:StopSound("vehicles/apc/apc_firstgear_loop1.wav")
    self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
end