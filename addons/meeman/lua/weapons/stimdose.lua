SWEP.PrintName = "Stimdose" -- The name of the weapon

SWEP.Author = "Johnny Roast Beef"
SWEP.Purpose = "Recover a static amount of HP then regenerate some HP over time"
SWEP.Instructions = "LMB to apply to yourself."
SWEP.Category = "Deep Gaming" --This is required or else your weapon will be placed under "Other"
SWEP.Spawnable = true

SWEP.Base = "weapon_base"
 -- How much ammo will be taken per shot
SWEP.Primary.ClipSize = 1  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "XBowBolt" --The ammo type will it use, set to XBow Bolt because I only wanted a single use 
SWEP.Primary.TakeAmmo = 1 -- How much bullets preloaded when spawned
SWEP.Primary.Spread = 0.1 -- The spread when shot
SWEP.Primary.Recoil = .2 -- The amount of recoil
SWEP.Primary.Delay = 10 -- Delay before the next shot

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"

function SWEP:PrimaryAttack()
    if (self:Clip1() == 0 ) then
        self:EmitSound("items/medshotno1.wav")
        return
    else
        if (self:Health() >= self:GetMaxHealth()) then
            return
        else   
            local hth = 50 -- stands for health to heal, set this to what you want to have for initial healing
            local regenAmount = 1 --Number of HP healed per iteration, leave set to 0 if you
            local regenIterations = 30 --Number of times the regen effect is applied
            local regenInterval = 3 --how many seconds are in between each iteration
            local sndtoplay = "items/medshot4.wav"
            initialheal(self:GetOwner(), hth)
            timer.Create("regentimer", regenInterval, regenIterations, function() regenerateOverTime(self:GetOwner(), regenAmount) end)
            self:EmitSound(sndtoplay)
            self:TakePrimaryAmmo(1)
        end
    end
end

function SWEP:SecondaryAttack()
    if (self:Clip1() == 0) then
        self:EmitSound("items/medshotno1.wav")
        return
    else
        if (self:Health() >= self:GetMaxHealth()) then
            return
        else
            local injector = self:GetOwner()
            local injectee = injector:GetEyeTrace().Entity
            local injecteeloc = injectee:GetPos()
            local injectorloc = injector:GetPos()
            local hthtwo = 30 -- stands for health to heal, set this to what you want to have for initial healing
            local regenAmounttwo = 1 --Number of HP healed per iteration, leave set to 0 if you
            local regenIterationstwo = 30 --Number of times the regen effect is applied
            local regenIntervaltwo = 3 --how many seconds are in between each iteration
            local sndtoplaytwo = "items/medshot4.wav"
            if (injectee:IsPlayer() && injecteeloc:DistToSqr(injectorloc) < 500)  then
                initialheal(self:GetOwner(), hthtwo)
                timer.Create("regentimer", regenIntervaltwo, regenIterationstwo, function() regenerateOverTime(injectee, regenAmounttwo) end)
                self:EmitSound(sndtoplaytwo)
                self:TakePrimaryAmmo(1)
            else
                self:EmitSound("items/medshotno1.wav")
            end
        end
    end
end

function regenerateOverTime(target, amount)
    if (target:Health() < 1) then
        timer.Remove("regentimer")
        return
    elseif (target:Health() >= target:GetMaxHealth()) then
        return
    else
        target:SetHealth(target:Health() + amount)
    end
end


function initialheal(owner, amount)
    if (owner:Health() + amount > owner:GetMaxHealth()) then
        hpov = owner:GetMaxHealth() - owner:Health()
        owner:SetHealth(owner:Health() + hpov)
    else
        owner:SetHealth(owner:Health() + amount)
    end
end