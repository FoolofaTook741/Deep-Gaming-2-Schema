ENT.Base = "lvs_base_wheeldrive"
ENT.PrintName = "Jalopy"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/rebel_jalopy.png"

ENT.AITEAM = 2
ENT.AdminSpawnable = false
ENT.MDL = "models/vehicle.mdl"
ENT.SpawnNormalOffset = 0
ENT.Spawnable = IsMounted("ep2")
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.EngineSounds = {
    {
        sound = "vehicles/junker/jnk_start_loop1.wav",
        Volume = 1,
        Pitch = 95,
        PitchMul = 25,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
    },
    {
        sound = "vehicles/junker/jnk_third.wav",
        Volume = 1,
        Pitch = 50,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_NONE,
        UseDoppler = true,
    },
    {
        sound = "vehicles/junker/jnk_throttle_off_fast_loop1.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_REV_DOWN,
        UseDoppler = true,
    },
    {
        sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 90,
        SoundType = LVS.SOUNDTYPE_REV_UP,
        UseDoppler = true,
    },
}

ENT.TurboSound = "vehicles/junker/jnk_turbo_on_loop1.wav"

ENT.TireSoundTypes = {
    ["roll"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_racing"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_dirt"] = "lvs/vehicles/generic/wheel_roll_dirt.wav",
    ["roll_wet"] = "lvs/vehicles/generic/wheel_roll_wet.wav",
    ["roll_damaged"] = "lvs/wheel_damaged_loop.wav",
    ["skid"] = "vehicles/junker/skid_lowfriction_nostartdelay.wav",
    ["skid_racing"] = "vehicles/junker/skid_normalfriction_nostartdelay.wav",
    ["skid_dirt"] = "vehicles/junker/skid_lowfriction_nostartdelay.wav",
    ["skid_wet"] = "vehicles/junker/skid_lowfriction_nostartdelay.wav",
    ["tire_damage_layer"] = "lvs/wheel_destroyed_loop.wav",
}

ENT.ExhaustPositions = {
    {
        pos = Vector(20, -140, 37),
        ang = Angle(0, -90, 0),
    },
    {
        pos = Vector(-22, -140, 37),
        ang = Angle(0, -90, 0),
    },
}

ENT.Lights = {
    {
        Trigger = "high",
        Sprites = {
            {
                pos = Vector(-34.5, 77.5, 29),
                colorB = 200,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(36.4, 77.5, 29.5),
                colorB = 200,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(-27.1, 77.5, 29),
                colorB = 200,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(29, 77.5, 29.5),
                colorB = 200,
                colorA = 150,
                size = 60
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(32.7, 79.5, 29.0),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 2000
            },
            {
                pos = Vector(-30.75, 79.5, 28.9),
                ang = Angle(0, 90, 0),
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
                pos = Vector(-34.5, 77.5, 29),
                colorB = 200,
                colorA = 150
            },
            {
                pos = Vector(36.4, 77.5, 29.5),
                colorB = 200,
                colorA = 150
            },
            {
                pos = Vector(-27.1, 77.5, 29),
                colorB = 200,
                colorA = 150
            },
            {
                pos = Vector(29, 77.5, 29.5),
                colorB = 200,
                colorA = 150
            },
        },
        ProjectedTextures = {
            {
                pos = Vector(32.7, 79.5, 29.0),
                ang = Angle(15, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 1000
            },
            {
                pos = Vector(-30.75, 79.5, 28.9),
                ang = Angle(15, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = false,
                farz = 1000
            },
        },
    },
    {
        Trigger = "main+brake",
        ProjectedTextures = {
            {
                pos = Vector(15.9, -139.2, 53),
                ang = Angle(40, -90, 0),
                colorG = 0,
                colorB = 0,
                colorA = 150,
                shadows = false,
                farz = 100
            },
            {
                pos = Vector(-17.44, -139.2, 53),
                ang = Angle(40, -90, 0),
                colorG = 0,
                colorB = 0,
                colorA = 150,
                shadows = false,
                farz = 100
            },
        },
        Sprites = {},
    },
    {
        Trigger = "reverse",
        ProjectedTextures = {
            {
                pos = Vector(15.9, -139.2, 53),
                ang = Angle(40, -90, 0),
                colorG = 0,
                colorB = 0,
                colorA = 150,
                shadows = false,
                farz = 100
            },
            {
                pos = Vector(-17.44, -139.2, 53),
                ang = Angle(40, -90, 0),
                colorG = 0,
                colorB = 0,
                colorA = 150,
                shadows = false,
                farz = 100
            },
        },
        Sprites = {},
    },
}

local redlights = {Vector(25.8, -139.2, 53), Vector(24.28, -139.2, 53), Vector(22.76, -139.2, 53), Vector(21.24, -139.2, 53), Vector(19.72, -139.2, 53), Vector(18.2, -139.2, 53), Vector(16.68, -139.2, 53), Vector(15.16, -139.2, 53), Vector(13.64, -139.2, 53), Vector(12.12, -139.2, 53), Vector(10.6, -139.2, 53), Vector(9.08, -139.2, 53), Vector(7.56, -139.2, 53), Vector(6.04, -139.2, 53), Vector(-27.32, -139.2, 53), Vector(-25.8, -139.2, 53), Vector(-24.28, -139.2, 53), Vector(-22.76, -139.2, 53), Vector(-21.24, -139.2, 53), Vector(-19.72, -139.2, 53), Vector(-18.2, -139.2, 53), Vector(-16.68, -139.2, 53), Vector(-15.16, -139.2, 53), Vector(-13.64, -139.2, 53), Vector(-12.12, -139.2, 53), Vector(-10.6, -139.2, 53), Vector(-9.08, -139.2, 53), Vector(-7.56, -139.2, 53)}
for k, v in pairs(redlights) do
    table.insert(ENT.Lights[3].Sprites, {
        pos = v,
        colorG = 0,
        colorB = 0,
        colorA = 150
    })

    table.insert(ENT.Lights[4].Sprites, {
        pos = v,
        colorG = 0,
        colorB = 0,
        colorA = 150
    })
end
