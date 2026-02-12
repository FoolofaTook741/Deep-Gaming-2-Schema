AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Overwatch Marksman Rifle"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/w_models/w_combine_sniper.mdl")
SWEP.ViewModel = Model("models/weapons/c_overwatch_sr2_marksmen_rifle.mdl")
SWEP.ViewModelOffset = Vector(2,0,2)
SWEP.ViewModelFOV = 45

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/osr2mr/reload.wav"
SWEP.EmptySound = "weapons/clipempty_pistol.wav"

sound.Add({
	name = "CUST.OMR.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"arccw_go/g3sg1/g3sg1-1.wav"}
})

SWEP.Primary.Sound = Sound("CUST.OMR.Single")

SWEP.Primary.Recoil = 5-- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 29
SWEP.Primary.PenetrationScale = 1.25
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.0002
SWEP.Primary.Delay = RPM(300)

SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.UseIronsightsRecoil = false

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.0004
SWEP.Spread.IronsightsMod = 0.3 -- multiply
SWEP.Spread.CrouchMod = 0.4 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.5 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.09 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1, 0, 2)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.2
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 0.25

SWEP.LoweredPos = Vector(0, -7, -11)
SWEP.LoweredAng = Angle(20, 45, 0)

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
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
			local offsetVec = Vector(15, -2, -2)
			local offsetAng = Angle(0, 90, 180)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(1.2)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

SWEP.SoundString = "arccw_go/g3sg1/g3sg1-1.wav"
SWEP.WorldModelString = "models/weapons/w_models/w_combine_sniper.mdl"
SWEP.ViewModelString = "models/weapons/c_overwatch_sr2_marksmen_rifle.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end