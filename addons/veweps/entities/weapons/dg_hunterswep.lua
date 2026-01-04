AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Hunter SWEP"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = true
end

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
SWEP.WorldModel	= ""

SWEP.ViewModelFOV = 0
SWEP.ViewModelFlip = false
SWEP.HoldType = "normal"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.25

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.IsAlwaysRaised = true

SWEP.UseHands = false

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()

	local ang = (self:GetHitpos(ply) - pos):GetNormalized():Angle()
    local pos = self:GetOwner():GetForward()

	local ent = ents.Create("hunter_flechette")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:SetVelocity(ang:Forward() * 2000)
	ent:SetOwner(self)

	local effectdata = EffectData()
	effectdata:SetEntity(self)

	ParticleEffect("hunter_muzzle_flash", pos, ang)
	util.Effect("HunterMuzzleFlash", effectdata)

	self:EmitSound("NPC_Hunter.FlechetteShoot")
end