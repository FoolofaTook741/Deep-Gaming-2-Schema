ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Combine APC (Armed)"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combineapc_armed.png"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.SpawnNormalOffset = 0

ENT.MDL = "models/vehicles/combine_apc.mdl"
ENT.MDL_DESTROYED = "models/combine_apc_destroyed_gib01.mdl"
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
ENT.MaxHealth = 2000
ENT.MaxVelocity = 1600
ENT.EngineCurve = 0.8
ENT.EngineTorque = 400

ENT.TransGears = 4
ENT.TransGearsReverse = 2

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

// taken from one of the armed vehicles
function ENT:OnSetupDataTables()
    self:AddDT("Float", "TurretPitch")
    self:AddDT("Float", "TurretYaw")
    self:AddDT("Bool", "TurretEnabled")

    if ( SERVER ) then
        self:SetTurretEnabled(true)
    end
end

function ENT:IsTurretEnabled()
    if ( self:GetHP() <= 0 ) then
        return false
    end

    if ( !self:GetTurretEnabled() ) then
        return false
    end

    return IsValid(self:GetDriver()) or self:GetAI()
end

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
    sound = "lvs/halflife2/cars/apc/apc_fire1.wav",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 90
})

function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/bullet.png")
    weapon.Ammo = -1
    weapon.Delay = 0.1
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 0.5
    weapon.Attack = function(ent)
        local ID = ent:LookupAttachment("muzzle")
        local Muzzle = ent:GetAttachment(ID)

        if ( !Muzzle ) then return end

        local spread = tonumber(GetConVar("lvs_car_hl2_combineapc_spread"):GetString())

        local bullet = {}
        bullet.Src = Muzzle.Pos
        bullet.Dir = Muzzle.Ang:Forward()
        bullet.Spread = Vector(spread, spread, spread)
        bullet.TracerName = "none"
        bullet.Force = 1000
        bullet.HullSize = 0
        bullet.Damage = tonumber(GetConVar("lvs_car_hl2_combineapc_damage"):GetInt())
        bullet.Velocity = 30000
        bullet.Attacker = ent:GetDriver()
        bullet.Callback = function(att, tr, dmginfo)
            local effectdata = EffectData()
            effectdata:SetEntity(ent)
            effectdata:SetAttachment(ID)
            effectdata:SetStart(Muzzle.Pos)
            effectdata:SetOrigin(tr.HitPos)
            effectdata:SetScale(6000)
            util.Effect("AirboatGunHeavyTracer", effectdata)
        
            local effectdata = EffectData()
            effectdata:SetOrigin( tr.HitPos + tr.HitNormal)
            effectdata:SetNormal(tr.HitNormal)
            util.Effect("AR2Impact", effectdata, true, true)

            local effectdata = EffectData()
            effectdata:SetEntity(ent)
            effectdata:SetAttachment(ID)
            effectdata:SetStart(Muzzle.Pos)
            effectdata:SetOrigin(tr.HitPos)
            util.Effect("AirboatMuzzleFlash", effectdata)
        end

        local PhysObj = ent:GetPhysicsObject()
        if ( IsValid(PhysObj) ) then
            PhysObj:ApplyForceOffset(-Muzzle.Ang:Forward() * 15000, Muzzle.Pos)
        end

        ent:EmitSound("LVS.HL2.CombineAPC.Fire", 90)

        ent:LVSFireBullet(bullet)

        ent:TakeAmmo(1)
    end
    weapon.FinishAttack = function(ent)
        ent:EmitSound("LVS.HL2.CombineAPC.FireLast", 90, math.random(90, 110))
    end
    weapon.OnSelect = function(ent)
        if ( ent.SetTurretEnabled ) then
            ent:SetTurretEnabled(true)
        end
    end
    weapon.OnDeselect = function(ent)
        if ( ent.SetTurretEnabled ) then
            ent:SetTurretEnabled(false)
        end
    end
    weapon.OnThink = function(ent, active)
        if ( !ent:GetTurretEnabled() ) then return end

        local AimAngles = self:WorldToLocalAngles(self:GetAimVector():Angle())

        local AimRate = 250 * FrameTime() 
    
        local Pitch = math.ApproachAngle(self:GetTurretPitch(), AimAngles.p, AimRate)
        local Yaw = math.ApproachAngle(self:GetTurretYaw(), AimAngles.y - 90, AimRate)

        self:SetTurretPitch(math.Clamp(Pitch, -100, 140))
		--self:SetTurretYaw(math.Clamp(Yaw, -170, 170))
		self:SetTurretYaw( Yaw )
    
        self:SetPoseParameter("vehicle_weapon_pitch", -self:GetTurretPitch())
        self:SetPoseParameter("vehicle_weapon_yaw", -self:GetTurretYaw())
    end
    weapon.OnOverheat = function(ent)
        ent:EmitSound("lvs/overheat.wav")
    end
    weapon.HudPaint = function( ent, X, Y, ply )
        local ID = ent:LookupAttachment("muzzle")
        local Muzzle = ent:GetAttachment(ID)

        if ( !Muzzle ) then return end
        
        local traceTurret = util.TraceLine( {
            start = Muzzle.Pos,
            endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 5000,
            filter = ent:GetCrosshairFilterEnts()
        } )

        local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

        ent:PaintCrosshairCenter( MuzzlePos2D, Col )
        ent:LVSPaintHitMarker( MuzzlePos2D )
    end

    self:AddWeapon(weapon)
    
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/missile.png")
    weapon.Ammo = 60
    weapon.Delay = 1.25
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 0.75
    weapon.Attack = function( ent )
        local ID = ent:LookupAttachment("cannon_muzzle")
        local Muzzle = ent:GetAttachment(ID)

        if ( !Muzzle ) then return end

        ent:EmitSound("PropAPC.FireCannon")

        local Driver = ent:GetDriver()
        local Target = ent:GetEyeTrace().HitPos

        local projectile = ents.Create("lvs_missile")
        projectile:SetPos(Muzzle.Pos)
        projectile:SetAngles(Muzzle.Ang)
        projectile:SetParent(ent)
        projectile:Spawn()
        projectile:Activate()
        projectile.GetTarget = function(missile)
            return missile
        end
        projectile.GetTargetPos = function(missile)
            if ( missile.HasReachedTarget ) then
                return missile:LocalToWorld(Vector(100,0,0))
            end

            if ( missile:GetPos() - Target ):Length() < 100 then
                missile.HasReachedTarget = true
            end

            return Target
        end
        projectile:SetAttacker(IsValid(Driver) and Driver or self)
        projectile:SetEntityFilter(ent:GetCrosshairFilterEnts())
        projectile:SetSpeed(ent:GetVelocity():Length() + tonumber(GetConVar("lvs_car_hl2_combineapc_rocketspeed"):GetString()))
        projectile:SetDamage(tonumber(GetConVar("lvs_car_hl2_combineapc_rocketdamage"):GetString()))
        projectile:SetRadius(tonumber(GetConVar("lvs_car_hl2_combineapc_rocketradius"):GetString()))
        projectile:Enable()

        local PhysObj = ent:GetPhysicsObject()
        if ( IsValid(PhysObj) ) then
            PhysObj:ApplyForceOffset(-Muzzle.Ang:Forward() * 100000, Muzzle.Pos)
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(Muzzle.Pos)
        effectdata:SetNormal(Muzzle.Ang:Forward())
        effectdata:SetEntity(ent)
        util.Effect("lvs_muzzle", effectdata)

        ent:TakeAmmo(1)
    end
    weapon.HudPaint = function( ent, X, Y, ply )
        local traceTurret = util.TraceLine( {
            start = EyePos(),
            endpos = EyePos() + EyeAngles():Forward() * 10000,
            filter = ent:GetCrosshairFilterEnts()
        } )

        local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

        ent:PaintCrosshairOuter( MuzzlePos2D, Col )
        ent:LVSPaintHitMarker( MuzzlePos2D )
    end

    self:AddWeapon(weapon)

    local weapon = {}
    weapon.Icon = Material("lvs/weapons/tank_noturret.png")
    weapon.Ammo = -1
    weapon.Delay = 0
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0

    self:AddWeapon(weapon)
end