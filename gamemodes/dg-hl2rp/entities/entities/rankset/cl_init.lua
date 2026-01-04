include("shared.lua")

ENT.AutomaticFrameAdvance = true
function ENT:Think()

	self:SetNextClientThink(CurTime() + 0.25)

	return true
end
