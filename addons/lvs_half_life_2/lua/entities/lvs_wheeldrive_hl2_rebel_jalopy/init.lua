AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    // fix angles
    self:SetAngles(self:GetAngles() - Angle(0,90,0))

    local Pod = self:AddDriverSeat(Vector(-20,-40,16), Angle(0,0,0))
    Pod.ExitPos = Vector(-64,-28,16)

    Pod = self:AddPassengerSeat(Vector(20,-25,24), Angle(0,0,0))
    Pod.ExitPos = Vector(64,-28,16)

    self:AddEngine(Vector(0,50,40), Angle(0,90,0))
    self:AddFuelTank(Vector(0,0,0), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL)
    
    local FrontRadius = 18
    local RearRadius = 20
    local FL, FR, RL, RR, ForwardAngle = self:AddWheelsUsingRig(FrontRadius, RearRadius)

    local FrontAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 30,
            TorqueFactor = 0,
            BrakeFactor = 1,
        },
        Wheels = {FL, FR},
        Suspension = {
            Height = 20,
            MaxTravel = 7,
            ControlArmLength = 100,
            SpringConstant = 20000,
            SpringDamping = 2000,
            SpringRelativeDamping = 2000,
        },
    })

    local RearAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 1,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {RL, RR},
        Suspension = {
            Height = 20,
            MaxTravel = 7,
            ControlArmLength = 100,
            SpringConstant = 20000,
            SpringDamping = 2000,
            SpringRelativeDamping = 2000,
        },
    })
end

function ENT:OnEngineActiveChanged( Active )
    if ( Active ) then
        self:ResetSequence("idle_running")
    else
        self:ResetSequence("idle")
    end
end