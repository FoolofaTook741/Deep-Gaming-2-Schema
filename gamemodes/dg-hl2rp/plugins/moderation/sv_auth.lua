local authedCollaborators = {}


function impulse.UpdateSyncedGroup(steamID, group, syncDiscord)
	steamID = tostring(steamID or ""):Trim():upper()
	group = tostring(group or "user"):Trim():lower()

	if not steamID:match("^STEAM_%d:%d:%d+$") then
		return false
	end

	local query = mysql:Update("impulse_players")
	query:Update("group", group)
	query:Where("steamid", steamID)

	query:Callback(function()
		local target = player.GetBySteamID(steamID)

		if IsValid(target) then
			target:SetUserGroup(group)

			local colour = impulse.Config.RankColours[target:GetUserGroup()]

			if colour then
				target:SetWeaponColor(Vector(colour.r / 255,colour.g / 255,colour.b / 255))
			end
		end

		if syncDiscord and isfunction(QueueDiscordSync) then
			QueueDiscordSync(steamID)
		end

		impulse.debugPrint("Updated group: " .. steamID .. " -> " .. group)
	end)

	query:Execute()

	return true
end


function impulse.SyncGroupFromDatabase(steamID)
	steamID = tostring(steamID or ""):Trim():upper()

	if not steamID:match("^STEAM_%d:%d:%d+$") then
		return false
	end

	local query = mysql:Select("impulse_players")
	query:Select("group")
	query:Where("steamid", steamID)
	query:Limit(1)

	query:Callback(function(result)
		if not result or not result[1] or not result[1].group then
			impulse.debugPrint("No stored group found for " .. steamID)
			return
		end

		local group = tostring(result[1].group or "user"):Trim():lower()
		local target = player.GetBySteamID(steamID)

		if not IsValid(target) then
			return
		end

		target:SetUserGroup(group)

		local colour = impulse.Config.RankColours[target:GetUserGroup()]

		if colour then
			target:SetWeaponColor(Vector(colour.r / 255,colour.g / 255,colour.b / 255))
		end

		impulse.debugPrint("Synced live group: " .. steamID .. " -> " .. group)
	end)

	query:Execute()

	return true
end


concommand.Add("sync_player_group", function(ply, _, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		return
	end

	local steamID = tostring(args[1] or ""):Trim():upper()

	if not steamID:match("^STEAM_%d:%d:%d+$") then
		impulse.debugPrint(
			"Usage: sync_player_group STEAM_0:1:12345678"
		)

		return
	end

	impulse.SyncGroupFromDatabase(steamID)
end)


concommand.Add("add_collaborator", function(ply, _, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:PrintMessage(
			HUD_PRINTCONSOLE,
			"You must be a superadmin or use the server console."
		)

		return
	end

	local steamID = tostring(args[1] or ""):Trim():upper()

	if not steamID:match("^STEAM_%d:%d:%d+$") then
		impulse.debugPrint("Usage: add_collaborator STEAM_0:1:12345678")
		return
	end

	authedCollaborators[steamID] = true

	local target = player.GetBySteamID(steamID)

	if IsValid(target) then
		target:SetNWBool("IsCollaborator", true)
		target:ChatPrint("You have been granted Collaborator access.")
	end

	local query = mysql:Select("impulse_players")
	query:Select("group")
	query:Where("steamid", steamID)
	query:Limit(1)

	query:Callback(function(result)
		if not result or not result[1] or not result[1].group then
			impulse.debugPrint("No stored group found for " .. steamID)
			return
		end

		local group = tostring(result[1].group or "user"):Trim():lower()

		if group == "user" or group == "donator" then
			impulse.UpdateSyncedGroup(steamID, "collaborator", true)
		end
	end)

	query:Execute()
end)


concommand.Add("remove_collaborator", function(ply, _, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:PrintMessage(HUD_PRINTCONSOLE,"You must be a superadmin or use the server console.")
		return
	end

	local steamID = tostring(args[1] or ""):Trim():upper()

	if not steamID:match("^STEAM_%d:%d:%d+$") then
		impulse.debugPrint("Usage: remove_collaborator STEAM_0:1:12345678")
		return
	end

	authedCollaborators[steamID] = nil

	local target = player.GetBySteamID(steamID)

	if IsValid(target) then
		target:SetNWBool("IsCollaborator", false)
		target:ChatPrint("Your Collaborator access has been removed.")
	end

	local query = mysql:Select("impulse_players")
	query:Select("group")
	query:Where("steamid", steamID)
	query:Limit(1)

	query:Callback(function(result)
		if not result or not result[1] or not result[1].group then
			impulse.debugPrint("No stored group found for " .. steamID)
			return
		end

		local group = tostring(result[1].group or "user"):Trim():lower()

		if group == "collaborator" then
			impulse.UpdateSyncedGroup(steamID, "donator", true)
		end
	end)

	query:Execute()
end)


hook.Add("PlayerInitialSpawn","Collaborator_SetNWBoolOnJoin",
	function(ply)
		local steamID = tostring(ply:SteamID() or ""):Trim():upper()
		ply:SetNWBool("IsCollaborator",authedCollaborators[steamID] == true)
	end
)