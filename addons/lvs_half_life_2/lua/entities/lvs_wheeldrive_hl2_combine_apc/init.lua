AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    local DriverSeat = self:AddDriverSeat(Vector(-30, 0, 65), Angle(0, 270, 0))
    DriverSeat.ExitPos = Vector(-44.58, 13.57, 69.06)

    -- add 6 seats
    local PassengerSeat
    for i = 1, 6 do
        local pos, ang = Vector(-52, -30, 50), Angle(0, 0, 0)
        pos.x = pos.x - (i - 1) * 24
        if ( i > 3 ) then
            pos.y = pos.y + 60
            pos.x = pos.x + 72
            ang.y = ang.y + 180
        end

        PassengerSeat = self:AddPassengerSeat(pos, ang)
        PassengerSeat.ExitPos = Vector(0, -170, 64)
    end

    self:AddEngine(Vector(80, 0, 50))

    local FL, FR, RL, RR, ForwardAngle = self:AddWheelsUsingRig(25, 25)
    self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 45,
            TorqueFactor = 0.3,
            BrakeFactor = 1,
        },
        Wheels = {FL, FR},
        Suspension = {
            Height = 24,
            MaxTravel = 8,
            ControlArmLength = 128,
            SpringConstant = 5000,
            SpringDamping = 1000,
            SpringRelativeDamping = 1000,
        },
    })

    self:DefineAxle({
        Axle = {
            ForwardAngle = ForwardAngle,
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 0.7,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {RL, RR},
        Suspension = {
            Height = 24,
            MaxTravel = 8,
            ControlArmLength = 128,
            SpringConstant = 5000,
            SpringDamping = 1000,
            SpringRelativeDamping = 1000,
        },
    })

    self:ManipulateBoneScale(self:LookupBone("APC.Gun_Base"), vector_origin)

    local var = GetConVar("lvs_car_hl2_combineapc_health") and GetConVar("lvs_car_hl2_combineapc_health"):GetInt() or 1600
    self.MaxHealth = var
    self:SetHP(var)

    if ( self.PostOnSpawn ) then self:PostOnSpawn(PObj) end
end

function ENT:OnDriverEnterVehicle(client)
    self:ResetSequence("enter" .. math.random(1, 2))
end

function ENT:OnDriverExitVehicle(client)
    self:ResetSequence("exit" .. math.random(1, 2))
end
