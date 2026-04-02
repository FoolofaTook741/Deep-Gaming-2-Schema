function PLUGIN:CreateSyncVars()
	SYNC_LOYALIST_LEVEL = impulse.Sync.RegisterVar(SYNC_INT)
end

local loyalistLevelCommand = {
    description = "(OCA/CP HC only) Changes a player's Loyalist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CA") < 1 then
			if ply:GetTeamWhitelist("TEAM_CP") < 6 then
				if !ply:IsSuperAdmin() then
    				ply:Notify("You cannot use this command.")
					return
				end
			end
    	end
		local ranktable = { "Neutral", "Tier I", "Tier II", "Tier III", "Tier IV", "Level V", "Level VI"}

        local steamid = arg[1]
		local level = arg[2]
		

		if level then
			level = tonumber(level)

			level = math.floor(level)
		else
			level = 0
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local targ = player.GetBySteamID(steamid)

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "TEAM_CITIZEN"

			if not type(result) == "table" or #result == 0 then
				ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
			else
				local inTable = impulse.Teams.GetWhitelist(steamid, teamName, function(exists)
					if not IsValid(ply) then
						return
					end
					
					if exists then
						if level == 0 then
							local query = mysql:Delete("impulse_whitelists")
							query:Where("steamid", steamid)
							query:Where("team", teamName)
							query:Execute()

							ply:Notify(steamid.." was removed from the Loyalist whitelist successfully.")
						else
							local query = mysql:Update("impulse_whitelists")
							query:Where("steamid", steamid)
							query:Where("team", teamName)
							query:Update("level", level)
							query:Execute()
							if level < 5 then
								ply:Notify(steamid.." has been set to the " .. ranktable[level + 1] .. " whitelist.")
							else
								ply:Notify(steamid.." has been set to Loyalist level " .. level .. ".")
							end
						end
					else
						if level != 0 then
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamName)
							query:Insert("steamid", steamid)
							query:Execute()	

							if level < 5 then
								ply:Notify(steamid.." has been set to the " .. ranktable[level + 1] .. " whitelist.")
							else
								ply:Notify(steamid.." has been set to Loyalist level " .. level .. ".")
							end
						end
					end

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						if level < 10 && level != 0 then
							targ:Notify("Your Loyalist faction rank has been edited to " .. ranktable[level + 1] .. " by supervisor "..ply:SteamName()..".")
						elseif level == 0 then
							targ:Notify("Your Loyalist faction rank has been removed, you are now at Tier 0 or Neutral.")
						else
							targ:Notify("Your Loyalist faction rank has been edited to level " .. level .. " by supervisor "..ply:SteamName()..".")
						end
					end
				end)
			end
		end)


		if targ and IsValid(targ) then
			if targ:Team() == TEAM_CITIZEN or targ:Team() == TEAM_CWU then
				targ:SetSyncVar(SYNC_LOYALIST_LEVEL, level, true)
			else
				targ:SetSyncVar(SYNC_LOYALIST_LEVEL, 0, true)
			end
		end
		query:Execute()

		local embeds = {{
			title = "Loyalist Rank Adjusted",
			description = "A user has given an order.",
			url = "https://pinnacle-gaming.xyz/news",
			color = 10181046,
			fields = {
				{
					name = "Supervisor:",
					value = ply:Name() .. "(" .. ply:SteamID() .. ")"
				},
				{
					name = "Citizen:",
					value = targ:Name() .. "(" .. targ:SteamID() .. ")"
				},
				{
					name = "Level:",
					value = tostring(level)
				},
			}
		}}
		
		ReqwestLog(embeds, DG_LYL)
    end
}

impulse.RegisterChatCommand("/loyalistlevel", loyalistLevelCommand)
