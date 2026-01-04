local ghostCommand = {
    description = "Give ghost-mode. STEAMID, then, <1 enable or 0 disable>",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:SteamID64() == "76561198170183094" then return end

        local name = arg[1]
        local isOn = arg[2]
		local plyTarget = impulse.FindPlayer(name)

        if not tonumber(isOn) then
            return
        end

        isOn = tobool(tonumber(isOn))

		if plyTarget then
			if isOn then
                plyTarget:GhostMode(true)
            else
                plyTarget:GhostMode(false)
            end

			plyTarget:Notify("You have been "..(isOn and "possesed by a spirit" or "un-possesed")..".")
			ply:Notify(plyTarget:SteamName().." has been "..(isOn and "made into a ghost" or "un-ghosted")..".")
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/ghostmode", ghostCommand)

local ghostCommand = {
    description = "[Ghost only] Opens the Ghost Control Panel",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:SteamID64() == "76561198170183094" then
            return
        end

        net.Start("landisGhostPanel")
        net.Send(ply)
    end
}

impulse.RegisterChatCommand("/gp", ghostCommand)

local ghostCommand = {
    description = "[Ghost only] Sends a ghostly message to your hunted target.",
    requiresArg = true,
    AdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:SteamID() == "STEAM_0:0:104958683" then
            return
        end

        if not IsValid(GHOST_TARG) then
            return ply:Notify("No target")
        end

        local rf = RecipientFilter()
        rf:AddPlayer(ply)
        rf:AddPlayer(GHOST_TARG)

        net.Start("impulseGhostMessage")
        net.WriteString(rawText)
        net.Send(rf)

        ply:Notify("Sent ghostly message to "..GHOST_TARG:Nick().." (and you).")
    end
}

impulse.RegisterChatCommand("/gs", ghostCommand)

local ghostCommand = {
    description = "[Ghost only] Makes you visible only to your hunted target.",
    requiresArg = false,
    AdminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:SteamID() == "STEAM_0:0:104958683" then
            return
        end

        if not IsValid(GHOST_TARG) then
            return ply:Notify("No target")
        end

        local isVisible = not ply:GetSyncVar(SYNC_HAL_GHOST_VIS,true)
        ply:SetSyncVar(SYNC_HAL_GHOST_VIS,isVisible,true)

        local rf = RecipientFilter()
        rf:AddPlayer(ply)
        rf:AddPlayer(GHOST_TARG)

        net.Start("impulseGhostVisible")
        net.WriteBool(isVisible)
        net.Send(rf)

        ply:Notify("Visibility to "..GHOST_TARG:Nick().." is now " .. tostring(isVisible) .. ".")
    end
}

impulse.RegisterChatCommand("/gv", ghostCommand)


sound.Add({
    name = "impulse_ghost_whispers",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 75,
    pitch = 100,
    sound = "impulse/whispers3.wav"
})

local ghostActions = {
    ["Hunt"] = {
        ShouldBlock = function(ply, targ)
            return false
        end,
        Do = function(ply, targ)
            net.Start("impulseGhostTarget")
            net.WriteEntity(targ)
            net.Send(ply)
            if IsValid(GHOST_TARG) then
                GHOST_TARG:SetSyncVar(SYNC_HAL_GHOST_TARGET,false,true)
            end
            
            timer.Simple(0.1,function()
                GHOST_TARG = targ
                targ:SetSyncVar(SYNC_HAL_GHOST_TARGET,true,true)
            end)
        end
    },
    ["Stop Hunting"] = {
        ShouldBlock = function(ply, targ)
            if GHOST_TARG and GHOST_TARG == targ then
                return false
            end

            return true
        end,
        Do = function(ply, targ)
            net.Start("impulseGhostTarget")
            net.WriteEntity(Entity(0))
            net.Send(ply)

            GHOST_TARG = nil
            targ:SetSyncVar(SYNC_HAL_GHOST_TARGET,false,true)
        end
    },
    ["Burn target (5s)"] = {
        Do = function(ply, targ)
            targ:Ignite(5)
        end
    },
    ["Burn target (15s)"] = {
        Do = function(ply, targ)
            targ:Ignite(15)
        end
    },
    ["Mega storm (private)"] = {
        Do = function(ply, targ)
            return ply:Notify("Disabled")
        end
    },
    ["Blind (5s)"] = {
        Do = function(ply, targ)
            targ:ScreenFade(1, Color(0, 0, 0), 3, 4)
        end
    },
    ["Blind (9s)"] = {
        Do = function(ply, targ)
            targ:ScreenFade(1, Color(0, 0, 0), 3, 8)
        end
    },
    ["Force insane (level 3) (private)"] = {
        Do = function(ply, targ)
            targ:SetLocalSyncVar(SYNC_INSANE, 3)
        end
    },
    ["Force insane (level 4) (private)"] = {
        Do = function(ply, targ)
            targ:SetLocalSyncVar(SYNC_INSANE, 4)
        end
    },
    ["Force insane (level 5) (private)"] = {
        Do = function(ply, targ)
            targ:SetLocalSyncVar(SYNC_INSANE, 5)
        end
    },
    ["Suspense sounds (private)"] = {
        Do = function(ply, targ)
            targ:SurfacePlaySound("music/stingers/industrial_suspense"..math.random(1, 2)..".wav")
        end
    },
    ["Playground sounds (public)"] = {
        Do = function(ply, targ)
            targ:SurfacePlaySound("ambient/voices/playground_memory.wav")
        end
    },
    ["Screenshake (public)"] = {
        Do = function(ply, targ)
            util.ScreenShake(targ:GetPos(), 5, 5, 10, 900)
        end
    },
    ["Start whispering (public)"] = {
        Do = function(ply, targ)
            targ:EmitSound("impulse_ghost_whispers")

            timer.Simple(60, function()
                if IsValid(targ) then
                    targ:StopSound("impulse_ghost_whispers")
                end
            end)
        end  
    },
    ["Pull out of reality (private)"] = {
        Do = function(ply,targ)
            targ.InScaryWorld = not (targ.InScaryWorld or false)
            ply.InScaryWorld = targ.InScaryWorld
            ply:DrawShadow(not targ.InScaryWorld)
            targ:DrawShadow(not targ.InScaryWorld)
            local rf = RecipientFilter()
            rf:AddPlayer(ply)
            rf:AddPlayer(targ)
            net.Start("impulseGhostReality")
            net.WriteBool(targ.InScaryWorld)
            net.Send(rf)
            targ:SetSyncVar(SYNC_HAL_SCARY,targ.InScaryWorld,true)
            --targ:SetNoDraw(not targ.InScaryWorld)
            targ:AchievementGive("ach_haunted")
            
        end
    },
    ["Stop insane"] = {
        Do = function(ply, targ)
            targ:StopInsane()
        end
    },
    ["KILL PLAYER (SCREAM)"] = {
        Do = function(ply, targ)
            targ:SetSyncVar(SYNC_HAL_GHOST_TARGET,false,true)
            targ:EmitSound("ambient/creatures/town_child_scream1.wav")
            targ:Kill()
        end
    }
}

local count = 0
for v,k in pairs(ghostActions) do
    count = count + 1
    properties.Add(v, {
        MenuLabel = "GHOST: "..v, -- Name to display on the context menu
        Order = count, -- The order to display this property relative to other properties
        MenuIcon = "icon16/eye.png", -- The icon to display next to the property
    
        Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
            if not ply:GetSyncVar(SYNC_HAL_GHOST, false) then return false end
            if ( !IsValid( ent ) ) then return false end
            if ( !ent:IsPlayer() ) then return false end
            if k.ShouldBlock and k.ShouldBlock(ply, ent) == true then return false end

            return true
        end,
        Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
            self:MsgStart()
                net.WriteEntity(ent)
            self:MsgEnd()
        end,
        Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
            local ent = net.ReadEntity()
    
            if ( !self:Filter( ent, ply ) ) then return end
    
            k.Do(ply, ent)
        end 
    })
end
