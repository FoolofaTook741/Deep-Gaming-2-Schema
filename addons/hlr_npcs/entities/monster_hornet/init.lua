
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

AccessorFunc(ENT, "bHoming", "Homing", FORCE_BOOL)
AccessorFunc(ENT, "fSearchRadius", "SearchRadius", FORCE_NUMBER)
AccessorFunc(ENT, "fSpeed", "Speed", FORCE_NUMBER)

function ENT:Initialize()
	timer.Simple(4,function() if IsValid(self) then self:Remove() end end)
	self:SetMoveCollide(3)
	self:SetModel("models/half-life/hornet.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetHealth(1)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1)
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(0)
	end
	self.fSpeed = self.fSpeed || 240
	self.fSearchRadius = self.fSearchRadius || 500
	if self.bHoming == nil then self.bHoming = true end
	self.posOrigin = self:GetPos()
	
	self.delayDeploy = CurTime() +math.Rand(0.15,0.3)
	self.nextBuzz = 0
	
	util.SpriteTrail(self, 0, Color(255,math.random(50,200),0,120), true, 50, 0, 1, 0.04, "sprites/hornettrail.vmt")
end

function ENT:SetEntityOwner(entOwner)
	self:SetOwner(entOwner)
	self.entOwner = entOwner
end

local function FlyStraight(self)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(self:GetForward() *self:GetSpeed())
	end
end

local function FlyRandom(self)
	if self.dir then
		local vel = (self:GetVelocity():GetNormal() +self.dir *0.1) *self.fSpeed
		local phys = self:GetPhysicsObject()
		phys:ApplyForceCenter(vel)
		self:EmitSound( "npc/hornet/buzz" ..math.random(1,3).. ".wav", 75, 100)
	else FlyStraight(self) end
end

function ENT:Think()
	if !IsValid(self.entOwner) then return end
	if CurTime() < self.delayDeploy then FlyRandom(self) end
	if !self:GetHoming() then
		FlyStraight(self)
		return
	end
	local tblEnts = ents.FindInSphere(self:GetPos(), 500)
	local ent
	local i = 10
	for k, v in pairs(tblEnts) do
		if IsValid(v) && ((v:IsPlayer() && !tobool(GetConVarNumber("ai_ignoreplayers")) && !v:IsPossessing()) || v:IsNPC()) && v != self.entOwner && (self.entOwner:IsPlayer() || self.entOwner:Disposition(v) <= 2) && v:Health() > 0 then
			local flDist = self:OBBDistance(v)
			local yaw = self:GetAngleToPos(v:GetPos()).y
			if yaw > 180 then yaw = (yaw -360) *-1 end
			local _i = math.Clamp(flDist,0,200) /200 +yaw /360
			if _i < i then
				i = _i
				ent = v
			end
		end
	end
	if !IsValid(ent) then FlyRandom(self); return end
	local vel = self:GetVelocity() +((ent:GetHeadPos() -self:GetPos()):GetNormal() +Vector(math.Rand(-0.15,0.15), math.Rand(-0.15,0.15), math.Rand(-0.2,0.2))) *self.fSpeed
	local phys = self:GetPhysicsObject()
	if !IsValid(phys) then return end
	phys:ApplyForceCenter(vel)
	phys:AddAngleVelocity(phys:GetAngleVelocity() *-1)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
	self:EmitSound( "npc/hornet/buzz" ..math.random(1,3).. ".wav", 75, 100)
end

function ENT:PhysicsCollide(data, physobj)
	self.dir = data.HitNormal *-1
	if !data.HitEntity then return true end
	if IsValid(self) && (!IsValid(data.HitEntity) || (!data.HitEntity:IsPlayer() && !data.HitEntity:IsNPC())) then
		if !self:GetHoming() then
			self.Entity:EmitSound("npc/hornet/hit" ..math.random(1,3).. ".wav", 75, 100)
			self:Remove()
		end
		return true
	end
	local owner = self.entOwner
	if !IsValid(owner) then owner = self end
	data.HitEntity.attacker = owner
	data.HitEntity.inflictor = self
	if (data.HitEntity:IsPlayer() || data.HitEntity:IsNPC()) && (!IsValid(self.entOwner) || self.entOwner:IsPlayer() || self.entOwner:Disposition(data.HitEntity) <= 2) then
		if data.HitEntity:GetClass() != "npc_turret_floor" then
			data.HitEntity:TakeDamage(GetConVarNumber("sk_npc_dmg_hornet"), owner, self)
		elseif !data.HitEntity.bSelfDestruct then
			data.HitEntity:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
			data.HitEntity:Fire("selfdestruct", "", 0)
			data.HitEntity.bSelfDestruct = true
		end
	end
	self.Entity:EmitSound("npc/hornet/hit" ..math.random(1,3).. ".wav", 75, 100)
	self:Remove()
	return true
end

