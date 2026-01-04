SWEP.PrintName = "Arrest Baton" -- The name of the weapon

SWEP.Author = "Johnny Roast Beef"
SWEP.Purpose = "Use this on people you are arresting to send them to jail."
SWEP.Instructions = "LMB to arrest cuffed suspects | RMB to unarrest."
SWEP.Category = "Deep Gaming" --This is required or else your weapon will be placed under "Other"
SWEP.Spawnable = true

SWEP.Base = "weapon_base"
 -- How much ammo will be taken per shot
SWEP.Primary.ClipSize = -1  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0 -- The spread when shot
SWEP.Primary.Recoil = 0 -- The amount of recoil
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 2 -- Delay before the next shot

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local targ = ply:GetEyeTrace().Entity
    print(targ)
    if targ:IsPlayer() && targ:HasWeapon() == "weapon_handcuffed" && targ:Team() != TEAM_CP && !targ:IsArrested() then
        targ:Jail(300)
        self:EmitSound("buttons/button16.wav")
        
        if !timer.Exists("abnoticecooldown") then
            ply:Notify("Target has been arrested for 5 minutes.")
            timer.Create("abnoticecooldown", 2, 0, function() timer.Remove("abnoticecooldown") end)
        end
    elseif targ:IsPlayer() then
        if !timer.Exists("abnoticecooldown") then
            ply:Notify("This person cannot be arrested.")
            timer.Create("abnoticecooldown", 2, 0, function() timer.Remove("abnoticecooldown") end)
        end
    else
        if !timer.Exists("abnoticecooldown") then
            ply:Notify("Invalid target.")
            timer.Create("abnoticecooldown", 2, 0, function() timer.Remove("abnoticecooldown") end)
        end
    end
    self:EmitSound("buttons/button16.wav")
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    local targ = ply:GetEyeTrace().Entity
    if targ:IsPlayer() && targ:IsArrested() then
        targ:Unjail()
    end
end