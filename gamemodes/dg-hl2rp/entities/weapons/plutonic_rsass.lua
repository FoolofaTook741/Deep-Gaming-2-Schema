AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "R11 RSASS-S"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.ViewModel = Model("models/RSASummit/v_snip_sg550.mdl")
SWEP.WorldModel = Model("models/RSASummit/w_snip_sg550.mdl")
SWEP.ViewModelOffset = Vector(-2,8,0)
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 3, -0.25)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.CenteredPos = Vector(4.5, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"
SWEP.MuzzleFlashAttachment = "0"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

sound.Add({
	name = "LS2.RSASS.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/rsass/rsass_close_silenced1.ogg"}
})

sound.Add({
	name = "LS2.RSASS.Inside",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"weapons/darsu_eft/rsass/rsass_indoor_close_silenced1.ogg"}
})


SWEP.Primary.Sound = Sound("LS2.RSASS.Single")
SWEP.Primary.Inside_Sound = Sound("LS2.RSASS.Inside")

SWEP.ReloadSound = "weapons/projectmmod_shotgun/shotgun_reload" .. math.random(1,4) .. ".wav"
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

SWEP.Primary.Recoil = 3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 30
SWEP.Primary.PenetrationScale = 1.3
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.0005
SWEP.Primary.Delay = RPM(330)

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
SWEP.Spread.IronsightsMod = 0.1 -- multiply
SWEP.Spread.CrouchMod = 0.1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.7 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 2.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(0, 0, 0)
SWEP.IronsightsAng = Angle(0.2, -0.201, 0)
SWEP.IronsightsFOV = 0.2
SWEP.IronsightsSensitivity = 0.25
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.LoweredPos = Vector(0, 0, 0)
SWEP.LoweredAng = Angle(-10, -20, 0)

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
			e.Primary.Recoil = 4
		end,
		ModCleanup = function(e)
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "foregrip"
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
			local offsetVec = Vector(0, 0, 0)
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
SWEP.SoundString = "rsasummit/sg550/sg550-1.wav"
SWEP.WorldModelString = Model("models/RSASummit/w_snip_sg550.mdl")
SWEP.ViewModelString = Model("models/RSASummit/v_snip_sg550.mdl")

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end