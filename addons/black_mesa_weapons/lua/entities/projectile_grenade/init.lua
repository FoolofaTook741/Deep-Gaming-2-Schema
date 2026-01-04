AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/bms_wal/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--local mins, maxs = Vector(-5.5, -7.5, 1), Vector(5.5, 7.5, 6)
	--self:PhysicsInitBox(mins, maxs)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	

	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(6)
		phys:SetMaterial("metal")
	end
end

function ENT:OnTakeDamage( dmginfo )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:Explode()
		self.Activated = true
		self.m_bApplyingDamage = false
	end
end

function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/metal/metal_grenade_impact_hard"..math.random(3)..".wav")
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

	local owoner = self.Objectowoner
	if IsValid(owoner) and owoner:IsPlayer() then
		local pos = self:GetPos() + self:GetUp() * 6
		local range = 192
		for _, ent in pairs(ents.FindInSphere(pos, range)) do
			if WorldVisible(pos, ent:NearestPoint(pos))  then
				local nearest = ent:NearestPoint(pos)

				local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_BLAST)
				dmginfo:SetDamage((((range ^ 2) - nearest:DistToSqr(pos)) / (range ^ 2)) * self.ExplDamage)
				dmginfo:SetAttacker(owoner)
				dmginfo:SetInflictor(self)
				dmginfo:IsExplosionDamage(true)
				ent:TakeDamageInfo(dmginfo)
			end
		end

		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect((self:WaterLevel() >= 3) and "WaterSurfaceExplosion" or "Explosion", effectdata)
	end
end

ENT.NextVisThink = 0
function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end

	if not IsValid(self.Objectowoner) then self:Remove() end

	if (self:GetActivationDelay() <= CurTime()) and not self.Exploded then
		self:Explode()
	end

	self:NextThink(CurTime())
	return true
end