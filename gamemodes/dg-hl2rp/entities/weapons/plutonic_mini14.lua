AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Mini-14"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/w_tfa_mni14c.mdl")
SWEP.ViewModel = Model("models/weapons/v_tfa_mni14c.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/projectmmod_smg1/smg1_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")
SWEP.ViewModelOffset = Vector(2, 0, -1)

sound.Add({
	name = "LS2.AR15.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/tx15_fire_outdoor_close.ogg"}
})

sound.Add({
	name = "LS2.AR15.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/tx15_fire_indoor_close.ogg"}
})

sound.Add({
	name = "LS2.AR15.Silenced_Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/adar_fire_indoor_silenced_close.ogg"}
})

sound.Add({
	name = "LS2.AR15.Silenced",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/m4a1/fire_new/adar_fire_outdoor_silenced_close.ogg"}
})

SWEP.Primary.Sound = Sound("LS2.AR15.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.AR15.Inside")

SWEP.Primary.Recoil = 0.6 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 19
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = RPM(280)
SWEP.Primary.Automatic = true
SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-3, -2, -4)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.02
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.1 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-2.11, 0, 0.45)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

local copyCone = SWEP.Primary.Cone
local copyIronFOV = SWEP.IronsightsFOV
local copyIronSens = SWEP.IronsightsSensitivity
local copyIronPos = SWEP.IronsightsPos
local copyCH = SWEP.IronsightsCrosshair 

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
			local fov = .45
			e.IronsightsFOV = fov
			if CLIENT then 
				local copyScopeSens = impulse.GetSetting("scope_sens")
				e.IronsightsSensitivity = copyScopeSens * (fov / 0.8)
			end
			e.IronsightsPos = Vector(-10, -20, -10)
			e.IronsightsCrosshair = true
			e.Primary.Cone = 0.001
		end,
		ModCleanup = function(e)
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.IronsightsPos = copyIronPos

			e.IronsightsCrosshair = copyCH
			e.Primary.Cone = copyCone
		end,
		Behaviour = "magnifier",
	}
}

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(30, 0, 0)

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(17, -1, -4)
			local offsetAng = Angle(195, 0, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(1)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end


SWEP.SoundString = "ma85_mw3/silencer/smg_mp5.wav"
SWEP.WorldModelString = "models/weapons/w_tfa_mni14c.mdl"
SWEP.ViewModelString = "models/weapons/v_tfa_mni14c.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end




