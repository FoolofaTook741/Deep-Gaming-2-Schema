AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "CZ-75 Auto"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "pistol"

SWEP.WorldModel = Model("models/weapons/tfa_ins2/w_cz75a.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_ins2/c_cz75a.mdl")
SWEP.ViewModelFOV = 55
SWEP.ViewModelOffset = Vector(5,2,-1)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/p38_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.CZ.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/57/fiveseven_fire_close.ogg"}
})

sound.Add({
	name = "LS2.CZ.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/57/fiveseven_fire_indoor_close.ogg"}
})

sound.Add({
	name = "LS2.CZ.Silenced",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_30dB,
	pitch = {95, 105},
	sound = {"weapons/tfa_ins2/cz75/fp_suppressed.wav"}
})

SWEP.Primary.Sound = Sound("LS2.CZ.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.CZ.Inside")

SWEP.Primary.Recoil = 3.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.018
SWEP.Primary.Delay = RPM(550)

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.UseIronsightsRecoil = false

SWEP.QuickDraw = true

SWEP.Spread = {}
SWEP.Spread.Min = 0.008
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.9 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.025 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-2, 0, -0.1)
SWEP.IronsightsAng = Angle(1, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2

local copyRecoil = SWEP.Primary.Recoil + 0

SWEP.Attachments = {
	att_pistol_silencer = {
        Cosmetic = {
			Model = "models/weapons/arccw_go/atts/supp_large.mdl",
			Bone = "A_Suppressor",
			Pos = Vector(0,0,0),
			Ang = Angle(0, 90, 0),
			Scale = 0.85,
			Skin = 0
			--World = {
			--	Pos = Vector(11, 1.5, -6),
			--	Ang = Angle(0, 180, 90),
			--	Scale = 0.85
			--}
		},
		ModSetup = function(e)
			e.Primary.Sound = Sound("LS2.CZ.Silenced")
			e.Primary.Recoil = 2.75
		end,
		ModCleanup = function(e)
			e.Primary.Sound = Sound("LS2.CZ.Single")
			e.Primary.Recoil = copyRecoil
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
			local offsetVec = Vector(5, -1, -1)
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

SWEP.SoundString = "weapons/tfa_ins2/cz75/fp.wav"
SWEP.SilencedSoundString = "weapons/tfa_ins2/cz75/fp_suppressed.wav"
SWEP.WorldModelString = "models/weapons/tfa_ins2/w_cz75a.mdl"
SWEP.ViewModelString = "models/weapons/tfa_ins2/c_cz75a.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end