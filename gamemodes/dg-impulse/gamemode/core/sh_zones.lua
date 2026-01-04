function meta:GetZone()
	return self.impulseZone
end

function meta:GetZoneName()
	if self.impulseZone then
		return impulse.Config.Zones[self.impulseZone].name
	else
		return ""
	end
end

function meta:SetZone(id)
	if (self.impulseZone or -1) == id then return end
	self.impulseZone = id

	net.Start("impulseZoneUpdate")
	net.WriteUInt(id, 8)
	net.Send(self)

	hook.Run("PlayerZoneChanged", self, id)
end

function impulse.GetZoneFromPos(pos)
    local zoneName = "UNKNOWN"

    for _, zone in pairs(impulse.Config.Zones) do
        local p1, p2 = zone.pos1, zone.pos2

        local mn = Vector(
            math.min(p1.x, p2.x),
            math.min(p1.y, p2.y),
            math.min(p1.z, p2.z)
        )
        local mx = Vector(
            math.max(p1.x, p2.x),
            math.max(p1.y, p2.y),
            math.max(p1.z, p2.z)
        )

        if pos.x >= mn.x and pos.x <= mx.x
        and pos.y >= mn.y and pos.y <= mx.y
        and pos.z >= mn.z and pos.z <= mx.z then
            zoneName = zone.name or zoneName
            break
        end
    end

    return string.upper(zoneName)
end
