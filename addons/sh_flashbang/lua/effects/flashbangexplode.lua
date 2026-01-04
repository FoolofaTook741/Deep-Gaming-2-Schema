local EFFECT_LIFETIME = 0.2

function EFFECT:Init(ed)
	local pos = ed:GetOrigin()
	self.m_vStartPos = pos

	local ct = CurTime()
	self.m_fStartTime = ct
	self.m_fEndTime = ct + EFFECT_LIFETIME

	if (FLASHBANG_SETTINGS.EmitParticles) then
		local emitter = ParticleEmitter(pos)

		for i = 1, math.random(30, 40) do
			local vOffset = Vector(math.Rand(0, 5), math.Rand(0, 5), math.Rand(0, 10))
			local r = math.Rand(20, 25)
			local c = math.Rand(50, 200)
			local vecr = VectorRand()
			vecr.z = math.abs(vecr.z) * 0.2
			
			local smoke = emitter:Add("particle/particle_smokegrenade1", pos + vOffset)
			smoke:SetVelocity(vecr * math.Rand(200, 350))
			smoke:SetDieTime(math.Rand(9, 16))
			smoke:SetStartAlpha(math.Rand(245, 255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(r)
			smoke:SetEndSize(r * math.Rand(1, 3))
			smoke:SetRoll(math.Rand(-180, 180))
			smoke:SetRollDelta(math.Rand(-0.5, 0.5))
			smoke:SetColor(c, c, c)
			smoke:SetAirResistance(math.random(60, 90))
			smoke:SetCollide(true)
		end

		for i = 1, math.random(10, 15) do
			local vOffset = Vector(math.Rand(0, 6), math.Rand(0, 6), math.Rand(0, 6))
			local r = math.Rand(20, 25)
			local c = math.random(200, 255)
			local vecr = VectorRand()

			local smoke = emitter:Add("particle/fire", pos + vOffset)
			smoke:SetVelocity(vecr * math.Rand(50, 75))
			smoke:SetDieTime(math.Rand(0.5, 0.75))
			smoke:SetStartAlpha(math.Rand(175, 255))
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(1)
			smoke:SetEndSize(1)
			smoke:SetStartLength(math.random(5, 10))
			smoke:SetEndLength(0)
			smoke:SetColor(c, c * math.Rand(0.25, 0.5), 0)
			smoke:SetRoll(math.Rand(-180, 180))
			smoke:SetRollDelta(math.Rand(-1, 1))
			smoke:SetAirResistance(math.random(60, 90))
			smoke:SetCollide(true)
		end

		emitter:Finish()
	end

	if (FLASHBANG_SETTINGS.CreateDecal) then
		local trs = util.TraceLine({start = pos + Vector(0, 0, 64), endpos = pos + Vector(0, 0, -128), filter = ents.GetAll()})
		util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
	end
end

local brightness = 10
local size = 200

function EFFECT:Think()
	local time = self.m_fEndTime - CurTime()
	local frac = time / EFFECT_LIFETIME

	local light = DynamicLight(0)
	light.Pos = self.m_vStartPos
	light.r = 255
	light.g = 255
	light.b = 255
	light.Decay = size * 5
	light.Size = size
	light.DieTime = CurTime() + 1
	light.Brightness = brightness * frac

	return CurTime() < self.m_fEndTime
end

function EFFECT:Render()
end