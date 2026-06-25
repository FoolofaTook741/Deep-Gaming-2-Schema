function meta:GetCPFactionXP()
	return self:GetSyncVar(SYNC_CP_XP, 0)
end

if SERVER then
	function meta:SetCPFactionXP(amount)
		if not isnumber(amount) or amount < 0 or amount >= 1 / 0 then return end

		amount = math.floor(amount)

		local query = mysql:Update("impulse_players")
		query:Update("cp_xp", amount)
		query:Where("steamid", self:SteamID())
		query:Execute()

		return self:SetSyncVar(SYNC_CP_XP, amount, true)
	end

	function meta:AddCPFactionXP(amount)
		if not isnumber(amount) or amount <= 0 or amount >= 1 / 0 then return end
		if self:Team() != TEAM_CP then return end

		amount = math.floor(amount)

		local setAmount = self:GetCPFactionXP() + amount

		self:SetCPFactionXP(setAmount)

		hook.Run("PlayerGetCPFactionXP", self, amount)
	end
end