--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.Touched = {}
	self:Fire("kill", "", 6)
	
	self:SetModel("models/weapons/bms_wal/crossbow_bolt.mdl")
	self:SetModelScale(1)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:SetTrigger(true)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(34)
		phys:SetBuoyancyRatio(10)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end

	self.TimeCreated = CurTime()
end

ENT.HitSomething = nil
function ENT:Think()
	if self.HitSomething  then
		local owoner = self:GetOwOner()
		if IsValid(owoner) and owoner:IsPlayer() then
			local hitent = self.DHitEnt
			self:SetPos(self.DHitPos)
			self:SetAngles(self.DHitAng)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			self:GetPhysicsObject():EnableMotion(false)
			if hitent and hitent:IsValid() then
				local hitphys = hitent:GetPhysicsObject()
				if hitphys:IsValid() and hitphys:IsMoveable() then
					self:SetParent(hitent)
				end
			end
		end
	end
end


ENT.DHitEnt = nil
ENT.DHitPos = nil
ENT.DHitAng = nil
function ENT:PhysicsCollide(data, phys)
	if self.Done then return end
	self.Done = true

	self:Fire("kill", "", 4)

	phys:EnableMotion(false)
	self:EmitSound(")weapons/crowbar/melee_hit"..math.random(1,3)..".wav")
	self.HitSomething = true

	self.DHitEnt = data.HitEntity
	self.DHitPos = data.HitPos
	self.DHitAng = data.HitNormal:Angle()
end

function ENT:StartTouch(ent)
	if self.Done or self.Touched[ent] or not ent:IsValid() then return end

	local owoner = self:GetOwOner()
	if not owoner:IsValid() then owoner = self end

	if ent == owoner or ent:IsPlayer() and (ent:Team() == self.Team or not ent:Alive()) then return end

	self.Touched[ent] = true

	ent:TakeDamage(self.BoltDmg or 100, owoner, self)
	ent:EmitSound(")weapons/crowbar/melee_hit"..math.random(1,3)..".wav")
	self.HitSomething = true
	self:Remove()
end