--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:Fire("kill", "", 16)
	
	self:SetModel("models/weapons/bms_wal/w_rpg_projectile.mdl")
	self:SetModelScale(1)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	--self:SetTrigger(true)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(75)
		phys:SetBuoyancyRatio(0)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		--phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:Wake()
	end
	self:EmitSound("weapon_rpg.TrailLoop")
	self.TimeCreated = CurTime()
end

local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
function WorldVisible(posa, posb) -- a utility function that i take from zs
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util.TraceLine(WorldVisibleTrace).Hit
end

ENT.Radius = 128
ENT.HitSomething = nil

ENT.NextVisThink = 0
ENT.NextEmit = 0
function ENT:Think()
	if self.HitSomething  then
		--self:StopSound("weapon_rpg.TrailLoop")
		self:Explode()
	end
	--[[
	local smoke = ents.Create("env_smoketrail")
	smoke:SetKeyValue("startsize","8")
	smoke:SetKeyValue("endsize","16")
	smoke:SetKeyValue("spawnradius","1")
	--smoke:SetKeyValue("spawnrate","10")
	smoke:SetKeyValue("opacity","1")
	smoke:SetKeyValue("lifetime","1")
	smoke:SetKeyValue("opacity","1")
	smoke:SetKeyValue("startcolor","255 255 255 5000")
	smoke:SetKeyValue("endcolor","196 196 196 5000")
	smoke:SetPos(self:GetPos())
	smoke:SetParent(self)
	smoke:Spawn()
	smoke:Fire("kill", "", 16)
	]]
	if self.NextEmit <= CurTime() then
		self.NextEmit = CurTime() + 0.7
		ParticleEffectAttach("grenade_rpg_trail", PATTACH_POINT_FOLLOW, self, 1)
	end

	if not self:GetOwOner():GetActiveWeapon().Guide then return end
	--if not self.Guide then return end
	if (self.TimeCreated + 0.25) >= CurTime() then return end
	if self.NextVisThink <= CurTime() then
		self.NextVisThink = CurTime() + 0.1
		
		local owoner = self:GetOwOner()
		local tr = owoner:GetEyeTrace()

		if tr.Entity == self then return end

		local targetpos = tr.HitPos
		local direction = ( targetpos - self:GetPos() )
		self:SetAngles(direction:Angle())

		local airtime = CurTime() - self.TimeCreated
		local speedmul = math.Clamp(1 + airtime, 1, 9)
		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(self:GetForward() * (700 * speedmul))
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true

	local owoner = self:GetOwOner()
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
				ent:TakeDamageInfo(dmginfo)
			end
		end
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		util.Effect((self:WaterLevel() >= 3) and "WaterSurfaceExplosion" or "Explosion", effectdata)
	end
	self:Remove()
end

function ENT:OnRemove()
	self:StopSound("weapon_rpg.TrailLoop")
end

function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	self.Done = true

	self:Fire("kill", "", 4)

	phys:EnableMotion(false)
	self.HitSomething = true
end