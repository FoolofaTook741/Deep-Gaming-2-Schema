if SERVER then
	function meta:SetRPName(name, save)
		if save then
			local query = mysql:Update("impulse_players")
			query:Update("rpname", name)
			query:Where("steamid", self:SteamID())
			query:Execute(true)

			self.defaultRPName = name
		end

		hook.Run("PlayerRPNameChanged", self, self:Name(), name)

		self:SetSyncVar(SYNC_RPNAME, name, true)
	end

	function meta:GetSavedRPName()
		return self.defaultRPName
	end
end

local blacklistNames = {
	["ooc"] = true,
	["shared"] = true,
	["world"] = true,
	["world prop"] = true,
	["blocked"] = true,
	["admin"] = true,
	["server admin"] = true,
	["mod"] = true,
	["game moderator"] = true,
	["adolf hitler"] = true,
	["masked person"] = true,
	["masked player"] = true,
	["unknown"] = true,
	["nigger"] = true,
	-- fag breaks it for some reason
	["f@g"] = true,
	["f@ggot"] = true,
	["fagg0t"] = true,
	["f@gg0t"] = true,
	["f4ggot"] = true,
	["f4gg0t"] = true,
	["n1gga"] = true,
	["n1gg@"] = true,
	["nigg@"] = true,
	["n0gga"] = true,
	["nogg@"] = true,
	["n0gg@"] = true,
	["n1gger"] = true,
	["n1gg3r"] = true,
	["n1gg4"] = true,
	["n1gg4r"] = true,
	["niggar"] = true,
	["UCh-VCHMsVcb-AppRsF2c2Rw"] = true,
	["sC8199W90t8"] = true,
	["nGBP2LlS2bY"] = true,
	["P_lh60aLP8c"] = true,
	["9WpptQzpmWs"] = true,
	["UCrPd2ZDrxGG2yinfoya9AEw"] = true,
	["UCz7lYPf2xyB8IG6Tve7hbzw"] = true,
	["RfVHapVJ_vg"] = true,
	["PQ2-nRbZVdk"] = true,
	["aLkHm0xkspQ"] = true,
	["skibidi"] = true,
	["sk1b1d1"] = true,
	["skib1d1"] = true,
	["skibid1"] = true,
	["sk1bid1"] = true,
	["sk!b!d!"] = true,
	["sk!bid!"] = true,
	-- caps incase it dosent count
	["F@G"] = true,
	["F@GGOT"] = true,
	["FAGG0T"] = true,
	["F@GG0T"] = true,
	["F4GGOT"] = true,
	["F4GG0T"] = true,
	["N1GGA"] = true,
	["N1GG@"] = true,
	["NIGG@"] = true,
	["N0GGA"] = true,
	["NOGG@"] = true,
	["N0GG@"] = true,
	["N1GGER"] = true,
	["N1GG3R"] = true,
	["N1GG4"] = true,
	["N1GG4R"] = true,
	["NIGGAR"] = true,
	["UCH-VCHMSVCB-APPRSF2C2RW"] = true,
	["SC8199W90T8"] = true,
	["NGBP2LLS2BY"] = true,
	["P_LH60ALP8C"] = true,
	["9WPPTQZPMWS"] = true,
	["UCRPD2ZDRXGG2YINFOYA9AEW"] = true,
	["UCZ7LYPF2XYB8IG6TVE7HBZW"] = true,
	["RFVHAPVJ_VG"] = true,
	["PQ2-NRBZVDK"] = true,
	["ALKHM0XKSPQ"] = true,
	["SKIBIDI"] = true,
	["SK1B1D1"] = true,
	["SKIB1D1"] = true,
	["SKIBID1"] = true,
	["SK1BID1"] = true,
	["SK!B!D!"] = true,
	["SK!BID!"] = true
}

function impulse.CanUseName(name)
	if name:len() >= 24 then
		return false, "Name too long. (max. 24)" 
	end

	name = name:Trim()
	name = impulse.SafeString(name)

	if name:len() <= 6 then
		return false, "Name too short. (min. 6)"
	end

	if name == "" then
		return false, "No name was provided."
	end


	local numFound = string.match(name, "%d") -- no numerics

	if numFound then
		return false, "Name contains numbers."
	end
	
	if blacklistNames[name:lower()] then
		return false, "Blacklisted/reserved name."	
	end

	return true, name
end

meta.steamName = meta.steamName or meta.Name
function meta:SteamName()
	return self.steamName(self)
end

function meta:Name()
    return self:GetSyncVar(SYNC_RPNAME, self:SteamName())
end

function meta:KnownName()
	local custom = hook.Run("PlayerGetKnownName", self)
	return custom or self:GetSyncVar(SYNC_RPNAME, self:SteamName())
end

meta.GetName = meta.Name
meta.Nick = meta.Name
