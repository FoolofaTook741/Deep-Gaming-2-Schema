local ACTCommand = {
    description = "Acts an action out with a animation. (Requires Action)",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        if (ply.DidAction or 0) > CurTime() then return end
        ply:impulseAction(name)
    end
}

impulse.RegisterChatCommand("/act", ACTCommand)

local ACTShorthandCommand = {
    description = "Acts an action out with a animation. (Requires Action)",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        if (ply.DidAction or 0) > CurTime() then return end
        ply:impulseAction(name)
    end
}

impulse.RegisterChatCommand("/e", ACTShorthandCommand)

local StopACTCommand = {
    description = "Stops the current action animation.",
    onRun = function(ply, arg, rawText)
        if (ply.DidAction or 0) > CurTime() then return end
		ply:impulseEndAction()
    end
}

impulse.RegisterChatCommand("/endact", StopACTCommand)
