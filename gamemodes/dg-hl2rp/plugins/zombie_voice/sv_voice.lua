function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
	if talker:Team() == TEAM_ZOMBIE or talker:Team() == TEAM_CREMATOR then return false end
end

function PLUGIN:PlayerSay(ply,say)
	if IsValid(ply) and ply:Team() == TEAM_ZOMBIE then
		say = say:lower()
		if not (string.Left(say,1) == "/") or string.Left(say,2) == "/y" or string.Left(say,2) == "/w" then
			return ""
		end
	end
end

function PLUGIN:PlayerSpawnProp(ply)
	if ply:Team() == TEAM_ZOMBIE then
		return false
	end
end

function PLUGIN:PlayerSpawnVehicle(ply)
	if ply:Team() == TEAM_ZOMBIE then
		return false
	end
end

function PLUGIN:PlayerUse(ply,ent)
	if ply:Team() == TEAM_ZOMBIE then
        return false
	end
end
