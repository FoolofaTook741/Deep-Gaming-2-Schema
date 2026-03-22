ENT.Base = "lvs_wheeldrive_hl2_combine_apc"
ENT.PrintName = "Combine APC (Armed)"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/combine_apc_armed.png"

ENT.Spawnable = true
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsmuzzleAttachment = "muzzle"
ENT.TurretAimRate = 100
ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"
ENT.TurretPitchPoseParameterName = "vehicle_weapon_pitch"
ENT.TurretPitchMin = -15
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = 0
ENT.TurretYawPoseParameterName = "vehicle_weapon_yaw"
ENT.TurretYawMin = -100
ENT.TurretYawMax = 170
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0

sound.Add({
    name = "LVS.HL2.CombineAPC.Fire",
    sound = "weapons/ar2/fire1.wav",
    channel = CHAN_WEAPON,
    volume = 1.0,
    pitch = {85, 95},
    level = 90
})

sound.Add({
    name = "LVS.HL2.CombineAPC.FireLast",
    sound = "lvs/hl2/cars/apc/apc_fire1.wav",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 90
})

function ENT:OnSetupDataTables()
    self:AddDT("Bool", "HornEnabled")
end

function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/bullet.png")
    weapon.Ammo = -1
    weapon.Delay = 0.1
    weapon.HeatRateUp = 0.5
    weapon.HeatRateDown = 0.5
    weapon.Attack = function(ent)
        local muzzle = ent:GetAttachment(ent:LookupAttachment("muzzle"))
        if !muzzle then return end

        local spread = tonumber(GetConVar("lvs_car_hl2_combineapc_spread"):GetString())
        local bullet = {}
        bullet.Src = muzzle.Pos
        bullet.Dir = muzzle.Ang:Forward()
        bullet.Spread = Vector(spread, spread, spread)
        bullet.TracerName = "none"
        bullet.Force = 1000
        bullet.HullSize = 15
        bullet.Damage = tonumber(GetConVar("lvs_car_hl2_combineapc_damage"):GetInt())
        bullet.Velocity = 30000
        bullet.Attacker = ent:GetDriver()
        bullet.Callback = function(att, tr, dmginfo)
            local effectData = EffectData()
            effectData:SetEntity(ent)
            effectData:SetAttachment(ent:LookupAttachment("muzzle"))
            effectData:SetStart(muzzle.Pos)
            effectData:SetOrigin(tr.HitPos)
            effectData:SetScale(6000)
            util.Effect("AirboatGunHeavyTracer", effectData)
            effectData = EffectData()
            effectData:SetOrigin(tr.HitPos + tr.HitNormal)
            effectData:SetNormal(tr.HitNormal)
            util.Effect("AR2Impact", effectData, true, true)
            effectData = EffectData()
            effectData:SetEntity(ent)
            effectData:SetAttachment(ent:LookupAttachment("muzzle"))
            effectData:SetStart(muzzle.Pos)
            effectData:SetOrigin(tr.HitPos)
            util.Effect("AirboatmuzzleFlash", effectData)
        end

        local physicsObject = ent:GetPhysicsObject()
        if IsValid(physicsObject) then physicsObject:ApplyForceOffset(-muzzle.Ang:Forward() * 15000, muzzle.Pos) end
        ent:EmitSound("LVS.HL2.CombineAPC.Fire")
        ent:LVSFireBullet(bullet)
        ent:TakeAmmo(1)
    end

    weapon.FinishAttack = function(ent) ent:EmitSound("LVS.HL2.CombineAPC.FireLast") end
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
    weapon.Icon = Material("lvs/weapons/missile.png")
    weapon.Ammo = 60
    weapon.Delay = 1.25
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 0.75
    weapon.Attack = function(ent)
        local muzzle = ent:GetAttachment(ent:LookupAttachment("cannon_muzzle"))
        if !muzzle then return end
        ent:EmitSound("PropAPC.FireCannon")
        local Driver = ent:GetDriver()
        local Target = ent:GetEyeTrace().HitPos
        local projectile = ents.Create("lvs_missile")
        projectile:SetPos(muzzle.Pos)
        projectile:SetAngles(muzzle.Ang)
        projectile:SetParent(ent)
        projectile:Spawn()
        projectile:Activate()
        projectile.GetTarget = function(missile) return missile end
        projectile.GetTargetPos = function(missile)
            if missile.HasReachedTarget then return missile:LocalToWorld(Vector(100, 0, 0)) end
            if (missile:GetPos() - Target):Length() < 100 then missile.HasReachedTarget = true end
            return Target
        end

        projectile:SetAttacker(IsValid(Driver) and Driver or self)
        projectile:SetEntityFilter(ent:GetCrosshairFilterEnts())
        projectile:SetSpeed(ent:GetVelocity():Length() + tonumber(GetConVar("lvs_car_hl2_combineapc_rocketspeed"):GetString()))
        projectile:SetDamage(tonumber(GetConVar("lvs_car_hl2_combineapc_rocketdamage"):GetString()))
        projectile:SetRadius(tonumber(GetConVar("lvs_car_hl2_combineapc_rocketradius"):GetString()))
        projectile:Enable()
        local physicsObject = ent:GetPhysicsObject()
        if IsValid(physicsObject) then physicsObject:ApplyForceOffset(-muzzle.Ang:Forward() * 100000, muzzle.Pos) end
        local effectData = EffectData()
        effectData:SetOrigin(muzzle.Pos)
        effectData:SetNormal(muzzle.Ang:Forward())
        effectData:SetEntity(ent)
        util.Effect("lvs_muzzle", effectData)
        ent:TakeAmmo(1)
    end

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
    weapon.OnSelect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(false) end end
    weapon.OnDeselect = function(ent) if ent.SetTurretEnabled then ent:SetTurretEnabled(true) end end

    self:AddWeapon(weapon)

    weapon = {}
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
