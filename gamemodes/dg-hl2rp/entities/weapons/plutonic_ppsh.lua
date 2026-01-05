AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "PPSh-41"
SWEP.Category = "Deep Gaming [Plutonic]" 
SWEP.ViewModelOffset = Vector(10, 10, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/w_nik_ppsh1.mdl")
SWEP.ViewModel = Model("models/weapons/v_nik_ppsh1.mdl")
SWEP.ViewModelFOV = 35

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_smg_bizon"
SWEP.MuzzleFlashAttachment = "0"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/ppsh_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "CUST.PPSH.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/pm/pb_close1.ogg"}
})

sound.Add({
	name = "CUST.PPSH.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/pm/pb_indoor_close1.ogg"}
})

SWEP.Primary.Sound = Sound("CUST.PPSH.Single")
SWEP.Primary.Inside_Sound = Sound("CUST.PPSH.Inside")

SWEP.Primary.Recoil = 3.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 4
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.005
SWEP.Primary.Delay = RPM(1900)

SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 71
SWEP.Primary.DefaultClip = 71

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.01
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.7 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.12 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(4.575, -4, 1.92)
SWEP.IronsightsAng = Angle(0, -0.25, 0)
SWEP.IronsightsFOV = 1
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.4

SWEP.SoundString = "weapons/shpaginik/ppshsingle1.wav"
SWEP.WorldModelString = "models/weapons/w_nik_ppsh1.mdl"
SWEP.ViewModelString = "models/weapons/v_nik_ppsh1.mdl"

SWEP.Attachments = {}

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    if IsValid(owner) then
        local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if bone then
            local bp, ba = owner:GetBonePosition(bone)
            
            -- tweak these 'offset' and 'rot' until it sits in the hand:
            local offset = Vector(1, 0, -3)
            local rot    = Angle(10, 0, 180)
            
            bp = bp
               + ba:Forward() * offset.x
               + ba:Right()   * offset.y
               + ba:Up()      * offset.z

            ba:RotateAroundAxis(ba:Right(),   rot.p)
            ba:RotateAroundAxis(ba:Up(),      rot.y)
            ba:RotateAroundAxis(ba:Forward(), rot.r)

            self:SetRenderOrigin(bp)
            self:SetRenderAngles(ba)
            self:DrawModel()
            return
        end
    end

    -- fallback
    self:DrawModel()
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end