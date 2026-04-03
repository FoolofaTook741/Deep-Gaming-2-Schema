AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "O.S.I.P.R. MK. II-E Pulse Orb Attachment"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_iiopnirifle.mdl")
SWEP.ViewModel = Model("models/weapons/c_iiopnirifle.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Sound = ""

SWEP.Primary.Recoil = 0.4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Delay = 0.8
SWEP.Primary.Damage = 0
SWEP.Primary.HitDelay = 0.1

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.Primary.Ammo = "AR2AltFire"
SWEP.Primary.Sound = "weapons/irifle/irifle_fire2.wav"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

--SWEP.ReloadSound = Sound("weapons/projectmmod_ar2/npc_ar2_reload.wav")
SWEP.EmptySound = Sound("Weapon_AR2.Empty")

function SWEP:Reload()
    
end
function SWEP:PrimaryAttack()
    local owner = self.Owner

    if owner:GetAmmoCount("AR2AltFire") <= 0 then
        if not self.NoDryFireAnim then
            self:PlayAnim(ACT_VM_DRYFIRE)
            self:QueueIdle()
        end
        self:SetNextPrimaryFire(CurTime() + 1)
        return
    end
    if SERVER then
	    owner:EmitSound("weapons/cguard/charging.wav")
	end

    owner:RemoveAmmo(1, "AR2AltFire")
    self:SetNextPrimaryFire(CurTime() + 3)
    self:SetNextSecondaryFire(CurTime() + 3)

    util.ScreenShake(owner:GetPos(), 3, 4, 1, 2)

    local vm = owner:GetViewModel()
    vm:SetSequence("shake")
    vm:SetPlaybackRate(0.5)
    --[[
    timer.Create("orb_shake_" .. owner:EntIndex(), 0.1, 10, function()
        if IsValid(self) and owner:GetActiveWeapon():GetClass() == "wep_ar2orb" then
            util.ScreenShake(owner:GetPos(), 3, 4, 1, 2)
        end
    end) ]]--

    if SERVER then
        timer.Create("orb_fire_" .. owner:EntIndex(), 1.0, 1, function()
            if not IsValid(self) or owner:GetActiveWeapon():GetClass() ~= "plutonic_xar2_orb" then return end

            owner:ViewPunch(Angle(0, 0, math.Rand(5, 10)))
            self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
            owner:SetAnimation(PLAYER_ATTACK1)
            self.Weapon:EmitSound("NPC_CombineBall.Launch")
            self.Weapon:EmitSound("weapons/irifle/irifle_fire2.wav")

            local ent = ents.Create("prop_combine_ball")
            ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 0.5)
            ent:SetOwner(owner)
            ent:SetSaveValue("m_flRadius", 10)
            ent:Activate()
            ent:Spawn()
            ent:SetSaveValue("m_nState", 3)
            ent:GetPhysicsObject():SetVelocity(owner:GetAimVector() * 1150)
            ent:Fire("Explode", nil, 2)
            
            local hasHit = false
            ent:AddCallback("PhysicsCollide", function(ent, data)
                if hasHit then return end
                local collided = data.HitEntity
                if IsValid(collided) and collided:IsPlayer() then
                    hasHit = true
                    ent:Fire("Explode", nil, 0)
                    local targets = ents.FindInSphere(ent:GetPos(), 100)
                    for _, target in ipairs(targets) do
                        if target:IsPlayer() then
                            target:EmitSound("weapons/physcannon/energy_disintegrate5.wav")
                            target:EmitSound("weapons/physcannon/energy_sing_flyby1.wav")
                        end
                    end
                end
            end)

            hook.Add("EntityTakeDamage", "DecreaseCombineBallDamage", function(target, dmginfo)
                if dmginfo:GetInflictor() == ent then
                    dmginfo:ScaleDamage(0.12)
                end
            end)

            self:TakePrimaryAmmo(1)
        end)
    end

    timer.Create("orb_animreset_" .. owner:EntIndex(), 2.05, 1, function()
        if IsValid(self) and owner:GetActiveWeapon():GetClass() == "plutonic_xar2_orb" then
            self:SendWeaponAnim(ACT_VM_IDLE)
        end
    end)
end

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(45, 45, 0)

SWEP.SoundString = "weapons/irifle/irifle_fire2.wav"
SWEP.WorldModelString = "models/weapons/w_iiopnirifle.mdl"
SWEP.ViewModelString = "models/weapons/c_iiopnirifle.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
