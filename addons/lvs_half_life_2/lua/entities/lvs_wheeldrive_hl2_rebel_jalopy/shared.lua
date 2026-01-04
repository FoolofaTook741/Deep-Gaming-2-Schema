ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Jalopy"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/jalopy.png"

ENT.Spawnable = IsMounted("ep2")
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.SpawnNormalOffset = 0

ENT.MDL = "models/vehicle.mdl"

ENT.AITEAM = 2
ENT.MaxHealth = 800
ENT.MaxVelocity = 1200
ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
    {
        sound = "vehicles/junker/jnk_rev_short_loop1.wav",
        Volume = 1,
        Pitch = 95,
        PitchMul = 25,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
    },
    {
        sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav",
        Volume = 1,
        Pitch = 50,
        PitchMul = 50,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_NONE,
        UseDoppler = true,
    },
    {
        sound = "vehicles/junker/jnk_firstgear_rev_loop1.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_REV_DOWN,
        UseDoppler = true,
    },
    {
        sound = "vehicles/junker/jnk_firstgear_rev_loop1.wav",
        Volume = 1,
        Pitch = 75,
        PitchMul = 50,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_REV_UP,
        UseDoppler = true,
    },
}

ENT.ExhaustPositions = {
    {
        pos = Vector(20,-140,37),
        ang = Angle(0,-90,0),
    },
    {
        pos = Vector(-22,-140,37),
        ang = Angle(0,-90,0),
    },
}

local redlights = {
    Vector(25.8,-139.2,53),Vector(24.28,-139.2,53),Vector(22.76,-139.2,53),Vector(21.24,-139.2,53),Vector(19.72,-139.2,53),Vector(18.2,-139.2,53),Vector(16.68,-139.2,53),Vector(15.16,-139.2,53),Vector(13.64,-139.2,53),Vector(12.12,-139.2,53),Vector(10.6,-139.2,53),Vector(9.08,-139.2,53),Vector(7.56,-139.2,53),Vector(6.04,-139.2,53),
    Vector(-27.32,-139.2,53),Vector(-25.8,-139.2,53),Vector(-24.28,-139.2,53),Vector(-22.76,-139.2,53),Vector(-21.24,-139.2,53),Vector(-19.72,-139.2,53),Vector(-18.2,-139.2,53),Vector(-16.68,-139.2,53),Vector(-15.16,-139.2,53),Vector(-13.64,-139.2,53),Vector(-12.12,-139.2,53),Vector(-10.6,-139.2,53),Vector(-9.08,-139.2,53),Vector(-7.56,-139.2,53)
}
ENT.Lights = {
    {
        Trigger = "high",
        Sprites = {
            {pos = Vector(-34.5,77.5,29), colorB = 200, colorA = 150, size = 60},
            {pos = Vector(36.4,77.5,29.5), colorB = 200, colorA = 150, size = 60},
            {pos = Vector(-27.1,77.5,29), colorB = 200, colorA = 150, size = 60},
            {pos = Vector(29,77.5,29.5), colorB = 200, colorA = 150, size = 60},
        },
        ProjectedTextures = {
            {pos = Vector(32.7,79.5,29.0), ang = Angle(0,90,0), colorB = 200, colorA = 150, shadows = false, farz = 2000},
            {pos = Vector(-30.75,79.5,28.9), ang = Angle(0,90,0), colorB = 200, colorA = 150, shadows = false, farz = 2000},
        },
    },
    {
        Trigger = "main", 
        Sprites = {
            {pos = Vector(-34.5,77.5,29), colorB = 200, colorA = 150},
            {pos = Vector(36.4,77.5,29.5), colorB = 200, colorA = 150},
            {pos = Vector(-27.1,77.5,29), colorB = 200, colorA = 150},
            {pos = Vector(29,77.5,29.5), colorB = 200, colorA = 150},
        },
        ProjectedTextures = {
            {pos = Vector(32.7,79.5,29.0), ang = Angle(15,90,0), colorB = 200, colorA = 150, shadows = false, farz = 1000},
            {pos = Vector(-30.75,79.5,28.9), ang = Angle(15,90,0), colorB = 200, colorA = 150, shadows = false, farz = 1000},
        },
    },
    {
        Trigger = "main+brake", 
        ProjectedTextures = {
            {pos = Vector(15.9,-139.2,53), ang = Angle(40,-90,0), colorG = 0, colorB = 0, colorA = 150, shadows = false, farz = 100},
            {pos = Vector(-17.44,-139.2,53), ang = Angle(40,-90,0), colorG = 0, colorB = 0, colorA = 150, shadows = false, farz = 100},
        },
        Sprites = {},
    },
    {
        Trigger = "reverse",
        ProjectedTextures = {
            {pos = Vector(15.9,-139.2,53), ang = Angle(40,-90,0), colorG = 0, colorB = 0, colorA = 150, shadows = false, farz = 100},
            {pos = Vector(-17.44,-139.2,53), ang = Angle(40,-90,0), colorG = 0, colorB = 0, colorA = 150, shadows = false, farz = 100},
        },
        Sprites = {},
    },
}

for k, v in pairs(redlights) do
    table.insert(ENT.Lights[3].Sprites, {pos = v, colorG = 0, colorB = 0, colorA = 150})
    table.insert(ENT.Lights[4].Sprites, {pos = v, colorG = 0, colorB = 0, colorA = 150})
end