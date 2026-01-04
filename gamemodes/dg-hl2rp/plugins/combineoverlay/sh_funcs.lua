if SERVER then
	util.AddNetworkString("impulseHL2RPCombineMessage")
	util.AddNetworkString("impulseHL2RPCombineWaypoint")

	function meta:SendCombineMessage(text, color)
		net.Start("impulseHL2RPCombineMessage")
		net.WriteString(text)
		if color then
			net.WriteColor(color)
		end
		net.Send(self)
	end 

	function meta:SendCombineWaypoint(message, pos, duration, icon, colour, unit)
		net.Start("impulseHL2RPCombineWaypoint")
		net.WriteString(message) 
		net.WriteVector(pos)
		net.WriteUInt(duration or 90, 10)
		net.WriteUInt(icon or 1, 8)
		net.WriteUInt(colour or 1, 8)
		if unit then
			net.WriteUInt(unit:EntIndex(), 8)
		else
			net.WriteUInt(0, 8)
		end
		net.Send(self)
	end
else
	function meta:SendCombineMessage(text, color)
		impulse.AddCombineMessage(text, color)
	end

	function meta:SendCombineWaypoint(message, duration, icon, colour, unit, sender)
		impulse.AddCombineWaypoint(message, duration, icon, colour, unit, sender)
	end
end

local pingCommand = {
	description = "(Combine) Ping a location for your squad.",
    requiresArg = false,
	requiresAlive = true,
    onRun = function(ply, arg, rawText)
		if (ply.CanPingNext or 0) > CurTime() then
			return
		end
		
		ply.CanPingNext = CurTime() + 2

		if not ply:IsCP() then
			return ply:Notify("This command is restricted to combine only!")
		end

		if ply:Team() == TEAM_CA then
			return ply:Notify("City Administrators cannot use this command.")
		end

		local squad = ply:GetSyncVar(SYNC_SQUAD_ID)
		if not squad then
			return ply:Notify("You must be in a squad to do this.")
		end

		local tr = ply:GetEyeTrace()
		if not tr.HitPos then
			return
		end

		local message = rawText == ""  and "Point of Interest" or rawText  

		for v,k in pairs(team.GetPlayers(ply:Team())) do
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squad then
				k:SendCombineWaypoint(message,tr.HitPos,15,2,1,ply)
			end
		end
		
	end
}

impulse.RegisterChatCommand("/ping",pingCommand)

local commandpingCommand = {
	description = "(Combine) Ping a location, all combine can see this.",
    requiresArg = false,
	requiresAlive = true,
    onRun = function(ply, arg, rawText)
		if (ply.CanPingNext or 0) > CurTime() then
			return
		end
		
		ply.CanPingNext = CurTime() + 15

		if not ply:IsCP() then
			return ply:Notify("This command is restricted to combine only!")
		end

		if ply:Team() == TEAM_OTA and ply:GetTeamRank() < RANK_OCP then
			return ply:Notify("You must be a CCP to use this command.")
		end

		if ply:Team() == TEAM_CP and ply:GetTeamRank() < RANK_OFC then
			return ply:Notify("You must be an RL to use this command.")
		end

		if ply:Team() == TEAM_CA and ply:GetTeamRank() < RANK_DEPUTY then
			return ply:Notify("You must be an Executive to use this command.")
		end

		local tr = ply:GetEyeTrace()
		if not tr.HitPos then
			return
		end

		local message = rawText == ""  and "Point of Interest" or rawText  

		for v, k in pairs(player.GetAll()) do
			if k:IsCP() then
				k:SendCombineMessage("NEW COMMAND PING FROM: "..ply:Name(), Color(255, 90, 0))
				k:SendCombineWaypoint(message, tr.HitPos, 90, 1, 3, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/commandping", commandpingCommand)