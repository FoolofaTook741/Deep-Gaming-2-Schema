AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    // fix angles
    self:SetAngles(self:GetAngles() - Angle(0,90,0))

    local Pod = self:AddDriverSeat(Vector(-15,75,0), Angle(0,0,0))
    Pod.ExitPos = Vector(-60,75,0)
    Pod.HidePlayer = true

    Pod = self:AddPassengerSeat(Vector(20,85,10), Angle(0,0,0))
    Pod.ExitPos = Vector(60,75,0)
    Pod.HidePlayer = true

    // add more 8 seats
    for i = 1, 8 do
        Pod = self:AddPassengerSeat(Vector(0,-50,0), Angle(0,0,0))
        Pod.ExitPos = Vector(math.random(1, 2) == 1 and 100 or -100,0,64)
        Pod.HidePlayer = true
    end

    self:AddEngine(Vector(-20,-80,50))
    self:AddFuelTank(Vector(-61.34,49.71,15.98), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL)
    
    local WheelModel = "models/props_vehicles/apc_tire001.mdl"

    local WheelFrontLeft = self:AddWheel({
        pos = Vector(-45,77,-22),
        mdl = WheelModel,
        mdl_ang = Angle(0,180,0),
    })
    local WheelFrontRight = self:AddWheel({
        pos = Vector(45,77,-22),
        mdl = WheelModel,
        mdl_ang = Angle(0,0,0),
    })

    local WheelRearLeft = self:AddWheel({
        pos = Vector(-45,-74,-22),
        mdl = WheelModel,
        mdl_ang = Angle(0,180,0),
    })
    local WheelRearRight = self:AddWheel({
        pos = Vector(45,-74,-22),
        mdl = WheelModel,
        mdl_ang = Angle(0,0,0),
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
            ForwardAngle = Angle(0,90,0),
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
            ForwardAngle = Angle(0,90,0),
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 0.7,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {WheelRearLeft, WheelRearRight},
        Suspension = SuspensionSettings,
    })
end