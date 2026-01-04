-- DOnt steal this bitches

local chatCommand = {
	description = "Tactical way to get down from somewhere",
	adminOnly = false,
    requiresArg = false,
    onRun = function(ply, arg, rawText)

		if ply:Team() == TEAM_OTA then

			if ((ply.HL2RPNextRappel or 0) > CurTime()) then
				return ply:Notify("You must wait " .. string.NiceTime(ply.HL2RPNextRappel - CurTime()) .. " to rappel again." )
			end

			if (ply:IsRappelling()) then
				return ply:Notify("You are already rappelling.")
			end

			if (ply:GetTeamClass() == CLASS_PAYBACK and ply:Team() == TEAM_OTA) then
				return ply:Notify("You cannot rappel as WALLHAMMER.")
			end

			ply.HL2RPNextRappel = CurTime() + 1

			ply:Notify("You hook onto a ledge")

			ply:EmitSound("NPC_Combine.Zipline_Start")
			ply:StartRappel()

			timer.Simple(0.4, function()
				ply:EmitSound("NPC_Combine.Zipline_Mid")
			end)

			return
		end

		if ply:Team() == TEAM_CP then
			if ((ply.HL2RPNextRappel or 0) > CurTime()) then
				return ply:Notify("You must wait " .. string.NiceTime(ply.HL2RPNextRappel - CurTime()) .. " to rappel again." )
			end

			if ((ply:GetTeamRank() or 0) < RANK_I2) then
				return ply:Notify("You must be i2+ to Rappel.")
			end

			if (ply:IsRappelling()) then
				return ply:Notify("You are already rappelling.")
			end

			ply.HL2RPNextRappel = CurTime() + 1

			ply:Notify("You hook onto a ledge")

			ply:EmitSound("NPC_Combine.Zipline_Start")
			ply:StartRappel()

			timer.Simple(0.4, function()
				ply:EmitSound("NPC_Combine.Zipline_Mid")
			end)			

			return
		end

		if ply.HasRappelGear then
			if ((ply.HL2RPNextRappel or 0) > CurTime()) then
				return ply:Notify("You must wait " .. string.NiceTime(ply.HL2RPNextRappel - CurTime()) .. " to rappel again." )
			end

			if (ply:IsRappelling()) then
				return ply:Notify("You are already rappelling.")
			end

			ply.HL2RPNextRappel = CurTime() + 1

			ply:Notify("You hook onto a ledge")

			ply:EmitSound("NPC_Combine.Zipline_Start")
			ply:StartRappel()

			timer.Simple(0.4, function()
				ply:EmitSound("NPC_Combine.Zipline_Mid")
			end)			

			return
		end

		return ply:Notify("Only OTA, CPs, and people with rappel gear can rappel.")

	end
}
impulse.RegisterChatCommand("/rappel", chatCommand)

local chatCommand = {
	description = "Stops your rappel",
	adminOnly = false,
    requiresArg = false,
    onRun = function(ply, arg, rawText)

		if ply.Rappel then

			ply:EmitSound("NPC_Combine.Zipline_End")
			ply:StopRappel()

			ply:Notify("You've stopped rappeling")

		end

	end
}
impulse.RegisterChatCommand("/unrappel", chatCommand)