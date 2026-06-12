if SERVER then
    util.AddNetworkString("ImmolatorFlame")
    resource.AddFile("materials/effects/muzzleflash2edit.vtf")
    resource.AddFile("materials/effects/muzzleflash2edit.vmt")
end

if CLIENT then
    net.Receive("ImmolatorFlame", function()
        local lp = LocalPlayer()
        if not IsValid(lp) then return end
        local startPos = net.ReadVector()
        local endPos = net.ReadVector()
        local ownerIndex = net.ReadUInt(8)
        local isOwner = LocalPlayer():EntIndex() == ownerIndex
        local isThirdPerson = LocalPlayer():ShouldDrawLocalPlayer()
        if isOwner and not isThirdPerson then return end
        startPos.z = startPos.z - 10

        local mats = {"effects/muzzleflash2", "effects/muzzleflash2edit", "effects/muzzleflash3"}
        local emitter = ParticleEmitter(startPos)
        if not emitter then return end

        for i = 0, 8 do
            local p = emitter:Add(mats[math.random(1,3)], startPos)
            if p then
                p:SetVelocity(((endPos - startPos):GetNormal() * math.random(900,1200)) + (VectorRand() * math.random(142,172)))
                p:SetLifeTime(0)
                p:SetDieTime(0.52)
                p:SetStartAlpha(math.random(92,132))
                p:SetEndAlpha(0)
                p:SetStartSize(math.random(4,6))
                p:SetEndSize(math.random(32,52))
                p:SetRoll(math.Rand(-360, 360))
                p:SetRollDelta(math.Rand(-7.2, 7.2))
                p:SetAirResistance(math.random(128, 256))
                p:SetCollide(true)
                p:SetGravity(Vector(0, 0, 64))
            end
        end

        hook.Add("PostDrawTranslucentRenderables", "ImmolatorBeam", function()
            local lp = LocalPlayer()
            if not IsValid(lp) then return end
            local wep = lp:GetActiveWeapon()
            if not IsValid(wep) or wep:GetClass() ~= "weapon_immolator" then return end
            if not lp:KeyDown(IN_ATTACK) then return end
            if lp:ShouldDrawLocalPlayer() then return end -- skip in third person

            local shootPos = lp:GetShootPos()
            local forward = lp:GetAimVector()
            local hit = lp:GetEyeTrace().HitPos

            render.SetMaterial(Material("sprites/bluelaser1"))
            render.DrawBeam(shootPos + forward * 20, hit, 3, 0, 1, Color(0, 255, 0, 200))
        end)
        --[[
        local explodeEmitter = ParticleEmitter(endPos)
        if explodeEmitter then
            local mats = {"effects/muzzleflash2", "effects/muzzleflash2edit", "effects/muzzleflash3"}
            for i = 0, 16 do
                local p = explodeEmitter:Add(mats[math.random(1,3)], endPos)
                if p then
                    p:SetVelocity(VectorRand() * 172)
                    p:SetLifeTime(0)
                    p:SetDieTime(0.72)
                    p:SetStartAlpha(210)
                    p:SetEndAlpha(0)
                    p:SetStartSize(0)
                    p:SetEndSize(64)
                    p:SetRoll(math.Rand(-210, 210))
                    p:SetRollDelta(math.Rand(-3.2, 3.2))
                    p:SetAirResistance(350)
                    p:SetGravity(Vector(0, 0, 64))
                end
            end
            explodeEmitter:Finish()
        end ]]--
        emitter:Finish()
    end)
end

local FLAMETHROWER_RANGE = 320
local LASER_RANGE        = 800

local FLAME_AMMO_MAX     = 100
local FLAME_AMMO_ENABLED = false 

local WOOD_MATERIALS = { "wood", "Wood" }

local IGNITE_CLASSES = {
    ["prop_ragdoll"]  = true,
    ["impulse_item"]  = true,
}


if CLIENT then
    language.Add( "weapon_immolator_dg", "Immolator (Beta)" )

    SWEP.Category          = "Half-Life 2"
    SWEP.PrintName         = "Immolator Deep Gaming 2"
    SWEP.Slot              = 2
    SWEP.SlotPos           = 3
    SWEP.DrawAmmo          = false
    SWEP.DrawCrosshair     = true
    SWEP.ViewModelFOV      = 58
    SWEP.AutoIconAngle     = Angle( 0, 0, -25 )
    SWEP.ViewModelFlip     = false
    SWEP.DrawWeaponInfoBox = true
    SWEP.UseHands          = true
    SWEP.WepSelectIcon     = surface.GetTextureID( "HUD/swepicons/weapon_immolator_beta" )
    SWEP.BounceWeaponIcon  = false
end

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.Weight         = 5
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 0
SWEP.Primary.Recoil      = 0
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = true
SWEP.Secondary.Ammo        = "none"

SWEP.ViewModel = "models/weapons/c_immolator_beta.mdl"
SWEP.WorldModel = ""  -- built into the cremator player model
SWEP.HoldType  = "physgun"

sound.Add({
    name    = "Weapon_Immolator.LaserOn",
    channel = CHAN_AUTO,
    volume  = 1.0,
    level   = SNDLVL_GUNFIRE,
    sound   = "ambient/fire/gascan_ignite1.wav"
})

sound.Add({
    name    = "Weapon_Immolator.LaserLoop",
    channel = CHAN_WEAPON,
    volume  = 1.0,
    level   = SNDLVL_GUNFIRE,
    sound   = "ambient/fire/fire_small1.wav"
})

local LaserOn   = Sound("Weapon_Immolator.LaserOn")
local LaserLoop = Sound("Weapon_Immolator.LaserLoop")

sound.Add( {
    name    = "Weapon_Immolator.Off",
    channel = CHAN_VOICE2,
    volume  = 1.0,
    level   = SNDLVL_GUNFIRE,
    sound   = "weapons/mtov_flame3.wav"
} )

sound.Add( {
    name    = "Weapon_Immolator.Run",
    channel = CHAN_WEAPON,
    volume  = 1.0,
    level   = SNDLVL_GUNFIRE,
    sound   = "ambient/fire_big_loop1.wav"
} )

sound.Add( {
    name    = "Weapon_Immolator.On",
    channel = CHAN_VOICE2,
    volume  = 1.0,
    level   = SNDLVL_GUNFIRE,
    sound   = "weapons/mtov_flame1.wav"
} )

SWEP.Sound = Sound( "Weapon_Immolator.Run" )
local ImmoOff = Sound( "Weapon_Immolator.Off" )
local ImmoOn  = Sound( "Weapon_Immolator.On" )

SWEP.LastSoundRelease = 0
SWEP.RestartDelay     = 0

function SWEP:Initialize()
    self:SetWeaponHoldType( self.HoldType )
    self.burnradius = 0.1

    if SERVER then
        self.Weapon:SetNWInt( "FlameAmmo", FLAME_AMMO_MAX )
    end
end

function SWEP:GetLaserPos()
    local owner = self.Owner
    local bonePos = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
    local speed = owner:GetVelocity():Length2D()
    local zOffset = speed > 10 and -8 or -16
    local xOffset = speed > 10 and 63 or 60
    return bonePos + owner:GetAimVector() * xOffset + owner:GetRight() * -3 + Vector(0, 0, zOffset)
end

function SWEP:GetFlamePos()
    local owner = self.Owner
    local bonePos = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
    local speed = owner:GetVelocity():Length2D()
    local zOffset = speed > 10 and 2 or -6
    local xOffset = speed > 10 and 63 or 60
    return bonePos + owner:GetAimVector() * xOffset + owner:GetRight() * -3 + Vector(0, 0, zOffset)
end


local function IsWooden( ent )
    if not IsValid( ent ) then return false end
    local phys = ent:GetPhysicsObject()
    if not IsValid( phys ) then return false end
    local mat = phys:GetMaterial() or ""
    for _, pattern in ipairs( WOOD_MATERIALS ) do
        if mat:find( pattern ) then return true end
    end
    return false
end

local function ShouldIgnite( ent )
    if not IsValid( ent ) then return false end
    local cls = ent:GetClass()
    if IGNITE_CLASSES[cls] then
        if cls == "impulse_item" and ent.Item and ent.Item.UniqueID == "item_ashes" then
            return false
        end
        return true
    end
    if cls == "prop_physics" and IsWooden( ent ) then return true end
    return false
end


function SWEP:PrimaryAttack()
    if self:IsUnderWater() then return end
    if not SERVER then return end

    if not self.LaserFiring then
        self.Owner:EmitSound( LaserOn )
        self.LaserFiring = true
        self.LaserLoopDelay = CurTime() + 0.3
    end

    local shootPos = self.Owner:GetShootPos()
    local forward  = self.Owner:GetAimVector()

    local rawHit = self.Owner:GetEyeTrace().HitPos
    local dist   = shootPos:Distance( rawHit )
    local hit    = dist > LASER_RANGE and (shootPos + forward * LASER_RANGE) or rawHit

    local MuzzlePos = self:GetLaserPos()
    self:lase( 0, 0, MuzzlePos, hit, 0 )
    self:ShootEffects()
end

function SWEP:SecondaryAttack()
    if self:IsUnderWater() then return end
    if not SERVER then return end

    if ( self.NextFlameTime or 0 ) > CurTime() then return end
    self.NextFlameTime = CurTime() + 0.08

    --self:SetNextSecondaryFire( CurTime() + 0.08 )

    -- Ammo check (ready for when FLAME_AMMO_ENABLED = true)
    if FLAME_AMMO_ENABLED then
        local cur = self.Weapon:GetNWInt( "FlameAmmo", FLAME_AMMO_MAX )
        if cur <= 0 then return end
        self.Weapon:SetNWInt( "FlameAmmo", cur - 1 )
    end

    local trace = self.Owner:GetEyeTrace()
    local shootPos = self.Owner:GetShootPos()
    local forward  = self.Owner:GetAimVector()

    local dist = shootPos:Distance( trace.HitPos )
    local hitPos
    if dist > FLAMETHROWER_RANGE then
        hitPos = shootPos + forward * FLAMETHROWER_RANGE
    else
        hitPos = trace.HitPos
    end

    if SERVER then
        local muzzlePos = self:GetFlamePos()
        net.Start("ImmolatorFlame")
        net.WriteVector(muzzlePos)
        net.WriteVector(hitPos)
        net.WriteUInt(self.Owner:EntIndex(), 8)
        net.Broadcast()
        self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", math.random(27,35), math.random(32,152) )

        local flamefx = EffectData()
        flamefx:SetOrigin( hitPos )
        flamefx:SetStart( shootPos )
        flamefx:SetAttachment( 1 )
        flamefx:SetEntity( self.Weapon )
        util.Effect( "swep_flamethrower_flame", flamefx, true, true )

        local delay = shootPos:Distance( hitPos ) / 1520
        local owner  = self.Owner

        timer.Simple( delay, function()
            if not IsValid( owner ) then return end

            --local firefx = EffectData()
            --firefx:SetOrigin( hitPos )
            --util.Effect( "swep_flamethrower_explosion", firefx, true, true )

            for _, ent in pairs( ents.FindInSphere( hitPos, 100 ) ) do
                if ent == owner then continue end
                if not ShouldIgnite( ent ) then continue end

                -- Tag for future plugin
                ent.CrematorIgnited   = true
                ent.CrematorIgnitedBy = owner

                ent:Ignite( math.random(16, 32), 100 )

                hook.Run( "CrematorIgnited", owner, ent )
            end

            local hitEnt = trace.Entity
            if IsValid( hitEnt ) and hitEnt ~= owner and ShouldIgnite( hitEnt ) then
                hitEnt.CrematorIgnited   = true
                hitEnt.CrematorIgnitedBy = owner
                if not hitEnt:IsOnFire() then
                    hitEnt:Ignite( math.random(16, 32), 100 )
                end
                hook.Run( "CrematorIgnited", owner, hitEnt )
            end
        end )
    end
end

function SWEP:Reload()
end

function SWEP:Think()
    if not SERVER then return end

    if self.Owner:KeyDown( IN_ATTACK ) then
        if not self.LaserSoundObj and (self.LaserLoopDelay or 0) < CurTime() then
            self.LaserSoundObj = CreateSound( self.Weapon, LaserLoop )
            self.LaserSoundObj:Play()
        end
        if self.LaserSoundObj then
            self.LaserSoundObj:PlayEx( 1, 100 )
        end
    else
        if self.LaserSoundObj then
            self.LaserSoundObj:FadeOut( 0.8 )
            self.LaserSoundObj = nil
            self.burnradius = 0.1
        end
        self.LaserFiring = false
    end

    if self.Owner:KeyPressed( IN_ATTACK2 ) then
        self:EmitSound( ImmoOn )
    end

    if self.Owner:KeyDown( IN_ATTACK2 ) then
        if not self.SoundObject then
            self.SoundObject = CreateSound( self.Weapon, self.Sound )
            self.SoundObject:Play()
        end
        self.SoundObject:PlayEx( 1, 100 )
        self.SoundPlaying = true
    else
        if self.SoundObject and self.SoundPlaying then
            self.SoundObject:FadeOut( 0.8 )
            self.SoundPlaying = false
            self.LastSoundRelease = CurTime()
            self:Idle()
            self:EmitSound( ImmoOff )
        end
    end

    if not self.Owner:Alive() then
        if self.LaserSoundObj then self.LaserSoundObj:Stop() self.LaserSoundObj = nil end
        if self.SoundObject then self.SoundObject:Stop() self.SoundObject = nil end
    end

    self.Weapon:SetNWBool( "on", self.SoundPlaying )
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
    self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() )
    self:NextThink( CurTime() + self:SequenceDuration() )
    self:Idle()
    return true
end

function SWEP:ShootEffects()
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:IsUnderWater()
    return self.Owner:WaterLevel() >= 2
end

function SWEP:lase( par, stat, from, to, noise )
    local beamx = math.Rand( -1, 1 )
    local beamy = math.Rand( -1, 1 )
    local beamz = math.Rand( -1, 1 )
    local attacker = self.Owner
    local dmginfo  = DamageInfo()
    self.burnradius = math.Clamp( self.burnradius + ( 5 / 6 ), 0.1, 64 )
    local brightness  = 255 * ( self.burnradius / 256 )
    local explodebeam = to + Vector( beamx, beamy, beamz ) * self.burnradius

    if SERVER then
        local entItem  = ents.Create( "info_teleport_destination" )
        local realName = "entItem" .. tostring( self.Owner:GetName() )
        entItem:SetKeyValue( "targetname", realName )
        entItem:Spawn()
        entItem:SetOwner( self.Owner )
        entItem:SetPos( to )

        local entItem2  = ents.Create( "info_teleport_destination" )
        local realName2 = "entItem2" .. tostring( self.Owner:GetName() )
        entItem2:SetKeyValue( "targetname", realName2 )
        entItem2:Spawn()
        entItem2:SetPos( explodebeam )
        entItem2:SetOwner( self.Owner )

        local entItem3  = ents.Create( "info_teleport_destination" )
        local realName3 = "entItem3" .. tostring( self.Owner:GetName() )
        entItem3:SetKeyValue( "targetname", realName3 )
        entItem3:Spawn()
        entItem3:SetPos( from )
        entItem3:SetOwner( self.Owner )

        local beam = ents.Create( "env_beam" )
        beam:SetKeyValue( "renderamt",      "200" )
        beam:SetKeyValue( "rendercolor",    "0 255 0" )
        beam:SetKeyValue( "texture",        "sprites/bluelaser1.vmt" )
        beam:SetKeyValue( "TextureScroll",  "100" )
        beam:SetKeyValue( "boltwidth",      "3" )
        beam:SetKeyValue( "LightningStart", realName3 )
        beam:SetKeyValue( "LightningEnd",   realName )
        beam:SetKeyValue( "spawnflags",     1 )
        beam:SetKeyValue( "NoiseAmplitude", 1 )
        beam:Spawn()
        beam:Activate()
        beam:SetOwner( self.Owner )

        local beamend = ents.Create( "env_beam" )
        beamend:SetKeyValue( "renderamt",      "128" )
        beamend:SetKeyValue( "rendercolor",    "0 255 0" )
        beamend:SetKeyValue( "texture",        "sprites/bluelaser1.vmt" )
        beamend:SetKeyValue( "TextureScroll",  "100" )
        beamend:SetKeyValue( "boltwidth",      "20" )
        beamend:SetKeyValue( "LightningStart", realName )
        beamend:SetKeyValue( "LightningEnd",   realName2 )
        beamend:SetKeyValue( "spawnflags",     769 )
        beamend:SetKeyValue( "NoiseAmplitude", 15 )
        beamend:Spawn()
        beamend:Activate()
        beamend:SetOwner( self.Owner )

        beamend:Fire( "kill", "", 0.15 )
        beam:Fire( "kill", "", 0.01 )
        entItem:Fire( "kill", "", 0.01 )
        entItem2:Fire( "kill", "", 0.01 )
        entItem3:Fire( "kill", "", 0.01 )

        for k, v in pairs( ents.FindInSphere( entItem2:GetPos(), self.burnradius * 0.75 ) ) do
            if IsValid( v ) and v != self.Owner and v:Health() > 0 then
                if v:IsPlayer() and v:Team() == TEAM_CREMATOR then continue end
                v:Ignite( 2.5, 20 )
                dmginfo:SetDamageForce( self.Owner:GetAimVector() )
                dmginfo:SetDamageType( 16777224 )
                dmginfo:SetAttacker( attacker )
                dmginfo:SetInflictor( self )

                if v:IsPlayer() and v:Team() == TEAM_ZOMBIE then
                    dmginfo:SetDamage( 4 )
                else
                    dmginfo:SetDamage( 1 )
                end

                v:TakeDamageInfo( dmginfo )
            end
        end
    end
end

function SWEP:CreateSound()
    self.SoundObject = CreateSound( self.Weapon, self.Sound )
    self.SoundObject:Play()
end

function SWEP:OwnerChanged() self:EndSound() end

function SWEP:EndSound()
    if self.SoundObject then
        self.SoundObject:Stop()
    end
end

function SWEP:OnRemove()
    self:EndSound()
    return true
end

function SWEP:Holster( weapon )
    if CLIENT then return end
    self:StopIdle()
    return true
end

function SWEP:DoIdleAnimation()
    self:SendWeaponAnim( ACT_VM_IDLE )
end

function SWEP:DoIdle()
    self:DoIdleAnimation()
    timer.Adjust( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 0, function()
        if not IsValid( self ) then timer.Destroy( "weapon_idle" .. self:EntIndex() ) return end
        self:DoIdleAnimation()
    end )
end

function SWEP:StopIdle()
    timer.Destroy( "weapon_idle" .. self:EntIndex() )
end

function SWEP:Idle()
    if CLIENT or not IsValid( self.Owner ) then return end
    timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration() - 0.2, 1, function()
        if not IsValid( self ) then return end
        self:DoIdle()
    end )
end