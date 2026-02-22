AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "FN SCAR-H"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/arccw_go/v_rif_scar.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_rif_scar.mdl")
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(-7.3, -1, -2)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

sound.Add({
	name = "LS2.SCAR.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/acr/acr.wav"}
})

SWEP.Primary.Sound = Sound("LS2.SCAR.Single")

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

SWEP.Primary.Recoil = 2.15 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 15
SWEP.Primary.PenetrationScale = 1.55
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.001
SWEP.Primary.Delay = RPM(420)

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.005
SWEP.Spread.Max = 0.15
SWEP.Spread.IronsightsMod = 0.5 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.5 -- how does if the player is in the air effect spread (multiply)
--SWEP.Spread.RecoilMod = 0.09 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.UseIronsightsRecoil = false

SWEP.IronsightsPos = Vector(-5.04, 0, 0.8)
SWEP.IronsightsAng = Angle(-0.5, -1, 0.7)
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
SWEP.Attachments = {
}

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(-12, -7, -8.5)
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

SWEP.SilencedSoundString = "weapons/m27 iar/m27-sil.wav"
SWEP.SoundString = "weapons/darsu_eft/stm9/stm9_fire_outdoor_close.ogg"
SWEP.WorldModelString = "models/weapons/arccw/vmwm_xm4_bocw.mdl"
SWEP.ViewModelString = "models/weapons/arccw/v_xm4_bocw.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
