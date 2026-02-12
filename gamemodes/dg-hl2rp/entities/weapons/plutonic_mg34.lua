AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Rheinmetall MG-42"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/doi/w_mg42.mdl")
SWEP.ViewModel = Model("models/weapons/doi/v_mg42.mdl")
SWEP.ViewModelFOV = 65
SWEP.ViewModelOffset = Vector(0, -1, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)
SWEP.UseHands = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/mg42_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "CUST.MG34.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	sound = {"weapons/darsu_eft/axmc/aiax_outdoor_close.ogg"}
})

sound.Add({
	name = "CUST.MG34.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	sound = {"weapons/darsu_eft/axmc/aiax_indoor_close.ogg"}
})

SWEP.Primary.Sound = Sound("CUST.MG34.Single")
SWEP.Primary.Inside_Sound = Sound("CUST.MG34.Inside")

SWEP.Primary.Recoil = 1.3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 10.4
SWEP.Primary.NumShots = 1
SWEP.Primary.PenetrationScale = 1.5
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(900)
SWEP.SpeedReduction = 150

SWEP.UseIronsightsRecoil = false

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.CenteredPos = Vector(0, -2, -4)
SWEP.CenteredAng = Angle(3,3,0)

SWEP.Spread = {}
SWEP.Spread.Min = 0.02
SWEP.Spread.Max = 0.05
SWEP.Spread.IronsightsMod = 0.02 -- multiply
SWEP.Spread.CrouchMod = 0.02 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 1 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 6.25 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-2.35, 0, 1.0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(20, 0, 0)

SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashColor = Color(150, 150, 150)
SWEP.MuzzleFlashShadow = true

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(12.7, -1, 5)
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

SWEP.SoundString = "weapons/syndod/mg34_fire.wav"
SWEP.WorldModelString = "models/weapons/doi/w_mg42.mdl"
SWEP.ViewModelString = "models/weapons/doi/v_mg42.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end