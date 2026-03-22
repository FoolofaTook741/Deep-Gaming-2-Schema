AddCSLuaFile()

sound.Add({
	name = "Weapon_M870.Shoot",
	sound = {")weapons/remington_870/870_shoot_1.wav",")weapons/remington_870/870_shoot_2.wav",")weapons/remington_870/870_shoot_3.wav"},
	level = SNDLVL_150dB,
    channel = CHAN_WEAPON,
    pitch = {95, 105}
})

sound.Add({
	name = "TFA_INS2.Remington_870.Boltback",
	sound = {"weapons/remington_870/870_pumpback.wav"},
	level = 60,
	channel = CHAN_AUTO,
	pitch = 100
})

sound.Add({
	name = "TFA_INS2.Remington_870.Boltrelease",
	sound = {"weapons/remington_870/870_pumpforward.wav"},
	level = 60,
	channel = CHAN_AUTO,
	pitch = 100
})

sound.Add({
	name = "TFA_INS2.LeanIn",
	sound = "weapons/remington_870/870_draw.wav",
	level = 60,
	channel = CHAN_AUTO,
	pitch = {95,105}
})

-- TFA_INS2.Remington_870.ShellInsertSingle

sound.Add({
	name = "TFA_INS2.Remington_870.ShellInsert",
	sound = {"weapons/remington_870/870_insertshell_1.wav","weapons/remington_870/870_insertshell_2.wav","weapons/remington_870/870_insertshell_3.wav"},
	level = 60,
	channel = CHAN_AUTO,
	pitch = {90,110}
})

sound.Add({
	name = "TFA_INS2.Remington_870.ShellInsertSingle",
	sound = {"weapons/remington_870/870_shell_in_1.wav","weapons/remington_870/870_shell_in_2.wav","weapons/remington_870/870_shell_in_3.wav"},
	level = 60,
	channel = CHAN_AUTO,
	pitch = {90,110}
})

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "Remington M870"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"
SWEP.IronsightsHoldType = "ar2"
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_m870_inss.mdl")
SWEP.ViewModel = Model("models/weapons/smc/r870/c_remington_m870.mdl")
SWEP.ViewModelFOV = 74
SWEP.ViewModelOffset = nil
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.BarrelLength = 9.4

SWEP.CSMuzzleFlashes = false
SWEP.ReloadShellSound = Sound("")
SWEP.ReloadSound = Sound("")
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

SWEP.Primary.Sound = Sound(")weapons/remington_870/870_shoot_1.wav",")weapons/remington_870/870_shoot_2.wav",")weapons/remington_870/870_shoot_3.wav")
SWEP.Primary.Recoil = 6.3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8.5
SWEP.Primary.NumShots = 7
SWEP.Primary.Cone = 0.095
SWEP.Primary.Delay = Plutonic.FireRate.RPM(60)

SWEP.Primary.StartFalloff = 100
SWEP.Primary.EndFalloff = 950

SWEP.Primary.Shell = "ShotgunShellEject"
SWEP.Primary.ShellScale =1
SWEP.Primary.ShellAttachment = 3
SWEP.Primary.RecoilUp = 4
SWEP.Primary.RecoilDown = 1
SWEP.Primary.RecoilSide = 2.56
SWEP.SwayLevel = 2
SWEP.SwayIdle = 0.5
SWEP.SwayBob = 2.8
SWEP.SwayRightMultiplier = 1.5

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.CannotChamber = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Spread = {}
SWEP.Spread.Min = 0.01
SWEP.Spread.Max = 4
SWEP.DoEmptyReloadAnim = true
SWEP.Spread.IronsightsMod = 0.98 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.5 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.3 -- movement speed effect on spread (additonal)
SWEP.LoweredPos = Vector(4.119, -1.221, -1.24)
SWEP.LoweredAng = Angle(5.7, 29.7, -1.9)
SWEP.IronsightsPos = Vector(-2.401, -1.422, 1.399)
SWEP.IronsightsAng = Angle(0.6, 0, 0)
SWEP.IronsightsFOV =1
SWEP.IronsightsSensitivity = 0.75
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.IronsightsRocking = 24
SWEP.BlowbackPos         = Vector(0, -14, -2.22) -- Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackAngle          = Angle(5.333, 0, 0)
SWEP.CanBreachDoors = true
SWEP.CustomEvents = {
    [ACT_SHOTGUN_RELOAD_START] = ACT_SHOTGUN_RELOAD_START
}

SWEP.Reverb = {}
SWEP.Reverb.Primary = {}

SWEP.Reverb.Primary.IndoorEnabled = false
SWEP.Reverb.Primary.Indoor = Sound("weapons/remington_870/870_shoot_1.wav")
SWEP.Reverb.Primary.IndoorRange = 10000

SWEP.Reverb.Primary.OutdoorEnabled = false
SWEP.Reverb.Primary.Outdoor = Sound("weapons/remington_870/870_shoot_1.wav")
SWEP.Reverb.Primary.OutdoorRange = 16000
SWEP.CenteredPos = Vector(-2.031,1.22,  -2.58)
SWEP.CenteredAng = Angle(2.92, 1.509, -23.216)
SWEP.MuzzleEffect = "muzzleflash_shotgun"
local mat = Material("models/weapons/tfa_ins2/optics/eotech_reticule")
function SWEP:ExtraViewModelDrawn()
	if SERVER then return end

	if not IsValid(self.AttachedCosmetic) then
		return
	end

	local a = self.AttachedCosmetic
	--cam.Start2D()
	local ang = a:GetAngles() + Angle(0,0,0)
	ang:RotateAroundAxis(a:GetAngles():Right(), 90)
	cam.Start3D2D(((a:GetPos())+a:GetAngles():Forward()) + a:GetAngles():Up(), ang, 0.0025)
	--draw.RoundedBox(0, 0, 0, 256, 256, color_white)
		surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(-256, -256, 512, 512)
		cam.End3D2D()
	--cam.End2D()
		
	
	draw.NoTexture()
	


	if IsValid(self.AttachedCosmetic) then
		local a = self.AttachedCosmetic
		a:SetSubMaterial(1, "")
		a:SetSubMaterial(2, "")
	end
end

function SWEP:Deploy()
	self:QueueIdle()
end

function SWEP:CustomShootEffects()
    timer.Simple(0,function()
        timer.Simple(0.5,function()
			if IsValid(self) then
            	self:PlayAnim(ACT_VM_PULLBACK)
            	self:QueueIdle()
			end
        end)
    end)
end
SWEP.DoEmptyReloadAnim = true

SWEP.Attachments = {
	not_a_hunting_scope = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",
			Bone = "A_Optic",
			Pos = Vector(0, -0.5, 0),
			Ang = Angle(90, 0, 90),
			Scale = 0.85,
			Skin = 0
			--[[World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 180, 90),
				Scale = 0
			}]]--
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-2.401, -0.422, 0.7)
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-2.401, -0.422, 1.399)
		end,
		Behaviour = "dumy",
		NeedsHDR = true,
		ScopeTexture = Material("ph_scope/ph_scope_lens3")
	}
}
--[[function SWEP:Reload()
	if not self:CanReload() then return end

	if self:Clip1() == 0 then
        self:PlayAnim( ACT_VM_RELOAD_EMPTY )
        self:SetClip1( self:Clip1() + 1 )
	    self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )
    else
        self:PlayAnim( ACT_SHOTGUN_RELOAD_START )
    end
    
	self.Owner:DoReloadEvent()
	self:QueueIdle()


	self:SetReloading( true )
	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )

	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end

	hook.Run("LongswordWeaponReload", self.Owner, self)
end]]