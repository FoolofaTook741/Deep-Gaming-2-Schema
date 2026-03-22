ENT.Base = "lvs_base_wheeldrive"
ENT.PrintName = "Conscript APC"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/conscript_apc_armed.png"

ENT.AITEAM = 2
ENT.AdminSpawnable = false
ENT.EngineCurve = 0.25
ENT.EngineTorque = 300
ENT.GibModels = {"models/props_vehicles/apc_tire001.mdl", "models/props_vehicles/apc_tire001.mdl", "models/props_vehicles/apc_tire001.mdl", "models/props_vehicles/apc_tire001.mdl", "models/props_c17/TrapPropeller_Engine.mdl", "models/gibs/helicopter_brokenpiece_01.mdl", "models/gibs/manhack_gib01.mdl", "models/gibs/manhack_gib02.mdl", "models/gibs/manhack_gib03.mdl", "models/combine_apc_destroyed_gib02.mdl", "models/combine_apc_destroyed_gib03.mdl", "models/combine_apc_destroyed_gib04.mdl", "models/combine_apc_destroyed_gib05.mdl"}
ENT.MDL = "models/riggs9162/thirdparty/conscript_apc.mdl"
ENT.MDL_DESTROYED = "models/riggs9162/thirdparty/conscript_apc.mdl"
ENT.MaxHealth = 2400
ENT.MaxVelocity = 2400
ENT.SpawnNormalOffset = 0
ENT.Spawnable = true
ENT.TransGears = 4
ENT.TransGearsReverse = 1
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.EngineSounds = {
    {
        sound = "lvs/vehicles/222/eng_idle_loop.wav",
        Volume = 1,
        Pitch = 95,
        PitchMul = 25,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_ALL,
    },
    {
        sound = "lvs/vehicles/222/eng_loop.wav",
        Volume = 1,
        Pitch = 25,
        PitchMul = 100,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_REVUP,
        UseDoppler = true,
    },
}

ENT.ExhaustPositions = {}

ENT.Lights = {
    {
        Trigger = "main",
        Sprites = {
            {
                pos = Vector(145, 48, 21),
                colorB = 150,
                colorA = 150
            },
            {
                pos = Vector(145, -48, 21),
                colorB = 150,
                colorA = 150
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(145, 48, 21),
                ang = Angle(15, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
            {
                pos = Vector(145, -48, 21),
                ang = Angle(15, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
        },
    },
    {
        Trigger = "high",
        Sprites = {
            {
                pos = Vector(145, 38, 21),
                colorB = 150,
                colorA = 150
            },
            {
                pos = Vector(145, -38, 21),
                colorB = 150,
                colorA = 150
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(145, 48, 21),
                ang = Angle(15, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
            {
                pos = Vector(145, -48, 21),
                ang = Angle(15, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
            {
                pos = Vector(145, 38, 21),
                ang = Angle(0, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
            {
                pos = Vector(145, -38, 21),
                ang = Angle(0, 0, 0),
                colorB = 150,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 1000
            },
        },
    },
    {
        Trigger = "turnright",
        Sprites = {
            {
                pos = Vector(-146, 45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
        },
    },
    {
        Trigger = "turnleft",
        Sprites = {
            {
                pos = Vector(-146, -45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
        },
    },
    {
        Trigger = "main+brake",
        Sprites = {
            {
                pos = Vector(-146, 45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
            {
                pos = Vector(-146, -45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
        },
    },
    {
        Trigger = "reverse",
        Sprites = {
            {
                pos = Vector(-146, 45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
            {
                pos = Vector(-146, -45, 27),
                colorR = 220,
                colorG = 120,
                colorB = 0,
                colorA = 150
            },
        },
    },
}

function ENT:TurretInRange()
    local ID = self:LookupAttachment("muzzle_left")
    local Muzzle = self:GetAttachment(ID)
    if not Muzzle then return true end
    local Dir1 = Muzzle.Ang:Forward()
    local Dir2 = self:GetAimVector()
    return self:AngleBetweenNormal(Dir1, Dir2) < 5
end

include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")
ENT.TurretBallisticsmuzzleAttachment = "muzzle_left"
ENT.TurretAimRate = 100
ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"
ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -70
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0
ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMin = -180
ENT.TurretYawMax = 180
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0
function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/flak_he.png")
    weapon.Ammo = 1500
    weapon.Delay = 0.25
    weapon.HeatRateUp = 0.25
    weapon.HeatRateDown = 0.5
    weapon.Attack = function(ent)
        if not ent:TurretInRange() then return true end
        -- Determine which muzzle to use this shot, alternating between left and right
        local chosen = ent._NextMuzzle or "muzzle_left"
        local ID = ent:LookupAttachment(chosen)
        local Muzzle = ent:GetAttachment(ID)
        -- If the chosen muzzle doesn't exist, try the other side as a fallback
        if not Muzzle then
            chosen = (chosen == "muzzle_left") and "muzzle_right" or "muzzle_left"
            ID = ent:LookupAttachment(chosen)
            Muzzle = ent:GetAttachment(ID)
            if not Muzzle then return end
        end

        local Pos = Muzzle.Pos
        local Dir = (ent:GetEyeTrace().HitPos - Pos):GetNormalized()
        local bullet = {}
        bullet.Src = Pos
        bullet.Dir = Dir
        bullet.Spread = Vector(0, 0, 0)
        bullet.TracerName = "lvs_tracer_autocannon"
        bullet.Force = 3900
        bullet.HullSize = 50 * math.max(Dir.z, 0)
        bullet.Damage = 40
        bullet.EnableBallistics = true
        bullet.SplashDamage = 20
        bullet.SplashDamageRadius = 100
        bullet.SplashDamageEffect = "lvs_defence_explosion"
        bullet.SplashDamageType = DMG_SONIC
        bullet.Velocity = 50000
        bullet.Attacker = ent:GetDriver()
        ent:LVSFireBullet(bullet)
        local effectdata = EffectData()
        effectdata:SetOrigin(bullet.Src)
        effectdata:SetNormal(bullet.Dir)
        effectdata:SetEntity(ent)
        util.Effect("lvs_muzzle", effectdata)
        ent:PlayAnimation("fire")
        ent:TakeAmmo(1)
        -- Toggle the next muzzle only after a successful fire
        ent._NextMuzzle = (chosen == "muzzle_left") and "muzzle_right" or "muzzle_left"
        -- Preserve existing sound behavior
        if IsValid(ent.muzzleLeftSound) then ent.muzzleLeftSound:PlayOnce(100 + math.cos(CurTime() + ent:EntIndex() * 1337) * 5 + math.Rand(-1, 1), 1) end
    end

    weapon.OnOverheat = function(ent) ent:EmitSound("lvs/vehicles/222/cannon_overheat.wav") end
    weapon.HudPaint = function(ent, X, Y, ply)
        local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()
        local Col = ent:TurretInRange() and Color(255, 255, 255, 255) or Color(255, 0, 0, 255)
        ent:PaintCrosshairCenter(Pos2D, Col)
        ent:PaintCrosshairSquare(Pos2D, Col)
        ent:LVSPaintHitMarker(Pos2D)
    end

    self:AddWeapon(weapon)
    weapon = {}
    weapon.Icon = Material("lvs/weapons/tank_noturret.png")
    weapon.Ammo = -1
    weapon.Delay = 0
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.OnSelect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(false) end end
    weapon.OnDeselect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(true) end end
    self:AddWeapon(weapon)
end
