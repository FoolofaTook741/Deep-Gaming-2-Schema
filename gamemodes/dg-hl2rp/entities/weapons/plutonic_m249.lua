AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "M249"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/arccw_go/v_mach_m249para.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_mach_m249para.mdl")
SWEP.ViewModelFOV = 65
SWEP.ViewModelOffset = Vector(0, -4, -0.4)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/30cal_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.M249.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/mk18/mk18_fire_close.wav"}
})

sound.Add({
	name = "LS2.M249.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/mk18/mk18_fire_indoor_close.wav"}
})

SWEP.Primary.Sound = Sound("LS2.M249.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.M249.Inside")


SWEP.Primary.Recoil = 2.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = RPM(650)
SWEP.SpeedReduction = 170
SWEP.Primary.PenetrationScale = 2

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.UseIronsightsRecoil = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(-3, -2, -6)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.25 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 16.25 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-7.9, 0, 1.5)
SWEP.IronsightsAng = Angle(0, 0, -0.4)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

local copyDelay = SWEP.Primary.Delay + 0
local copyRecoil = SWEP.Primary.Recoil + 0

SWEP.Attachments = {
	greased_belt = {
		Cosmetic = {
			Model = "models/props_lab/huladoll.mdl",
			Bone = "v_weapon.m249",
			Pos = Vector(-0.721, -3.537, 3.635),
			Ang = Angle(-29.611, -5.844, -94.676),
			Scale = 0.379,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Delay = RPM(700)
			e.Primary.Recoil = 11
		end,
		ModCleanup = function(e)
			e.Primary.Delay = copyDelay
			e.Primary.Recoil = copyRecoil
		end,
		Behaviour = "grease_belt"
	}
}

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(10, 20, 0)

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(-18, -8, -8.4)
			local offsetAng = Angle(0, 0, 180)
			
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


SWEP.SoundString = "weapons/syndod/30cal_fire.wav"
SWEP.WorldModelString = "models/weapons/arccw/w_50cal_12.mdl"
SWEP.ViewModelString = "models/weapons/arccw/c_50cal_10.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
	self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
