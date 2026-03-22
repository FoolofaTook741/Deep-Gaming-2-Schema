ENT.Base = "lvs_wheeldrive_hl2_rebel_jeep"
ENT.PrintName = "Jeep (Armed)"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/rebel_jeep_armed.png"

ENT.Spawnable = true
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsmuzzleAttachment = "Muzzlee"
ENT.TurretAimRate = 100
ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"
ENT.TurretPitchPoseParameterName = "vehicle_weapon_pitch"
ENT.TurretPitchMin = -15
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0
ENT.TurretYawPoseParameterName = "vehicle_weapon_yaw"
ENT.TurretYawMin = -100
ENT.TurretYawMax = 170
ENT.TurretYawMul = -1
ENT.TurretYawOffset = 0

CreateConVar("lvs_car_hl2_jeep_damage", 10, nil, "Controls the damage of the main gun from the Jeep.")

function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/bullet.png")
    weapon.Ammo = -1
    weapon.Delay = 0.2
    weapon.HeatRateUp = 0.2
    weapon.HeatRateDown = 0.35
    weapon.Attack = function(ent)
        local ID = ent:LookupAttachment("muzzle")
        local Muzzle = ent:GetAttachment(ID)
        if !Muzzle then return end

        local bullet = {}
        bullet.Src = Muzzle.Pos
        bullet.Dir = Muzzle.Ang:Forward()
        bullet.Spread = Vector(0.015, 0.015, 0)
        bullet.Tracer = 0
        bullet.TracerName = "none"
        bullet.Force = 50
        bullet.HullSize = 15
        bullet.Damage = tonumber(GetConVar("lvs_car_hl2_jeep_damage"):GetString())
        bullet.Velocity = 30000
        bullet.Attacker = ent:GetDriver()
        bullet.Callback = function(att, tr, dmginfo)
            local effectData = EffectData()
            effectData:SetEntity(ent)
            effectData:SetAttachment(ID)
            effectData:SetStart(Muzzle.Pos)
            effectData:SetOrigin(tr.HitPos)
            util.Effect("lvs_hl2_gausstracer", effectData)

            local effect = ents.Create("env_spark")
            effect:SetKeyValue("targetname", "target")
            effect:SetPos(tr.HitPos + tr.HitNormal * 2)
            effect:SetAngles(tr.HitNormal:Angle())
            effect:Spawn()
            effect:SetKeyValue("spawnflags", "128")
            effect:SetKeyValue("Magnitude", 5)
            effect:SetKeyValue("TrailLength", 3)
            effect:Fire("SparkOnce")
            effect:Fire("kill", "", 0.21)
            util.Decal("fadingscorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
        end

        local PhysObj = ent:GetPhysicsObject()
        if IsValid(PhysObj) then PhysObj:ApplyForceOffset(-Muzzle.Ang:Forward() * 1000, Muzzle.Pos) end
        ent:EmitSound("weapons/gauss/fire1.wav", 90, math.Rand(95, 105), 1, CHAN_STATIC)
        ent:LVSFireBullet(bullet)
    end

    weapon.OnSelect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(true) end end
    weapon.OnDeselect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(false) end end

    weapon.OnOverheat = function(ent) ent:EmitSound("lvs/overheat.wav") end
    weapon.HudPaint = function(ent, X, Y, client)
        local muzzle = ent:GetAttachment(ent:LookupAttachment("muzzle"))
        if !muzzle then return end
        local traceTurret = util.TraceLine({
            start = muzzle.Pos,
            endpos = muzzle.Pos + muzzle.Ang:Forward() * 50000,
            filter = ent:GetCrosshairFilterEnts()
        })

        local muzzlePos2D = traceTurret.HitPos:ToScreen()
        ent:PaintCrosshairOuter(muzzlePos2D, COLOR_WHITE)
        ent:LVSPaintHitMarker(muzzlePos2D)
    end

    self:AddWeapon(weapon)

    weapon = {}
    weapon.Icon = Material("lvs/weapons/tank_noturret.png")
    weapon.Ammo = -1
    weapon.Delay = 0
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    self:AddWeapon(weapon)
end
