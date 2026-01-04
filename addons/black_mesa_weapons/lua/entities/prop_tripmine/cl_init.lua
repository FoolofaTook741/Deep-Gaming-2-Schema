include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	local attach = self:GetAttachment(self:LookupAttachment("Beam"))
	self.LaserPos = attach.Pos
	self.LaserAng = attach.Ang
	self.LaserDir = -attach.Ang:Forward() * -768
	
	hook.Add("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.TripMineLaser_"..self:EntIndex(), function()
		if IsValid(self) then
			self:DrawTranslucent()
		end
	end)
end

local matGlow = Material("sprites/glow04_noz")
local matLaser = Material("trails/laser")
local colBeam = Color(64, 180, 232, 255)
local COLOR_WHITE = color_white
function ENT:DrawTranslucent()
	local lightpos = self.LaserPos
	if not (self:GetActivationDelay() <= CurTime()) then return end
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, 4, 4, colBeam)
	render.DrawSprite(lightpos, 2, 2, colBeam)

	local tr = util.QuickTrace(lightpos, self.LaserDir, self:CachedTraceFilter())

	render.SetMaterial(matLaser)
	render.DrawBeam(lightpos, tr.HitPos, 3.6, 0, 1, colBeam)
	render.DrawBeam(lightpos, tr.HitPos, 2.3, 0, 1, colBeam)
end

function ENT:OnRemove()
	hook.Remove("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.TripMineLaser_"..self:EntIndex())
end
