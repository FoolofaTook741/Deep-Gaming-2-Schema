ENT.Base = "lvs_wheeldrive_hl2_combine_apc"
ENT.PrintName = "Combine Transporter"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/combine_apc_transport.png"

ENT.Spawnable = true
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.GibModels = {"models/combine_apc_destroyed_gib02.mdl", "models/combine_apc_destroyed_gib03.mdl", "models/combine_apc_destroyed_gib04.mdl", "models/combine_apc_destroyed_gib05.mdl", "models/combine_apc_destroyed_gib06.mdl"}
ENT.MDL = "models/riggs9162/vehicles/combine_transport.mdl"
ENT.MDL_DESTROYED = "models/riggs9162/vehicles/combine_transport.mdl"

ENT.EngineSounds = {}

ENT.Lights = {
    {
        Trigger = "high",
        Sprites = {
            {
                pos = Vector(0, 102, 60.5),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(3, 99.5, 56.5),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 20
            }
        },
        ProjectedTextures = {
            {
                pos = Vector(0, 102, 60.5),
                ang = Angle(0, 90, 0),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                shadows = false,
                brightness = 10,
                farz = 3072,
                fov = 90
            }
        },
    },
    {
        Trigger = "main",
        Sprites = {
            {
                pos = Vector(0, 102, 60.5),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(3, 99.5, 56.5),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 20
            }
        },
        ProjectedTextures = {
            {
                pos = Vector(0, 102, 60.5),
                ang = Angle(10, 90, 0),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                shadows = false,
                brightness = 4,
                farz = 3072,
                fov = 90
            }
        },
    },
}
