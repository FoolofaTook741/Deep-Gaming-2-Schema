AddCSLuaFile()
ENT.Type = "anim"
ENT.Spawnable = false
function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if CLIENT then
		self.DynLight = DynamicLight(self:EntIndex())
		self.DynLight.Pos = self:GetPos()
		self.DynLight.Size = 128
		self.DynLight.Decay = 256
		self.DynLight.R = 255
		self.DynLight.G = 100
		self.DynLight.B = 0
		self.DynLight.Brightness = 10
		self.DynLight.DieTime = CurTime() + 1
	end
end

function ENT:Launch()
	self.plutonic_StartAng = self:GetAngles()
	self.plutonic_StartPos = self:GetPos() + self:GetAngles():Forward() * 10
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:ApplyForceCenter(self:GetAngles():Forward() * 1000000 ^ 2)
	end
end

function ENT:PhysicsCollide(data, physobj)
	if data.Speed > 50 then
		self:EmitSound("physics/metal/metal_box_impact_hard" .. math.random(1, 3) .. ".wav")
	end

	if data.HitEntity == self:GetOwner() then return end
	self:Remove()
end

function ENT:Think()
	if CLIENT then
		if self.DynLight then
			self.DynLight.Pos = self:GetPos()
			self.DynLight.DieTime = CurTime() + 1
		else
			self.DynLight = DynamicLight(self:EntIndex())
			self.DynLight.Pos = self:GetPos()
			self.DynLight.Size = 128
			self.DynLight.Decay = 256
			self.DynLight.R = 255
			self.DynLight.G = 100
			self.DynLight.B = 0
			self.DynLight.Brightness = 10
			self.DynLight.DieTime = CurTime() + 1
		end
	end
	--self:SetPos(self:GetPos() + self:GetAngles():Forward() * 10)
	--self:SetAngles(self:GetAngles() + Angle(0, 0, -1))
end

function ENT:OnRemove()
	if CLIENT then
		self.DynLight.DieTime = CurTime()
	end
end

function ENT:Draw()
	render.SetMaterial(Material("sprites/light_glow02_add"))
	render.DrawBeam(self:GetPos() - self:GetAngles():Forward() * 160, self:GetPos(), 16, 0, 0, Color(255, 255, 255, 255))
	render.DrawSprite(self:GetPos(), 16, 16, Color(255, 255, 255, 255))
end