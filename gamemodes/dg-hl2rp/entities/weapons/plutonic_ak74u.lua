AddCSLuaFile()

hook.Add("Initialize", "impulseLSAmmoRifle", function()
	game.AddAmmoType({
		name = "Rifle",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE_AND_WHIZ,
		force = 5000,
		minsplash = 10,
		maxsplash = 100
	})
end)

SWEP.Base = "plutonic_base"

SWEP.PrintName = "AK-74u"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.UseHands = true

SWEP.HoldType = "ar2"
SWEP.MuzzleEffect = "muzzleflash_pistol_cleric"
SWEP.MuzzleFlashAttachment = "2"

SWEP.WorldModel = Model("models/weapons/tfa_ins2/akpack/w_aks74u.mdl")
SWEP.ViewModel = Model("models/weapons/c_tdon_eftak.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ReloadSound = "weapons/syndod/gewehr43_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.AK47U.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sr1mp/gyrza_close1.ogg"}
})

sound.Add({
	name = "LS2.AK47U.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/sr1mp/gyrza_indoor_close1.ogg"}
})

SWEP.Primary.Sound = Sound("LS2.AK47U.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.AK47U.Inside")
SWEP.Primary.Recoil = 2.0 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 13
SWEP.Primary.PenetrationScale = 1.6
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.015
SWEP.Primary.Delay = RPM(650)

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 1
SWEP.Spread.IronsightsMod = 0.1 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.7 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.015 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.RecoilAcceleration = 1
SWEP.Spread.VelocityMod = 1.0 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.218, 0, -0.1)
SWEP.IronsightsAng = Angle(2, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.6
SWEP.UseIronsightsRecoil = false

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyISF = copyIronFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
local copyCH = SWEP.IronsightsCrosshair
local copyCone = SWEP.Primary.Cone + 0
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
			e.Primary.ClipSize = 60
		end,
		ModCleanup = function(e)
			e.Primary.ClipSize = copyPrimaryClipSize
			if e:Clip1() > copyPrimaryClipSize then
				e:SetClip1(copyPrimaryClipSize)
			end
		end,
		Behaviour = "extendedmagazine"
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
			e.Primary.Recoil = 1
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = 2
		end,
		Behaviour = "foregrip"
	},
}

sound.Add({
	name = "Weapon_iAK47.Single",
	sound = "impulse/ak47_fire.wav",
	channel = CHAN_WEAPON,
	level = SNDLVL_150dB,
	pitch = {95, 105}
})

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


SWEP.SoundString = "weapons/mw3/ak47shot.wav"
SWEP.WorldModelString = "models/weapons/tfa_ins2/w_aksz.mdl"
SWEP.ViewModelString = "models/weapons/c_tdon_eftak.mdl"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end