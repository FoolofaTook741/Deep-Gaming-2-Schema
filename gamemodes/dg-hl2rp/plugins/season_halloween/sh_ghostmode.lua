local ghostCommand = {
    description = "Give ghost-mode. STEAMID, then, <1 enable or 0 disable>",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then return end

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
    description = "[Ghost only] Sends a ghostly message to your hunted target.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:GetSyncVar(SYNC_HAL_GHOST, false) then
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


function PLUGIN:CreateSyncVars()
    SYNC_HAL_GHOST = impulse.Sync.RegisterVar(SYNC_BOOL)
end

local ghostActions = {
    ["Hunt"] = {
        ShouldBlock = function(ply, targ)
            return false
        end,
        Do = function(ply, targ)
            net.Start("impulseGhostTarget")
            net.WriteEntity(targ)
            net.Send(ply)

            GHOST_TARG = targ
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

            GHOST_TARG = targ
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
            local rf = RecipientFilter()

            rf:AddPlayer(ply)
            rf:AddPlayer(targ)

            timer.Create("megaStorm"..targ:SteamID(), 0.25, 15 * 4, function()
                if math.random(1,3) == 3 then
                    doLightningStrike(rf)
                end
            end)
        end
    },
    ["Blind (5s)"] = {
        Do = function(ply, targ)
            targ:ScreenFade(1, Color(0, 0, 0), 3, 4)
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
            targ:EmitSound("impulse/whispers3.wav")
        end  
    },
    ["Stop insane"] = {
        Do = function(ply, targ)
            targ:StopInsane()
        end
    },
    ["KILL PLAYER (SCREAM)"] = {
        Do = function(ply, targ)
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
