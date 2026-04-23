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
SWEP.Primary.Damage      = 1
SWEP.Primary.Recoil      = 0
SWEP.Primary.Ammo        = "none"
SWEP.Secondary.Ammo      = "none"

SWEP.ViewModel = "models/weapons/c_immolator_beta.mdl"
SWEP.WorldModel = ""  -- built into the cremator player model
SWEP.HoldType  = "physgun"

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
end

local MUZZLE_RIGHT   =  11.5
local MUZZLE_UP      =  -8.25
local MUZZLE_FORWARD =  36

function SWEP:GetMuzzlePos()
    local owner = self.Owner
    local boneIndex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
    if boneIndex then
        local bonePos, boneAng = owner:GetBonePosition(boneIndex)
        if bonePos then
            return bonePos + owner:GetAimVector() * 25 + owner:GetRight() * 15 + Vector(0, 0, -100)
        end
    end
    local aimVec = owner:GetAimVector()
    local rightVec = owner:GetRight()
    local pos = owner:GetPos() + aimVec * 20 + Vector(0, 0, owner:GetViewOffset().z * 0.9)
    return pos + Vector(0, 0, 10) + rightVec * 8 + aimVec * 10
end

function SWEP:PrimaryAttack()
    if self:IsUnderWater() then return end
    if not SERVER then return end

    local hit       = self.Owner:GetEyeTrace().HitPos
    local MuzzlePos = self:GetMuzzlePos()

    self:lase( 0, 0, MuzzlePos, hit, 0 )
    self:ShootEffects()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
    if not SERVER then return end

    if self.Weapon:GetNextPrimaryFire() < 0.1 + CurTime() then
        if self.Owner:KeyPressed( IN_ATTACK ) then
            self:EmitSound( ImmoOn )
        end

        self.LastFrame         = self.LastFrame or CurTime()
        self.LastRandomEffects = self.LastRandomEffects or 0

        if self.Owner:KeyDown( IN_ATTACK ) and self.LastSoundRelease + self.RestartDelay < CurTime() then
            if not self.SoundObject then
                self:CreateSound()
            end
            self.SoundObject:PlayEx( 1, 100 )
            self.SoundPlaying = true
        else
            if self.SoundObject and self.SoundPlaying then
                self.burnradius = 0.1
                self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
                self.SoundObject:FadeOut( 0.8 )
                self.SoundPlaying = false
                self.LastSoundRelease = CurTime()
                self:Idle()
                self:EmitSound( ImmoOff )
            end
        end

        if not self.Owner:Alive() then
            self:EndSound()
        end

        self.LastFrame = CurTime()
        self.Weapon:SetNWBool( "on", self.SoundPlaying )
    end
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
        beam:SetKeyValue( "renderamt",      brightness )
        beam:SetKeyValue( "rendercolor",    "0 255 0" )
        beam:SetKeyValue( "texture",        "sprites/bluelaser1.vmt" )
        beam:SetKeyValue( "TextureScroll",  "100" )
        beam:SetKeyValue( "boltwidth",      "1" )
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

        for k, v in pairs(ents.FindInSphere(entItem2:GetPos(), self.burnradius * 0.75)) do
            if IsValid(v) and v != self.Owner and v:Health() > 0 then
                v:Ignite(2.5, 20)
                dmginfo:SetDamageForce(self.Owner:GetAimVector())
                dmginfo:SetDamageType(16777224)
                dmginfo:SetAttacker(attacker)
                dmginfo:SetInflictor(self)

                if v:IsPlayer() and v:Team() == TEAM_ZOMBIE then
                    dmginfo:SetDamage(5)
                else
                    dmginfo:SetDamage(1)
                end

                v:TakeDamageInfo(dmginfo)
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
