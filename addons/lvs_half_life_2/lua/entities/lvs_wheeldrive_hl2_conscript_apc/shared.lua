ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Conscript APC"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/conscriptapc.png"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.SpawnNormalOffset = 0

ENT.MDL = "models/blu/conscript_apc.mdl"
ENT.GibModels = {
    "models/props_vehicles/apc_tire001.mdl",
    "models/props_vehicles/apc_tire001.mdl",
    "models/props_vehicles/apc_tire001.mdl",
    "models/props_vehicles/apc_tire001.mdl",
    "models/props_c17/TrapPropeller_Engine.mdl",
    "models/gibs/helicopter_brokenpiece_01.mdl",
    "models/gibs/manhack_gib01.mdl",
    "models/gibs/manhack_gib02.mdl",
    "models/gibs/manhack_gib03.mdl",
    "models/combine_apc_destroyed_gib02.mdl",
    "models/combine_apc_destroyed_gib03.mdl",
    "models/combine_apc_destroyed_gib04.mdl",
    "models/combine_apc_destroyed_gib05.mdl",
}

ENT.AITEAM = 2
ENT.MaxHealth = 2400
ENT.MaxVelocity = 1200
ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 4
ENT.TransGearsReverse = 1

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
            {pos = Vector(48,145,21), colorB = 150, colorA = 150},
            {pos = Vector(-48,145,21), colorB = 150, colorA = 150},
        },
        ProjectedTextures = {
            {pos = Vector(48,145,21), ang = Angle(15,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
            {pos = Vector(-48,145,21), ang = Angle(15,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
        },
    },
    {
        Trigger = "high",
        Sprites = {
            {pos = Vector(38,145,21), colorB = 150, colorA = 150},
            {pos = Vector(-38,145,21), colorB = 150, colorA = 150},
        },
        ProjectedTextures = {
            {pos = Vector(48,145,21), ang = Angle(15,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
            {pos = Vector(-48,145,21), ang = Angle(15,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
            {pos = Vector(38,145,21), ang = Angle(0,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
            {pos = Vector(-38,145,21), ang = Angle(0,90,0), colorB = 150, colorA = 150, shadows = false, brightness = 10, farz = 1000},
        },
    },
    {
        Trigger = "turnright",
        Sprites = {
            {pos = Vector(45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "turnleft",
        Sprites = {
            {pos = Vector(-45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "main+brake",
        Sprites = {
            {pos = Vector(45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
            {pos = Vector(-45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "reverse",
        Sprites = {
            {pos = Vector(45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
            {pos = Vector(-45,-146,27), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
}