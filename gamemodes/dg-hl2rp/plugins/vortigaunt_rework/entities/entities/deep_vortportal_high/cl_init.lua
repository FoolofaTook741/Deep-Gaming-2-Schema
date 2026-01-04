include("shared.lua")

function ENT:Initialize()
    self.ParticleEmitter = ParticleEmitter(self:GetPos())
end

function ENT:OnRemove()
    if IsValid(self.ParticleEmitter) then
        self.ParticleEmitter:Finish()
    end
end

function ENT:Draw()
    if LocalPlayer():Team() ~= TEAM_VORT then return end
    self:DrawModel()
end

function ENT:Think()
    if LocalPlayer():Team() ~= TEAM_VORT then
        self:NextThink(CurTime())
        return true
    end
	
	if not IsValid(self.ParticleEmitter) then
		self.ParticleEmitter = ParticleEmitter(self:GetPos())
    end

    local pos = self:GetPos()
    local emitter = self.ParticleEmitter
    if not IsValid(emitter) then return end

    local time = CurTime()
    local numParticles = 6
    local baseRadius = 1
    local pulsate = math.sin(time * 2) * 20
    local radius = baseRadius + pulsate

    for i = 1, numParticles do
        local angle = math.rad((360 / numParticles) * i + (time * 75))
        local jitter = math.Rand(-1, 2)
        local effectiveRadius = radius + jitter
        local offset = Vector(math.cos(angle) * effectiveRadius, math.sin(angle) * effectiveRadius, 0)
        local verticalOffset = math.Rand(1, 2)
        local particlePos = pos + offset + Vector(0, 0, verticalOffset)
        local particle = emitter:Add("effects/yellowflare", particlePos)
        if particle then
            local upwardVelocity = 10 + math.Rand(-1, 1)
            particle:SetVelocity(Vector(0, 0, upwardVelocity))
            particle:SetDieTime(math.Rand(1.3, 1.7))
            particle:SetStartAlpha(200)
            particle:SetEndAlpha(0)
            particle:SetStartSize(math.Rand(2, 5))
            particle:SetEndSize(0)
            particle:SetColor(255, 0, 0)
            particle:SetRoll(math.random(0, 360))
            particle:SetRollDelta(math.Rand(-2, 2))
            particle:SetAirResistance(50)
            particle:SetCollide(false)
        end
    end

    self:NextThink(time)
    return true
end



