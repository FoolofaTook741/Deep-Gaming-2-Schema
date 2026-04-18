ENT.Type        = "anim"
ENT.Base        = "base_anim"
ENT.PrintName   = "Oil Refinery Foreman"
ENT.Category    = "impulse"
ENT.Spawnable   = true
ENT.AdminOnly   = false

ENT.HUDName     = "Oil Refinery Foreman"
ENT.HUDDesc     = "Manages oil refinery workshifts."

function ENT:DoAnimation(custom)
	local seq = (custom and custom ~= "") and custom or "idle_subtle"
	local seqID = self:LookupSequence(seq)
	if seqID and seqID >= 0 then
		self:SetSequence(seqID)
		self:SetPlaybackRate(1)
		self:SetCycle(0)
		self:ResetSequenceInfo()
	end
end
