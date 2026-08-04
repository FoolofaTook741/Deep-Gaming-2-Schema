if not E2Lib then
	return
end


E2Lib.RegisterExtension("hl2rp", true, "Allows E2 to interact with impulse: Half-Life 2 Roleplay.")

local function checkOwner(self)
	return IsValid(self.player);
end

__e2setcost(25)
e2function number hl2rpGetCityCode()
	return CODE_CIVIL --impulse.Dispatch.GetCityCode()
end