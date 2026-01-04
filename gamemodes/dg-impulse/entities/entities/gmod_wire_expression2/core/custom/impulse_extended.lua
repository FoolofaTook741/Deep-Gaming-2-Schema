if not E2Lib then
	return
end

E2Lib.RegisterExtension("impulseextended", true, "Allows E2 to interact with certain methods in the impulse framework. Extended by Landis Community.")


__e2setcost(35)
e2function number entity:impulseGetXP()
	if not this:IsPlayer() then
		self:throw("Entity is not a player!", nil)
		return 0
	end

	return this:GetXP()
end

e2function string entity:impulseGroup()
	if not this:IsPlayer() then
		self:throw("Entity is not a player!", nil)
		return ""
	end

	local group = this:GetSyncVar(SYNC_GROUP_NAME,nil)

	if (group == nil) or (group == "") then
		return "none"
	end

	return group
end

e2function string entity:impulseGroupRank()
	if not this:IsPlayer() then
		self:throw("Entity is not a player!", nil)
		return ""
	end

	local rank = this:GetSyncVar(SYNC_GROUP_RANK,nil)

	if (rank == nil) or (rank == "") then
		return "none"
	end

	return rank
end

e2function number entity:impulseGroupHasPermission(number permission)
	if not this:IsPlayer() then
		self:throw("Entity is not a player!", nil)
		return ""
	end

	return this:GroupHasPermission(permission) and 1 or 0
end

e2function string impulsePlayerGetZone(entity e)
	if not e:IsPlayer() then
		return ""
	end

	return impulse.Config.Zones[e:GetSyncVar(SYNC_ZONE,1)].name
end

--[[
__e2setcost(10)

--- Sets <this>'s bodygroup.
e2function void entity:setBodygroup(bgrp_id, bgrp_subid)
	if not IsValid(this) then return self:throw("Invalid entity!", nil) end
	if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end
	if this:IsPlayer() then
		if this:Team() == 1 or this:Team() == 2 then
			return self:throw("You cannot change the bodygroup on this team!", nil)
		end
	end
	this:SetBodygroup(bgrp_id, bgrp_subid)
end
]]