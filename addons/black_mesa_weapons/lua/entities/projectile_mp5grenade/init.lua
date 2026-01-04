--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:Fire("kill", "", 7)
	
	self:SetModel("models/weapons/bms_wal/w_mp5grenade.mdl")
	self:SetModelScale(1)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(34)
		phys:SetBuoyancyRatio(10)
		phys:EnableDrag(false)
		phys:EnableGravity(true)
		phys:Wake()
	end

	self.TimeCreated = CurTime()
end

ENT.Radius = 128
ENT.HitSomething = nil
function ENT:Think()
	if self.HitSomething  then
		self:Explode()
	end
end

local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
function WorldVisible(posa, posb) -- a utility function that i take from zs
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util.TraceLine(WorldVisibleTrace).Hit
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owoner = self:GetOwOner()
	if IsValid(owoner) and owoner:IsPlayer() then
		local pos = self:GetPos() + self:GetUp()
		local range = 192
		for _, ent in pairs(ents.FindInSphere(pos, range)) do
			if WorldVisible(pos, ent:NearestPoint(pos))  then
				local nearest = ent:NearestPoint(pos)

				local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_BLAST)
				dmginfo:SetDamage((((range ^ 2) - nearest:DistToSqr(pos)) / (range ^ 2)) * self.ExplDamage)
				dmginfo:SetAttacker(owoner)
				dmginfo:SetInflictor(self)
				ent:TakeDamageInfo(dmginfo)
			end
		end
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect((self:WaterLevel() >= 3) and "WaterSurfaceExplosion" or "Explosion", effectdata)
	end
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	self.Done = true

	self:Fire("kill", "", 4)

	phys:EnableMotion(false)
	self.HitSomething = true
end