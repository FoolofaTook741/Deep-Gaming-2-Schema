--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.Touched = {}
	
	self.HornetBuzzSound = CreateSound(self, ")weapons/hivehand/buzz.wav")
	self.HornetBuzzSound:SetSoundLevel(60)

	self:Fire("kill", "", 6)
	
	self:SetModel("models/weapons/w_hornet.mdl")
	self:SetModelScale(0.5)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:SetBuoyancyRatio(0.01)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end

	self.TimeCreated = CurTime()
end

ENT.Targeting = nil
ENT.Target = nil
ENT.Radius = 128
ENT.HitSomething = nil

ENT.NextVisThink = 0
function ENT:Think()
	if not self.HitSomething then
		self.HornetBuzzSound:PlayEx(1, 100 + CurTime() % 1)
	else
		self.HornetBuzzSound:Stop()

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

	if not self.DoTargeting then return end
	if self.NextVisThink <= CurTime() then
		self.NextVisThink = CurTime() + 0.1
		local radius = self.Radius
		local owoner = self:GetOwOner()
		local pos = self:GetPos()

		for _, ent in pairs(ents.FindInSphere(pos, radius)) do
			if not (ent == owoner) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then -- target them anyways
				self.Target = ent
				break
			end
		end
	end

	local target = self.Target
	if IsValid(target) and (target:IsPlayer() or target:IsNPC() or target:IsNextBot()) then
		local targetpos = target:LocalToWorld(target:OBBCenter() + Vector(0, 0, 1))
		local direction = (targetpos - self:GetPos()):GetNormal()

		self:SetAngles(direction:Angle())

		local airtime = CurTime() - self.TimeCreated
		local speedmul = math.Clamp(1 + airtime, 1, 9)
		local phys = self:GetPhysicsObject()
		phys:SetVelocityInstantaneous(direction * (136 * speedmul))
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
	self:EmitSound(")weapons/hivehand/bug_impact.wav")
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

	ent:TakeDamage(12, owoner, self)
	ent:EmitSound(")weapons/hivehand/bug_impact.wav")
	self.HitSomething = true
	self:Remove()
end