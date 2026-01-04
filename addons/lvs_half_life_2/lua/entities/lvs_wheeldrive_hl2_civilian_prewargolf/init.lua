AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    self:AddDriverSeat(Vector(-12,16,10), Angle(0,-90,0))
    self:AddPassengerSeat(Vector(2,-16,18), Angle(0,-90,10))

    self:AddPassengerSeat(Vector(-28,16,18), Angle(0,-90,10))
    self:AddPassengerSeat(Vector(-28,0,18), Angle(0,-90,10))
    self:AddPassengerSeat(Vector(-28,-16,18), Angle(0,-90,10))

    self:AddEngine(Vector(64,0,28))
    self:AddFuelTank(Vector(-61.44,31.91,31.63), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL)

    local WheelModel = "models/salza/hatchback/hatchback_wheel.mdl"

    local WheelFrontLeft = self:AddWheel({
        pos = Vector(44.5,28,12),
        mdl = WheelModel,
        mdl_ang = Angle(0,90,0),
    })
    local WheelFrontRight = self:AddWheel({
        pos = Vector(44.5,-28,12),
        mdl = WheelModel,
        mdl_ang = Angle(0,90,0),
    })

    local WheelRearLeft = self:AddWheel({
        pos = Vector(-46,29.5,12),
        mdl = WheelModel,
        mdl_ang = Angle(0,90,0),
    })
    local WheelRearRight = self:AddWheel({
        pos = Vector(-46,-29.5,12),
        mdl = WheelModel,
        mdl_ang = Angle(0,90,0),
    })

    local SuspensionSettings = {
        Height = 8,
        MaxTravel = 7,
        ControlArmLength = 25,
        SpringConstant = 20000,
        SpringDamping = 2000,
        SpringRelativeDamping = 2000,
    }

    local FrontAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = Angle(0,0,0),
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 30,
            TorqueFactor = 0.3,
            BrakeFactor = 1,
        },
        Wheels = {WheelFrontLeft, WheelFrontRight},
        Suspension = SuspensionSettings,
    })

    local RearAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = Angle(0,0,0),
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 0.7,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {WheelRearLeft, WheelRearRight},
        Suspension = SuspensionSettings,
    })
end