AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "Double Barrel Shotgun"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/tfa_ins2/w_izh43_sawnoff.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_ins2/c_izh43_sawnoff.mdl")
SWEP.ViewModelFOV = 56

SWEP.ViewModelOffset = Vector(2.5, 2, -0.5)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false
SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.MuzzleFlashAttachment = "1"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadSound = "weapons/tfa_ins2/doublebarrel/breakopen.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Primary.Sound = Sound("Weapon_DoubleBarrel.Single")
SWEP.Primary.Inside_Sound = Sound("Weapon_DoubleBarrel.Inside")
SWEP.Primary.Recoil = 12 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 11
SWEP.Primary.Cone = 0.08
SWEP.Primary.Delay = RPM(180)
SWEP.Primary.Range = 500

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2

SWEP.CenteredPos = Vector(-9.0, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.UseIronsightsRecoil = false

SWEP.DoEmptyReloadAnim = true

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.1 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.05 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-1.9, -2.462, 1.9)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.25

sound.Add({
	name = "Weapon_DoubleBarrel.Single",
	sound = "weapons/darsu_eft/mr43/mr43_fire_close1.ogg",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE
})

sound.Add({
	name = "Weapon_DoubleBarrel.Inside",
	sound = "weapons/darsu_eft/mr43/mr43_fire_indoor_close1.ogg",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE
})

local copyps = SWEP.Primary.Sound
local copycone = SWEP.Primary.Cone + 0
local copynum = SWEP.Primary.NumShots + 0
local copybdmg = SWEP.Primary.Damage + 0
local copyrecoil = SWEP.Primary.Recoil + 0
--local copypen = SWEP.Primary.PenetrationScale + 0

SWEP.Attachments = {
	incendiary_rounds = {
		Cosmetic = {
			Model = "models/hunter/plates/plate.mdl",
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
			e.IncendiaryRounds = true
            e.Primary.Damage = 5
            e.Primary.NumShots = 11
			e.Primary.Sound = Sound("PLT.DragonsBreath")
		end,
		ModCleanup = function(e)
			e.IncendiaryRounds = false
            e.Primary.Damage = copybdmg
            e.Primary.NumShots = copynum
			e.Primary.Sound = copyps
		end,
		Behaviour = "incendiaryrounds",
	},
	slug_rounds = {
		Cosmetic = {
			Model = "models/hunter/plates/plate.mdl",
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
            e.Primary.Damage = 50
			e.Primary.Cone = 0.01
            e.Primary.NumShots = 1
			e.Primary.PenetrationScale = 1.3
			e.Primary.Recoil = 10
		end,
		ModCleanup = function(e)
            e.Primary.Damage = copydmg
            e.Primary.NumShots = copynum
			e.Primary.Cone = copycone
			e.Primary.PenetrationScale = 0
			e.Primary.Recoil = copyrecoil
		end,
		Behaviour = "slugs",
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
			local offsetVec = Vector(1, -1, 0)
			local offsetAng = Angle(10, 5, 180)
			
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

SWEP.SoundString = "weapons/tfa_ins2/doublebarrel/doublebarrel_fire.wav"
SWEP.SilencedSoundString = "weapons/mow/type97at.wav"
SWEP.WorldModelString = "models/weapons/tfa_ins2/w_izh43_sawnoff.mdl"
SWEP.ViewModelString = "models/weapons/tfa_ins2/c_izh43_sawnoff.mdl"

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end