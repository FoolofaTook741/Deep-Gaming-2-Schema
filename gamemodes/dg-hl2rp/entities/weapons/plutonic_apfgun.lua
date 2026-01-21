
AddCSLuaFile()

SWEP.Base = "plutonic_base"
local BaseClass = baseclass.Get("plutonic_base")


SWEP.PrintName = "O.S.I.A.E.R."
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/suppressor/w_suppressor.mdl")
SWEP.ViewModel = Model("models/weapons/c_suppressor.mdl")
SWEP.ViewModelFOV = 68

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.APF.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"suppressor/suppressor_fire1.wav"}
})

SWEP.Primary.Sound = Sound("LS2.APF.Single")

SWEP.Primary.Recoil = 0.9 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 2
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(900)
SWEP.Primary.Tracer = "AR2Tracer"
SWEP.UseIronsightsRecoil = false
SWEP.SpeedReduction = 170

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 0.35 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.25 -- movement speed effect on spread (additonal)

SWEP.NoIronsights = false

SWEP.IronsightsPos = Vector(-1.81, -2.613, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.LoweredPos = Vector(1.406, -1.609, 1.809)
SWEP.LoweredAng = Angle(-9.849, 9.848, 0)
SWEP.IsAlwaysRaised = false

SWEP.MuzzleEffect = "muzzleflash_minimi"
SWEP.MuzzleFlashAttachment = 2

sound.Add({
	name = "Weapon_Swing",
	sound = "weapons/universal/uni_weapon_draw.wav",
	channel = CHAN_AUTO,
	level = SNDLVL_GUNFIRE
})

sound.Add({
	name = "Magazine.Out",
	sound = "weapons/tfa_mmod/ar2/ar2_magout.wav"
})

-- weapons/700n-close.wav

sound.Add({
	name = "Magazine.In",
	sound = "weapons/tfa_mmod/ar2/ar2_magin.wav"
})

--weapons/700n-eject.wav

sound.Add({
	name = "Weapon_Swing2",
	sound = "weapons/tfa_hl2r/uni/uni_weapon_draw_01.wav"
})

SWEP.IsRevving         = false
SWEP.CanFireAfterRev   = false
SWEP.RevStartTime      = 0
SWEP.RevUpDuration     = 1.7
SWEP.RevDownDuration   = 0.5
SWEP.SpinUpSound       = "suppressor/wpn_combine_mg_wind_up_01.wav"
SWEP.SpinDownSound     = "suppressor/wpn_combine_mg_wind_down_01.wav"
SWEP.LoopFireSound     = "suppressor/suppressor_fire_loop.wav"

function SWEP:Think()
	BaseClass.Think(self)

    local owner     = self.Owner
    local holding   = owner:KeyDown(IN_ATTACK)
    local canShoot  = holding and self:CanPrimaryAttack()

    if canShoot and not self.IsRevving then
        self.IsRevving       = true
        self.RevStartTime    = CurTime()
        self:EmitSound(self.SpinUpSound)
    end

    if self.IsRevving and not self.CanFireAfterRev then
        if CurTime() >= self.RevStartTime + self.RevUpDuration then
            self.CanFireAfterRev = true
        end
    end

    if not holding and self.IsRevving then
        self.IsRevving         = false
        self.CanFireAfterRev   = false
        self:EmitSound(self.SpinDownSound)
        self:StopSound(self.LoopFireSound)
    end

    if owner:KeyReleased(IN_ATTACK) then
        self:StopSound(self.LoopFireSound)
    end
end

function SWEP:PrimaryAttack()
    if not self.IsRevving or not self.CanFireAfterRev then return end

    if not self.PlayingLoop then
        self:EmitSound(self.LoopFireSound)
        self.PlayingLoop = true
    end

    BaseClass.PrimaryAttack(self)
end


function SWEP:SecondaryAttack()
end


SWEP.Attachments = {}

SWEP.SoundString = "suppressor/suppressor_fire1.wav"
SWEP.WorldModelString = "models/weapons/suppressor/w_suppressor.mdl"
SWEP.ViewModelString = "models/weapons/c_suppressor.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
