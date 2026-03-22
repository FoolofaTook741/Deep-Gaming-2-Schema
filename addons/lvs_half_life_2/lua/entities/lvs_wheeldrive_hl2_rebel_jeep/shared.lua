ENT.Base = "lvs_base_wheeldrive"
ENT.PrintName = "Jeep"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/rebel_jeep.png"

ENT.AITEAM = 2
ENT.AdminSpawnable = false
ENT.MDL = "models/riggs9162/vehicles/jeep.mdl"
ENT.SpawnNormalOffset = 0
ENT.Spawnable = true
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.EngineSounds = {
    {
        sound = "vehicles/v8/v8_start_loop1.wav",
        Volume = 1,
        Pitch = 95,
        PitchMul = 25,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
    },
    {
        sound = "vehicles/v8/third.wav",
        Volume = 1,
        Pitch = 50,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_NONE,
        UseDoppler = true,
    },
    {
        sound = "vehicles/v8/v8_throttle_off_fast_loop1.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_REV_DOWN,
        UseDoppler = true,
    },
    {
        sound = "vehicles/v8/fourth_cruise_loop2.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_REV_UP,
        UseDoppler = true,
    },
}

ENT.TurboSound = "vehicles/v8/v8_turbo_on_loop1.wav"

ENT.TireSoundTypes = {
    ["roll"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_racing"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_dirt"] = "lvs/vehicles/generic/wheel_roll_dirt.wav",
    ["roll_wet"] = "lvs/vehicles/generic/wheel_roll_wet.wav",
    ["roll_damaged"] = "lvs/wheel_damaged_loop.wav",
    ["skid"] = "vehicles/v8/skid_lowfriction.wav",
    ["skid_racing"] = "vehicles/v8/skid_highfriction.wav",
    ["skid_dirt"] = "vehicles/v8/skid_lowfriction.wav",
    ["skid_wet"] = "vehicles/v8/skid_highfriction.wav",
    ["tire_damage_layer"] = "lvs/wheel_destroyed_loop.wav",
}

ENT.ExhaustPositions = {
    {
        pos = Vector(-88.31, -13.1, 34.3),
        ang = Angle(0, 180, 0),
    },
}

ENT.Lights = {
    {
        Trigger = "high",
        Sprites = {
            {
                pos = Vector(57, 11, 38.8),
                colorB = 200,
                colorA = 150
            },
            {
                pos = Vector(57, -11, 38.8),
                colorB = 200,
                colorA = 150
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(55, 11, 35),
                ang = Angle(0, 0, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 2000
            },
            {
                pos = Vector(55, -11, 35),
                ang = Angle(0, 0, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 2000
            },
        },
    },
    {
        Trigger = "main",
        Sprites = {
            {
                pos = Vector(57, 11, 38.8),
                colorB = 200,
                colorA = 150
            },
            {
                pos = Vector(57, -11, 38.8),
                colorB = 200,
                colorA = 150
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(55, 11, 35),
                ang = Angle(10, 0, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 1000
            },
            {
                pos = Vector(55, -11, 35),
                ang = Angle(10, 0, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 1000
            },
        },
    },
    {
        Trigger = "main+brake",
        Sprites = {
            {
                pos = Vector(-101, 14.9, 39.1),
                colorB = 200,
                colorA = 150
            },
        },
    },
    {
        Trigger = "reverse",
        Sprites = {
            {
                pos = Vector(-101, 14.9, 39.1),
                colorB = 200,
                colorA = 150
            },
        },
    },
}
