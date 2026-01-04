SWEP.Base = "weapon_base"
SWEP.PrintName = "SCP 008 Infection Controller" -- The name of the weapon

SWEP.Author = "Johnny Roast Beef"
SWEP.Purpose = "Spread the infection!"
SWEP.Instructions = "Use LMB to spawn zombies and attack the site | Use RMB to toggle noclip."
SWEP.Category = "Deep Gaming" --This is required or else your weapon will be placed under "Other"

SWEP.Primary.Damage = 0 --The amount of damage will the weapon do
SWEP.Primary.TakeAmmo = 0 -- How much ammo will be taken per shot
SWEP.Primary.ClipSize = -1  -- How much bullets are in the mag
SWEP.Primary.Ammo = "Pistol" --The ammo type will it use
SWEP.Primary.DefaultClip = -1 -- How much bullets preloaded when spawned
SWEP.Primary.Spread = 0.1 -- The spread when shot
SWEP.Primary.NumberofShots = 0 -- Number of bullets when shot
SWEP.Primary.Automatic = false -- Is it automatic
SWEP.Primary.Recoil = 0 -- The amount of recoil
SWEP.Primary.Delay = 4 -- Delay before the next shot
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Primary.Delay = 6 -- Delay before the next shot
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true --Does it draw the crosshair
SWEP.DrawAmmo = false
SWEP.Weight = 5 --Priority when the weapon your currently holding drops
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModelFOV		= 60
SWEP.ViewModel			= "models/weapons/c_stunstick.mdl"

function SWEP:PrimaryAttack()
    local ownb = self:GetOwner()
    local eighttarget = ownb:GetEyeTrace()
    local chomb = ents.Create("npc_fastzombie")
    chomb:SetPos(eighttarget.HitPos)
    chomb:Spawn()
    chomb:SetHealth(500)
    self:EmitSound("npc/fast_zombie/fz_alert_close1.wav")
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
    local ownb = self:GetOwner()
    local eighttarget = ownb:GetEyeTrace()
    local chomb = ents.Create("npc_poisonzombie")
    chomb:SetPos(eighttarget.HitPos)
    chomb:Spawn()
    chomb:SetHealth(1000)
    self:EmitSound("npc/zombie_poison/pz_alert2.wav")
    self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:Reload()
    if CLIENT then return end
    local own = self:GetOwner()
    if own:GetMoveType() == MOVETYPE_WALK then
        own:SetMoveType( MOVETYPE_NOCLIP )
    elseif own:GetMoveType() == MOVETYPE_NOCLIP then
        own:SetMoveType( MOVETYPE_WALK )
    end
end