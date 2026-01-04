if SERVER then
	util.AddNetworkString("impulseHL2RPBioDeath")

	hook.Add("PlayerDeath", "impulseHL2RPBiosignal", function(victim)
		if victim:IsCP() and victim.impulseZone then
			local recipFilter = RecipientFilter()

			for v,k in pairs(player.GetAll()) do
				if k:IsCP() then
					recipFilter:AddPlayer(k)
				end
			end

			local rank = victim:GetTeamRank() or 0
			local jammed = victim:IsNearSignalJammer() or false


			net.Start("impulseHL2RPBioDeath")
			net.WriteUInt(victim:EntIndex(), 8)
			net.WriteUInt(victim.impulseZone, 8)
			net.WriteUInt(rank, 8)
			net.WriteUInt(victim:Team(), 8)
			net.WriteBool(jammed)
			net.Send(recipFilter)
		elseif victim:IsCP() then
			local recipFilter = RecipientFilter()

			for v,k in pairs(player.GetAll()) do
				if k:IsCP() then
					recipFilter:AddPlayer(k)
				end
			end

			local zone = 255
			local rank = victim:GetTeamRank() or 0
			local jammed = victim:IsNearSignalJammer() or false

			net.Start("impulseHL2RPBioDeath")
			net.WriteUInt(victim:EntIndex(), 8)
			net.WriteUInt(zone, 8)
			net.WriteUInt(rank, 8)
			net.WriteUInt(victim:Team(), 8)
			net.WriteBool(jammed)
			net.Send(recipFilter)
		end
	end)
end