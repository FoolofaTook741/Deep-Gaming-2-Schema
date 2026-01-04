if SERVER then
	util.AddNetworkString("deepHL2RPGroupWaypoint")

	function meta:SendGroupWaypoint(message, pos, duration, icon, colour, unit)
		net.Start("deepHL2RPGroupWaypoint")
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
	function meta:SendGroupWaypoint(message, duration, icon, colour, unit, sender)
		impulse.AddGroupWaypoint(message, duration, icon, colour, unit, sender)
	end
end

local groupWPCommand = {
	description = "(Group) Ping a location for your group.",
    requiresArg = false,
	requiresAlive = true,
    onRun = function(ply, arg, rawText)
		if (ply.CanPingNext or 0) > CurTime() then
			return
		end
		
		ply.CanPingNext = CurTime() + 2

		if ply:IsCP() then
            return
		elseif ((ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and !ply:IsICT()) then
			local group = ply:GetSyncVar(SYNC_GROUP_NAME, nil)
			if not group then
				return ply:Notify("You must be in a group to do this.")
			end

			local tr = ply:GetEyeTrace()
			if not tr.HitPos then
				return
			end

			local message = rawText == ""  and "GROUP PING" or rawText  
			for v,k in pairs(player.GetAll()) do
				if k:GetSyncVar(SYNC_GROUP_NAME, nil) == group then
					k:SendGroupWaypoint(message,tr.HitPos,15,1,1,ply)
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/groupwp", groupWPCommand)
impulse.RegisterChatCommand("/gwp", groupWPCommand)