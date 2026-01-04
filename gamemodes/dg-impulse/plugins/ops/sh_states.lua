local statesCommand = {
	description = "Opens the Player State menu.",
	adminOnly = true,
	onRun = function(ply, arg, rawText)
		return ply:Notify("Command disabled.")
        --net.Start("opsOpenStateMenu")
        --net.Send(ply)
    end
}

impulse.RegisterChatCommand("/states", statesCommand)
