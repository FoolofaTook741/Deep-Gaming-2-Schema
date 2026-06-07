include("shared.lua")

local PARTICLE_INTERVAL = 0.3
local PARTICLE_RADIUS   = 80
local GAS_COLOR         = { r = 50, g = 200, b = 50 }

function ENT:Initialize()
    self.NextParticle = 0
end

function ENT:Think()
    local now = CurTime()
    if now < self.NextParticle then return end
    self.NextParticle = now + PARTICLE_INTERVAL

    local pos     = self:GetPos()
    local emitter = ParticleEmitter(pos)
    if not emitter then return end

    for i = 1, 3 do
        local scatter = VectorRand() * math.random(10, PARTICLE_RADIUS)
        scatter.z     = math.abs(scatter.z)

        local p = emitter:Add("particle/smokesprites_000" .. math.random(1, 8), pos + scatter)
        if p then
            p:SetVelocity(Vector(
                math.Rand(-8, 8),
                math.Rand(-8, 8),
                math.random(10, 25)
            ))
            p:SetLifeTime(0)
            p:SetDieTime(math.random(2, 4))
            p:SetStartAlpha(math.random(60, 90))
            p:SetEndAlpha(0)
            p:SetStartSize(math.random(12, 25))
            p:SetEndSize(math.random(30, 60))
            p:SetRoll(math.Rand(-180, 180))
            p:SetRollDelta(math.Rand(-1, 1))
            p:SetColor(GAS_COLOR.r, GAS_COLOR.g, GAS_COLOR.b)
            p:SetGravity(Vector(0, 0, 6))
            p:SetAirResistance(60)
            p:SetLighting(false)
        end
    end

    emitter:Finish()
end

function ENT:Draw()
    --invisible, gas has particles anyways
end
