AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "G3A3"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/arccw_go/v_rif_g3.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_rif_g3.mdl")
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/pps43_reload.wav"
SWEP.EmptySound = Sound("Weapon_357.Empty")

sound.Add({
	name = "LS2.G3.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/rsass/rsass_fire_indoor_close.ogg"}
})

sound.Add({
	name = "LS2.G3.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/rsass/rsass_fire_close5.ogg"}
})

SWEP.Primary.Sound = Sound("LS2.G3.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.G3.Inside")
SWEP.Primary.Recoil = 12 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.009
SWEP.Primary.Delay = RPM(240)
SWEP.Primary.PenetrationScale = 1.1

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.001
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.03 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.74, 0, 2)
SWEP.IronsightsAng = Angle(0.2, -0.201, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.LoweredPos = Vector(0, 0, 0)
SWEP.LoweredAng = Angle(0, 15, 0)

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyCH = SWEP.IronsightsCrosshair
local copyDMG = SWEP.Primary.Damage + 0
local copyCone = SWEP.Primary.Cone + 0
local copyrecoil = SWEP.Primary.Recoil + 0

SWEP.Attachments = {
	zoom_optic = {
		Cosmetic = {
			Model = "abv",
			Bone = "none",
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
			e.IronsightsFOV = 0.15
			if CLIENT then 
				impulse.debugPrint("equipped")
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens
			end
			e.IronsightsPos = Vector(-20, -20, -20)
			e.IronsightsCrosshair = true
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.IronsightsPos = copyIronPos

			e.IronsightsCrosshair = copyCH
		end,
		Behaviour = "magnifier",
	},
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
			e.Primary.Recoil = 3
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "foregrip"
	},
	holographic_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/eotech.mdl",
			Bone = "v_weapon.g3sg1_Parent",
			Pos = Vector(0.1, -4.7, -1),
			Ang = Angle(270, 90, 0),
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
			RotationAngle = 0,
			Pos = Vector(0,0,1),
			Material = Material("hud/holosight/go_eotech.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-4.77, 0, 1.85)
			e.IronsightsAng = Angle(0, 0, 0)
			e.IronsightsFOV = 0.7
			e.FOVScoped = 0.7
			e.Primary.Cone = copyCone / 2
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-4.74, 0, 2)
			e.IronsightsAng = Angle(0.2, -0.201, 0)
			e.IronsightsFOV = copyIronFOV
			e.FOVScoped = nil
			e.Primary.Cone = copyCone
		end,
		Behaviour = "holo_sight",
	},
	hunter_sight = {
		Cosmetic = {
			Model = "models/weapons/arccw_go/atts/hunter.mdl",
			Bone = "v_weapon.g3sg1_Parent",
			Pos = Vector(0.1, -4.7, 1),
			Ang = Angle(270, 90, 0),
			Scale = 0.85,
			Skin = 0,
			World = {
				Pos = Vector(11, 1.5, -6),
				Ang = Angle(0, 0, 0),
				Scale = 0.85
			}
		},
		Reticule = {
			Size = 1,
			RotationAngle = 0,
			Pos = Vector(0,0,1.2),
			Material = Material("hud/scopes/hamr_go.png"),
			Color = Color(255,0,0,255),
			NoMask = true,
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-4.78, 0, 1.65)
			e.IronsightsAng = Angle(0, 0, 0)
			e.IronsightsFOV = 0.5
			e.Primary.Cone = 0.0001
			e.FOVScoped = 0.7
		end,
		ModCleanup = function(e)
			e.IronsightsPos = Vector(-4.74, 0, 2)
			e.IronsightsAng = Angle(0.2, -0.201, 0)
			e.IronsightsFOV = copyIronFOV
			e.FOVScoped = nil
			e.Primary.Cone = copyCone
		end,
		Behaviour = "hunter_sight",
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
			local offsetVec = Vector(-14, -5, -8.25)
			local offsetAng = Angle(0, 0, 180)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

SWEP.SoundString = "weapons/deagle/wa2000.wav"
SWEP.WorldModelString = "models/weapons/arccw_go/v_rif_g3.mdl"
SWEP.ViewModelString = "models/weapons/arccw_go/v_rif_g3.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end