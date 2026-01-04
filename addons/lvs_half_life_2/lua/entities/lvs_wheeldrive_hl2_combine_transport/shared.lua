ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Combine Transporter (HL2)"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combinetransport.png"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.SpawnNormalOffset = 0

ENT.MDL = "models/vehicles/combine_transport.mdl"
ENT.MDL_DESTROYED = "models/vehicles/combine_transport.mdl"
ENT.GibModels = {
    "models/combine_apc_destroyed_gib02.mdl",
    "models/combine_apc_destroyed_gib03.mdl",
    "models/combine_apc_destroyed_gib04.mdl",
    "models/combine_apc_destroyed_gib05.mdl",
    "models/combine_apc_destroyed_gib06.mdl",
}

ENT.DSArmorIgnoreForce = 0
ENT.CannonArmorPenetration = 9200

ENT.AITEAM = 1
ENT.MaxHealth = 1600
ENT.MaxVelocity = 1200
ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 1
ENT.TransGearsReverse = 1

ENT.EngineSounds = {}

ENT.Lights = {
    {
        Trigger = "high", 
        Sprites = {
            {pos = Vector(0,102,60.5), colorR = 0, colorG = 180, colorB = 220, colorA = 150, size = 60},
            {pos = Vector(3,99.5,56.5), colorR = 0, colorG = 180, colorB = 220, colorA = 150, size = 20}
        },
        ProjectedTextures = {
            {pos = Vector(0,102,60.5), ang = Angle(0,90,0), colorR = 0, colorG = 180, colorB = 220, colorA = 150, shadows = false, brightness = 10, farz = 3072, fov = 90}
        },
    },
    {
        Trigger = "main", 
        Sprites = {
            {pos = Vector(0,102,60.5), colorR = 0, colorG = 180, colorB = 220, colorA = 150, size = 60},
            {pos = Vector(3,99.5,56.5), colorR = 0, colorG = 180, colorB = 220, colorA = 150, size = 20}
        },
        ProjectedTextures = {
            {pos = Vector(0,102,60.5), ang = Angle(10,90,0), colorR = 0, colorG = 180, colorB = 220, colorA = 150, shadows = false, brightness = 4, farz = 3072, fov = 90}
        },
    },
}