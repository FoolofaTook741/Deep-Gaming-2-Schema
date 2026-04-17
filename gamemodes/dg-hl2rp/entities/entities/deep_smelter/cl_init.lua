include("shared.lua")

function ENT:Initialize()
	self.flameEmitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
	local basePos = self:GetPos() + Vector(0, 0, 40)

	if IsValid(self.flameEmitter) then
		self.flameEmitter:SetPos(basePos)

		local p = self.flameEmitter:Add("particles/flamelet" .. math.random(1, 5), basePos)
		if p then
			p:SetVelocity(Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(40, 80)))
			p:SetLifeTime(0)
			p:SetDieTime(math.Rand(0.5, 1.0))
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(30, 50))
			p:SetEndSize(math.Rand(10, 20))
			p:SetColor(255, math.random(80, 160), 0)
			p:SetGravity(Vector(0, 0, 30))
			p:SetCollide(false)
			p:SetLighting(false)
		end
	end

	self:SetNextClientThink(CurTime() + 0.05)
	return true
end

function ENT:OnRemove()
	if IsValid(self.flameEmitter) then
		self.flameEmitter:Finish()
	end
end

function ENT:Draw()
	render.SetColorModulation(0, 0, 0)
	self:DrawModel()
	render.SetColorModulation(1, 1, 1)
end