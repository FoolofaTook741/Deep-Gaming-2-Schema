impulse.CommsNetWorkOn = true
impulse.SuperBoxRaid = false

local function DivisionalWhitelistLog(division, steamid, supervisor, rankLevel)
	FetchSteamName(steamid, function(name, err)
		local steamname = name or "Unknown"
		local rankStatus = (rankLevel == 1) and "Added" or "Removed"

		local embeds = {{
			title = "Divisional Whitelist",
			description = "User rank was changed.",
			url = "https://discord.com/channels/1149540724648456252/1438121921253478441",
			color = 16776960,
			fields = {
				{
					name = "User Rank Changed:",
					value = steamname .. " (" .. steamid .. ")"
				},
				{
					name = "Supervisor:",
					value = "**" .. supervisor:SteamName() .. "** | **" .. supervisor:Name() .. "** (" .. supervisor:SteamID() .. ")"
				},
				{
					name = "Division:",
					value = division
				},
				{
					name = "Status:",
					value = rankStatus
				}
			}
		}}

		ReqwestLog(embeds, PG_DIVISIONAL_WHITELIST)
	end)
end

local broadcastCommand = {
    description = "Send a message over the city broadcast system.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if (ply:GetPos() - impulse.Config.BroadcastPos):LengthSqr() > ((impulse.Config.BroadcastDistance or impulse.Config.WhisperDistance) ^ 2) then
            ply:Notify("You are not near the broadcasting station.")
            return
        end

        if not ply:HasInventoryItem("item_broadcastkey") then
            ply:Notify("The terminal looks like it needs a key to be used.")
            return
        end

        if impulse.CommsNetWorkOn == false or ply.IsRogue then
            ply:Notify("The broadcasting station dosen't appear to be working at this time..")
            return
        end

        for v, k in pairs(player.GetAll()) do
            if not k.IsRogue then
                k:SendChatClassMessage(50, rawText, ply)
            end
        end
    end
}

impulse.RegisterChatCommand("/broadcast", broadcastCommand)

local setgroupCommand = {
	description = "Assign a user group for a player. /setgroup steamid group .",
	requiresArg = true,
	requiesAlive = true,
	leadAdminOnly = true,
	onRun = function(ply, arg, rawText)
		local steamid = arg[1]
		local group = arg[2]
		local targ = impulse.FindPlayer(steamid)
		local targ64 = targ:SteamID64()
		local ply64 = ply:SteamID64()
		local groups = {"user", "donator", "gamemaster", "admin", "leadadmin"}
		local msg = ply:SteamName() .. " has assigned " .. targ:SteamName() .. " to group " .. group .. "."
		if not ply:IsSuperAdmin() then
			if groups[group] and group != "donator" then
				VyHub.Group:set(targ64, group, nil, ply64, nil)
				ply:Notify("Success.")
				VyHub.Util:print_chat_all(msg)
				VyHub.Group:set(targ64, group)
			else
				ply:Notify("Invalid group.")
			end
		else
			if groups[group] then
				VyHub.Group:set(targ64, group, nil, ply64, nil)
				ply:Notify("Success.")
				VyHub.Util:print_chat_all(msg)
				VyHub.Group:set(targ64, group)
			else
				ply:Notify("Invalid group.")
			end
		end

	end
}

impulse.RegisterChatCommand("/setgroup", setgroupCommand)

local applyCommand = {
	description = "Shows your citizen ID to nearby players.",
	requiresArg = false,
	requiresAlive = true,
	onRun = function(ply)
		local message = ply.ApplyLevel or 0
		--print(ply.ApplyLevel)
		if ply:Team() == TEAM_CITIZEN and ply:GetTeamWhitelist("TEAM_CITIZEN") >= 1 then
			message = ply:GetTeamWhitelist("TEAM_CITIZEN") or 0
		end
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then
				k:SendChatClassMessage(51, message, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/apply", applyCommand)

local radioCmdCommand = {
	description = "Send a radio message to all commanding units.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:IsCP() then
			if not ply:IsCPCommand() then
				ply:Notify("You must be a supervisor to use this.")
				return
			else
				rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
				for v,k in pairs(player.GetAll()) do
		   	   		if k:IsCPCommand() or k.SnooperMode == true then
						k:SendChatClassMessage(53, rawText, ply)
		   	   		end
				end
				for k,v in pairs(player.GetAll()) do
					if (v:GetPos():Distance(ply:GetPos()) < 100 and !v:IsCPCommand() and v != ply)  then
						v:SendChatClassMessage(53, rawText, ply)
					end
				end
				ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			end
		end
	end
}

impulse.RegisterChatCommand("/radiocmd", radioCmdCommand)
impulse.RegisterChatCommand("/rcmd", radioCmdCommand)

local rebelRadioCommand = {
	description = "Send a radio message to rebels on your frequency. Be wary of snitches...",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		local frequency = ply.Frequency
		if not ply.HasRadio and not ply.IsRogue then
			ply:Notify("You must have a radio or rebel suit to use this.")
			return
		elseif ply.Frequency < 1 or ply.Frequency > 10 then
			ply:Notify("You are not on a valid frequency.")
			return
		elseif not ply.Frequency then
			ply:Notify("You are not on a valid frequency.")
			return
		else
			rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
			for v,k in pairs(player.GetAll()) do
				if (!k:IsCP() and !k.IsRogue) and k.HasRadio then
		   			if k.Frequency == frequency then
						k:SendChatClassMessage(200 + frequency, rawText, ply)
		   			end
				elseif (COMMSTAP == frequency or COMMSTAP_2 == frequency) and ply:IsNearSignalJammer() != true then
					if k:Team() == TEAM_CP and k:GetTeamClass() == CLASS_GHOST then
						k:SendChatClassMessage(200 + frequency, rawText, ply)
					end
				elseif k:GetPos():Distance(ply:GetPos()) < 100 and k != ply then
					k:SendChatClassMessage(200 + frequency, rawText, ply)
				elseif k.SnooperMode == true then
					k:SendChatClassMessage(200 + frequency, rawText, ply)
				end
				ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			end
			if ply:IsNearAudioBug() and COMMSTAP != frequency and COMMSTAP_2 != frequency then
				for k,v in pairs(player.GetAll()) do
					if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
						if ply:IsNearSignalJammer() == false then
							v:SendChatClassMessage(74, rawText, ply)
						else
							rawText = "*SIGNAL JAMMED*"
							v:SendChatClassMessage(74, rawText, ply)
						end
					end
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/rr", rebelRadioCommand)

local frequencyCommand = {
	description = "Sets your rebel radio frequency.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg)
		local frequency = tonumber(arg[1])
		if frequency > 10 or frequency < 1 then
			ply:Notify("Frequencies must be between 1 and 10.")
			frequency = 1
			ply.Frequency = frequency
			return
		end
		if not ply.HasRadio then
			ply:Notify("You must have a radio to use this.")
			frequency = 1
			ply.Frequency = frequency
			return
		else
			frequency = tonumber(arg[1])
			if frequency > 10 or frequency < 1 then
				frequency = 1
			end
			ply.Frequency = frequency
			ply:Notify("You have set your frequency to: " .. frequency)
			return
		end
	end
}

impulse.RegisterChatCommand("/frequency", frequencyCommand)

local toggleForcefield = {
    description = "Enables/Disables forcefields near your position.",
    requiresArg = false,
    requiresAlive = true,
    onRun = function(ply, arg)
        local rank = ply:GetTeamRank() or 0
        if 	(ply:GetTeamClass() == CLASS_GRID and rank >= RANK_I4) or
   			(ply:GetTeamClass() == CLASS_ICT and rank >= RANK_SUPERVISOR and ply:Team() == TEAM_CWU) or
   			(ply:GetTeamClass() == CLASS_INDUST and rank >= RANK_SUPERVISOR and ply:Team() == TEAM_CWU) or
   			(ply:GetTeamClass() == CLASS_RESEARCH and rank >= RANK_EMPLOYEE and (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT)) or
   			(rank >= RANK_I2 and ply:Team() == TEAM_CP) or
   			(ply:Team() == TEAM_OTA) or
			(ply:Team() == TEAM_CA and rank >= RANK_REPRESENTATIVE) or
   			ply:IsAdmin() or
   			ply:IsCPCommand() then
                for k,v in pairs(ents.FindByClass("deep_forcefield")) do
                    if v:GetPos():Distance(ply:GetPos()) < 250 then
                        if v.Active == true and CurTime() > v.NextActivation then
                            v.Active = false
                            v:SetMaterial("Models/effects/vol_light001")
                            v:SetCollisionGroup(COLLISION_GROUP_WORLD)
                            v:SetNotSolid(true)
                            v:EmitSound("buttons/combine_button5.wav")
                            v.NextActivation = CurTime() + 4
                        elseif v.Active == false and CurTime() > v.NextActivation then
                            v.Active = true
                            v:SetMaterial("effects/combineshield/comshieldwall2")
                            v:SetCollisionGroup(COLLISION_GROUP_NONE)
                            v:SetNotSolid(false)
                            v:EmitSound("buttons/combine_button5.wav")
                            v.NextActivation = CurTime() + 4
                        end
                    end
                end
                for k,v in pairs(ents.FindByClass("deep_forcefield_small")) do
                    if v:GetPos():Distance(ply:GetPos()) < 250 then
                        if v.Active == true and CurTime() > v.NextActivation then
                            v.Active = false
                            v:SetMaterial("Models/effects/vol_light001")
                            v:SetCollisionGroup(COLLISION_GROUP_WORLD)
                            v:SetNotSolid(true)
                            v:EmitSound("buttons/combine_button5.wav")
                            v.NextActivation = CurTime() + 4
                        elseif v.Active == false and CurTime() > v.NextActivation then
                            v.Active = true
                            v:SetMaterial("effects/combineshield/comshieldwall2")
                            v:SetCollisionGroup(COLLISION_GROUP_NONE)
                            v:SetNotSolid(false)
                            v:EmitSound("buttons/combine_button5.wav")
                            v.NextActivation = CurTime() + 4
                        end
                    end
                end
                ply:Notify("Forcefield(s) toggled, if you did not see a change, each forcefield has a 4 second cooldown to be toggled to prevent spam.")
        else
            ply:Notify("You lack the permissions to control this forcefield.")
        end
    end
}

impulse.RegisterChatCommand("/ff", toggleForcefield)

local radioSquadCommand = {
	description = "Send a radio message to your squad.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if impulse.CommsNetWorkOn == false or ply.IsRogue then
			ply:Notify("The radio is not available at this time.")
		else
			local mySquad = ply:GetSyncVar(SYNC_SQUAD_ID)
			if ply:IsCP() and mySquad then
				rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText

				for v,k in pairs(player.GetAll()) do
					if k:Team() == ply:Team() and k:GetSyncVar(SYNC_SQUAD_ID, -1) == mySquad then
						k:SendChatClassMessage(55, rawText, ply)
					elseif k:GetPos():Distance(ply:GetPos()) < 100 and k != ply then
						k:SendChatClassMessage(55, rawText, ply)
					elseif k.SnooperMode == true then
						k:SendChatClassMessage(55, rawText, ply)
					end
				end
				ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			end
		end
	end
}

impulse.RegisterChatCommand("/radiosquad", radioSquadCommand)
impulse.RegisterChatCommand("/rs", radioSquadCommand)

local radioTeamCommand = {
	description = "Send a message to your team.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if impulse.CommsNetWorkOn == false or ply.IsRogue == true then
			ply:Notify("The radio is not available at this time.")
			return
		else
			rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_ZOMBIE or ply:Team() == TEAM_VORT or ply.IsRogue == true then
				return
			end

			if ply:Team() == TEAM_CWU then
				for k,v in pairs(player.GetAll()) do
					if (v:IsCP() and v:IsCPCommand()) or v:Team() == TEAM_CWU or (v:GetPos():Distance(ply:GetPos()) < 100 and v != ply) or v:Team() == TEAM_CA or v.SnooperMode == true then
						v:SendChatClassMessage(72, rawText, ply)
					end
				end
			end

			if ply:Team() == TEAM_CA then
				for k,v in pairs(player.GetAll()) do
					if (v:Team() == TEAM_CA or (v:GetPos():Distance(ply:GetPos()) < 100 and v != ply) or v.SnooperMode == true) and v.IsRogue != true then
						v:SendChatClassMessage(59, rawText, ply)
					end
				end
			end

			if ply:Team() == TEAM_CP then
				for v,k in pairs(player.GetAll()) do
					if (k:Team() == TEAM_CP or (k:GetPos():Distance(ply:GetPos()) < 100 and k != ply) or k.SnooperMode == true) and k.IsRogue != true then
						k:SendChatClassMessage(57, rawText, ply)
					end
				end
			end

			if ply:Team() == TEAM_OTA then
				for v,k in pairs(player.GetAll()) do
					if (k:Team() == TEAM_OTA or (k:GetPos():Distance(ply:GetPos()) < 100 and k != ply) or k.SnooperMode == true) and k.IsRogue != true then
						k:SendChatClassMessage(58, rawText, ply)
					end
				end
			end

			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
		end

	end
}

impulse.RegisterChatCommand("/rt", radioTeamCommand)
impulse.RegisterChatCommand("/radioteam", radioTeamCommand)

local vortCallCommand = {
	description = "Sends a long range message to all vortigaunts.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)

		for v,k in pairs(player.GetAll()) do
			if k:Team() == TEAM_VORT or k.SnooperMode == true then
				k:SendChatClassMessage(54, rawText, ply)
			end
		end

		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						rawText = "*Vortigaunt Noises*"
						v:SendChatClassMessage(74, rawText, ply)
					else
						rawText = "*SIGNAL JAMMED*"
						v:SendChatClassMessage(74, rawText, ply)
					end
				end
			end
		end

	end
}

impulse.RegisterChatCommand("/vc", vortCallCommand)

local ictRadioCommand = {
	description = "Sends a message on the I.C.T. response network.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if (ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_ICT) or (ply:IsCPCommand() and not k.IsRogue) or ply:SteamID() == "STEAM_0:0:64940229" then

			for v,k in pairs(player.GetAll()) do
				if ((((k:Team() == TEAM_CWU and k:GetTeamClass() == CLASS_ICT) or (k:Team() == TEAM_CWU and k:GetTeamRank() >= RANK_MINISTER)) or ply:IsCPCommand()) or (k:GetPos():Distance(ply:GetPos()) < 100 and k != ply) or k.SnooperMode == true) or k:SteamID() == "STEAM_0:0:64940229" then
					k:SendChatClassMessage(73, rawText, ply)
				end
			end
			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
		else
			ply:Notify("You cannot use this command.")
		end
	end
}

impulse.RegisterChatCommand("/ir", ictRadioCommand)

local radioCWU = {
	description = "Send a radio message to CWU.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if impulse.CommsNetWorkOn == false then
			ply:Notify("The radio is not available at this time.")
		else
			if (ply:IsCP() and ply:Team() == TEAM_CA and ply:GetTeamRank() >= RANK_REPRESENTATIVE) or (ply:Team() == TEAM_CWU) or (ply:IsCP() and ply:Team() == TEAM_CP and ply:GetTeamRank() == RANK_OFC) or (ply:IsCP() and ply:Team() == TEAM_OTA and ply:GetTeamRank() >= RANK_OCP) then
				rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
				if ply:Team() == TEAM_CA or ply:Team() == TEAM_CWU then
					for k,v in pairs(player.GetAll()) do
						if (v:IsCP() and v:IsCPCommand()) or v:Team() == TEAM_CWU or (v:GetPos():Distance(ply:GetPos()) < 100 and v != ply) or v:Team() == TEAM_CA or v.SnooperMode == true then
							v:SendChatClassMessage(72, rawText, ply)
						end
					end
				end
				ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			end
		end
	end
}

impulse.RegisterChatCommand("/cwradio", radioCWU)

local radioRND = {
    description = "Send a radio message to RND members.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if impulse.CommsNetWorkOn == false then
            ply:Notify("The radio is not available at this time.")
        else
            if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and ply:GetTeamClass() == CLASS_RESEARCH and ply:GetTeamRank() >= RANK_INTERN or
               (ply:Team() == TEAM_CA and ply:GetTeamRank() >= RANK_REPRESENTATIVE) or
			   (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_OFC) then
                rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
                for k,v in pairs(player.GetAll()) do
                    if (v:GetTeamClass() == CLASS_RESEARCH) or
                       v:Team() == TEAM_CA and ply:GetTeamRank() >= RANK_REPRESENTATIVE or
                       v.SnooperMode == true then
                        v:SendChatClassMessage(200, rawText, ply)
                    end
                end
                ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
            else
                ply:Notify("You don't have access to this radio.")
            end
        end
    end
}

impulse.RegisterChatCommand("/rndradio", radioRND)

local zombieCommand = {
	description = "Sends a long range message to all zombies.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)

		for v,k in pairs(player.GetAll()) do
			if k:Team() == TEAM_ZOMBIE or k.SnooperMode == true then
				k:SendChatClassMessage(100, rawText, ply)
			end
		end

		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						rawText = "*Zombie Sounds*"
						v:SendChatClassMessage(74, rawText, ply)
					else
						rawText = "*SIGNAL JAMMED*"
						v:SendChatClassMessage(74, rawText, ply)
					end
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/zomcomms", zombieCommand)
impulse.RegisterChatCommand("/zc", zombieCommand)

local swordWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the SWORD division.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CP") < 6 then
			ply:Notify("You cannot use this command.")
			return
		end

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CP_SpecOps"

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

							ply:Notify(steamid.." was removed from the SWORD successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for SWORD.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the SWORD whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your SWORD division whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("SWORD", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/swordwhitelist", swordWhitelistCommand)

local dispatchwhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the DISPATCH division.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CP") < 6 then
			ply:Notify("You cannot use this command.")
			return
		end

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "MPF_Dispatch"

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

							ply:Notify(steamid.." was removed from DISPATCH successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for DISPATCH.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the DISPATCH whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your DISPATCH division whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
    end
}

impulse.RegisterChatCommand("/dispatchwhitelist", dispatchwhitelistCommand)

local ghostWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the GHOST division.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CP") < 6 then
			ply:Notify("You cannot use this command.")
			return
		end

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CP_Investigator"

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

							ply:Notify(steamid.." was removed from the GHOST successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for GHOST.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the GHOST whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your GHOST division whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()

		DivisionalWhitelistLog("GHOST", steamid, ply, level)

    end
}

impulse.RegisterChatCommand("/ghostwhitelist", ghostWhitelistCommand)

local hactLicense = {
    description = "(Supervisor only) Whitelists a player for the HACT license.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CP") < 5 then
			ply:Notify("You cannot use this command.")
			return
		end

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CP_HactLicense"

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

							ply:Notify(steamid.." was removed from the HACT license registry.")
						else
							ply:Notify(steamid.." already has a HACT license.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the HACT license registry.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your HACT license has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("HACT-License", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/hactlicense", hactLicense)

local paybackWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the PAYBACK job. SteamID then 1 for add or 0 for remove. Supervisor only command.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if not ply:IsLeadAdmin() then
			if ply:GetTeamWhitelist("TEAM_OTA") < RANK_CTL then
				ply:Notify("You cannot use this command.")
				return
			end
		end -- wtf is lua doing idk

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CTA_PAYBACK"

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

							ply:Notify(steamid.." was removed from the PAYBACK whitelist successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for PAYBACK.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the PAYBACK whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your PAYBACK job whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("PAYBACK", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/paybackwhitelist", paybackWhitelistCommand)

local apfWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the SWEEPER division.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if not ply:IsLeadAdmin() then
			if ply:GetTeamWhitelist("TEAM_OTA") < RANK_CTL then
				ply:Notify("You cannot use this command.")
				return
			end
		end --

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CTA_SLASH"

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

							ply:Notify(steamid.." was removed from the SWEEPER successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for SWEEPER.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the SWEEPER whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your SWEEPER division whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("SWEEPER", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/apfwhitelist", apfWhitelistCommand)

local fistWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the FIST division.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if not ply:IsLeadAdmin() then
			if ply:GetTeamWhitelist("TEAM_OTA") < RANK_CTL then
				ply:Notify("You cannot use this command.")
				return
			end
		end --

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CTA_FIST"

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

							ply:Notify(steamid.." was removed from the FIST successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for FIST.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the FIST whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your FIST division whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("FIST", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/fistwhitelist", fistWhitelistCommand)

local scoutWhitelistCommand = {
    description = "(Supervisor only) Whitelists a player for the NOMAD job. SteamID then 1 for add or 0 for remove. Supervisor only command.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if not ply:IsLeadAdmin() then
			if ply:GetTeamWhitelist("TEAM_OTA") < RANK_CTL then
				ply:Notify("You cannot use this command.")
				return
			end
		end -- wtf is lua doing idk

        local steamid = arg[1]
		local level = arg[2]

		if level then
			level = tonumber(level)

			if not level or (level < 0 or level > 1) then
				return ply:Notify("The level must be a number 0-1.")
			end

			level = math.floor(level)
		else
			level = 1
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CTA_NOMAD"

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

							ply:Notify(steamid.." was removed from the NOMAD whitelist successfully.")
						else
							ply:Notify(steamid.." is already whitlisted for NOMAD.")
						end
					else
						local query = mysql:Insert("impulse_whitelists")
						query:Insert("level", 1)
						query:Insert("team", teamName)
						query:Insert("steamid", steamid)
						query:Execute()

						ply:Notify(steamid.." has been added to the NOMAD whitelist.")
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						targ:Notify("Your NOMAD job whitelist has been edited by faction leader "..ply:SteamName()..".")
					end
				end)
			end
		end)

		query:Execute()
		DivisionalWhitelistLog("NOMAD", steamid, ply, level)
    end
}

impulse.RegisterChatCommand("/nomadwhitelist", scoutWhitelistCommand)




local cwWhitelistCommand = {
    description = "(CW Supervisor only) Changes a player's Civic Workforce whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CW") < 2 and !ply:IsLeadAdmin() then
			return
    	end

        local steamid = arg[1]
		local level = arg[2]


		if level then
			level = tonumber(level)

			level = math.floor(level)
		else
			level = 0
		end

		if not ply:IsLeadAdmin() then
			if ply:GetTeamWhitelist("TEAM_CW") == 2 then
				if level > 1 then
					ply:Notify("You cannot whitelist higher than 1 at this rank.")
					return
				end
			elseif ply:GetTeamWhitelist("TEAM_CW") == 3 then
				if level > 2 then
					ply:Notify("You cannot whitelist higher than 2 at this rank.")
					return
				end
			elseif ply:GetTeamWhitelist("TEAM_CW") == 4 then
				if level > 3 then
					ply:Notify("You cannot whitelist higher than 4 at this rank.")
					return
				end
			end
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local teamName = "TEAM_CW"
		local newrank = (impulse.Teams.Data[TEAM_CWU].ranks[level + 1] and impulse.Teams.Data[TEAM_CWU].ranks[level + 1].name) or "Invalid Rank"
		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

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

							ply:Notify(steamid.." was removed from the MPF whitelist successfully.")
						else
							local query = mysql:Update("impulse_whitelists")
							query:Where("steamid", steamid)
							query:Where("team", teamName)
							query:Update("level", level)
							query:Execute()
							if level < 10 then
								ply:Notify(steamid.." has been set to the " .. newrank .. " whitelist.")
							else
								ply:Notify(steamid.." has been set to CW level " .. level .. ".")
							end
						end
					else
						if level != 0 then
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamName)
							query:Insert("steamid", steamid)
							query:Execute()

							if level < 6 then
								ply:Notify(steamid.." has been set to the " .. newrank .. " whitelist.")
							else
								ply:Notify(steamid.." has been set to CW level " .. level .. ".")
							end
						end
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						if level < 6 && level != 0 then
							targ:Notify("Your CW faction rank has been edited to " .. newrank .. " by supervisor "..ply:SteamName()..".")
						elseif level == 0 then
							targ:Notify("Your CW faction rank has been removed, you are now an Intern.")
						else
							targ:Notify("Your CW faction rank has been edited to level " .. level .. " by supervisor "..ply:SteamName()..".")
						end
					end
				end)
			end
		end)

		query:Execute()
		FetchSteamName(steamid, function(name, err)
			local steamname = name or "Unknown"
			local embeds = {{
				title = "C.W. Rank Changed",
				description = "User rank was changed.",
				url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
				color = 1752220,
				fields = {
					{
						name = "Method:",
						value = "Chat Command"
					},
					{
						name = "User Rank Changed:",
						value = steamname .. " (" .. steamid .. ")"
					},
					{
						name = "Supervisor:",
						value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID() .. ")"
					},
					{
						name = "Division:",
						value = "Civic Workforce"
					},
					{
						name = "Rank:",
						value = newrank .. " (" .. level .. ")"
					},
				}
			}}
			ReqwestLog(embeds, DG_CWWH)
		end)
    end
}

impulse.RegisterChatCommand("/cwwhitelist", cwWhitelistCommand)

local researchWhitelistCommand = {
    description = "(CW Supervisor only) Changes a player's Civic Workforce whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CW") < 4 and ply:GetTeamWhitelist("TEAM_VORT") < 4 and !ply:IsLeadAdmin() then
			return
    	end
		local ranktable = { "Intern", "Employee", "Supervisor", "Director", "Minister" }

        local steamid = arg[1]
		local level = arg[2]


		if level then
			level = tonumber(level)

			level = math.floor(level)
		else
			level = 0
		end

		if level < 0 then
			level = 0
		end
		if level > 1 then
			level = 1
		end
		if ply:GetTeamWhitelist("TEAM_CW") < 4 and ply:GetTeamWhitelist("TEAM_VORT") < 4 and !ply:IsLeadAdmin() then
    			ply:Notify("You cannot use this command.")
    		return
		end

		if steamid:len() > 25 then
			return ply:Notify("SteamID too long.")
		end

		local newrank = (ranktable[level]) or "Invalid Rank"

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "CW_Research"

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

							ply:Notify(steamid.." was removed from the Research whitelist successfully.")
						else
							local query = mysql:Update("impulse_whitelists")
							query:Where("steamid", steamid)
							query:Where("team", teamName)
							query:Update("level", level)
							query:Execute()
							--impulse.debugPrint("1")
							ply:Notify(steamid.." has been given the Research Team whitelist.")
						end
					else
						if level != 0 then
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamName)
							query:Insert("steamid", steamid)
							query:Execute()
							--impulse.debugPrint("2")
							ply:Notify(steamid.." has been given the Research whitelist.")
						end
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						if level == 0 then
							targ:Notify("Your Research Team rank has been removed.")
						else
							targ:Notify("You have been whitelisted for the CW Research Team.")
						end
					end
				end)
			end
		end)

		local newwhitelist = "Added"
		if level == 0 then
			newwhitelist = "Removed"
		end
		query:Execute()
		FetchSteamName(steamid, function(name, err)
			local steamname = name or "Unknown"
			local embeds = {{
				title = "Research Whitelist Changed",
				description = "User rank was changed.",
				url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
				color = 1752220,
				fields = {
					{
						name = "Method:",
						value = "Chat Command"
					},
					{
						name = "User Whitelist Changed:",
						value = "**" .. steamname .. "** (" .. steamid .. ")"
					},
					{
						name = "Supervisor:",
						value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID() .. ")"
					},
					{
						name = "Division:",
						value = "Research Team"
					},
					{
						name = "Rank:",
						value = newwhitelist
					},
				}
			}}

			ReqwestLog(embeds, DG_CWWH)
		end)
    end
}

impulse.RegisterChatCommand("/researchwhitelist", researchWhitelistCommand)

local function getRankNameByWhitelistLevel(teamTable, whitelistLevel)
    for _, rank in pairs(teamTable.ranks) do
        if rank.whitelistLevel == whitelistLevel or (whitelistLevel == 0 and rank.whitelistLevel == nil) then
            return rank.name
        end
    end

    return "Invalid Rank"
end

local cpWhitelistCommand = {
    description = "(Supervisor only) Changes a player's Civil Protection whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        if ply:GetTeamWhitelist("TEAM_CP") < 4 and not ply:IsLeadAdmin() then
            ply:Notify("You cannot use this command.")
            return
        end

        local steamid = arg[1]
        local level = tonumber(arg[2]) or 0
        level = math.floor(level)

        if not ply:IsLeadAdmin() then
            local maxLevels = { [4] = 1, [5] = 4, [6] = 5, [7] = 6, [8] = 7, [9] = 8, [10] = 10 }
            local maxAllowed = maxLevels[ply:GetTeamWhitelist("TEAM_CP")] or math.huge
            if level > maxAllowed then
                ply:Notify("You cannot whitelist higher than the allowed rank at this rank.")
                return
            end
        end

        if steamid:len() > 25 then
            return ply:Notify("SteamID too long.")
        end

        local query = mysql:Select("impulse_players")
        query:Select("id")
        query:Where("steamid", steamid)
        query:Callback(function(result)
            if not IsValid(ply) then return end

            local teamName = "TEAM_CP"
            if type(result) ~= "table" or #result == 0 then
                ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
            else
                impulse.Teams.GetWhitelist(steamid, teamName, function(exists)
                    if not IsValid(ply) then return end

                    if exists then
                        local query = level == 0 and mysql:Delete("impulse_whitelists") or mysql:Update("impulse_whitelists")
                        query:Where("steamid", steamid)
                        query:Where("team", teamName)
                        if level > 0 then query:Update("level", level) end
                        query:Execute()
                    else
                        if level > 0 then
                            local query = mysql:Insert("impulse_whitelists")
                            query:Insert("level", level)
                            query:Insert("team", teamName)
                            query:Insert("steamid", steamid)
                            query:Execute()
                        end
                    end
					local rankName = getRankNameByWhitelistLevel(impulse.Teams.Data[TEAM_CP], level) or "Unknown"
                    local targ = player.GetBySteamID(steamid)
                    if targ and IsValid(targ) then
                        targ:SetupWhitelists()
                        targ:Notify("Your MPF faction rank has been edited to " .. rankName .. " by supervisor " .. ply:SteamName() .. ".")
                    end
					ply:Notify(steamid.." has been set to the " .. rankName .. " whitelist.")
                end)
            end
        end)
        query:Execute()

        local newrank = getRankNameByWhitelistLevel(impulse.Teams.Data[TEAM_CP], level)
		FetchSteamName(steamid, function(name, err)
			local steamname = name or "Unknown"
			local embeds = {{
				title = "Rank Changed",
				description = "User rank was changed.",
				url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
				color = 16776960,
				fields = {
					{ name = "Method:", value = "Chat Command" },
					{ name = "User Rank Changed:", value = steamname .. " (" .. steamid .. ")" },
					{ name = "Supervisor:", value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID() .. ")" },
					{ name = "Division:", value = "Metro Police Force" },
					{ name = "Rank:", value = newrank },
				}
			}}
			ReqwestLog(embeds, DG_PMWH)
		end)
    end
}

impulse.RegisterChatCommand("/cpwhitelist", cpWhitelistCommand)

local otaWhitelistCommand = {
    description = "(Supervisor only) Changes a player's CTA whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        if ply:GetTeamWhitelist("TEAM_OTA") < 3 and not ply:IsLeadAdmin() then
            ply:Notify("You cannot use this command.")
            return
        end

        local steamid = arg[1]
        local level = tonumber(arg[2]) or 0
        level = math.floor(level)

        if not ply:IsLeadAdmin() then
            local maxLevels = { [3] = 2, [4] = 3, [5] = 4, [6] = 6 }
            local maxAllowed = maxLevels[ply:GetTeamWhitelist("TEAM_OTA")] or math.huge
            if level > maxAllowed then
                ply:Notify("You cannot whitelist higher than the allowed rank at this rank.")
                return
            end
        end

        if steamid:len() > 25 then
            return ply:Notify("SteamID too long.")
        end

        local query = mysql:Select("impulse_players")
        query:Select("id")
        query:Where("steamid", steamid)
        query:Callback(function(result)
            if not IsValid(ply) then return end

            local teamName = "TEAM_OTA"
            if type(result) ~= "table" or #result == 0 then
                ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
            else
                impulse.Teams.GetWhitelist(steamid, teamName, function(exists)
                    if not IsValid(ply) then return end

                    if exists then
                        local query = level == 0 and mysql:Delete("impulse_whitelists") or mysql:Update("impulse_whitelists")
                        query:Where("steamid", steamid)
                        query:Where("team", teamName)
                        if level > 0 then query:Update("level", level) end
                        query:Execute()
                    else
                        if level > 0 then
                            local query = mysql:Insert("impulse_whitelists")
                            query:Insert("level", level)
                            query:Insert("team", teamName)
                            query:Insert("steamid", steamid)
                            query:Execute()
                        end
                    end
					local rankName = getRankNameByWhitelistLevel(impulse.Teams.Data[TEAM_OTA], level)
                    local targ = player.GetBySteamID(steamid)
                    if targ and IsValid(targ) then
                        targ:SetupWhitelists()
                        targ:Notify("Your CTA faction rank has been edited to " .. rankName .. " by supervisor " .. ply:SteamName() .. ".")
                    end
					ply:Notify(steamid.." has been set to the " .. rankName .. " whitelist.")
                end)
            end
        end)
        query:Execute()

        local newrank = getRankNameByWhitelistLevel(impulse.Teams.Data[TEAM_OTA], level)
		FetchSteamName(steamid, function(name, err)
			local steamname = name or "Unknown"
			local embeds = {{
				title = "Rank Changed",
				description = "User rank was changed.",
				url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
				color = 16776960,
				fields = {
					{ name = "Method:", value = "Chat Command" },
					{ name = "User Rank Changed:", value = steamname .. " (" .. steamid .. ")" },
					{ name = "Supervisor:", value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID() .. ")" },
					{ name = "Division:", value = "Combine Transhuman Arm" },
					{ name = "Rank:", value = newrank },
				}
			}}
			ReqwestLog(embeds, DG_PMWH)
		end)
    end
}

impulse.RegisterChatCommand("/otawhitelist", otaWhitelistCommand)

local cwMenuCommand = {
    description = "(Supervisor only) Changes a player's Civic Workforce whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		if ply:IsCWSupervisor() then
			net.Start("DeepOpenCWMenu")
			net.Send(ply)
		end
	end
}

impulse.RegisterChatCommand("/cwmenu", cwMenuCommand)

local caWhitelistCommand = {
    description = "(Supervisor only) Changes a player's Civil Protection whitelist level. Args STEAMID NUMBER.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
    	if ply:GetTeamWhitelist("TEAM_CA") < 3 then
			if !ply:IsLeadAdmin() then
    			ply:Notify("You cannot use this command.")
				return
			end
    	end

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

		local query = mysql:Select("impulse_players")
		query:Select("id")
		query:Where("steamid", steamid)
		query:Callback(function(result)
			if not IsValid(ply) then
				return
			end

			local teamName = "TEAM_CA"

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

							ply:Notify(steamid.." was removed from the OCA whitelist successfully.")
						else
							local query = mysql:Update("impulse_whitelists")
							query:Where("steamid", steamid)
							query:Where("team", teamName)
							query:Update("level", level)
							query:Execute()
							local rank = impulse.Teams.Data[TEAM_CA].ranks[level + 1] and impulse.Teams.Data[TEAM_CA].ranks[level + 1].name or "Unknown"
							ply:Notify(steamid.." has been set to the " .. rank .. " whitelist.")
						end
					else
						if level != 0 then
							local query = mysql:Insert("impulse_whitelists")
							query:Insert("level", level)
							query:Insert("team", teamName)
							query:Insert("steamid", steamid)
							query:Execute()

							local rank = impulse.Teams.Data[TEAM_CA].ranks[level + 1] and impulse.Teams.Data[TEAM_CA].ranks[level + 1].name or "Unknown"
							ply:Notify(steamid.." has been set to the " .. rank .. " whitelist.")
						end
					end

					local targ = player.GetBySteamID(steamid)

					if targ and IsValid(targ) then
						targ:SetupWhitelists()
						local rank = impulse.Teams.Data[TEAM_CA].ranks[level + 1] and impulse.Teams.Data[TEAM_CA].ranks[level + 1].name or "Unknown"
						if level < 10 and level != 0 then
							targ:Notify("Your OCA faction rank has been edited to " .. rank .. " by supervisor "..ply:SteamName()..".")
						elseif level == 0 then
							targ:Notify("Your OCA faction rank has been removed, you are now an Assistant.")
						else
							targ:Notify("Your OCA faction rank has been edited to level " .. level .. " by supervisor "..ply:SteamName()..".")
						end
					end
				end)
			end
		end)

		query:Execute()
		local rank = impulse.Teams.Data[TEAM_CA].ranks[level + 1] and impulse.Teams.Data[TEAM_CA].ranks[level + 1].name or "Unknown"
		FetchSteamName(steamid, function(name, err)
			local steamname = name or "Unknown"
			local embeds = {{
				title = "Rank Changed",
				description = "User rank was changed.",
				url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
				color = 16776960,
				fields = {
					{ name = "Method:", value = "Chat Command" },
					{ name = "User Rank Changed:", value = steamname .. " (" .. steamid .. ")" },
					{ name = "Supervisor:", value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID() .. ")" },
					{ name = "Division:", value = "Office of City Administration" },
					{ name = "Rank:", value = rank .. " (" .. level .. ")" },
				}
			}}
			ReqwestLog(embeds, DG_PMWH)
		end)
    end
}

impulse.RegisterChatCommand("/cawhitelist", caWhitelistCommand)

local setXPCommand = {
	description = "Sets a players XP.",
	requiresArg = true,
	requiresAlive = true,
	superAdminOnly = true,
	onRun = function(ply, arg, rawText)
		if ply:IsSuperAdmin() then
			local targetName = arg[1]
			local amount = tonumber(arg[2])
			local targ = impulse.FindPlayer(targetName)
			targ:SetXP(amount)
			ply:Notify("You have set " .. targetName .. "'s XP to " .. amount .. ".")
		else
			ply:Notify("You cannot use this command.")
		end
	end
}

impulse.RegisterChatCommand("/setxp", setXPCommand)

local setcXPCommand = {
	description = "Sets a players crafting XP.",
	requiresArg = true,
	requiresAlive = true,
	superAdminOnly = true,
	onRun = function(ply, arg, rawText)
		if ply:SteamID() != "STEAM_0:0:104958683" then
			ply:Notify("You cannot use this command.")
			return
		else
			local steamid = arg[1]
			local amount = tonumber(arg[2])
			local targ = player.GetBySteamID(steamid)
			targ:SetSkillXP("craft", amount)
			ply:Notify("You have set " .. steamid .. "'s crafting XP to " .. amount .. ".")
		end
	end
}

impulse.RegisterChatCommand("/setcxp", setcXPCommand)

local setArmorCommand = {
	description = "Sets a players crafting XP.",
	requiresArg = true,
	requiresAlive = true,
	adminOnly = true,
	onRun = function(ply, arg, rawText)
		local steamid = arg[1]
		local amount = tonumber(arg[2])
		local targ = player.GetBySteamID(steamid)
		if not amount then return end
		if amount < 0 then
			return ply:Notify("Must be equal to or over 0.")
		end
		targ:SetArmor(amount)
	end
}

impulse.RegisterChatCommand("/setarmor", setArmorCommand)

local function SpawnLVSVehicle( className, pos, ang )
    local entTable = list.Get("SpawnableEntities")[ className ]
    if not entTable then
        ErrorNoHalt("[LVS] No vehicle definition for '".. className .."'\n")
        return
    end

    local ent = ents.Create( className )
    if not IsValid(ent) then
        ErrorNoHalt("[LVS] ents.Create failed for '".. className .."'\n")
        return
    end

    if entTable.KeyValues then
        for key, val in pairs( entTable.KeyValues ) do
            ent:SetKeyValue( key, val )
        end
    end

    ent:SetPos( pos )
    ent:SetAngles( ang or Angle(0,0,0) )
    ent:Spawn()
    ent:Activate()

    return ent
end

local function spawnAPC(ply)
    if OCAAB_CUR_FUNDS < 2000 then
        ply:Notify("Insufficient funds. 2000 credits required to spawn an APC.")
        return
    end

    if IsValid(ply.RazorVehicle) then
        ply.RazorVehicle:Remove()
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 2000
    end
    if IsValid(ply.Hunter) then
        ply.Hunter:Remove()
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 4000
    end

    local armedAPCs = table.Count(ents.FindByClass("lvs_wheeldrive_hl2_combine_apc_armed"))
    local regularAPCs = table.Count(ents.FindByClass("lvs_wheeldrive_hl2_combine_transport_hla"))
    local vehicleClass = ply:Team() == TEAM_OTA and "lvs_wheeldrive_hl2_combine_apc_armed" or "lvs_wheeldrive_hl2_combine_transport_hla"

    if (vehicleClass == "lvs_wheeldrive_hl2_combine_apc_armed" and armedAPCs >= 2) or
       (vehicleClass == "lvs_wheeldrive_hl2_combine_transport_hla" and regularAPCs >= 2) then
        ply:Notify("APC Deployment has currently reached maximum capacity for your class.")
        return
    end

    local spawnPos = ply:GetEyeTrace().HitPos
    if not util.IsInWorld(spawnPos) then
        ply:Notify("Invalid spawn position. Please aim at a valid surface.")
        return
    end

    ply:Notify("Spawning vehicle. 2000 credits deducted from the treasury.")
    timer.Create(ply:SteamID() .. "apcspawncooldown", 3, 1, function() end)

    timer.Simple(3, function()
        if not IsValid(ply) then return end
        local vehicle = SpawnLVSVehicle(vehicleClass, spawnPos, Angle(0, 0, 0))
        if not IsValid(vehicle) then
            ply:Notify("Failed to spawn APC. Vehicle class may be invalid.")
            return
        end
        ply.RazorVehicle = vehicle
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - 2000
    end)

    for _, v in pairs(player.GetAll()) do
        if v:IsCP() and IsValid(v) then
            timer.Simple(0.5, function()
                if IsValid(v) then
                    v:EmitSound("npc/overwatch/radiovoice/attention.wav")
                    v:SendCombineMessage(ply:Name() .. " HAS PURCHASED AN APC.", Color(150, 150, 150))
                end
            end)
        end
    end
end

local razorSpawnCar = {
    description = "(NOMAD/GRID) Spawns an APC.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
        if timer.Exists(ply:SteamID() .. "apcspawncooldown") then
            ply:Notify("APC spawn is on cooldown. Please wait.")
            return
        end

        if ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_NOMAD then
            spawnAPC(ply)
            return
        end

        if ply:Team() == TEAM_CP and ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2 then
            impulse.Teams.GetWhitelist(ply:SteamID(), "CP_HactLicense", function(level)
                if not level then
                    ply:Notify("You must have a HACT License to spawn an APC.")
                    return
                end
                spawnAPC(ply)
            end)
            return
        end

        ply:Notify("You must be a NOMAD or GRID (I2+) to spawn an APC.")
    end
}

impulse.RegisterChatCommand("/apcspawn", razorSpawnCar)

local razorCarRemove = {
	description = "(NOMAD/GRID) Despawns the APC.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
    	if ((ply:Team() == TEAM_OTA) and (ply:GetTeamClass() == CLASS_NOMAD)) or (ply:Team() == TEAM_CP and ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2) then -- wtf is lua doing idk
			if IsValid(ply.RazorVehicle) then
				ply.RazorVehicle:Remove()
				OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 2000
			end
			ply:Notify("Removing vehicle. 2000 credits added to the treasury.")
    	end
	end
}
impulse.RegisterChatCommand("/apcremove", razorCarRemove)

local hunterSpawnCommand = {
    description = "(NOMAD Only) Spawns the Hunter.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
        if timer.Exists(ply:SteamID() .. "hunterspawncooldown") then
            ply:Notify("Hunter spawn is on cooldown. Please wait.")
            return
        end
        if not ((ply:Team() == TEAM_OTA) and (ply:GetTeamClass() == CLASS_NOMAD)) then
            ply:Notify("You must be a Nomad (OTA) to spawn a Hunter.")
            return
        end
        if OCAAB_CUR_FUNDS < 4000 then
            ply:Notify("Insufficient funds. 4000 credits required to spawn a Hunter.")
            return
        end
        if IsValid(ply.RazorVehicle) then
            ply.RazorVehicle:Remove()
            OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 2000
        end
        if IsValid(ply.Hunter) then
            ply.Hunter:Remove()
            OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 4000
        end
        local spawnPos = ply:GetEyeTrace().HitPos
        if not util.IsInWorld(spawnPos) then
            ply:Notify("Invalid spawn position. Please aim at a valid surface.")
            return
        end
        ply:Notify("Spawning Hunter. 4000 credits deducted from the treasury.")
        timer.Create(ply:SteamID() .. "hunterspawncooldown", 3, 1, function() end)
        timer.Simple(3, function()
            if not IsValid(ply) then return end
            local hunter = ents.Create("gw_hunter")
            if not IsValid(hunter) then
                ply:Notify("Failed to spawn Hunter. Entity may be invalid.")
                return
            end
            hunter:SetPos(spawnPos)
            hunter:Spawn()
            ply.Hunter = hunter
            OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - 4000
        end)
        for _, v in pairs(player.GetAll()) do
            if (v:IsCPCommand() or v:Team() == TEAM_CA) and IsValid(v) then
                timer.Simple(0.5, function()
                    if IsValid(v) then
                        v:EmitSound("npc/overwatch/radiovoice/attention.wav")
                        v:SendCombineMessage(ply:Name() .. " HAS DEPLOYED A HUNTER.", Color(120, 120, 120))
                    end
                end)
            end
        end
    end
}
impulse.RegisterChatCommand("/hunterspawn", hunterSpawnCommand)

local hunterRemoveCommand = {
	description = "(NOMAD Only) Despawns the Hunter.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
    	if (ply:Team() == TEAM_OTA) and (ply:GetTeamClass() == CLASS_NOMAD) then -- wtf is lua doing idk
			if IsValid(ply.Hunter) then
				ply.Hunter:Remove()
				OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 4000
			end
			ply:Notify("Removing vehicle. 4000 credits added to the treasury.")
    	end
	end
}
impulse.RegisterChatCommand("/hunteremove", hunterRemoveCommand)

local setModelCommand = {
    description = "Sets model of the specified player.",
    requiresArg = true,
    gameMasterOnly = true,
    onRun = function(ply, arg, rawText)
		if not ply:IsGameMaster() then
			ply:Notify("You cannot use this command.")
		else
        	local targ = impulse.FindPlayer(arg[1])
        	local model = arg[2]

        	for k,v in ipairs(arg) do
        	    if k == 1 or k == 2 then
        	        continue
        	    end

        	    model = model .. " " .. v
        	end

        	if not model then
        	    return
        	end

        	if targ and IsValid(targ) then
        	    targ:SetModel(model)
        	    ply:Notify("You have set "..targ:Nick().."'s model to "..model..".")

        	    if targ == ply then
        	        for v,k in pairs(player.GetAll()) do
        	            if k:IsLeadAdmin() then
        	                k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." set their model to "..model..".")
        	            end
        	        end
        	    end
        	else
        	    return ply:Notify("Could not find player: "..tostring(arg[1]))
        	end
		end
    end
}

impulse.RegisterChatCommand("/setmodel", setModelCommand)

local destalkerizeCommand = {
    description = "Sets model of the specified player.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		if not ply:IsAdmin() then
			ply:Notify("You cannot use this command.")
		else
        	local targ = impulse.FindPlayer(arg[1])
			local sid = targ:SteamID()
        	if targ:Team() == TEAM_STALKER or timer.Exists(sid .. "stalkerization") then
				timer.Remove(sid.."stalkerization")
				timer.Remove(sid.."StalkerUpdate")
				targ:SetTeam(TEAM_CITIZEN)
				ply:Notify("You have destalkerized " .. targ:SteamName() )
				targ:Notify("You have been destalkerized by an admin." )
			end
		end
    end
}

impulse.RegisterChatCommand("/destalkerize", destalkerizeCommand)

local hicomRadio = {
	description = "(HiCom Radio) Send a radio message to high command operatives.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if ((ply:Team() == TEAM_OTA and ply:GetTeamRank() >= RANK_ORD) or (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_DVL) or (ply:Team() == TEAM_CA and ply:GetTeamRank() >= RANK_CA)) then
			for v,k in pairs(player.GetAll()) do
				if k:GetTeamClass() and ((k:Team() == TEAM_OTA and k:GetTeamRank() >= RANK_ORD) or (k:Team() == TEAM_CP and k:GetTeamRank() >= RANK_DVL) or (k:Team() == TEAM_CA and k:GetTeamRank() >= RANK_CA)) or k.SnooperMode == true then
					k:SendChatClassMessage(60, rawText, ply)
				end
			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			end
		end
	end
}

impulse.RegisterChatCommand("/hc", hicomRadio)


local ghostRadio = {
	description = "(Ghost Radio) Sends a radio message to all ghost operatives.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if (ply:Team() == TEAM_CP and ply:GetTeamClass() == CLASS_GHOST) then
			for v,k in pairs(player.GetAll()) do
				if k:GetTeamClass() and ((k:Team() == TEAM_CP and k:GetTeamClass() == CLASS_GHOST) or k.SnooperMode == true) then
					k:SendChatClassMessage(6969, rawText, ply)
				end
			end
			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
		end
	end
}

impulse.RegisterChatCommand("/ghost", ghostRadio)

local recentdisconnects = {
    description = "Prints the recent disconnected users info to your console.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply)
		if ply:IsAdmin() then
        	net.Start("DGRecentDCs")
			net.WriteTable(recentdcs)
			net.Send(ply)
		end
    end
}

impulse.RegisterChatCommand("/recentdcs", recentdisconnects)

local setNameCommand = {
    description = "Sets name of the specified player.",
    requiresArg = true,
    gameMasterOnly = true,
    onRun = function(ply, arg, rawText)
		if ply:IsAdmin() or ply:IsGameMaster() then
        	local targ = impulse.FindPlayer(arg[1])
        	local name = arg[2]

        	for k,v in ipairs(arg) do
        	    if k == 1 or k == 2 then
        	        continue
        	    end

        	    name = name .. " " .. v
        	end

        	if not name then
        	    return
        	end

        	if targ and IsValid(targ) then
        	    targ:SetRPName(name)
        	    ply:Notify("You have set "..targ:SteamName().."'s name to "..name..".")

        	    if targ == ply then
        	        for v,k in pairs(player.GetAll()) do
        	            if k:IsLeadAdmin() then
        	                k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." set their name to "..name..".")
        	            end
        	        end
        	    end
        	else
        	    return ply:Notify("Could not find player: "..tostring(arg[1]))
        	end
		end
    end
}

impulse.RegisterChatCommand("/setname", setNameCommand)

local meritCommand = {
    description = "Gives a merit to a player.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		if ply:IsCPCommand() then
        	local targ = impulse.FindPlayer(arg[1])

			local teamtext = "Metro Police Force"
			if not targ:IsCP() then
				ply:Notify("You can only merit Combine.")
				return
			end
			if targ:Team() != ply:Team() then
				ply:Notify("You can only merit men in your division.")
				return
			end

			if ply:Team() == TEAM_OTA then
				teamtext = "Transhuman Arm"
			elseif ply:Team() == TEAM_CA then
				teamtext = "City Administration"
			end
			ply:Notify("Merit issued.")

        	local embeds = {{
				title =  teamtext .. " Merit Issued",
				description = "A user has given an order.",
				url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
				color = 5763719,
				fields = {
					{
						name = "Supervisor:",
						value = ply:Name() .. " - " .. ply:SteamID()
					},
					{
						name = "Unit:",
						value = targ:Name() .. " - " .. targ:SteamID()
					},
					{
						name = "Merit:",
						value = rawText
					},
				}
			}}

			ReqwestLog(embeds, DG_MER)
		end
    end
}

impulse.RegisterChatCommand("/merit", meritCommand)

local demeritCommand = {
    description = "Gives a demerit to a player.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		if ply:IsCPCommand() then
        	local targ = impulse.FindPlayer(arg[1])

			local teamtext = "Metro Police Force"
			if not targ:IsCP() then
				ply:Notify("You can only merit Combine.")
				return
			end
			if targ:Team() != ply:Team() then
				ply:Notify("You can only merit men in your division.")
				return
			end

			if ply:Team() == TEAM_OTA then
				teamtext = "Transhuman Arm"
			elseif ply:Team() == TEAM_CA then
				teamtext = "City Administration"
			end

			ply:Notify("Demerit issued.")

        	local embeds = {{
				title =  teamtext .. " Demerit Issued",
				description = "A user has given an order.",
				url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
				color = 15548997,
				fields = {
					{
						name = "Supervisor:",
						value = ply:Name() .. " - " .. ply:SteamID()
					},
					{
						name = "Unit:",
						value = targ:Name() .. " - " .. targ:SteamID()
					},
					{
						name = "Merit:",
						value = rawText
					},
				}
			}}

			ReqwestLog(embeds, DG_DMER)
		end
    end
}

impulse.RegisterChatCommand("/demerit", demeritCommand)

local trainingMeritCommand = {
    description = "Gives a training merit to a player.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		if ply:IsCPCommand() or (ply:Team() == TEAM_OTA and ply.GetTeamRank and ply:GetTeamRank() >= RANK_ECS) then
        	local targ = impulse.FindPlayer(arg[1])

			local teamtext = "Metro Police Force"
			if not targ:IsCP() then
				ply:Notify("You can only merit Combine.")
				return
			end

			if ply:Team() == TEAM_OTA then
				teamtext = "Transhuman Arm"
			elseif ply:Team() == TEAM_CA then
				teamtext = "City Administration"
			end

			ply:Notify("Merit issued.")

        	local embeds = {{
				title =  teamtext .. " Training Merit Issued",
				description = "A user has given an order.",
				url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
				color = 5793266,
				fields = {
					{
						name = "Supervisor:",
						value = ply:Name() .. " - " .. ply:SteamID()
					},
					{
						name = "Unit:",
						value = targ:Name() .. " - " .. targ:SteamID()
					},
					{
						name = "Merit:",
						value = rawText
					},
				}
			}}

			ReqwestLog(embeds, DG_TMER)
		end
    end
}

impulse.RegisterChatCommand("/trainingmerit", trainingMeritCommand)

local setNoTargetCommand = {
    description = "Sets a player to no target or off of no target (immune from NPCs).",
	gameMasterOnly = true,
    requiresArg = true,
    adminOnly = false,
    onRun = function(ply, arg)
		if ply:IsGameMaster() or ply:IsAdmin() then
        	local targ = impulse.FindPlayer(arg[1])


        	if targ and IsValid(targ) then
				if ply:IsFlagSet(FL_NOTARGET) then
					targ:SetNoTarget(false)
					ply:Notify("You have turned off no target for: "..targ:Nick().. ".")
				else
        	    	targ:SetNoTarget(true)
        	    	ply:Notify("You have turned on no target for: "..targ:Nick().. ".")
				end

        	    if targ == ply then
        	        for v,k in pairs(player.GetAll()) do
        	            if k:IsLeadAdmin() then
        	                k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." toggled no target.")
        	            end
        	        end
        	    end
        	else
        	    return ply:Notify("Could not find player: "..tostring(arg[1]))
        	end
		else
			ply:Notify("You cannot use this command.")
		end
    end
}

impulse.RegisterChatCommand("/setnotarget", setNoTargetCommand)

local nexte2cleanup = 0

local cleanUpE2Command = {
    description = "Clears all e2s on the server.",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		if CurTime() > nexte2cleanup then
			local e2s = 0
        	for k,v in pairs(ents.FindByClass("gmod_wire_expression2")) do
				v:Remove()
				e2s = e2s + 1
			end
			ply:Notify("Cleaned up " .. e2s .. " E2 chips.")
			nexte2cleanup = CurTime() + 15
		else
			ply:Notify("Please wait " .. math.floor(nexte2cleanup - CurTime()) .. " seconds before using this command.")
		end
    end
}

impulse.RegisterChatCommand("/cleanupe2s", cleanUpE2Command)

local nextNPCCleanup = 0

local cleanUpNPCsCommand = {
    description = "Clears all NPCs on the server.",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		if CurTime() > nextNPCCleanup then
			local npcs = 0
        	for k,v in pairs(ents.GetAll()) do
				if v:IsNPC() then
					if v:GetClass() != "npc_combine_camera" then
						v:Remove()
						npcs = npcs + 1
					end
				end
			end
			ply:Notify("Cleaned up " .. npcs .. " NPCs.")
			timer.Simple(1, function()
				game.ConsoleCommand("impulse_save_reload")
			end)
			nextNPCCleanup = CurTime() + 30
		else
			ply:Notify("Please wait " .. math.floor(nextNPCCleanup - CurTime()) .. " seconds before using this command.")
		end
    end
}

impulse.RegisterChatCommand("/cleanupnpcs", cleanUpNPCsCommand)

local setRogueCommand = {
    description = "For supervisors to mark a Combine unit as rogue. /setrogue steamid. If a unit is rogue, this will remove their rogue status.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		if !ply:IsAdmin() then
        	if ply:Team() == TEAM_CP and ply:GetTeamRank() < RANK_OFC then
				ply:Notify("You cannot use this command.")
				return
			elseif ply:Team() == TEAM_OTA and ply:GetTeamRank() < RANK_OCP then
				ply:Notify("You cannot use this command.")
				return
			elseif ply:Team() == TEAM_CA and ply:GetTeamRank() < RANK_CA then
				ply:Notify("You cannot use this command.")
				return
			elseif not ply:IsCP() then
				ply:Notify("You cannot use this command.")
				return
			end
		end
        local steamid = arg[1]
		local targ = player.GetBySteamID(steamid)
		if !timer.Exists("roguecooldown") then
			if targ:IsCP() and targ:Alive() and (targ:GetTeamRank() < ply:GetTeamRank()) and targ.IsRogue == false then
				targ.IsRogue = true
				ply:Notify("Rogue status added for unit: " .. targ:Name())
				if targ:Team() == TEAM_CP then
					targ:SetModel("models/dpfilms/metropolice/resistance_police.mdl")
				end
				targ:SetRPName("Autonomous Unit - "..targ:Name())
				for k,v in pairs(player.GetAll()) do
					if v:IsCP() then
						timer.Simple(0.5, function()
							v:EmitSound("npc/overwatch/radiovoice/attention.wav")
							v:SendCombineMessage("INCOMING TRANSMISSION FROM COMMAND...", Color(0, 0, 100))
						end)
						timer.Simple(2, function()
							v:SendCombineMessage("UNIT " .. targ:Name() .. " MARKED AUTONOMOUS, PROSECUTE AT WILL.", Color(0, 0, 100))
							v:EmitSound("npc/overwatch/radiovoice/completesentencingatwill.wav")
						end)
					end
				end
			elseif targ:IsCP() and targ:Alive() and (targ:GetTeamRank() < ply:GetTeamRank()) and targ.IsRogue == true then
				targ.IsRogue = false
				ply:Notify("Rogue status revoked for unit: " .. targ:Name())
				for k,v in pairs(player.GetAll()) do
					if v:IsCP() then
						timer.Simple(0.5, function()
							v:EmitSound("npc/overwatch/radiovoice/attention.wav")
							v:SendCombineMessage("UNIT: " .. targ:Name() .. " ROGUE STATUS REVOKED, CEASE MANHUNT", Color(0, 0, 200))
						end)
					end
				end
				if targ:Team() == TEAM_CP then
					targ:SetModel("models/wn7new/metropolice/male_04.mdl")
					targ:SetBodygroup(1, 0)
					targ:SetBodygroup(2, 0)
					targ:SetBodygroup(3, 1)
					targ:SetBodygroup(4, 0)
					targ:SetBodygroup(5, 1)
					targ:SetBodygroup(6, 0)
					targ:SetBodygroup(7, 0)
					targ:SetBodygroup(8, 0)
				end
			end
			timer.Create("roguecooldown", 360, 1, function()
				timer.Remove("roguecooldown")
			end)
		else
			ply:Notify("You cannot use this command for another: " .. math.floor(timer.TimeLeft("roguecooldown")) .. " seconds."  )
		end
    end
}

impulse.RegisterChatCommand("/setrogue", setRogueCommand)

local declareRogueCommand = {
    description = "For rogue units to declare rogue status. WARNING, YOU REQUIRE MODERATOR PERMISSION TO BECOME ROGUE, MISUSING THIS WILL RESULT IN PUNISHMENT.",
    requiresArg = false,
    onRun = function(ply, arg, rawText)
		if ply:Team() != TEAM_CP then
			return
		end
		if ply:GetTeamRank() > RANK_I4 then
			return
		end
		local targ = ply
		if !timer.Exists("roguecooldown") then
			if ply.IsRogue == false then
				ply.IsRogue = true
				ply:Notify("You have declared rogue status.")
				if targ:Team() == TEAM_CP then
					targ:SetModel("models/dpfilms/metropolice/resistance_police.mdl")
				end
				hook.Run("OnRogueDeclare")
				targ:SetRPName("Autonomous Unit - "..targ:Name())
				for k,v in pairs(player.GetAll()) do
					if v:IsCP() then
						timer.Simple(0.5, function()
							v:EmitSound("npc/overwatch/radiovoice/attention.wav")
							v:SendCombineMessage("INCOMING TRANSMISSION FROM COMMAND...", Color(0, 0, 100))
						end)
						timer.Simple(2, function()
							v:SendCombineMessage("UNIT " .. targ:Name() .. " MARKED AUTONOMOUS, PROSECUTE AT WILL.", Color(0, 0, 100))
							v:EmitSound("npc/overwatch/radiovoice/completesentencingatwill.wav")
						end)
					end
				end
			end
			timer.Create("roguecooldown", 30, 1, function()
				timer.Remove("roguecooldown")
			end)
		else
			ply:Notify("You cannot use this command for another: " .. math.floor(timer.TimeLeft("roguecooldown")) .. " seconds."  )
		end
    end
}

impulse.RegisterChatCommand("/declarerogue", declareRogueCommand)

local removeRagdollsCommand = {
    description = "Removes all NPC corpses.",
    requiresArg = false,
    leadAdminOnly = true,
    onRun = function(ply)
        for _, v in ipairs(player.GetAll()) do
			if (IsValid(v) && !v:IsBot()) then
				v:SendLua([[game.RemoveRagdolls()]])
			end
		end
		ply:Notify("Completed.")
    end
}

impulse.RegisterChatCommand("/removeragdolls", removeRagdollsCommand)

local changealiasCommand = {
    description = "OTA NOMAD and Ghost Command.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
		local name = rawText
        if ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_NOMAD or ply:Team() == TEAM_CP and ply:GetTeamClass() == CLASS_GHOST then
			ply:SetRPName(rawText)
			ply:Notify("You have set your alias to " .. rawText .. ".")
			return
		else
			ply:Notify("You cannot use this command.")
			return
		end
    end
}
impulse.RegisterChatCommand("/changealias", changealiasCommand)


local gettoolsCommand = {
    description = "A command for people need tools.",
    requiresArg = false,
    onRun = function(ply)
        if (ply:GetXP() >= 100 or ply:IsDonator()) and ply:GetSyncVar(SYNC_ARRESTED) != true and ply.InJail != true then
			ply:Give("weapon_physgun")
			ply:Give("gmod_tool")
			ply:Give("impulse_hands")
			ply:Notify("You have received your tools. Holding out your tools when not using them or using tools for things other than their intended purpose will result in sanction.")
			return
		else
			ply:Notify("You must have 100 XP or be a donator to get tools. You cannot get them while detained.")
			return
		end
    end
}

impulse.RegisterChatCommand("/tools", gettoolsCommand)

local getBroomCommand = {
    description = "A command for vortigaunts.",
    requiresArg = false,
    onRun = function(ply)
        if (ply:Team() == TEAM_VORT) then
			ply:Give("plutonic_broom")
			ply:Notify("You have received your broom.")
			return
		else
			ply:Notify("You must be a Vortigaunt.")
			return
		end
    end
}

impulse.RegisterChatCommand("/broom", getBroomCommand)

local removetoolsCommand = {
    description = "A command for people who don't want tools.",
    requiresArg = false,
    onRun = function(ply)
		if ply:Team() == TEAM_ZOMBIE or ply:Team() == TEAM_STALKER then
			return
		end
        if ply:HasWeapon("weapon_physgun") or ply:HasWeapon("gmod_tool") then
			ply:StripWeapon("weapon_physgun")
			ply:StripWeapon("gmod_tool")
			ply:Notify("You have removed your tools.")
			return
		else
			ply:Notify("You must have 100 XP or be a donator to get tools. You cannot get them while detained.")
		end
    end
}

impulse.RegisterChatCommand("/removetools", removetoolsCommand)



local eventModeCommand = {
    description = "Toggles event mode, gives GMs access to spawning SENTs, event tools, etc.",
    requiresArg = false,
    leadAdminOnly = true,
    onRun = function(ply)
        if impulse.EventMode == true then
            impulse.EventMode = false
            SetGlobalBool("opsEventMode", false)
            ply:Notify("Event mode is now inactive.")
        else
            impulse.EventMode = true
            SetGlobalBool("opsEventMode", true)
            ply:Notify("Event mode is now active.")

            -- turn this shit off after an hour (if they forget)
            timer.Simple(3600, function()
                if impulse.EventMode == true then
                    impulse.EventMode = false
                    SetGlobalBool("opsEventMode", false)
                    for _, v in ipairs(player.GetAll()) do
                        if v:IsAdmin() then
                            v:Notify("Event mode has automatically ended after 1 hour.")
                        end
                    end
                end
            end)
        end
    end
}

impulse.RegisterChatCommand("/eventmode", eventModeCommand)

local eventSpawn = {
    description = "Stand where you want the spawn to be, use /eventspawn # [1-7]. Use 0 to clear all event spawns.",
    requiresArg = true,
    gameMasterOnly = true,
    onRun = function(ply, arg)
		if impulse.EventMode == true or ply:IsLeadAdmin() then
			local teams = {"Citizen", "CW", "MPF", "CTA", "OCA", "Vortigaunt", "Zombie"}
			local teambools = {EV_CITIZEN_SPAWN, EV_CW_SPAWN, EV_MPF_SPAWN, EV_CTA_SPAWN, EV_OCA_SPAWN, EV_VORT_SPAWN, EV_ZOMBIE_SPAWN}
			local teamnumber = tonumber(arg[1])
			if teamnumber <= 0 or teamnumber >= 8 then
				EV_CITIZEN_SPAWN = Vector(0, 0, 0)
				EV_CW_SPAWN = Vector(0, 0, 0)
				EV_MPF_SPAWN = Vector(0, 0, 0)
				EV_CTA_SPAWN = Vector(0, 0, 0)
				EV_OCA_SPAWN = Vector(0, 0, 0)
				EV_VORT_SPAWN = Vector(0, 0, 0)
				EV_ZOMBIE_SPAWN = Vector(0, 0, 0)
				ply:Notify("All event spawns reset.")
			elseif teamnumber <= 7 then
				if teamnumber == 1 then
					EV_CITIZEN_SPAWN = ply:GetPos()
				elseif teamnumber == 2 then
					EV_CW_SPAWN = ply:GetPos()
				elseif teamnumber == 3 then
					EV_MPF_SPAWN = ply:GetPos()
				elseif teamnumber == 4 then
					EV_CTA_SPAWN = ply:GetPos()
				elseif teamnumber == 5 then
					EV_OCA_SPAWN = ply:GetPos()
				elseif teanumber == 6 then
					EV_VORT_SPAWN = ply:GetPos()
				elseif teamnumber == 7 then
					EV_ZOMBIE_SPAWN = ply:GetPos()
				end
				-- this is scuffed as shit but for some reason the fucking table was not working so ill fix it later
				ply:Notify("Event spawn for " .. teams[teamnumber] .. " set to your current position." )
			else
				ply:Notify("Invalid arguments.")
			end
		else
			ply:Notify("You must be a manager or event mode must be on.")
		end
    end
}

impulse.RegisterChatCommand("/eventspawn", eventSpawn)

if CLIENT then
	local broadcastColor = Color(153, 0, 0)
	local talkCol = Color(255, 255, 100)
	local dispatchCol = Color(30, 125, 137)
	local priodispatchCol = Color(15, 67, 70)
	local commandCol = Color(255, 150, 0)
	local vortCol = Color(153, 52, 255)
	local squadCol = Color(75, 155, 45)

	surface.CreateFont("Impulse-ChatBroadcast", {
		font = "Linux Libertine Slanted",
		size = 19,
		weight = 800,
		antialias = true,
		shadow = true
    })

	local fontmedium = "Impulse-ChatMedium"
	local fontlarge = "Impulse-ChatLarge"
	local fontsmall = "Impulse-ChatSmall"

   	surface.CreateFont("Impulse-VortCall", {
		font = "Anyong",
		size = 19,
		weight = 700,
		antialias = true,
		shadow = true
    })

	impulse.RegisterChatClass(50, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatBroadcast"
		chat.AddText(broadcastColor, "[CITY BROADCAST] ", speaker:Name(), ": ", talkCol, message)
	end)

	impulse.RegisterChatClass(51, function(message, speaker)
		if level == nil then
			level = 0
		end
		if speaker:Team() == TEAM_CWU then
			local cwuclasses = {"Ministry of Labor - Maintenance", "Ministry of Commerce", "Ministry of Health - Medicine", "Ministry of Labor - Refinery", "Ministry of Health - I.C.T.", "Ministry of Research - R&D" }
			local cwranks = {"Intern", "Employee", "Supervisor", "Director", "Minister"}
			if speaker:GetTeamRank() >= 1 then
				chat.AddText(team.GetColor(speaker:Team()), speaker:Name(), " shows ID: ", speaker:Name(), ", ", team.GetName(speaker:Team()) .. ", Rank + Branch: " .. cwranks[speaker:GetTeamRank()] .. cwuclasses[speaker:GetTeamClass()])
			else
				chat.AddText(team.GetColor(speaker:Team()), speaker:Name(), " shows ID: ", speaker:Name(), ", ", team.GetName(speaker:Team()) .. ", Branch: Unassigned")
			end
		elseif speaker:Team() == TEAM_CITIZEN then
			chat.AddText(team.GetColor(speaker:Team()), speaker:Name(), " shows ID: ", speaker:Name(), ", ", team.GetName(speaker:Team()), ", Loyalist Status: Tier ", message, ".")
		else
			chat.AddText(team.GetColor(speaker:Team()), speaker:Name(), " shows ID: ", speaker:Name(), ", ", team.GetName(speaker:Team()))
		end
	end)

	impulse.RegisterChatClass(52, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(dispatchCol, "[DISPATCH] Attention, you have been charged with: ", message, " You are judged guilty by civil protection teams.")
	end)

	impulse.RegisterChatClass(53, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(commandCol, "[COMMAND RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(54, function(message, speaker)
		impulse.customChatFont = "Impulse-VortCall"

		chat.AddText(vortCol, "[VORT CHAT] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(100, function(message, speaker)
		impulse.customChatFont = "Impulse-VortCall"

		chat.AddText(Color(150, 0, 0), "[ZOMB COMMS] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(55, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(squadCol, "[SQUAD RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(57, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(0,150,255), "[M.P.F. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(60, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(255,100,0), "[H.C. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(58, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(100,100,100), "[C.T.A. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(59, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(150,0,0), "[O.C.A. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(201, function(message, speaker)
		chat.AddText(Color(0,150,0), "[C.R.N. Frequency 1] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(202, function(message, speaker)
		chat.AddText(Color(0,160,0), "[C.R.N. Frequency 2] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(203, function(message, speaker)
		chat.AddText(Color(0,170,0), "[C.R.N. Frequency 3] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(204, function(message, speaker)
		chat.AddText(Color(0,180,0), "[C.R.N. Frequency 4] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(205, function(message, speaker)
		chat.AddText(Color(0,190,0), "[C.R.N. Frequency 5] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(206, function(message, speaker)
		chat.AddText(Color(0,200,0), "[C.R.N. Frequency 6] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(207, function(message, speaker)
		chat.AddText(Color(0,210,0), "[C.R.N. Frequency 7] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(208, function(message, speaker)
		chat.AddText(Color(0,220,0), "[C.R.N. Frequency 8] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(209, function(message, speaker)
		chat.AddText(Color(0,230,0), "[C.R.N. Frequency 9] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(210, function(message, speaker)
		chat.AddText(Color(0,240,0), "[C.R.N. Frequency 10] ", speaker:Name(), ": ", message)
	end)


	impulse.RegisterChatClass(70, function(decree, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(150, 0, 0), "[URGENT ANNOUNCEMENT] ", "Attention Please. By order of: " .. speaker:Name() .. ", " .. decree)
	end)

	impulse.RegisterChatClass(71, function(message)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(255, 200, 0), "[AUTOMATED BROADCAST] ", message)
	end)

	impulse.RegisterChatClass(72, function(message, speaker)
		impulse.customChatFont = fontmedium
		chat.AddText(Color(200, 200, 200), "[C.W. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(200, function(message, speaker)
		impulse.customChatFont = fontmedium
		chat.AddText(Color(200, 200, 200), "[R&D RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(73, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(150, 150, 0), "[I.C.T. RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(74, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(0, 200, 200), "[AUDIO BUGGING DEVICE] Unidentified Suspect: ", message)
	end)
	impulse.RegisterChatClass(75, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(0, 255, 0), "[CITY ANNOUNCEMENT] ", message)
	end)
	impulse.RegisterChatClass(77, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(255,25,25), "[DISPATCH] ", message)

		if CLIENT then
			impulse.AddRadioLog("Dispatch Announcer", message)
		end
	end)

	impulse.RegisterChatClass(76, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(255,25,25), "[OVERWATCH] ", message)

		if CLIENT then
			impulse.AddRadioLog("Overwatch Announcer", message)
		end
	end)
end

local function StationaryRadioCommand(ply, message)
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	local ent = tr.Entity

	if ent and IsValid(ent) and ent:GetClass() == "impulse_hl2rp_rebelradio" then
		ent:Transmit(ply, message)
	end
end

hook.Add("RadioMessageFallback", "impulseStationaryRadio", StationaryRadioCommand)

local cpMassDemoteCommand = {
    description = "(Superadmin only) Mass demotes all CP whitelist level 3 and 4 members to level 2.",
    requiresArg = false,
	superAdminOnly = true,
    onRun = function(ply)
        if not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this command.")
            return
        end

        ply:Notify("Starting mass demotion of CP levels 3 and 4 to level 2...")

        local query = mysql:Select("impulse_whitelists")
        query:Select("steamid")
        query:Select("level")
        query:Where("team", "TEAM_CP")
        query:Where("level", 3)
        query:OrWhere("level", 4)
        query:Callback(function(result)
            if not IsValid(ply) then return end

            if type(result) ~= "table" or #result == 0 then
                ply:Notify("No players found with CP whitelist levels 3 or 4.")
                return
            end

            local count = 0
            local total = #result

            ply:Notify("Found " .. total .. " players to demote. Processing...")

            for _, data in pairs(result) do
                local steamid = data.steamid

                local updateQuery = mysql:Update("impulse_whitelists")
                updateQuery:Update("level", 2)
                updateQuery:Where("steamid", steamid)
                updateQuery:Where("team", "TEAM_CP")
                updateQuery:Execute()

                local targ = player.GetBySteamID(steamid)
                if targ and IsValid(targ) then
                    targ:SetupWhitelists()
                    targ:Notify("Your MPF faction rank has been automatically adjusted to i3 by a mass demotion command.")
                end

                count = count + 1
            end

            timer.Simple(1, function()
                if IsValid(ply) then
                    ply:Notify("Mass demotion completed! " .. count .. " players were demoted to CP wh level 2.")
                end
            end)
        end)
        query:Execute()
    end
}

impulse.RegisterChatCommand("/cpmassdemote", cpMassDemoteCommand)

impulse.RegisterChatCommand("/toggleshield", {
    description = "Enable or disable wallhammer shield. (PAYBACK Only)",
    onRun = function(ply)
        if ply:Team() ~= TEAM_OTA or ply:GetTeamClass() ~= CLASS_PAYBACK then
            ply:Notify("You must be a member of the OTA and Class Payback.")
            return
        end

        local className = "att_assault_shield"
        local inv = ply:GetInventory(1) -- 1 = player inventory
        local itemID
        for id, item in pairs(inv) do
            if item.class == className then
                itemID = id
                break
            end
        end

        if not itemID then
            ply:Notify("You do not have the Wallhammer Shield in your inventory.")
            return
        end

        local item = impulse.Inventory.Data[ply.impulseID][1][itemID]
        local currentlyEquipped = item.equipped

        -- Toggle equip state
        ply:SetInventoryItemEquipped(itemID, not currentlyEquipped)

        if currentlyEquipped then
            ply:Notify("Wallhammer Shield disabled.")
        else
            ply:Notify("Wallhammer Shield enabled.")
        end
    end
})

IED_TRACKING_ENABLED = false
local iedTrackingCommand = {
    description = "(Superadmin only) Toggles IED detonation tracking. When enabled, IEDs won't explode and admins will be notified of detonation attempts.",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply)
        if not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this command.")
            return
        end

        IED_TRACKING_ENABLED = not IED_TRACKING_ENABLED

        if IED_TRACKING_ENABLED then
            ply:Notify("IED tracking ENABLED. IEDs will not explode and admins will be notified of detonation attempts.")

            for _, admin in pairs(player.GetAll()) do
                if admin:IsAdmin() then
                    admin:Notify("IED tracking has been enabled by " .. ply:Name() .. ". IEDs will not explode.")
                end
            end
        else
            ply:Notify("IED tracking DISABLED. IEDs will function normally.")

            for _, admin in pairs(player.GetAll()) do
                if admin:IsAdmin() then
                    admin:Notify("IED tracking has been disabled by " .. ply:Name() .. ". IEDs will explode normally.")
                end
            end
        end
    end
}

impulse.RegisterChatCommand("/iedtracking", iedTrackingCommand)

local iedStatusCommand = {
    description = "Shows current IED tracking status.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply)
        if IED_TRACKING_ENABLED then
            ply:Notify("IED tracking is ENABLED. IEDs will not explode.")
        else
            ply:Notify("IED tracking is DISABLED. IEDs will explode normally.")
        end
    end
}
impulse.RegisterChatCommand("/iedstatus", iedStatusCommand)

local lootDrops = {
    description = "(Superadmin only) Toggles whether MPF and OTA units drop loot upon death. (Reserved for MCE/Big Events)",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply)
        if DISABLE_LOOT_DROPS then
            ply:Notify("Loot drops ENABLED.")
			DISABLE_LOOT_DROPS = false
        else
            ply:Notify("Loot drops DISABLED.")
			DISABLE_LOOT_DROPS = true
        end
    end
}
impulse.RegisterChatCommand("/lootdrops", lootDrops)

local ghostRadioCommand = {
	description = "Send a radio message to all ghost units.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if not (ply:Team() == TEAM_CP and (ply:GetTeamClass() == CLASS_GHOST or ply:GetTeamRank() == RANK_CMD or ply:GetTeamRank() == RANK_VCMD or ply:GetTeamRank() == RANK_DCO)) then
			ply:Notify("You must be a Ghost or high command to use this.")
			return
		end
		if impulse.CommsNetWorkOn == false or ply.IsRogue then
			ply:Notify("The radio is not available at this time.")
			return
		end
		local message = rawText
		if hook.GetTable()["ChatClassMessageSend"] then
			message = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
		end
		for v,k in pairs(player.GetAll()) do
			if (k:Team() == TEAM_CP and (k:GetTeamClass() == CLASS_GHOST or k:GetTeamRank() == RANK_CMD or k:GetTeamRank() == RANK_VCMD or k:GetTeamRank() == RANK_DCO)) or k.SnooperMode == true then
				k:SendChatClassMessage(62, message, ply)
			elseif k:GetPos():Distance(ply:GetPos()) < 100 and k != ply then
				k:SendChatClassMessage(62, message, ply)
			end
		end
		ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
	end
}

impulse.RegisterChatCommand("/ghostr", ghostRadioCommand)

if CLIENT then
	impulse.chatClasses = impulse.chatClasses or {}
	impulse.RegisterChatClass(62, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio"
		chat.AddText(Color(255, 0, 0), "[GHOST] ", Color(255, 255, 255), speaker:Name(), ": ", message)
	end)
end