if SERVER then
	util.AddNetworkString("impulseHL2RPWaypoint")
else
	net.Receive("impulseHL2RPWaypoint", function()
		local sender = net.ReadUInt(8)
		local message = net.ReadString()
		local isSquad = net.ReadBool()
		local isCommander = net.ReadBool() or false
		sender = Entity(sender)

		if sender and IsValid(sender) and sender:IsPlayer() and sender:IsCP() then
			if not isSquad then
				if isCommander == true then
					LocalPlayer():SendCombineMessage("NEW COMMANDER WAYPOINT FROM: "..sender:Name(), Color(0, 157, 255))
					impulse.AddCombineWaypoint(message, sender:GetPos(), 90, 1, 7, 7, sender)
				else
					LocalPlayer():SendCombineMessage("NEW COMMAND WAYPOINT FROM: "..sender:Name(), Color(255, 150, 0))
					impulse.AddCombineWaypoint(message, sender:GetPos(), 90, 1, 3, 3, sender)
				end
			else
				LocalPlayer():SendCombineMessage("NEW WAYPOINT FROM: "..sender:Name())
				impulse.AddCombineWaypoint(message, sender:GetPos(), 90, 1, 2, 2, sender)
			end
		end
	end)
end

net.Receive("rationwaypoint", function()
	local pos = net.ReadVector()
	timer.Simple(2, function() 
		impulse.AddCombineWaypoint("RATION TERMINAL COMPROMISED", pos, 120, 1, 4, 4, "DISPATCH")
	end)
end)

local waypointCommand = {
	description = "Sends a command waypoint to all units.",
	requiresArg = true,
	requiesAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:IsCP() then
			if not ply:IsCPCommand() then
				return ply:Notify("You must be a commander to do this.")
			end

			rawText = string.sub(rawText, 1, 32) -- max of 32 char

			if (ply.nextWaypoint or 0) > CurTime() then 
				return ply:Notify("Please wait a while before sending another waypoint.") 
			end

			ply.nextWaypoint = CurTime() + 90

			local recipFilter = RecipientFilter()

			for v,k in pairs(player.GetAll()) do
				if k:IsCP() then
					recipFilter:AddPlayer(k)
				end
			end
			local isCommander = false
			if (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_CMD) or (ply:GetTeamRank() >= RANK_OSC and ply:Team() == TEAM_OTA) or (ply:GetTeamRank() >= RANK_COUNCILOR and ply:Team() == TEAM_CA) then
				isCommander = true
			end
			net.Start("impulseHL2RPWaypoint")
			net.WriteUInt(ply:EntIndex(), 8)
			net.WriteString(rawText)
			net.WriteBool(false)
			net.WriteBool(isCommander)
			net.Send(recipFilter)
		end
	end
}

impulse.RegisterChatCommand("/waypoint", waypointCommand)

local squadWaypointCommand = {
	description = "Sends a waypoint to all units in your squad.",
	requiresArg = true,
	requiesAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:IsCP() then
			local squad = ply:GetSyncVar(SYNC_SQUAD_ID)
			if not squad then
				return ply:Notify("You must be in a squad to do this.")
			end

			rawText = string.sub(rawText, 1, 32) -- max of 32 char

			if (ply.nextWaypoint or 0) > CurTime() then 
				return ply:Notify("Please wait a while before sending another waypoint.") 
			end

			ply.nextWaypoint = CurTime() + 90

			local recipFilter = RecipientFilter()


			for v,k in pairs(team.GetPlayers(ply:Team())) do
				if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squad then
					recipFilter:AddPlayer(k)
				end
			end

			net.Start("impulseHL2RPWaypoint")
			net.WriteUInt(ply:EntIndex(), 8)
			net.WriteString(rawText)
			net.WriteBool(true)
			net.Send(recipFilter)
		end
	end
}

impulse.RegisterChatCommand("/squadwaypoint", squadWaypointCommand)