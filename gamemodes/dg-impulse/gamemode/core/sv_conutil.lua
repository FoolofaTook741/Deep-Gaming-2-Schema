concommand.Add("impulse_setgroup", function(ply, cmd, args)
	if ply != NULL or IsValid(ply) then
		return
	end
	
	local steamid = args[1]
	local group = args[2]

	if not steamid or not group then
		return print("[impulse] SteamID or group name not provided.")
	end

	local query = mysql:Select("impulse_players")
	query:Select("group")
	query:Where("steamid", steamid)
	query:Limit(1)
	query:Callback(function(result, ok, err)
		if ok == false then
			return print("[impulse] Failed to check group for '"..steamid.."': "..tostring(err))
		end

		local targ = player.GetBySteamID(steamid)
		local storedGroup = result and result[1] and string.lower(result[1].group or "") or ""
		local currentGroup = IsValid(targ) and string.lower(targ:GetUserGroup() or "") or storedGroup
		local groups = impulse.Config.Usergroups or {}

		if (groups[storedGroup] or groups[currentGroup]) and not groups[string.lower(group)] then
			return print("[impulse] Protected '"..steamid.."' from being changed from staff group '"..(groups[currentGroup] and currentGroup or storedGroup).."' to '"..group.."'.")
		end

		if IsValid(targ) then
			targ:SetUserGroup(group)
			net.Start("impulseRefreshGroupRank")
			net.WriteString(targ:GetUserGroup())
			net.Send(targ)
		end

		local update = mysql:Update("impulse_players")
		update:Update("group", group)
		update:Where("steamid", steamid)
		update:Execute()

		print("[impulse] Set '"..steamid.."'' to group '"..group.."'.")
		QueueDiscordSync(steamid)
	end)
	query:Execute()
end)
