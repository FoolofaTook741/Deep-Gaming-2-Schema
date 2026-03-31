AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M4A1"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/arccw/vmwm_xm4_bocw.mdl")
SWEP.ViewModel = Model("models/weapons/arccw/v_xm4_bocw.mdl")
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 3, -0.25)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_m14"
SWEP.MuzzleFlashAttachment = "1"



SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

sound.Add({
	name = "LS2.M4A1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/adar_fire_outdoor_close.ogg"}
})

sound.Add({
	name = "LS2.M4A1.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/adar_fire_indoor_close.ogg"}
})

sound.Add({
	name = "LS2.M4A1.Silenced",
	channel = CHAN_WEAPON, 
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {85, 125},
	sound = {"weapons/m27 iar/m27-sil.wav"}
})

SWEP.Primary.Sound = Sound("LS2.M4A1.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.M4A1.Inside")

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

SWEP.Primary.Recoil = 1.4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 11
SWEP.Primary.PenetrationScale = 1.2
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.0019
SWEP.Primary.Delay = RPM(530)

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-4, 4, -5)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spread = {}
SWEP.Spread.Min = 0.0019
SWEP.Spread.Max = 0.32
SWEP.Spread.IronsightsMod = 0.8 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.7 -- movement speed effect on spread (additonal)

SWEP.UseIronsightsRecoil = false

SWEP.IronsightsPos = Vector(-3.3, 0, 0.65)
SWEP.IronsightsAng = Angle(0, 1.5, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.25

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(30, 0, 0)

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyCH = SWEP.IronsightsCrosshair
local copyDMG = SWEP.Primary.Damage + 0
local copyRecoil = SWEP.Primary.Recoil + 0
local copyPrimaryClipSize = SWEP.Primary.ClipSize + 0

SWEP.Attachments = {
	fortyrndmag = {
		Cosmetic = {
			Model = "sheem",
			Bone = "meeman",
			Pos = Vector(5.099, -4, -0.9),
			Ang = Angle(0, 77.5, 0),
			Scale = 0.85,
			Skin = 0
			--World = {
			--	Pos = Vector(11, 1.5, -6),
			--	Ang = Angle(0, 180, 90),
			--	Scale = 0.85
			--}
		},
		ModSetup = function(e)
			e.Primary.ClipSize = 45
		end,
		ModCleanup = function(e)
			e.Primary.ClipSize = copyPrimaryClipSize
			if e:Clip1() > copyPrimaryClipSize then
				e:SetClip1(copyPrimaryClipSize)
			end
		end,
		Behaviour = "extendedmagazine"
	},
	--[[ 
	rifle_foregrip = {
		Cosmetic = {
			Model = "sheem",
			Bone = "meeman",
			Pos = Vector(5.099, -4, -0.9),
			Ang = Angle(0, 77.5, 0),
			Scale = 0.85,
			Skin = 0
			--World = {
			--	Pos = Vector(11, 1.5, -6),
			--	Ang = Angle(0, 180, 90),
			--	Scale = 0.85
			--}
		},
		ModSetup = function(e)
			e.Primary.Recoil = 0.3
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyRecoil
		end,
		Behaviour = "foregrip"
	}, ]]--
	holographic_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/eotech.mdl",
			Bone = "tag_bolt_animate",
			Pos = Vector(0.5, -0.8, 0.7),
			Ang = Angle(0, 0, -45),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		Reticule = {
			Size = 0.5,
			RotationAngle = 180,
			Pos = Vector(0,-0.025,1),
			Material = Material("hud/holosight/go_eotech.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-2.05, -2, 4.75)
			e.IronsightsAng = Angle(0, 0, 45)
			e.IronSightsFOV = 0.5
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(2.5, 3, -0.25)
			e.IronsightsAng = Angle(0, 1.5, 0)
			e.IronsightsFov = copyISF
		end,
		Behaviour = "holo_sight",
	},
	t1_reflex = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/t1.mdl",
			Bone = "tag_bolt_animate",
			Pos = Vector(0.5, -0.8, 0.7),
			Ang = Angle(0, 0, -45),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		Reticule = {
			Size = 0.25,
			RotationAngle = 180,
			Pos = Vector(0,-0.032,1.025),
			Material = Material("hud/holosight/go_delta.png"),
			Color = Color(0,255,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-2.05, -2, 4.75)
			e.IronsightsAng = Angle(0, 0, 45)
			e.IronSightsFOV = 0.5
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(2.5, 3, -0.25)
			e.IronsightsAng = Angle(0, 0, 0)
			e.IronsightsFov = copyISF
		end,
		Behaviour = "reflex_sight",
	},
	rifle_suppressor = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_suppressor_ins.mdl",
			Bone = "tag_barrel",
			Pos = Vector(1.4, 0, 0),
			Ang = Angle(0, 0, -45),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		ModSetup = function(e)
			e.Primary.Sound = Sound("LS2.M4A1.Silenced")
		end,
		ModCleanup = function(e)
			e.Primary.Sound = Sound("LS2.M4A1.Single")
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
			local offsetVec = Vector(-7, -4, -7)
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

SWEP.SilencedSoundString = "weapons/m27 iar/m27-sil.wav"
SWEP.SoundString = "weapons/darsu_eft/stm9/stm9_fire_outdoor_close.ogg"
SWEP.WorldModelString = "models/weapons/arccw/vmwm_xm4_bocw.mdl"
SWEP.ViewModelString = "models/weapons/arccw/v_xm4_bocw.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end