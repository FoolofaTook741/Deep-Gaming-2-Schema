ENT.Base = "lvs_base_wheeldrive"
ENT.PrintName = "Combine APC"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/combine_apc.png"

ENT.AITEAM = 1
ENT.AdminSpawnable = false
ENT.GibModels = {"models/combine_apc_destroyed_gib02.mdl", "models/combine_apc_destroyed_gib03.mdl", "models/combine_apc_destroyed_gib04.mdl", "models/combine_apc_destroyed_gib05.mdl", "models/combine_apc_destroyed_gib06.mdl"}
ENT.MDL = "models/riggs9162/vehicles/combine_apc_driveable.mdl"
ENT.MDL_DESTROYED = "models/combine_apc_destroyed_gib01.mdl"
ENT.Spawnable = true
ENT.TransGears = 1
ENT.TransGearsReverse = 1
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.EngineSounds = {}

ENT.TireSoundTypes = {
    ["roll"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_racing"] = "lvs/vehicles/generic/wheel_roll.wav",
    ["roll_dirt"] = "lvs/vehicles/generic/wheel_roll_dirt.wav",
    ["roll_wet"] = "lvs/vehicles/generic/wheel_roll_wet.wav",
    ["roll_damaged"] = "lvs/wheel_damaged_loop.wav",
    ["skid"] = "vehicles/v8/skid_highfriction.wav",
    ["skid_racing"] = "vehicles/v8/skid_normalfriction.wav",
    ["skid_dirt"] = "vehicles/v8/skid_lowfriction.wav",
    ["skid_wet"] = "vehicles/v8/skid_highfriction.wav",
    ["tire_damage_layer"] = "lvs/wheel_destroyed_loop.wav",
}

ENT.Lights = {
    {
        Trigger = "high",
        Sprites = {
            {
                pos = Vector(102, 0, 60),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(100, -3, 56),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 20
            }
        },
        ProjectedTextures = {
            {
                pos = Vector(102, 0, 60),
                ang = Angle(0, 0, 0),
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
                pos = Vector(102, 0, 60),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 60
            },
            {
                pos = Vector(100, -3, 56),
                colorR = 0,
                colorG = 180,
                colorB = 220,
                colorA = 150,
                size = 20
            }
        },
        ProjectedTextures = {
            {
                pos = Vector(102, 0, 60.5),
                ang = Angle(10, 0, 0),
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

function ENT:OnSetupDataTables()
    self:AddDT("Bool", "HornEnabled")
end

function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/horn.png")
    weapon.Ammo = -1
    weapon.Delay = 1
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.Attack = function(ent)
        if ent.GetHornEnabled and ent:GetHornEnabled() then
            self:SetHornEnabled(false)
        elseif ent.GetHornEnabled and !ent:GetHornEnabled() then
            self:SetHornEnabled(true)
        end
    end

    self:AddWeapon(weapon)
end
