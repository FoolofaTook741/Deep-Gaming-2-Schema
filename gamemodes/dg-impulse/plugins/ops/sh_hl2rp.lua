if SERVER then
    util.AddNetworkString("opsGiveCombineBan")
end

local combineBanCommand = {
    description = "Gives the player a combine ban for the time specified (max of 12 months).",
    requiresArg = true,
    onRun = function(ply, arg, rawText)

        if not (ply:IsAdmin() or ply:IsCombineHighCommand()) then
            return ply:Notify("You're either not an admin or high command.")
        end
        local name = arg[1]
        local time = arg[2]
        local plyTarget = impulse.FindPlayer(name)

        if not time or not tonumber(time) then
            return ply:Notify("Please specify a valid time value in minutes.")
        end

        time = tonumber(time)
        time = time * 60 -- Convert minutes to seconds
        time = math.Clamp(time, 0, 31536000) -- Clamp between 0 and 12 months (in seconds)

        if plyTarget and plyTarget.impulseData then
            local curT = os.time()
            local endT = curT + time

            plyTarget.impulseData.CombineBan = endT
            plyTarget:SaveData()

            if plyTarget:IsCP() then
                plyTarget:SetTeam(impulse.Config.DefaultTeam)
            end

            local howLong = string.NiceTime(time)

            ply:Notify("You have combine banned "..plyTarget:Nick().." for "..howLong..".")
            plyTarget:Notify("You have been banned from the combine faction for "..howLong.." by "..ply:Nick()..".")
			net.Start("opsGiveCombineBan")
			net.WriteUInt(time, 32) -- Write as 32-bit unsigned integer
			net.Send(plyTarget)
        else
			if not time or not tonumber(time) then
				return ply:Notify("Please specify a valid time value in minutes.")
			end
			if not isstring(name) or not name:match("^STEAM_0:[01]:%d+$") then
				ply:Notify("The SteamID provided is not a valid SteamID32.")
				return
			end
			local curT = os.time()
			local endT = curT + time
			
			local query = mysql:Select("impulse_players")
			query:Select("data")
			query:Where("steamid", name)
			query:Callback(function(result)
				if type(result) ~= "table" or #result == 0 then
					ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
					return
				end
			
				local rawData = result[1].data
				local data = util.JSONToTable(rawData)
			
				if not data then
					ply:Notify("Failed to read player data.")
					return
				end
			
				-- Set CombineBan
				data.CombineBan = endT
			
				-- Save updated data back to DB
				local newData = util.TableToJSON(data)
			
				local update = mysql:Update("impulse_players")
				update:Update("data", newData)
				update:Where("steamid", name)
				update:Execute()
			end)
			query:Execute()
        end
    end
}
impulse.RegisterChatCommand("/combineban", combineBanCommand)

local combineUnBanCommand = {
    description = "Removes a combine ban from a player.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        if not (ply:IsAdmin() or ply:IsCombineHighCommand()) then
            return ply:Notify("You're either not an admin or high command.")
        end
        local name = arg[1]
        local plyTarget = impulse.FindPlayer(name)

        if plyTarget and plyTarget.impulseData then
            plyTarget.impulseData.CombineBan = nil
            plyTarget:SaveData()

            ply:Notify("You have removed "..plyTarget:Nick().."'s combine ban.")
            plyTarget:Notify("Your combine ban has been removed by "..ply:Nick()..".")

            net.Start("opsRemoveCombineBan")
            net.Send(plyTarget)
        else
            return ply:Notify("Could not find player: "..tostring(name))
        end
    end
}

impulse.RegisterChatCommand("/uncombineban", combineUnBanCommand)