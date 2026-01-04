AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    // fix angles
    self:SetAngles(self:GetAngles() - Angle(0,90,0))

    local Pod = self:AddDriverSeat(Vector(0,-30,65), Angle(0,0,0))
    Pod.ExitPos = Vector(-44.58,13.57,69.06)

    // add 8 seats
    for i = 1, 8 do
        local pos, ang = Vector(-30, -80, 50), Angle(0, -90, 0)
        pos.y = pos.y - (i - 1) * 24

        if (i > 4) then
            pos.x = pos.x + 60
            pos.y = pos.y + 96

            ang.y = ang.y + 180
        end

        Pod = self:AddPassengerSeat(pos, ang)
        Pod.ExitPos = Vector(0,-170,64)
    end

    self:AddEngine(Vector(0,87,50))
    
    local FrontRadius = 21
    local RearRadius = 23
    local FL, FR, RL, RR, ForwardAngle = self:AddWheelsUsingRig(FrontRadius, RearRadius)

    local FrontAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 30,
            TorqueFactor = 0.3,
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
            TorqueFactor = 0.7,
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

    local var = GetConVar("lvs_car_hl2_combinetransport_health") and GetConVar("lvs_car_hl2_combinetransport_health"):GetInt() or 1600
    self.MaxHealth = var
    self:SetHP(var)
end