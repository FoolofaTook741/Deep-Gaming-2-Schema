AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.LaserPos = Vector(0, 0, 0)
ENT.LaserAng = Angle(0, 0, 0)
ENT.LaserLength = 3.0

function ENT:Initialize()
	self:SetModel("models/weapons/bms_wal/w_tripmine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	local attach = self:GetAttachment(self:LookupAttachment("Beam"))
	self.LaserPos = attach.Pos
	self.LaserAng = attach.Ang
	self.LaserDir = -attach.Ang:Forward() * -1
		
	local tr = util.QuickTrace(attach.Pos, self.LaserDir, self:CachedTraceFilter())
	self.LaserLength = tr.Fraction
	self.PreHitPos = tr.HitPos
	self:EmitSound("grenade_tripmine.WarmUp")
end

local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
function WorldVisible(posa, posb) -- a utility function that i take from zs
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util.TraceLine(WorldVisibleTrace).Hit
end

function ENT:OnTakeDamage( dmginfo )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:Explode()
		self.Activated = true
		self.m_bApplyingDamage = false
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owoner = self.Objectowoner
	if IsValid(owoner) and owoner:IsPlayer() then
		local pos = self:GetPos()
		local range = 192
		local pos = self.LaserPos
		local dir = self.LaserDir
		local angle = math.cos(math.rad(90))
		local startPos = self.LaserPos

		for _, ent in pairs(ents.FindInCone(startPos, dir, range, angle )) do
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
		effectdata:SetAngles(self.LaserAng)
		util.Effect((self:WaterLevel() >= 3) and "WaterSurfaceExplosion" or "Explosion", effectdata)
	end
end

function ENT:ActivationProcess()
	local attach = self:GetAttachment(self:LookupAttachment("Beam"))
	self.LaserPos = attach.Pos
	self.LaserAng = attach.Ang
	self.LaserDir = -attach.Ang:Forward() * -768
		
	local tr = util.QuickTrace(attach.Pos, self.LaserDir, self:CachedTraceFilter())
	self.LaserLength = tr.Fraction

	if not self.Activated then
		self.PreHitPos = tr.HitPos
		self:EmitSound("grenade_tripmine.Activate")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE) 
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	self.Activated = true
end

ENT.NextVisThink = 0
function ENT:Think()
	if self.Exploded then
		self:Remove()
		return
	end
	if not IsValid(self.Objectowoner) then self:Remove() end

	if (self:GetActivationDelay() <= CurTime()) and not self.Activated then
		self:ActivationProcess()
	end

	if self.Activated and (self.NextVisThink <= CurTime()) then
		self:ActivationProcess()
		self.NextVisThink = CurTime() + 0.1
	end

	if not self.Exploded and self.Activated then
		local tr = util.QuickTrace(self.LaserPos, self.LaserDir, self:CachedTraceFilter())
		if not (self.PreHitPos == tr.HitPos) then
			self:Explode()
		end
	end

	self:NextThink(CurTime())
	return true
end