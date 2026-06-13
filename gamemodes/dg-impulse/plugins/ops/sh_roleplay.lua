local unArrestCommand = {
    description = "Un arrests the player specified.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
		local plyTarget = impulse.FindPlayer(name)

		if plyTarget then
			plyTarget:UnArrest()
			plyTarget:Notify("You have been un-arrested by a game moderator.")
			ply:Notify(plyTarget:Name().." has been un-arrested.")

			if plyTarget.InJail then
				impulse.Arrest.Prison[plyTarget.InJail][plyTarget:EntIndex()] = nil
				plyTarget.InJail = nil
				timer.Remove(plyTarget:UserID().."impulsePrison")
				plyTarget:StopDrag()
				plyTarget:Spawn()
			end
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/unarrest", unArrestCommand)

local arrestCommand = {
    description = "Arrests the player with the specified SteamID for the given minutes.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local steamID = arg[1]
        local minutes = tonumber(arg[2])

        if not steamID or not steamID:match("STEAM_%d:%d:%d+") then
            return ply:Notify("Invalid SteamID format.")
        end
        if not minutes or minutes <= 0 then
            return ply:Notify("Please specify a valid number of minutes greater than 0.")
        end

        local plyTarget
        for _, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamID then
                plyTarget = v
                break
            end
        end

        if plyTarget then
            if plyTarget:IsArrested() then
                return ply:Notify(plyTarget:Name() .. " is already arrested.")
            end

            plyTarget:Arrest()
            plyTarget:Notify("You have been arrested by a game moderator for " .. minutes .. " minute(s).")
            ply:Notify(plyTarget:Name() .. " (" .. steamID .. ") has been arrested for " .. minutes .. " minute(s).")

            impulse.Arrest.Prison[plyTarget:EntIndex()] = true
            plyTarget.InJail = true

            local jailTime = minutes * 60
            timer.Create(plyTarget:UserID() .. "impulsePrison", jailTime, 1, function()
                if IsValid(plyTarget) then
                    plyTarget:UnArrest()
                    impulse.Arrest.Prison[plyTarget:EntIndex()] = nil
                    plyTarget.InJail = nil
                    plyTarget:Notify("Your arrest time has ended.")
                    plyTarget:Spawn()
                end
            end)

            plyTarget:StopDrag()
        else
            return ply:Notify("Could not find player with SteamID: " .. tostring(steamID))
        end
    end
}

impulse.RegisterChatCommand("/arrest", arrestCommand)

local setTeamCommand = {
    description = "Sets the team of the player specified. Teams are refrenced with their team ID number.",
    requiresArg = true,
    adminOnly = false,
	gamemasterOnly = true,
    onRun = function(ply, arg, rawText)
		if not ply:IsSeniorGameMaster() and not ply:IsAdmin() then
			ply:Notify("You cannot use this command.")
			return
		end 
        local name = arg[1]
        local teamID = arg[2]
		local plyTarget = impulse.FindPlayer(name)

		if teamID == TEAM_STALKER and ply:IsSuperAdmin() == false then
			ply:Notify("You cannot set a person to this team")
			return
		end

		if not tonumber(teamID) then
			return ply:Notify("Team ID should be a number.")
		end

		teamID = tonumber(teamID)

		if teamID == TEAM_STALKER and not ply:IsSuperAdmin() then
			return
		end

		if plyTarget then
		    if teamID and impulse.Teams.Data[teamID] then
		        local teamName = team.GetName(teamID)
		        if teamID == TEAM_CP or teamID == TEAM_OTA then
		            plyTarget.adminForcedTeam = teamID
		            DeepSpawn_OpenSelector(plyTarget, teamID)
		            plyTarget:Notify("Your team has been set to "..teamName.." by a game moderator. Please select a spawn location.")
		            ply:Notify(plyTarget:Name().." has been prompted to select a spawn location for "..teamName..".")
		        else
		            plyTarget:SetTeam(teamID)
		            plyTarget:Notify("Your team has been set to "..teamName.." by a game moderator.")
		            ply:Notify(plyTarget:Name().." has been set to "..teamName..".")
		        end
		    else
		        ply:Notify("Invalid team ID. They are in F4 menu order!")
		    end
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end
    end
}

impulse.RegisterChatCommand("/setteam", setTeamCommand)

local forceUnlockCommand = {
    description = "Unlocks the door you are looking at.",
	gameMasterOnly = true,
    adminOnly = false,
    onRun = function(ply, arg, rawText)
		local door = ply:GetEyeTrace().Entity

		if not door or not IsValid(door) or not door:IsDoor() then
			return ply:Notify("You are not looking at a door.")
		end

		door:DoorUnlock()
		ply:Notify("Door unlocked.")
    end
}

impulse.RegisterChatCommand("/forceunlock", forceUnlockCommand)

local forceLockCommand = {
    description = "Locks the door you are looking at.",
	gameMasterOnly = true,
    adminOnly = false,
    onRun = function(ply, arg, rawText)
		local door = ply:GetEyeTrace().Entity

		if not door or not IsValid(door) or not door:IsDoor() then
			return ply:Notify("You are not looking at a door.")
		end

		door:DoorLock()
		ply:Notify("Door locked.")
    end
}

impulse.RegisterChatCommand("/forcelock", forceLockCommand)

local removeDoorCommand = {
    description = "Removed a bugged door spawned with the door tool.",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		local door = ply:GetEyeTrace().Entity

		if not door or not IsValid(door) or (not door:IsDoor() and not door:IsPropDoor()) then
			return ply:Notify("You are not looking at a door.")
		end

		if door:MapCreationID() != -1 then
			return ply:Notify("This is a map door, you can not remove it.")
		end

		door:Remove()
		ply:Notify("Door removed.")
    end
}

impulse.RegisterChatCommand("/removebuggeddoor", removeDoorCommand)

local sellDoorCommand = {
    description = "Sells the door you are looking at.",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
		local door = ply:GetEyeTrace().Entity

		if not door or not IsValid(door) or not door:IsDoor() then
			return ply:Notify("You are not looking at a door.")
		end

		local owners = door:GetSyncVar(SYNC_DOOR_OWNERS, nil)

		if not owners then
			return ply:Notify("No door owners to remove.")
		end

		ply:RemoveDoorMaster(door)
		ply:Notify("Door sold.")
    end
}

impulse.RegisterChatCommand("/forceselldoor", sellDoorCommand)