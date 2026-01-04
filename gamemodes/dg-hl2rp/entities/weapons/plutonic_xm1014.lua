AddCSLuaFile()

SWEP.Base = "plutonic_base_shotgun"

SWEP.PrintName = "XM1014"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ItemClass = "wep_m500"

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/arccw_go/v_shot_m1014.mdl")
SWEP.ViewModel = Model("models/weapons/arccw_go/v_shot_m1014.mdl")
SWEP.ViewModelFOV = 55

SWEP.ViewModelOffset = Vector(2.5, 3, -1)
SWEP.ViewModelOffsetAng = Angle(0, 0, 0)

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.BarrelLength = 40
SWEP.CSMuzzleFlashes = false

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.ReloadShellSound = "weapons/projectmmod_shotgun/shotgun_reload" .. math.random(1,4) .. ".wav"
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

sound.Add({
	name = "LS2.XM.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {95, 105},
	sound = {"arccw_go/xm1014/xm1014-1.wav"}
})

SWEP.Primary.Sound = Sound("LS2.XM.Single")
SWEP.Primary.Recoil = 8.5 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 9
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = RPM(160)

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.08
SWEP.Spread.Max = 0.23
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 0.5 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.45 -- movement speed effect on spread (additonal)

SWEP.SwayLevel = 0.01
SWEP.SwayIdle = 0.01
SWEP.SwayRightMultiplier = 0.01
SWEP.SwayUpMultiplier = 0.01

SWEP.IronsightsPos = Vector(-4.295, 1, 2.8)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.63
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 15

SWEP.IncendiaryRounds = false

SWEP.CenteredPos = Vector(-9.0, -1, -2.55)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.MuzzleFlashAttachment = "1"

SWEP.MuzzleFlashSize = 256
SWEP.MuzzleFlashColor = Color(150, 150, 150)
SWEP.MuzzleFlashShadow = true


SWEP.CannotChamber = true
SWEP.VLowered = false
SWEP.VTime = CurTime()
SWEP.DrawTime = 0
SWEP.HasLoweredActivity = false

SWEP.Shotgun = true

function SWEP:CustomShootEffects()
	self.VTime = CurTime() + 0.1
	self.VLowered = false
end

SWEP.IronsightsAllowAnim = {
    [ACT_VM_PRIMARYATTACK] = true
}
SWEP.HasPlayedIntro = false

--[[function SWEP:CustomShootEffects()
    timer.Simple(0,function()
        if self:GetIronsights() then
			
			self:PlayAnim(ACT_VM_PRIMARYATTACK)
		end
	end)
end]]

local copyps = SWEP.Primary.Sound
local copycone = SWEP.Primary.Cone + 0
local copynum = SWEP.Primary.NumShots + 0
local copybdmg = SWEP.Primary.Damage + 0
local copyrecoil = SWEP.Primary.Recoil + 0

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
            e.Primary.Damage = 4
            e.Primary.NumShots = 7
			e.Primary.Sound = Sound("PLT.DragonsBreath")
		end,
		ModCleanup = function(e)
			e.IncendiaryRounds = false
            e.Primary.Damage = copybdmg
            e.Primary.NumShots = copynum
			e.Primary.Sound = copyps
		end,
		Behaviour = "incendiaryrounds",
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
			local offsetVec = Vector(-10, -5, -9)
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

SWEP.SoundString = "arccw_go/xm1014/xm1014-1.wav"
SWEP.SilencedSoundString = "weapons/mow/type97at.wav"
SWEP.WorldModelString = "models/weapons/arccw_go/v_shot_m1014.mdl"
SWEP.ViewModelString = "models/weapons/arccw_go/v_shot_m1014.mdl"

function SWEP:QueueIdle()
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end