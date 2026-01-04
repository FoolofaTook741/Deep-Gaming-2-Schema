local E2Donators = {}

concommand.Add("add_e2_donator", function(ply, cmd, args)
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "This command can only be run from the server console.")
		return
	end

	local steam64 = args[1]
	if not steam64 or steam64 == "" then
		print("Usage: add_e2_donator <steam64>")
		return
	end

	E2Donators[steam64] = true
	print("Added E2 Donator: " .. steam64)

	local target = player.GetBySteamID64(steam64)
	if IsValid(target) then
		target:SetNWBool("HasE2", true)
	end
end)

concommand.Add("remove_e2_donator", function(ply, cmd, args)
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "This command can only be run from the server console.")
		return
	end

	local steam64 = args[1]
	if not steam64 or steam64 == "" then
		print("Usage: remove_e2_donator <steam64>")
		return
	end

	E2Donators[steam64] = nil
	print("Removed E2 Donator: " .. steam64)

	local target = player.GetBySteamID64(steam64)
	if IsValid(target) then
		target:SetNWBool("HasE2", false)
	end
end)

hook.Add("PlayerInitialSpawn", "E2Donator_SetNWBoolOnJoin", function(ply)
	local sid = ply:SteamID64()
	if E2Donators[sid] then
		ply:SetNWBool("HasE2", true)
	else
		ply:SetNWBool("HasE2", false)
	end
end)