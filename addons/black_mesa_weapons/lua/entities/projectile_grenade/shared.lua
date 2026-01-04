ENT.Type = "anim"

function ENT:SetActivationDelay(time)
	self:SetDTFloat(0, time)
end

function ENT:GetActivationDelay()
	return self:GetDTFloat(0)
end

util.PrecacheModel("models/weapons/bms_wal/w_satchel.mdl")