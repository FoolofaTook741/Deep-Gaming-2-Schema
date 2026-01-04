--[[SECURE]]--
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.Touched = {}

	self:Fire("kill", "", 15)
	
	self:SetModel("models/weapons/bms_wal/snark_proj.mdl")
	local mins, maxs = Vector(-5.5, -3.5, 0), Vector(12.5, 3.5, 9)
	--local mins, maxs = Vector(-5.5, -12.5, 1), Vector(12.5, 12.5, 9)
	self:PhysicsInitBox(mins, maxs)
	self:SetModelScale(1)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)
	self:DrawShadow(false)
	self:EmitSound("npc_snark.Deploy")
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(8)
		phys:EnableDrag(false)
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetBuoyancyRatio(0.8)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end
end

function ENT:OnRemove()
	self:EmitSound("npc_snark.Die")
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale(6)
	util.Effect("BloodImpact", effectdata)
end

local WorldVisibleTrace = {mask = MASK_SOLID_BRUSHONLY}
function WorldVisible(posa, posb) -- a utility function that i take from zs
	WorldVisibleTrace.start = posa
	WorldVisibleTrace.endpos = posb
	return not util.TraceLine(WorldVisibleTrace).Hit
end

ENT.Targeting = nil
ENT.Target = nil
ENT.Radius = 768

ENT.NextVisThink = 0
ENT.NextVisThink2 = 0
local trace = {mask = MASK_SOLID}
function ENT:Think()
	self:ResetSequence( "runsimple" ) 

	if self.NextVisThink2 <= CurTime() and self.Activated then
		if self.NextVisThink <= CurTime() then
			self.NextVisThink = CurTime() + 0.4
			local radius = self.Radius
			local owoner = self.Objectowoner
			local pos = self:GetPos()
			
			for _, ent in pairs(ents.FindInSphere(pos, radius)) do
				if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then -- target them anyways
					self.Target = ent
					if ent:GetPos():DistToSqr(self:GetPos()) < 16384 then
						self.BestTarget = ent
						break
					end
				end
			end
		end

		local target = self.Target or self
		local besttarget = self.BestTarget or target
		if IsValid(target) and target:IsPlayer() or target:IsNPC() or target:IsNextBot() then
			if not IsValid(target) then return end -- check it again in case if target was removed from game
			if not WorldVisible(self:GetPos(), target:NearestPoint(self:GetPos())) then  return end
			local targetpos = target:LocalToWorld(target:OBBCenter() + Vector(0, 0, 1))
			local direction = (targetpos - self:GetPos()):GetNormal()

			self:SetAngles(direction:Angle())

			trace.filter = self
			trace.start = self:GetPos()
			trace.endpos = trace.start + Vector(0, 0, self:OBBMins().z - 8)
			local tr = util.TraceLine(trace)
			onground = tr.Hit
			if onground then
				local phys = self:GetPhysicsObject()

				local vel = phys:GetVelocity()
				local movedir = Vector(0, 0, 0)
				local aimangles = direction:Angle()
				local onground = false
			
				phys:SetDragCoefficient(10)

				self:LocalToWorldAngles(Angle(0,0,0) * FrameTime() * 1)
				if IsValid(besttarget) then
					local p = besttarget:GetPos()
					phys:SetAngleDragCoefficient(1000)
					if p:DistToSqr(self:GetPos()) < 22500 then
						local dir = direction
						local phys = self:GetPhysicsObject()
						if phys:IsValid() then
							dir.z = dir.z + 0.5
							phys:AddVelocity(dir * 360)
							self:EmitSound("npc_snark.Hunt")
							self.NextVisThink2 = CurTime() + 0.75
						end
					else
						phys:SetVelocityInstantaneous(direction * 300)
					end
				else
					phys:SetVelocityInstantaneous(direction * 300)
				end
			end
		end
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


function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
--[[
	self:EmitSound("npc_snark.Explode")
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale(6)
	util.Effect("BloodImpact", effectdata)
]]
	self:Remove()
end

function ENT:PhysicsCollide(data, phys)
	--[[
	if self.Activated then
		if 20 < data.Speed and 0.25 < data.DeltaTime then
			self:EmitSound("npc_snark.Hunt")
		end
	end
	]]
	trace.filter = self
	trace.start = self:GetPos()
	trace.endpos = trace.start + Vector(0, 0, self:OBBMins().z - 8)
	local tr = util.TraceLine(trace)
	local onground = tr.Hit
	if onground then
		self.Activated = true
	end

	self:NextThink(CurTime())
end

function ENT:StartTouch(ent)
	if self.Done or not ent:IsValid() then return end

	local owoner = self.Objectowoner
	if not owoner:IsValid() then owoner = self end
	if not self.Activated  then return end

	self.Touched[ent] = true

	self:EmitSound("npc_snark.Bite")
	ent:TakeDamage(4, owoner, self)
	self.Target = nil
	self.Activated = false

	local dir = ent:LocalToWorld(ent:OBBCenter() + Vector(0, 0, 1)):GetNormalized()

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		dir.z = dir.z + 1.5

		phys:AddVelocity(dir * 180)
		self.NextVisThink2 = CurTime() + 0.75
	end
end