AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    local Pod = self:AddDriverSeat(Vector(-50, 8.5, 15), Angle(0, -90, 0))
    Pod.ExitPos = Vector(-30, 64, 38)

    self:AddEngine(Vector(-75, -8, 37))
    self:AddFuelTank(Vector(0, 0, 0), Angle(0, -90, 0), 600, LVS.FUELTYPE_PETROL)

    local FL, FR, RL, RR, ForwardAngle = self:AddWheelsUsingRig(18, 19)
    self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 25,
            TorqueFactor = 0.4,
            BrakeFactor = 1,
        },
        Wheels = {FL, FR},
        Suspension = {
            Height = 18,
            MaxTravel = 12,
            ControlArmLength = 100,
            SpringConstant = 22000,
            SpringDamping = 3500,
            SpringRelativeDamping = 3500,
        },
    })

    self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 0.6,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {RL, RR},
        Suspension = {
            Height = 18,
            MaxTravel = 12,
            ControlArmLength = 100,
            SpringConstant = 22000,
            SpringDamping = 3500,
            SpringRelativeDamping = 3500,
        },
    })

    if ( self.PostOnSpawn ) then self:PostOnSpawn(PObj) end
end

function ENT:OnEngineActiveChanged(Active)
    if ( Active ) then
        self:ResetSequence("idle_running")
    else
        self:ResetSequence("idle")
        self:EmitSound("vehicles/v8/v8_stop1.wav")
    end
end
