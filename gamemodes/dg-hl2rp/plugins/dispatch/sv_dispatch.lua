util.AddNetworkString("impulseHL2RPDispatchAnnounce")
util.AddNetworkString("impulseHL2RPDispatchCityCode")
util.AddNetworkString("impulseHL2RPCivilUnrestStart")
util.AddNetworkString("impulseHL2RPMedicCall")
util.AddNetworkString("impulseHL2RPMedicCallRec")
util.AddNetworkString("impulseHL2RPObjectiveSet")
util.AddNetworkString("impulseHL2RPObjectiveSend")
util.AddNetworkString("deepGamingOTAObjSet")
util.AddNetworkString("deepGamingOTAObjSend")
util.AddNetworkString("impulseHL2RPObjectiveSendEvent")
util.AddNetworkString("impulseHL2RPCityCodeChange")
util.AddNetworkString("impulseHL2RPManhuntActivate")
util.AddNetworkString("impulseHL2RPOrderSearchTag")
util.AddNetworkString("deepSacrificeCodeSet")
util.AddNetworkString("deepgamingSacrificeCode")
util.AddNetworkString("DeepEMPMessage")

lastBlockSearch = {}

net.Receive("impulseHL2RPOrderSearchTag", function(len,ply)

	if (ply.nextOrderSearch or 0) > CurTime() then
		return
	end

	ply.nextOrderSearch = CurTime() + 1

	if not ply:IsCP() then
		return
	end

	if ply:GetTeamRank() < RANK_DVL then
		return ply:Notify("You must be a commanding unit to order a search!")
	end

	local terminal = net.ReadEntity()

	if not IsValid(terminal) then
		return
	end

	local tag = terminal:GetTag()

	if not tag then
		return
	end

	if (lastBlockSearch[tag] or 0) > CurTime() then
		return ply:Notify("Please wait before searching this property again.")
	end

	

	local allBuildings = impulse.Buildings.Data

	if not allBuildings then return end

	if not allBuildings[tag] then return end

	local targ = ply:GetSyncVar(SYNC_SQUAD_ID,-1)
	if targ == -1 then 
		return ply:Notify("You must be in a PT to order a property search.") 
	end
	lastBlockSearch[tag] = CurTime() + 300

	for v,k in pairs(team.GetPlayers(ply:Team())) do
		if k:GetSyncVar(SYNC_SQUAD_ID, -1) == targ then
			net.Start("impulseSquadDoBlockInspection")
			net.WriteString(allBuildings[tag].name)
			net.WriteVector(terminal:GetPos())
			net.Send(k)
		end
	end
end)

net.Receive("impulseHL2RPManhuntActivate", function(len, ply)
	if not ply:IsCP() then
		return
	end
	if not ply:IsCPCommand() then
		return
	end
	
end)

net.Receive("impulseHL2RPDispatchAnnounce", function(len, ply)
	if not ply:IsCP() then
		return
	end
	
	if (nextDispatchSay or 0) > CurTime() then
		return ply:Notify("Wait a while before broadcasting another announcement.")
	end

	if not IsValid(ply.Terminal) then
		if not ply:IsScanner() and not ply:IsCP() and not ply:GetTeamRank() >= RANK_OFC then
			impulse.debugPrint("Terminal is not valid, and player is not a scanner.")
			return
		end
	end

	nextDispatchSay = CurTime() + 14

	local index = net.ReadUInt(8)

	if not impulse.Config.DispatchLines[index] then
		return
	end

	if ply:Team() == TEAM_CA or ply:IsCPCommand() then
		impulse.Dispatch.Announce(index)
		ply:Notify("Dispatch announcement sent.")
		hook.Run("OnDispatchAnnounce", ply, index)
	end
end)

local nextCityCodeChange = nextCityCodeChange or 0
net.Receive("impulseHL2RPDispatchCityCode", function(len, ply)
	if not ply:IsCP() then
		return
	end

	if not IsValid(ply.Terminal) then
		if not ply:IsScanner() and not ply:IsCP() and not ply:GetTeamRank() >= RANK_OFC then
			impulse.debugPrint("Terminal is not valid, and player is not a scanner.")
			return
		end
	end

	if nextCityCodeChange > CurTime() then
		return ply:Notify("You must wait "..string.NiceTime(nextCityCodeChange - CurTime()).." before changing the city code as it was recently changed.")
	end
	local oldcode = impulse.Dispatch.GetCityCode() 
	local code = net.ReadUInt(4)

	if not impulse.Dispatch.CityCodes[code] then
		return
	end

	if ply:Team() != TEAM_CA then
		if not ply:IsCPCommand() then
			return
		end
	end

	if code == CODE_AJ and (not ply:IsLeadAdmin() and not ply:IsCommander()) then
		return
	end

	if code == CODE_LOST and (not ply:IsSuperAdmin()) then
		return
	end

	if code == impulse.Dispatch.GetCityCode() then
		return
	end

	local codeData = impulse.Dispatch.CityCodes[code]

	if code == 2 then
		net.Start("impulseHL2RPCivilUnrestStart")
		net.Broadcast()
	end

	for v,k in pairs(player.GetAll()) do
		if k:IsCP() then
			if code > oldcode then
				k:SendCombineMessage("INCOMING STRATEGIC OBJECTIVE FROM " .. string.upper(ply:Name()), codeData[2])
			end
			timer.Simple(0.8, function()
				k:SendCombineMessage("POLITI-STABILIZATION INDEX UPDATE: "..codeData[1], codeData[2])
			end)
		end
	end


	if code == 1 then
		for _, ply in ipairs(player.GetAll()) do
			if ply:Team() ~= TEAM_CP then continue end
			if not ply:HasInventoryItem("clo_reinforcedcphelmet") then continue end

			local class = ply:GetTeamClass()
			local rank  = ply:GetTeamRank()

			local allowed = (class == CLASS_SWORD and rank >= RANK_SQL) or (rank == RANK_CMD)

			if not allowed then
				ply:TakeInventoryItemClass("clo_reinforcedcphelmet")
				local targetID
				local inv = impulse.Inventory.Data[ply.impulseID]
				if inv and inv[1] then
				    for id, item in pairs(inv[1]) do
				        if item.class == "clo_cphelmet" then
				            targetID = id
				            break
				        end
				    end
				end

				if targetID then
				    ply:SetInventoryItemEquipped(targetID, true)
				end
			end
		end
	end
	
	nextCityCodeChange = CurTime() + 90

	impulse.Dispatch.SetCityCode(code)
	impulse.Dispatch.SetupCityCode(code)

	local namedcodes = {"STABLE", "MARGINAL", "FRACTURED", "AUTONOMOUS JUDGEMENT", "JUDGEMENT WAIVER", "SECTOR EVACUATION"}
        local embeds = {{
            title = "City Code Updated",
            description = "A user has given a strategic order.",
            url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
            color = 12370112,
            fields = {
                {
                    name = "Supervisor:",
                    value = ply:Name()
                },
                {
                    name = "Code:",
                    value = namedcodes[code]
                },
            }
        }}
        
        ReqwestLog(embeds, DG_CAL)

	ply:Notify("You have changed the city code to: "..codeData[1]..".")

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	net.Start("impulseHL2RPCityCodeChange")
	net.WriteUInt(code, 4)
	net.Send(rf)

	hook.Run("OnCityCodeChanged", ply, codeData[1])
	hook.Call( "ImpulseCityCodeChangeLogs", ply, code)
end)

net.Receive("impulseHL2RPMedicCall", function(len, ply)
	if not ply:IsCP() then
		return
	end
	
	if (ply.nextCPMedicCall or 0) > CurTime() then return end
	ply.nextCPMedicCall = CurTime() + 90

	if ply:Health() > 90 then
		return
	end

	local rf = RecipientFilter()
	rf:AddPlayer(ply)

	for v,k in pairs(player.GetAll()) do
		if k:Team() != TEAM_CP then
			continue
		end

		local class = k:GetTeamClass()

		if class and class == CLASS_HELIX then
			rf:AddPlayer(k)
		end
	end

	net.Start("impulseHL2RPMedicCallRec")
	net.WriteEntity(ply)
	net.Send(rf)
end)

net.Receive("impulseHL2RPObjectiveSet", function(len, ply)
	if (ply.nextCPObjSet or 0) > CurTime() then return end
	ply.nextCPObjSet = CurTime() + 1
	if not ply:IsCP() then
		return
	end

	if not ply:GetTeamClass() or not ply:GetTeamRank() then
		return
	end

	local rank = ply:GetTeamRank()

	if ply:Team() == TEAM_CP && rank < RANK_DVL then
		return
	end

	if ply:Team() == TEAM_OTA && rank < RANK_ORD then
		return
	end
	
	if ply:Team() == TEAM_CA && rank < RANK_CA then
		return
	end

	if (HL2RP_NEXT_CPOBJECTIVE or 0) > CurTime() then
		return ply:Notify("Please wait a while before sending a new objective.")
	end

	local order = string.Trim(string.sub(net.ReadString(), 1, 72), " ")

	if order == "" then
		return
	end

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_CA)
	rf:AddRecipientsByTeam(TEAM_OTA)
 
	net.Start("impulseHL2RPObjectiveSend")
	net.WriteEntity(ply)
	net.WriteString(order)
	net.Send(rf)

	HL2RP_NEXT_CPOBJECTIVE = CurTime() + 60

	ply:Notify("Objective sent to all units.")
end)
  
net.Receive("deepGamingOTAObjSet", function(len, ply)
	if (ply.nextCPObjSet or 0) > CurTime() then return end
	ply.nextCPObjSet = CurTime() + 1

	if not ply:IsCP() then
		return
	end

	if not ply:GetTeamClass() or not ply:GetTeamRank() then
		return
	end

	local rank = ply:GetTeamRank()

	if ply:Team() == TEAM_OTA && rank < RANK_CCP then
		return
	end

	if (HL2RP_NEXT_CPOBJECTIVE or 0) > CurTime() then
		return ply:Notify("Please wait a while before sending a new objective.")
	end

	local order = string.Trim(string.sub(net.ReadString(), 1, 72), " ")

	if order == "" then
		return
	end

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_OTA)
 
	net.Start("deepGamingOTAObjSend")
	net.WriteEntity(ply)
	net.WriteString(order)
	net.Send(rf)

	HL2RP_NEXT_CPOBJECTIVE = CurTime() + 60

	ply:Notify("Objective sent to all units.")
end)

net.Receive("deepSacrificeCodeSet", function(len, ply)
	if (ply.nextCPObjSet or 0) > CurTime() then return end
	ply.nextCPObjSet = CurTime() + 1
	if ply:Team() != TEAM_CP and ply:Team() != TEAM_OTA then
		return
	end

	if not ply:GetTeamClass() or not ply:GetTeamRank() then
		return
	end

	local rank = ply:GetTeamRank()

	if ply:Team() == TEAM_CP && rank < RANK_DVL then
		return
	end

	if ply:Team() == TEAM_OTA && rank < RANK_ORD then
		return
	end

	if (HL2RP_NEXT_CPOBJECTIVE or 0) > CurTime() then
		return ply:Notify("Please wait a while before sending a new objective.")
	end

	local rf = RecipientFilter()
	rf:AddRecipientsByTeam(TEAM_CP)
	rf:AddRecipientsByTeam(TEAM_OTA)

	net.Start("deepgamingSacrificeCode")
	net.WriteEntity(ply)
	net.Send(rf)

	HL2RP_NEXT_CPOBJECTIVE = CurTime() + 60

	ply:Notify("Sacrifice code activated.")
end)