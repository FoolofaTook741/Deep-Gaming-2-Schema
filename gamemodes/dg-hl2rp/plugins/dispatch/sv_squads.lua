util.AddNetworkString("rationwaypoint")
util.AddNetworkString("DeepSquadOrder")
util.AddNetworkString("DeepSquadOrderClient")
util.AddNetworkString("DeepSquadDisband")

function PLUGIN:PlayerChangedTeam(ply, old, new)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end

function PLUGIN:PlayerChangeClass(ply)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end

function PLUGIN:PlayerChangeRank(ply)
	if ply:GetSyncVar(SYNC_SQUAD_ID) then
		ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end
end


if timer.Exists("impulseSquadThink") then
	timer.Remove("impulseSquadThink")
end

local squadExpireIndex = squadIndex or {}
timer.Create("impulseSquadThink", 10, 0, function()
	local temp = {}
	local temp2 = {}

	for v,k in pairs(team.GetPlayers(TEAM_CP)) do
		local squad = k:GetSyncVar(SYNC_SQUAD_ID)

		if squad then
			temp[squad] = true

			if k:GetSyncVar(SYNC_SQUAD_LEADER) then
				temp2[squad] = true
			end
		end
	end

	for v,k in pairs(temp) do
		if not temp2[v] then
			if not timer.Exists("impulseSquadExpireCP"..v) then
				timer.Create("impulseSquadExpireCP"..v, impulse.Config.SquadExpiryTime, 1, function() -- eww this is rushed and hacky
					local leaderFound = false
					for a,b in pairs(team.GetPlayers(TEAM_CP)) do
						if b:GetSyncVar(SYNC_SQUAD_ID, -1) == v and b:GetSyncVar(SYNC_SQUAD_LEADER) then
							leaderFound = true
						end
					end

					if not leaderFound then
						for a,b in pairs(team.GetPlayers(TEAM_CP)) do
							if b:GetSyncVar(SYNC_SQUAD_ID, -1) == v then
								b:SetSyncVar(SYNC_SQUAD_ID, nil, true)
								b:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)

								b:Notify("Your squad has been disbanded as the leader was not replaced in time.")
							end
						end
					end
				end)
			end
		end
	end
end)

util.AddNetworkString("impulseSquadMake")
util.AddNetworkString("impulseDISPSquadMake")
util.AddNetworkString("impulseSquadJoin")
util.AddNetworkString("impulseSquadLeave")
util.AddNetworkString("impulseSquadKick")
util.AddNetworkString("impulseSquadClaim")
util.AddNetworkString("impulseSquadAction")

util.AddNetworkString("impulseSquadDoReinforce")
util.AddNetworkString("impulseSquadDoBlockInspection")
util.AddNetworkString("impulseSquadDoMove")
util.AddNetworkString("impulseSquadDoOrder")


net.Receive("impulseDISPSquadMake", function(len, ply)
	if not ply:Alive() or not ply:IsCPCommand() then return end
	local target = net.ReadPlayer()
	if not IsValid(target) or not target:Alive() or target:Team() ~= TEAM_CP then return end
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1
	local lowestFree = 1
	local squads = {}
	local biggestSquad = 0

	for v,k in pairs(team.GetPlayers(target:Team())) do
		local squad = k:GetSyncVar(SYNC_SQUAD_ID)

		if not squad then
			continue
		end

		squads[squad] = true

		if squad > biggestSquad then
			biggestSquad = squad
		end
	end

	for i=1, biggestSquad + 1 do
		if not squads[i] then
			lowestFree = i
			break
		end
	end
	
	target:SetSyncVar(SYNC_SQUAD_LEADER, true, true)
	target:SetSyncVar(SYNC_SQUAD_ID, lowestFree, true)

	local n = target:Team() == TEAM_CP and "P.T." or "S.T."
	target:Notify("You have been assigned by Dispatch to lead a new "..n..".")
	if target:Team() == TEAM_CP then
		target:SetBodygroup(7,2)
	end
end)


net.Receive("impulseSquadMake", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:SquadCanMake() then
		return
	end

	local lowestFree = 1
	local squads = {}
	local biggestSquad = 0

	for v,k in pairs(team.GetPlayers(ply:Team())) do
		local squad = k:GetSyncVar(SYNC_SQUAD_ID)

		if not squad then
			continue
		end

		squads[squad] = true

		if squad > biggestSquad then
			biggestSquad = squad
		end
	end

	for i=1, biggestSquad + 1 do
		if not squads[i] then
			lowestFree = i
			break
		end
	end
	
	ply:SetSyncVar(SYNC_SQUAD_LEADER, true, true)
	ply:SetSyncVar(SYNC_SQUAD_ID, lowestFree, true)

	local n = ply:Team() == TEAM_CP and "P.T." or "S.T."
	ply:Notify("You have created a new "..n..".")
	if ply:Team() == TEAM_CP then
		ply:SetBodygroup(7,2)
	end
end)

net.Receive("impulseSquadLeave", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:GetSquad() then
		return
	end

	if ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		ply:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
	end

	ply:SetSyncVar(SYNC_SQUAD_ID, nil, true)

	local n = ply:Team() == TEAM_CP and "P.T." or "S.T."
	ply:Notify("You have left your "..n..".")
	if ply:Team() == TEAM_CP && ply:GetTeamClass() != CLASS_UNION then
		ply:SetBodygroup(7,0)
	elseif ply:Team() == TEAM_CP && ply:GetTeamClass() == CLASS_UNION then
		ply:SetBodygroup(7,1)
	end
end)

net.Receive("impulseSquadJoin", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local squadId = net.ReadUInt(8)
	if not ply:SquadCanJoin(squadId) then
		return
	end
	
	ply:SetSyncVar(SYNC_SQUAD_ID, squadId, true)
end)

net.Receive("impulseSquadClaim", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	if not ply:SquadCanClaim() then
		return
	end
	
	ply:SetSyncVar(SYNC_SQUAD_LEADER, true, true)
end)


net.Receive("impulseSquadKick", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local meHaveSquad, mySquad = ply:GetSquad()

	if not meHaveSquad then
		return
	end

	if not ply:GetSyncVar(SYNC_SQUAD_LEADER) then
		return
	end

	local targ = net.ReadEntity()

	if not targ:IsPlayer() then
		return
	end
	
	local themHaveSquad, theirSquad = targ:GetSquad()

	if not themHaveSquad then
		return
	end
	
	if mySquad != theirSquad then
		return
	end
	
	targ:SetSyncVar(SYNC_SQUAD_ID, nil, true)

	local n = ply:Team() == TEAM_CP and "PT" or "squad"
	targ:Notify("You have been kicked from your "..n.." by "..ply:Nick()..".")
	ply:Notify("You have kicked "..targ:Nick().." from your "..n..".")
end)

local cooldowns = {}

net.Receive("DeepSquadOrder", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() or not ply:IsCPCommand() then
		return
	end


	local squad = net.ReadUInt(8)
	local order = net.ReadString()
	local supervisor = ply
	local bool = false

	local DispatchOrder = net.ReadBool() or false
	if DispatchOrder == true then
		bool = true
	end

	local rf = RecipientFilter()

	ply:Notify("Order: '" .. order .. "' sent to all units of selected squad." )

	for k,v in pairs(player.GetAll()) do
		if v:Team() == ply:Team() then
			if v:GetSyncVar(SYNC_SQUAD_ID, -1) == squad then
				rf:AddPlayer(v)
			end
		end
	end

	net.Start("DeepSquadOrderClient")
	net.WriteEntity(supervisor)
	net.WriteString(order)
	net.WriteBool(bool)
	net.Send(rf)

end)

net.Receive("DeepSquadDisband", function(len, ply)
	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() or not ply:IsCPCommand() then
		return
	end

	local squad = net.ReadUInt(8)
	local supervisor = ply
	local plyteam = ply:Team()

	ply:Notify("You have disbanded the squad.")

	for a,b in pairs(team.GetPlayers(plyteam)) do
		if b:GetSyncVar(SYNC_SQUAD_ID, -1) == squad then
			b:SetSyncVar(SYNC_SQUAD_ID, nil, true)
			b:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)
			b:Notify("Your squad has been disbanded by faction supervisors.")
		end
	end
end)
