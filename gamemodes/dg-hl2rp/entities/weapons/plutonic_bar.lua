AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Browning Automatic Rifle"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_dm1918_bar.mdl")
SWEP.ViewModel = Model("models/weapons/v_dm1918_bar.mdl")
SWEP.ViewModelFOV = 65
SWEP.ViewModelOffset = Vector(8, 15, -4)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/syndod/enfield_reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "LS2.BAR.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"weapons/bar/mrk_bar_01.wav"}
})

SWEP.Primary.Sound = Sound("LS2.BAR.Single")
SWEP.Primary.Recoil = 2.8 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 12
SWEP.Primary.PenetrationScale = 1.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.012
SWEP.Primary.Delay = RPM(400)

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.2 -- crouch effect (multiply)
SWEP.Spread.AirMod = 10.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 3.0 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(0.4, 12, -0.6)
SWEP.IronsightsAng = Angle(1, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.2

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

local copyrecoil = SWEP.Primary.Recoil + 0
local copydelay = SWEP.Primary.Delay + 0

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
			e.Primary.Delay = RPM(600)
			e.Primary.Recoil = 8
		end,
		ModCleanup = function(e)
			e.Primary.Delay = copydelay
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "grease_belt"
	}
}


if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(0, 0, 0)
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

SWEP.SoundString = "weapons/bar/mrk_bar_01.wav"
SWEP.WorldModelString = "models/weapons/syndod/w_bar.mdl"
SWEP.ViewModelString = "models/weapons/v_dm1918_bar.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end