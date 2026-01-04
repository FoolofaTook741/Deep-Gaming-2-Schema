local respawnCommand = {
    description = "Respawns the player specified.",
    requiresArg = true,
    adminOnly = false,
    onRun = function(ply, arg, rawText)
		if !ply:IsAdmin() and !ply:IsGameMaster() then
			ply:Notify("You cannot use this command.")
			return
		end
        local name = arg[1]
		local plyTarget = impulse.FindPlayer(name)

		if plyTarget then
			plyTarget:Spawn()
			plyTarget:Notify("You have been respawned by a game moderator.")
			ply:Notify(plyTarget:Name().." has been respawned.")
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/respawn", respawnCommand)