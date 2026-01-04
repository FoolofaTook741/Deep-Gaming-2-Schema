AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OnSpawn(PObj)
    // fix angles
    self:SetAngles(self:GetAngles() - Angle(0,90,0))

    local Pod = self:AddDriverSeat(Vector(0,-30,65), Angle(0,0,0))
    Pod.ExitPos = Vector(-44.58,13.57,69.06)

    // add 6 seats
    for i = 1, 6 do
        local pos, ang = Vector(-30, -52, 50), Angle(0, -90, 0)
        pos.y = pos.y - (i - 1) * 24

        if (i > 3) then
            pos.x = pos.x + 60
            pos.y = pos.y + 72

            ang.y = ang.y + 180
        end

        Pod = self:AddPassengerSeat(pos, ang)
        Pod.ExitPos = Vector(0,-170,64)
    end

    self:AddEngine(Vector(0,87,50))
    
    local FrontRadius = 28
    local RearRadius = 28
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

    self:ManipulateBoneScale(self:LookupBone("APC.Gun_Base"), Vector(0, 0, 0))
    self:ManipulateBoneScale(self:LookupBone("APC.arm_root"), Vector(0, 0, 0))
    self:ManipulateBoneScale(self:LookupBone("APC.arm_middle"), Vector(0, 0, 0))

    local var = GetConVar("lvs_car_hl2_combineapc_health") and GetConVar("lvs_car_hl2_combineapc_health"):GetInt() or 1600
    self.MaxHealth = var
    self:SetHP(var)
end

function ENT:OnDriverEnterVehicle(ply)
    self:ResetSequence("enter"..math.random(1, 2))
end

function ENT:OnDriverExitVehicle(ply)
    self:ResetSequence("exit"..math.random(1, 2))
end