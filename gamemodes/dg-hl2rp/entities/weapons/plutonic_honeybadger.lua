AddCSLuaFile()

SWEP.Base = "plutonic_base"

SWEP.PrintName = "AAC Honey Badger"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/private_arsenals/w_honeybadger.mdl")
SWEP.ViewModel = Model("models/weapons/private_arsenals/c_honeybadger.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "weapons/projectmmod_smg1/smg1_reload.wav"
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

sound.Add({
	name = "LS2.HB.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_60dB,
	pitch = {95, 105},
	sound = {"ma85_mw3/silencer/smg_mp5.wav"}
})

SWEP.Primary.Sound = Sound("LS2.HB.Single")

SWEP.Primary.Sound = "ma85_mw3/silencer/smg_mp5.wav"
SWEP.Primary.Recoil = 0.03 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.022
SWEP.Primary.Delay = RPM(900)

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.8 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.1 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-2.8, -2.221, 0.45)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 1

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
			local offsetVec = Vector(3.2, -1, -2)
			local offsetAng = Angle(0, 0, 180)
			
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