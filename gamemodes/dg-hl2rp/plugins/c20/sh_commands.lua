if game.GetMap() == "rp_nightfall_c20_vdeep_v2" then
	local outlandsgateCommand = {
		description = "Opens the Outlands Gate. (Combine only)",
		requiesAlive = true,
		onRun = function(ply, arg, rawText)
			if not ((ply:Team() == TEAM_OTA) or (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_OFC)) then
				ply:Notify("You must be a member of the OTA or CP RL+ to use this.")
				return
			end

			if (ply:GetPos() - Vector(4761.4204101563, -4315.4916992188, -270.54571533203)):LengthSqr() <= (800 ^ 2) then
				if timer.Exists("ozgatecooldown") then
					ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
				else
					local buttons = 0
					for v,k in pairs(ents.FindByClass("func_button")) do
						if k:GetPos():Distance(Vector(3723.40625, -5597.3125, 301.0625)) < 10 then
							buttons = buttons + 1
							--impulse.debugPrint("HIT")
							k:Fire("use")
							--timer.Simple(20, function() k:Fire("use") end)
							for k, v in pairs(player.GetAll()) do
								if v:IsCP() then
									v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTLANDS GATE.", Color(0, 100, 0))
								end
							end
							timer.Simple(10, function()
								for k, v in pairs(player.GetAll()) do
									if v:IsCP() then
										v:SendCombineMessage("THE OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
									end
								end
							end)
						end
					end
					timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
					--print(buttons)
					ply:Notify("You have opened the outlands gate.")
				end
			else
				ply:Notify("You are not near the outlands gate.")
			end

		end
	}

	impulse.RegisterChatCommand("/ozg", outlandsgateCommand)

	local outlandsbaseCommand = {
		description = "Opens the Outlands Base Gate. (Combine only)",
		requiesAlive = true,
		onRun = function(ply, arg, rawText)
			if not ((ply:Team() == TEAM_OTA) or (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_OFC)) then
				ply:Notify("You must be a member of the OTA or CP RL+ to use this.")
				return
			end

			if (ply:GetPos() - Vector(10076.778320313, -2027.8458251953, 8070.6450195313)):LengthSqr() <= (800 ^ 2) then
				if timer.Exists("ozbasecooldown") then
					ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozbasecooldown")) .. " seconds before using this command.")
				else
					local buttons = 0
					for v,k in pairs(ents.FindByClass("func_button")) do
						if k:GetPos():Distance(Vector(10139.6875, -1569.90625, 8289.5)) < 10 then
							buttons = buttons + 1
							--impulse.debugPrint("HIT")
							k:Fire("use")
							timer.Simple(20, function() k:Fire("use") end)
						end
					end
					timer.Create("ozbasecooldown", 30, 1, function() timer.Remove("ozbasecooldown") end)
					--print(buttons)
					ply:Notify("You have opened the outlands base door.")
				end
			else
				ply:Notify("You are not near the outlands base door.")
			end

		end
	}

	impulse.RegisterChatCommand("/ozb", outlandsbaseCommand)
end

if game.GetMap() == "rp_c18_dg" then
    local outlandsgateCommand = {
        description = "Opens the Outlands Gate. (Combine only)",
        requiresAlive = true,
        onRun = function(ply, arg, rawText)
            if ply:SteamID() ~= "STEAM_0:0:29204032" then
                if (ply:Team() != TEAM_OTA) and not (ply:Team() == TEAM_CP and ply:GetTeamClass() >= CLASS_OFC) then
                    ply:Notify("You must be a member of the OTA or CP OFC+ to use this.")
                    return
                end
            end

            if (ply:GetPos() - Vector(3648, 3008, 792)):LengthSqr() > (800 ^ 2) then
                ply:Notify("You are not near the inner outlands gate.")
                return
            end

            if timer.Exists("ozgatecooldown") then
                ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
                return
            end

            local door = ents.GetMapCreatedEntity(6711)

            if not IsValid(door) then
                ply:Notify("The gate could not be found.")
                return
            end

            door:Fire("open", "", .6)

            for _, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage(ply:Name() .. " HAS OPENED THE INNER OUTLANDS GATE.", Color(0, 100, 0))
                end
            end

            timer.Simple(20, function()
                local d = ents.GetMapCreatedEntity(6711)
                if IsValid(d) then
                    d:Fire("close", "", .6)
                end

                for _, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("THE INNER OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
                    end
                end
            end)

            timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
            ply:Notify("You have opened the inner outlands gate.")
        end
    }
    impulse.RegisterChatCommand("/ozg", outlandsgateCommand)

    local outlandsgateCommand2 = {
	    description = "Opens the Outlands Gate. (Combine only)",
	    requiresAlive = true,
	    onRun = function(ply, arg, rawText)
	        if ply:SteamID() ~= "STEAM_0:0:29204032" then
	            if (ply:Team() != TEAM_OTA) and not (ply:Team() == TEAM_CP and ply:GetTeamClass() >= CLASS_OFC) then
	                ply:Notify("You must be a member of the OTA or CP OFC+ to use this.")
	                return
	            end
	        end

	        if (ply:GetPos() - Vector(8012, 3392, 836)):LengthSqr() > (800 ^ 2) then
	            ply:Notify("You are not near the outer outlands gate.")
	            return
	        end

	        if timer.Exists("ozgate2cooldown") then
	            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgate2cooldown")) .. " seconds before using this command.")
	            return
	        end

	        local door = ents.GetMapCreatedEntity(7284)

	        if not IsValid(door) then
	            ply:Notify("The gate could not be found.")
	            return
	        end

	        door:Fire("unlock", "", 0)
	        door:Fire("open", "", 0)

	        for _, v in pairs(player.GetAll()) do
	            if v:IsCP() then
	                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTER OUTLANDS GATE.", Color(0, 100, 0))
	            end
	        end

	        timer.Simple(20, function()
	            local d = ents.GetMapCreatedEntity(7284)
	            if IsValid(d) then
	                d:Fire("close", "", 0)
	            end

	            for _, v in pairs(player.GetAll()) do
	                if v:IsCP() then
	                    v:SendCombineMessage("THE OUTER OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
	                end
	            end
	        end)

	        timer.Create("ozgate2cooldown", 30, 1, function() timer.Remove("ozgate2cooldown") end)
	        ply:Notify("You have opened the outer outlands gate.")
	    end
	}
	impulse.RegisterChatCommand("/ozg2", outlandsgateCommand2)

elseif game.GetMap() == "rp_localinterval" then
	local outlandsgateCommand = {
	    description = "Opens the Outlands Gate. (Combine only)",
	    requiresAlive = true,
	    onRun = function(ply, arg, rawText)
	        if ply:SteamID() ~= "STEAM_0:0:29204032" then
	            if (ply:Team() != TEAM_OTA) and not (ply:Team() == TEAM_CP and ply:GetTeamClass() >= CLASS_OFC) then
	                ply:Notify("You must be a member of the OTA or CP OFC+ to use this.")
	                return
	            end
	        end

	        if (ply:GetPos() - Vector(3832.000000, 1248.000000, 297.959991)):LengthSqr() > (800 ^ 2) then
	            ply:Notify("You are not near the outlands gate.")
	            return
	        end

	        if timer.Exists("ozgatecooldown") then
	            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
	            return
	        end

	        local door = ents.FindByName("outerbulkhead")[1]

	        if not IsValid(door) then
	            ply:Notify("The gate could not be found.")
	            return
	        end

	        door:Fire("open", "", .6)

	        for _, v in pairs(player.GetAll()) do
	            if v:IsCP() then
	                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTLANDS GATE.", Color(0, 100, 0))
	            end
	        end

	        timer.Simple(20, function()
	            local d = ents.FindByName("outerbulkhead")[1]
	            if IsValid(d) then
	                d:Fire("close", "", .6)
	            end

	            for _, v in pairs(player.GetAll()) do
	                if v:IsCP() then
	                    v:SendCombineMessage("THE OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
	                end
	            end
	        end)

	        timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
	        ply:Notify("You have opened the outlands gate.")
	    end
	}

	impulse.RegisterChatCommand("/ozg", outlandsgateCommand)

	local ozffCommand = {
	    description = "Opens the Outlands Forcefield. (Combine only)",
	    requiresAlive = true,
	    onRun = function(ply, arg, rawText)
	        if ply:SteamID() ~= "STEAM_0:0:29204032" then
	            if (ply:Team() != TEAM_OTA) and not (ply:Team() == TEAM_CP and ply:GetTeamClass() >= CLASS_OFC) then
	                ply:Notify("You must be a member of the OTA or CP OFC+ to use this.")
	                return
	            end
	        end

	        if (ply:GetPos() - Vector(3827.5505371094, 4021.0310058594, 219.78125)):LengthSqr() > (800 ^ 2) then
	            ply:Notify("You are not near the outlands forcefield controls.")
	            return
	        end

	        if timer.Exists("ozffcooldown") then
	            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozffcooldown")) .. " seconds before using this command.")
	            return
	        end

	        local shield = ents.FindByName("outerbulkhead_shield")[1]

	        if not IsValid(shield) then
	            ply:Notify("The forcefield could not be found.")
	            return
	        end

	        shield:Fire("Disable")

	        for _, v in pairs(player.GetAll()) do
	            if v:IsCP() then
	                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTLANDS FORCEFIELD.", Color(0, 100, 0))
	            end
	        end

	        timer.Simple(60, function()
	            local s = ents.FindByName("outerbulkhead_shield")[1]
	            if IsValid(s) then
	                s:Fire("Enable")
	            end

	            for _, v in pairs(player.GetAll()) do
	                if v:IsCP() then
	                    v:SendCombineMessage("THE OUTLANDS FORCEFIELD HAS CLOSED.", Color(0, 100, 0))
	                end
	            end
	        end)

	        timer.Create("ozffcooldown", 30, 1, function() timer.Remove("ozffcooldown") end)
	        ply:Notify("You have opened the outlands forcefield.")
	    end
	}
	impulse.RegisterChatCommand("/ozff", ozffCommand)

	local apcgarageCommand = {
	    description = "Opens the APC Garage door. (Combine only)",
	    requiresAlive = true,
	    onRun = function(ply, arg, rawText)
	        if ply:SteamID() ~= "STEAM_0:0:29204032" then
	            if ply:Team() != TEAM_OTA and ply:Team() != TEAM_CP then
	                ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
	                return
	            elseif ply:Team() == TEAM_CP and ply:GetTeamRank() <= RANK_OFC then
	                ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
	                return
	            end
	        end

	        if (ply:GetPos() - Vector(1567.790039, -301.329987, 187.740005)):LengthSqr() > (800 ^ 2) then
	            ply:Notify("You are not near the APC Garage.")
	            return
	        end

	        if timer.Exists("apcgatecooldown") then
	            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("apcgatecooldown")) .. " seconds before using this command.")
	            return
	        end

	        local door = ents.FindByName("nexus_garagedoor1")[1]

	        if not IsValid(door) then
	            ply:Notify("The garage door could not be found.")
	            return
	        end

	        door:Fire("open", "", .6)

	        for _, v in pairs(player.GetAll()) do
	            if v:IsCP() then
	                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE APC GARAGE.", Color(0, 100, 0))
	            end
	        end

	        timer.Simple(20, function()
	            local d = ents.FindByName("nexus_garagedoor1")[1]
	            if IsValid(d) then
	                d:Fire("close", "", .6)
	            end

	            for _, v in pairs(player.GetAll()) do
	                if v:IsCP() then
	                    v:SendCombineMessage("THE APC GARAGE DOOR HAS CLOSED.", Color(0, 100, 0))
	                end
	            end
	        end)

	        timer.Create("apcgatecooldown", 30, 1, function() timer.Remove("apcgatecooldown") end)
	        ply:Notify("You have opened the APC Garage.")
	    end
	}
	impulse.RegisterChatCommand("/apcgarage", apcgarageCommand)



end
