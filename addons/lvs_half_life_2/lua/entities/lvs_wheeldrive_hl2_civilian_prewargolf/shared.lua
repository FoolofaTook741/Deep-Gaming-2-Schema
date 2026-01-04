ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Prewar Golf"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/prewargolf.png"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Civilian"

ENT.SpawnNormalOffset = 10

ENT.MDL = "models/blu/hatchback/pw_hatchback.mdl"

ENT.AITEAM = 0
ENT.MaxHealth = 800
ENT.MaxVelocity = 1400
ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/halflife2/cars/generic/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/halflife2/cars/generic/eng_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/halflife2/cars/generic/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
    {
        pos = Vector(-55.74,-22.71,11.29),
        ang = Angle(0,180,0),
    },
}

ENT.Lights = {
    {
        Trigger = "high", 
        Sprites = {
            {pos = Vector(71.15,23.26,27.92), colorB = 200, colorA = 150},
            {pos = Vector(71.07,-23.15,27.95), colorB = 200, colorA = 150},
        },
        ProjectedTextures = {
            {pos = Vector(71.15,23.26,27.92), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = false, farz = 2000},
            {pos = Vector(71.07,-23.15,27.95), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = false, farz = 2000},
        },
    },
    {
        Trigger = "main", 
        Sprites = {
            {pos = Vector(71.15,23.26,27.92), colorB = 200, colorA = 150},
            {pos = Vector(71.07,-23.15,27.95), colorB = 200, colorA = 150},
        },
        ProjectedTextures = {
            {pos = Vector(71.15,23.26,27.92), ang = Angle(15,0,0), colorB = 200, colorA = 150, shadows = false, farz = 1000},
            {pos = Vector(71.07,-23.15,27.95), ang = Angle(15,0,0), colorB = 200, colorA = 150, shadows = false, farz = 1000},
        },
    },
    {
        Trigger = "main+brake",
        Sprites = {
            {pos = Vector(-72,26.5,29), colorG = 0, colorB = 0, colorA = 150},
            {pos = Vector(-72,-26.5,29), colorG = 0, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "turnright",
        Sprites = {
            {pos = Vector(-72,-26.5,32), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "turnleft",
        Sprites = {
            {pos = Vector(-72,26.5,32), colorR = 220, colorG = 120, colorB = 0, colorA = 150},
        },
    },
    {
        Trigger = "reverse",
        Sprites = {
            {pos = Vector(-72,26.5,29), colorG = 0, colorB = 0, colorA = 150},
            {pos = Vector(-72,-26.5,29), colorG = 0, colorB = 0, colorA = 150},
        },
    },
}