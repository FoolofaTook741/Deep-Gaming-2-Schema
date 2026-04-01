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
				print(buttons)
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
				print(buttons)
				ply:Notify("You have opened the outlands base door.")
			end
		else
			ply:Notify("You are not near the outlands base door.")
		end

	end
}

impulse.RegisterChatCommand("/ozb", outlandsbaseCommand)

if game.GetMap() == "rp_c18_dg" then
	local outlandsgateCommand = {
		description = "Opens the Outlands Gate. (Combine only)",
		requiesAlive = true,
		onRun = function(ply, arg, rawText)
			if (ply:Team() != TEAM_OTA) or (ply:Team() == TEAM_CP and ply:GetTeamClass() < CLASS_OFC) then
				ply:Notify("You must be a member of the OTA or CP OFC+ to use this.")
				return
			end

			if (ply:GetPos() - Vector(3641.7868652344, 3002.6579589844, 738.47485351563)):LengthSqr() <= (800 ^ 2) then
				if timer.Exists("ozgatecooldown") then
					ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
				else
					local buttons = 0
					for v,k in pairs(ents.FindByClass("func_door")) do
						if k:GetPos():Distance(Vector(3641.7868652344, 3002.6579589844, 738.47485351563)) < 500 then
							buttons = buttons + 1
							k:Fire("open", "", .6)
							timer.Simple(20, function() k:Fire("close", "", .6) end)
							for k, v in pairs(player.GetAll()) do
								if v:IsCP() then
									v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTLANDS GATE.", Color(0, 100, 0))
								end
							end
							timer.Simple(20, function()
								for k, v in pairs(player.GetAll()) do
									if v:IsCP() then
										v:SendCombineMessage("THE OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
									end
								end
							end)
						end
					end
					timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
					ply:Notify("You have opened the outlands gate.")
				end
			else
				ply:Notify("You are not near the outlands gate.")
			end

		end
	}
	impulse.RegisterChatCommand("/outlandsgate", outlandsgateCommand)
end