include("shared.lua")

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
	if not IsValid(self.emitter) then
		self.emitter = ParticleEmitter(self:GetPos())
	end

	if self:GetNWBool("Filtering", false) then
		local exhaustPos = self:LocalToWorld(Vector(-53, 98, 160))
		self.emitter:SetPos(exhaustPos)

		local f = self.emitter:Add("particles/flamelet" .. math.random(1, 5), exhaustPos)
		if f then
			f:SetVelocity(Vector(math.Rand(-8, 8), math.Rand(-8, 8), math.Rand(30, 60)))
			f:SetLifeTime(0)
			f:SetDieTime(math.Rand(0.3, 0.6))
			f:SetStartAlpha(200)
			f:SetEndAlpha(0)
			f:SetStartSize(math.Rand(6, 10))
			f:SetEndSize(math.Rand(2, 4))
			f:SetColor(255, math.random(80, 160), 0)
			f:SetGravity(Vector(0, 0, 20))
			f:SetCollide(false)
			f:SetLighting(false)
		end

		local s = self.emitter:Add("particle/particle_smokegrenade", exhaustPos)
		if s then
			s:SetVelocity(Vector(math.Rand(-4, 4), math.Rand(-4, 4), math.Rand(20, 30)))
			s:SetLifeTime(0)
			s:SetDieTime(0.6)
			s:SetStartAlpha(60)
			s:SetEndAlpha(0)
			s:SetStartSize(10)
			s:SetEndSize(30)
			s:SetColor(80, 80, 80)
			s:SetGravity(Vector(0, 0, 10))
			s:SetCollide(false)
			s:SetLighting(false)
		end
	end

	self:SetNextClientThink(CurTime() + 0.05)
	return true
end

function ENT:OnRemove()
	if IsValid(self.emitter) then
		self.emitter:Finish()
	end
end

function ENT:Draw()
	self:DrawModel()

	local filtering = self:GetNWBool("Filtering", false)
	local pos = self:GetPos() + Vector(0, 0, 95)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleTextOutlined("OIL FILTER STATION", "BudgetLabel", 0, -10, Color(210, 170, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		if filtering then
			draw.SimpleTextOutlined("[ FILTERING... ]", "DebugFixed", 0, 10, Color(255, 210, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		else
			draw.SimpleTextOutlined("[ PRESS E - PLACE BARREL WITHIN 200u ]", "DebugFixed", 0, 10, Color(100, 210, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
		end
	cam.End3D2D()
end
