AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "HK MP5A2"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/w_inss2_mp5a5.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_smg_mp5.mdl")
SWEP.ViewModelFOV = 65
SWEP.ViewModelOffset = Vector(2.5, -2, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/thompsom_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "CUST.MP5.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/p226/p226_fire_close.ogg"}
})

sound.Add({
	name = "CUST.MP5.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/p226/pm_indoor_close1.ogg"}
})

sound.Add({
	name = "CUST.MP5.Silenced",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"weapons/inss/mp5a2/mp5k_suppressed_fp.wav"}
})

SWEP.Primary.Sound = Sound("CUST.MP5.Single")
SWEP.Primary.Inside_Sound = Sound("CUST.MP5.Inside")

SWEP.Primary.Recoil = 1 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.001
SWEP.Primary.Delay = RPM(560)

SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.01
SWEP.Spread.IronsightsMod = 0.1 -- multiply
SWEP.Spread.CrouchMod = 0.1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.2 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.0 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-5.2, -5, 1.675)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15

local oldsound = Sound("CUST.MP5.Single")

SWEP.Attachments = {
	holographic_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/eotech.mdl",
			Bone = "v_weapon.mp5sd_parent",
			Pos = Vector(0,0,5.5),
			Ang = Angle(0, 90, 0),
			Scale = 0.85,
			Skin = 0,
		},
		Reticule = {
			Size = 0.5,
			RotationAngle = 0,
			Pos = Vector(0,-0.025,1),
			Material = Material("hud/holosight/go_eotech.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-5.25, 0, 1.2)
			e.IronsightsAng = Angle(0, -2, 0)
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-5.2, -5, 1.675)
			e.IronsightsAng = Angle(0, 0, 0)
		end,
		Behaviour = "red_dot_sight",
	},
	t1_reflex = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/t1.mdl",
			Bone = "v_weapon.mp5sd_parent",
			Pos = Vector(0,0,5.5),
			Ang = Angle(0, 90, 0),
			Scale = 0.85,
			Skin = 0,
		},
		Reticule = {
			Size = 0.25,
			RotationAngle = 0,
			Pos = Vector(0,-0.032,1.025),
			Material = Material("hud/holosight/go_delta.png"),
			Color = Color(0,255,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-5.3, 0, 1.2)
			e.IronsightsAng = Angle(0, -2, 0)
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-5.2, -5, 1.675)
			e.IronsightsAng = Angle(0, 0, 0)
		end,
		Behaviour = "red_dot_sight",
	},
	att_pistol_silencer = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl",
			Bone = "v_weapon.mp5sd_parent",
			Pos = Vector(0, 26, 3.8),
			Ang = Angle(0, 90, 0),
			Scale = 0.85,
			Skin = 0,
		},
		ModSetup = function(e)
			e.Primary.Sound = Sound("CUST.MP5.Silenced")
		end,
		ModCleanup = function(e)
			e.Primary.Sound = oldsound
		end,
		Behaviour = "silencer",
	},
}

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(4, -2, 0)
			local offsetAng = Angle(0, 0, 180)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(1.1)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

SWEP.SoundString = "weapons/inss/mp5a2/mp5k_fp.wav"
SWEP.SilencedSoundString = "weapons/inss/mp5a2/mp5k_suppressed_fp.wav"
SWEP.WorldModelString = "models/weapons/w_inss2_mp5a5.mdl"
SWEP.ViewModelString = "models/weapons/arccw_go/v_smg_mp5.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end