AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
function ENT:OnSpawn(PObj)
    local Pod = self:AddDriverSeat(Vector(75, 20, -5), Angle(0, 270, 0))
    Pod.ExitPos = Vector(75, -60, 0)

    Pod = self:AddPassengerSeat(Vector(75, -20, 5), Angle(0, 270, 0))
    Pod.ExitPos = Vector(75, 60, 0)

    for i = 1, 8 do
        local pos, ang = Vector(28, 40, -15), Angle(0, 180, 0)
        pos.x = pos.x - (i - 1) * 19

        if i > 4 then
            pos.x = 28 - (i - 5) * 19
            pos.y = -pos.y
            ang.y = 0
        end

        Pod = self:AddPassengerSeat(pos, ang)
        Pod.ExitPos = Vector(math.random(1, 2) == 1 and 100 or -100, 0, 64)
    end

    self:AddEngine(Vector(-80, 20, 50))
    self:AddFuelTank(Vector(60, 55, 15), Angle(0, 0, 0), 600, LVS.FUELTYPE_DIESEL)

    local WheelModel = "models/props_vehicles/apc_tire001.mdl"
    local WheelFrontLeft = self:AddWheel({
        pos = Vector(77, -45, -22),
        mdl = WheelModel,
        mdl_ang = Angle(0, 0, 0),
    })

    local WheelFrontRight = self:AddWheel({
        pos = Vector(77, 45, -22),
        mdl = WheelModel,
        mdl_ang = Angle(0, 180, 0),
    })

    local WheelRearLeft = self:AddWheel({
        pos = Vector(-74, -45, -22),
        mdl = WheelModel,
        mdl_ang = Angle(0, 0, 0),
    })

    local WheelRearRight = self:AddWheel({
        pos = Vector(-74, 45, -22),
        mdl = WheelModel,
        mdl_ang = Angle(0, 180, 0),
    })

    local SuspensionSettings = {
        Height = 24,
        MaxTravel = 8,
        ControlArmLength = 128,
        SpringConstant = 5000,
        SpringDamping = 1000,
        SpringRelativeDamping = 1000,
    }

    local FrontAxle = self:DefineAxle({
        Axle = {
            ForwardAngle = Angle(0, 0, 0),
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
            ForwardAngle = Angle(0, 0, 0),
            SteerType = LVS.WHEEL_STEER_NONE,
            TorqueFactor = 0.7,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {WheelRearLeft, WheelRearRight},
        Suspension = SuspensionSettings,
    })

    local muzzleLeft = self:LookupAttachment("muzzle_left")
    local muzzleLeftObject = self:GetAttachment(muzzleLeft)
    self.muzzleLeftSound = self:AddSoundEmitter(self:WorldToLocal(muzzleLeftObject.Pos), "lvs/vehicles/222/cannon_fire.wav", "lvs/vehicles/222/cannon_fire_interior.wav")
    self.muzzleLeftSound:SetSoundLevel(95)
    self.muzzleLeftSound:SetParent(self, muzzleLeft)

    local muzzleRight = self:LookupAttachment("muzzle_right")
    local muzzleRightObject = self:GetAttachment(muzzleRight)
    self.muzzleRightSound = self:AddSoundEmitter(self:WorldToLocal(muzzleRightObject.Pos), "lvs/vehicles/222/cannon_fire.wav", "lvs/vehicles/222/cannon_fire_interior.wav")
    self.muzzleRightSound:SetSoundLevel(95)
    self.muzzleRightSound:SetParent(self, muzzleRight)
end
