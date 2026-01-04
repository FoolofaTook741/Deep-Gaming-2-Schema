ENT.Type = "anim"

ENT.IsBMSTripMine = true

function ENT:MakeTraceFilter()
	local filter = {}
	filter[#filter + 1] = self

	filter = table.Add(filter, ents.FindByClass("prop_tripmine*"))

	return filter
end

ENT.NextCache = 0
function ENT:CachedTraceFilter()
	if CurTime() < self.NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:MakeTraceFilter()
	self.NextCache = CurTime() + 1

	return self.CachedFilter
end

function ENT:SetActivationDelay(time)
	self:SetDTFloat(0, time)
end

function ENT:GetActivationDelay()
	return self:GetDTFloat(0)
end

util.PrecacheModel("models/weapons/bms_wal/w_tripmine.mdl")
