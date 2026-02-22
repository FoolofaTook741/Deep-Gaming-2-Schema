util.AddNetworkString("impulseHL2RPTerminalLeave")
util.AddNetworkString("impulseHL2RPRankUse")
util.AddNetworkString("impulseHL2RPRankBecome")
util.AddNetworkString("impulseHL2RPTerminalCharge")
util.AddNetworkString("impulseHL2RPOpenLocker")
util.AddNetworkString("impulseHL2RPUseLocker")
util.AddNetworkString("impulseHL2RPCombineOverlayBoot")
util.AddNetworkString("impulseHL2RPChargesRequest")
util.AddNetworkString("impulseHL2RPChargesGet")
util.AddNetworkString("impulseHL2RPChargesEdit")
util.AddNetworkString("impulseHL2RPDemoteCP")
util.AddNetworkString("impulseHL2RPTearGasFX")
util.AddNetworkString("impulseHL2RPInspectBody")
util.AddNetworkString("impulseHL2RPInspectBodyComplete")
util.AddNetworkString("impulseHL2RPVortessenceStart")
util.AddNetworkString("impulseHL2RPTheatreControls")
util.AddNetworkString("impulseHL2RPTheatreAction")
util.AddNetworkString("combinecommsnetwork")
util.AddNetworkString("callsignset")
util.AddNetworkString("deepdiscordwebhook")
util.AddNetworkString("rationboolean")
util.AddNetworkString("impulseHL2RPDeployScanner")
util.AddNetworkString("deepViewBodyCam")
util.AddNetworkString("impulseHL2RPTerminalTypeRequest")
util.AddNetworkString("ImpulseHL2RPPurchaseDistPermit")
util.AddNetworkString("impulseBulkOrder")
util.AddNetworkString("impulseFabricatorPurchase")
util.AddNetworkString("impulseSquadLeaderAssignment")
util.AddNetworkString("impulseSquadAssignment")
util.AddNetworkString("impulseHL2RPOVWDispatchRadio")
util.AddNetworkString("impulse_dispatch_dossier_save")
util.AddNetworkString("impulse_dispatch_dossier_load")
util.AddNetworkString("impulse_dispatch_dossier_data")
util.AddNetworkString("impulseHL2RPDisbandSquad")

net.Receive("impulseHL2RPDisbandSquad", function()
	v = net.ReadUInt(8)
	for a,b in pairs(team.GetPlayers(TEAM_CP)) do
		if b:GetSyncVar(SYNC_SQUAD_ID, -1) == v then
			b:SetSyncVar(SYNC_SQUAD_ID, nil, true)
			b:SetSyncVar(SYNC_SQUAD_LEADER, nil, true)

			b:Notify("Your squad has been disbanded by Dispatch.")
		end
	end
end)

local dossierDir = "impulse_dossiers"

if not file.IsDir(dossierDir, "DATA") then
    file.CreateDir(dossierDir)
end

net.Receive("impulse_dispatch_dossier_save", function(len, ply)
    local steamid = net.ReadString()
    local text = net.ReadString()

    if not steamid or steamid == "" then return end

    local safeSteamID = string.gsub(steamid, "[^%w]", "_")
    local path = dossierDir .. "/" .. safeSteamID .. ".txt"

    file.Write(path, text)
end)

net.Receive("impulse_dispatch_dossier_load", function(len, ply)
    local steamid = net.ReadString()
    if not steamid or steamid == "" then return end

    local safeSteamID = string.gsub(steamid, "[^%w]", "_")
    local path = dossierDir .. "/" .. safeSteamID .. ".txt"

    local text = ""
    if file.Exists(path, "DATA") then
        text = file.Read(path, "DATA") or ""
    end

    net.Start("impulse_dispatch_dossier_data")
        net.WriteString(steamid)
        net.WriteString(text)
    net.Send(ply)
end)

net.Receive("impulseHL2RPOVWDispatchRadio", function()
	message = net.ReadString()
	local selection = net.ReadUInt(8)

	if message and message ~= "" then
        timer.Simple(1, function()
			for v, k in pairs(player.GetAll()) do
            	if k:Team() == TEAM_CP and selection == 1 then
                    k:SendChatClassMessage(77, message, ply)
                elseif k:Team() == TEAM_OTA and selection == 2 then
                    k:SendChatClassMessage(76, message, ply)
                elseif selection == 3 then
                    k:SendChatClassMessage(76, message, ply)
				end
            end
        end)
    end

end)


net.Receive("impulseSquadAssignment", function()
	local ply = net.ReadPlayer()

	if (ply.nextSquadDo or 0) > CurTime() then return end
	ply.nextSquadDo = CurTime() + 1

	if not ply:Alive() then
		return
	end

	local squadId = net.ReadUInt(8)
	
	ply:SetSyncVar(SYNC_SQUAD_ID, squadId, true)
end)

net.Receive("impulseSquadLeaderAssignment", function(len, ply)
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
	ply:Notify("Dispatch has assigned you as a "..n.." Leader.")
	ply:Notify("You have created a new "..n..".")
	if ply:Team() == TEAM_CP then
		ply:SetBodygroup(7,2)
	end
end)

net.Receive("impulseFabricatorPurchase", function(len, ply)
    local class = net.ReadString()
	local niceName = net.ReadString()
    local cost = net.ReadInt(16)
    if not class or class == "" then return end

    local has, count = ply:HasInventoryItem("util_resin")
    if not has or count < cost then
        ply:Notify("You do not have enough resin for this purchase!")
        return
    end

    ply:TakeInventoryItemClass("util_resin", nil, cost)
    ply:Notify("You have used " .. cost .. " resin for the fabricator.")

	ply:EmitSound("combine_tech/upgrade_station/combine_3d_printer_upgrading_01.wav")
	timer.Simple(7, function()
		ply:Notify("You have received a "..niceName.." upgrade from the fabricator.")
		ply:GiveInventoryItem(class)
	end)
end)

local CWU_Items = {
    food_apple = { cost = 10 },
    food_banana = { cost = 10 },
    food_orange = { cost = 10 },
    food_pineapple = { cost = 25 },
    util_cookingoil = { cost = 15 },
    util_meat = { cost = 25 },
    util_yeast = { cost = 40 },
    ing_sugar = { cost = 15 },
    util_chicken = { cost = 30 },
    util_salt = { cost = 15 },
    ing_grapes = { cost = 15 },
    util_coffeegrounds = { cost = 20 },
    food_carrot = { cost = 10 },
    food_tomato = { cost = 15 },
    ing_milk = { cost = 20 },
    food_waterspecial = { cost = 20 },
    food_water = { cost = 10 },
    util_potato = { cost = 10 }
}

local BulkExploitAttempts = BulkExploitAttempts or {}
local function LogBulkExploit(ply, reason, data)
    BulkExploitAttempts[ply] = (BulkExploitAttempts[ply] or 0) + 1

    print(string.format(
        "[CWU-BULK BLOCKED] %s (%s) | Reason: %s | Attempts: %d",
        ply:Nick(),
        ply:SteamID(),
        reason,
        BulkExploitAttempts[ply]
    ))

    if data then
        PrintTable(data)
    end
end

net.Receive("impulseBulkOrder", function(_, ply)
    local clientTable = net.ReadTable()

    if ply:Team() ~= TEAM_CWU then
        LogBulkExploit(ply, "Wrong team", clientTable)
        return ply:Notify("You must be a member of the CWU.")
    end

    local finalOrder = {}
    local totalCost = 0
    local hasItems = false

    for itemID, data in pairs(clientTable) do
        local itemData = CWU_Items[itemID]

        if not itemData then
            LogBulkExploit(ply, "Invalid item ID: " .. tostring(itemID), clientTable)
            return
        end

        local count = tonumber(data.count) or 0

        if count < 0 or count > 20 then
            LogBulkExploit(ply, "Invalid item count", clientTable)
            return
        end

        if count > 0 then
            hasItems = true
            finalOrder[itemID] = { count = count }
            totalCost = totalCost + (count * itemData.cost)
        end
    end

    if not hasItems then
        return ply:Notify("You must order at least one item.")
    end

    totalCost = totalCost / 2

    if not ply:CanAfford(totalCost) then
        return ply:Notify("You cannot afford this.")
    end

    BulkExploitAttempts[ply] = nil

    ply:TakeMoney(totalCost)

    local crate = ents.Create("pinnacle_supplycrate")
    if not IsValid(crate) then return end

    crate:SetPos(impulse.Config.BulkCrateSpawn)
    crate:Spawn()

    crate.CrateContents = finalOrder

    if crate.SetContents then
        crate:SetContents(finalOrder)
    end

    crate:SetNWString("CrateDisplayName", ply:Nick())

    ply:Notify("Your supply crate has been delivered!")
end)


net.Receive("ImpulseHL2RPPurchaseDistPermit", function()
	local ply = net.ReadPlayer()

	if not ply:Team() == TEAM_CWU then return ply:Notify("You must be a member of the CWU to use this!") end
	--if ply:GetTeamRank() >= RANK_EMPLOYEE then return ply:Notify("You must be an Employee+ to use this!") end
	if not ply:CanAfford(100) then return ply:Notify("You can not afford this Purchase!") end

	ply:TakeMoney(100)
	ply:GiveInventoryItem("item_distpermit")
	ply:Notify("You have purchased a Distribution Permit!")
end)


function GetPlayerCount()
	local playercount = 0
	for k, v in pairs(player.GetAll()) do
		playercount = playercount + 1
	end
	return playercount
end
function GetCombineCount()
	local cps = 0
	for k, v in pairs(player.GetAll()) do
		if v:IsCP() then
			cps = cps + 1
		end
	end
	return cps
end
function GetCPCount()
	local cps = 0
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CP then
			cps = cps + 1
		end
	end
	return cps
end
function GetOTACount()
	local cps = 0
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_OTA then
			cps = cps + 1
		end
	end
	return cps
end


net.Receive("impulseHL2RPTerminalLeave", function(len, ply)
	if IsValid(ply) and ply:IsCP() then
		local terminal = ply.Terminal

		if terminal and IsValid(terminal) then
			terminal:RemoveUser(ply)
		end
		if ply.PrevPos or ply.BCT then
			local team = ply:Team()
			local rank = ply:GetTeamRank()
			local class = ply:GetTeamClass()
			local inv = ply:GetInventory()
			local name = ply:Name()
            ply:SetMoveType(MOVETYPE_WALK)
            ply:UnSpectate()
			ply:Spawn()
			ply:SetTeam(team)
            ply:SetTeamClass(class)
			ply:SetTeamRank(rank)
			ply:SetRPName(name)
			local targ = ply.BCT
			table.RemoveByValue(targ.Viewers, ply)
			ply.BCT = nil
			ply:SetPos(ply.PrevPos)
			ply.PrevPos = nil
		end
	end
end)

net.Receive("impulseHL2RPRankBecome", function(len, ply)
	local division = net.ReadUInt(8)
	local rank = net.ReadUInt(8)
	local div = division
    local team = ""
	local td = impulse.Teams.Data[ply:Team()]
	local rd = td.ranks[rank]
    local ranktwo = -1
	local success = false
	
	if rd.whitelistLevel then
		ranktwo = rd.whitelistLevel
	end
	
	ply.IsAugmented = false

    if ply:Team() == TEAM_OTA then
        team = "TEAM_OTA"
        local plyrank = ply:GetTeamWhitelist(team)
		if plyrank >= ranktwo && ply:GetTeamClass() == division then
			ply:SetTeamRank(rank)
			success = true
		elseif rank == RANK_CGR and div > CLASS_MACE then
			ply:Notify("You cannot become anything other than MACE or ECHO as a Grunt.")
		elseif plyrank >= ranktwo then
			if ply:CanBecomeTeamClass(division, true) then
				ply:ClearInventory(1)
                ply:SetTeamClass(division)
                ply:SetTeamRank(rank)
                success = true
			else
                ply:Notify("You cannot become this division or you already are this division.")
			end
		else
			ply:Notify("You do not occupy the correct whitelist level.")
		end
    elseif ply:Team() == TEAM_CP then
        team = "TEAM_CP"
        local plyrank = ply:GetTeamWhitelist(team)
		if plyrank >= ranktwo && ply:GetTeamClass() == division then
			ply:SetTeamRank(rank)
			success = true
		elseif rank == RANK_I4 and division != CLASS_UNION then
			ply:Notify("You cannot become anything other than UNION as an i4.")
        elseif plyrank >= ranktwo then
            if ply:CanBecomeTeamClass(division, true) then
				ply:ClearInventory(1)
                ply:SetTeamClass(division)
                ply:SetTeamRank(rank)
                success = true
            else
                ply:Notify("You cannot become this division or you already are this division.")
            end
		else
			ply:Notify("You do not occupy the correct whitelist level.")
        end
	elseif ply:Team() == TEAM_CA then
        team = "TEAM_CA"
        local plyrank = ply:GetTeamWhitelist(team)
        if plyrank >= ranktwo then
			if rank < RANK_REPRESENTATIVE and div == CLASS_BASETWO then
				ply:Notify("You cannot use this class unless you are a representative or greater.")
			elseif plyrank >= ranktwo && ply:GetTeamClass() == division then
				ply:SetTeamRank(rank)
				success = true
            elseif ply:CanBecomeTeamClass(division, true) then
				ply:ClearInventory(1)
                ply:SetTeamClass(division)
                ply:SetTeamRank(rank)
                success = true
            else
                ply:Notify("You cannot become this division or you already are this division.")
            end
		else
			ply:Notify("You do not occupy the correct whitelist level.")
        end
	elseif ply:Team() == TEAM_CWU then
        team = "TEAM_CW"
        local plyrank = ply:GetTeamWhitelist(team)
        if plyrank >= ranktwo then
            if ply:CanBecomeTeamClass(division, true) then
                ply:SetTeamClass(division)
                ply:SetTeamRank(rank)
                success = true
            else
                ply:Notify("You cannot become this division or you already are this division.")
            end
		else
			ply:Notify("You do not occupy the correct whitelist level.")
        end
	else
        ply:SetTeamClass(division)
        ply:SetTeamRank(rank)
        success = true
	end

	if success then
		ply:EmitSound("ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
		ply:EmitSound("items/suitchargeok1.wav", SNDLVL_NORM)
		ply:Notify("You have changed your rank and division.")
		net.Start("impulseHL2RPCombineOverlayBoot")
		net.Send(ply)
		hook.Run("PlayerSetCombineRank", ply, rank, division)
		
		if ply:GetXP() >= 100 or ply:IsDonator() then
			timer.Simple(1, function() 
				ply:Give("weapon_physgun")
				ply:Give("gmod_tool")
			end)
			ply.NovaTrooper = false
		end
		
		if ply:Team() == TEAM_CP and ply:GetTeamClass() != CLASS_DISPATCH and ply:GetTeamClass() != CLASS_SWORD then
			ply:SetSubMaterial(2, nil)
			print(div)
			print(rank)
			ply:SetSubMaterial(2, impulse.SubmatsConfig[ply:Team()][div][rank])
		end
	end
end)

net.Receive("impulseHL2RPTerminalCharge", function(len, ply)
	if ply:Team() != TEAM_CP then
		return
	end

	local count = net.ReadUInt(4)

	if not isnumber(count) or count > impulse.Config.MaxArrestCharges then
		return
	end

	local target = ply.ArrestedDragging
	if not target or not IsValid(target) or not ply:CanArrest(target) or target.InJail or target.BeingArrested then -- see if target is real and can be arrested
		return
	end

	target = Entity(ply.ArrestedDragging:EntIndex()) -- fix for an issue?


	if target:GetSyncVar(SYNC_ARRESTED, false) == false then -- see if target is arrested
		return
	end

	if PRIORITY_ONE_SUSPECT and target == PRIORITY_ONE_SUSPECT then
		ply:EmitSound("npc/overwatch/radiovoice/youarechargedwithterminal.wav")
		timer.Simple(2.8, function()
			ply:EmitSound("npc/overwatch/radiovoice/allunitsverdictcodeis.wav")
		end)
		timer.Simple(3.8, function()
			ply:EmitSound("npc/overwatch/radiovoice/immediateamputation.wav")
		end)
		timer.Simple(4.2, function()
			ply:EmitSound("npc/overwatch/radiovoice/finalverdictadministered.wav")
		end)
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(169, target:Name())
			end
		end
		target:Stalkerize()
		return
	else
		local charges = {}
		local sounds = {"npc/overwatch/radiovoice/attentionyouhavebeenchargedwith.wav"}
		local chargeNames = ""
		local time = 0

		for i=1,count do
			local charge = net.ReadUInt(8)
			local chargeData = impulse.Config.ArrestCharges[charge]

			if chargeData then
				time = time + (chargeData.severity * 60)

				table.insert(charges, charge)
				table.insert(sounds, chargeData.sound)

				if i == count then
					chargeNames = chargeNames..chargeData.name
				else
					chargeNames = chargeNames..chargeData.name.." "
				end
			end
		end

		chargeNames = chargeNames.."."

		table.insert(sounds, "npc/overwatch/radiovoice/youarejudgedguilty.wav")

		local maxTime = impulse.Config.MaxJailTimeGrunt

		if ply:IsCPCommand() then
			maxTime = impulse.Config.MaxJailTime
		end

		time = math.Clamp(time, impulse.Config.MinJailTime, maxTime)

		target.BeingJailed = time
		local delay = ply:EmitQueuedSounds(sounds, 1)

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(52, chargeNames, ply)
			end
		end

		timer.Simple(delay, function()
			if IsValid(target) and target:IsPlayer() then
				target:Jail(time, charges)
				target.BeingJailed = nil

				hook.Run("PlayerJailed", target, ply, time, charges)
			end
		end)
	end
end)

net.Receive("impulseHL2RPChargesRequest", function(len, ply)
	if (ply.nextChargesRequest or 0) > CurTime() then return end
	ply.nextChargesRequest = CurTime() + 2

	if not IsValid(ply.Terminal) then
		return
	end

	if not ply.Terminal:GetConvictIndex() then
		return
	end

	if not ply:CanUseTerminalConvicts() then
		return
	end

	local id = net.ReadUInt(8)
	local targ = Entity(id)
	
	if IsValid(targ) and targ:IsPlayer() and targ.InJail then
		local jailInfo = impulse.Arrest.Prison[targ.InJail][id]

		if jailInfo then
			local charges = jailInfo.jailData

			if charges then
				net.Start("impulseHL2RPChargesGet")
				net.WriteTable(charges)
				net.Send(ply)
			else
				ply:Notify("No charges data for "..targ:Nick()..".")
			end
		end
	end
end)

net.Receive("impulseHL2RPChargesEdit", function(len, ply)
	if (ply.nextChargesEdit or 0) > CurTime() then return end
	ply.nextChargesEdit = CurTime() + 2

	if not IsValid(ply.Terminal) then
		return
	end

	if not ply.Terminal:GetConvictIndex() then
		return
	end

	if not ply:CanUseTerminalConvicts() then
		return
	end

	local cycles = net.ReadUInt(8)
	local id = net.ReadUInt(8)
	local target = Entity(id)

	cycles = math.Clamp(cycles, 1, (impulse.Config.MaxJailTime / 60))

	if target and IsValid(target) and target:IsPlayer() and target.InJail then
		local jailInfo = impulse.Arrest.Prison[target.InJail][target:EntIndex()]

		if jailInfo then
			local start = jailInfo.start
			local oldDur = jailInfo.duration
			local newDur = cycles * 60
			local delta = (newDur + start) - CurTime()
			delta = math.Clamp(delta, 0, impulse.Config.MaxJailTime)

			timer.Adjust(target:UserID().."impulsePrison", delta, function()
				if IsValid(target) and target.InJail then
					target:UnJail()
				end
			end)

			impulse.Arrest.Prison[target.InJail][target:EntIndex()].duration = newDur
			target:SendJailInfo(delta)

			target:Notify("Your sentence has been changed to "..cycles.." cycles by a Civil Protection officer.")
			ply:Notify(target:Nick().."'s sentence has been changed to "..cycles.." cycles.")

			hook.Run("PlayerJailSentenceEdit", ply, target, oldDur, newDur)
		end
	end
end)

net.Receive("impulseHL2RPDemoteCP", function(len, ply)
	if (ply.nextDemoteCP or 0) > CurTime() then return end
	ply.nextDemoteCP = CurTime() + 2

	if not IsValid(ply.Terminal) then
		if not ply:IsScanner() and not ply:IsCP() and not ply:GetTeamRank() >= RANK_OFC then
			impulse.debugPrint("Terminal is not valid, and player is not a scanner.")
			return
		end
	end

	if ply:Team() != TEAM_CP or not ply:GetTeamRank() or ply:GetTeamRank() < RANK_DVL then
		return
	end

	local targ = net.ReadEntity()

	if not targ or not IsValid(targ) or not targ:IsPlayer() or targ:Team() != TEAM_CP then
		return
	end

	if targ:GetTeamRank() and targ:GetTeamRank() >= RANK_DVL or targ:IsAdmin() then
		return
	end

	if ply:GetTeamRank() == RANK_DVL and (ply.totalCPDemotes or 0) > 3 then
		return ply:Notify("You've demoted too many units.")
	end

	if targ.impulseData.CombineBan then
		return ply:Notify("Target already has an active combine ban.")
	end

	local cTime = os.time()
	local length = 30 -- 30 min

	if ply:GetTeamRank() == RANK_CMD then
		length = 2880 -- 2 days
	end

	length = length * 60

	local eTime = cTime + length

	targ.impulseData.CombineBan = eTime
	targ:SaveData()

	targ:SetTeam(impulse.Config.DefaultTeam)

	local howLong = string.NiceTime(length)

	targ:Notify("You have been demoted from CP by "..ply:Nick().." you will be unable to access combine teams for "..howLong..".")
	ply:Notify("You have demoted "..targ:Nick()..". They will be unable to access combine teams for "..howLong..".")
	ply.totalCPDemotes = (ply.totalCPDemotes or 0) + 1

	hook.Run("OnCPDemoted", ply, targ)
end)

net.Receive("impulseHL2RPInspectBody", function(len, ply)
	if (ply.nextBodyCheck or 0) > CurTime() then return end
	ply.nextBodyCheck = CurTime() + 2

	if ply:Team() != TEAM_CP or ply:GetTeamClass() != CLASS_JURY then
		return
	end

	local body = net.ReadEntity()

	if not IsValid(body) or body:GetClass() != "prop_ragdoll" then
		return
	end

	if body:GetPos():DistToSqr(ply:GetPos()) > (400 ^ 2) then
		return
	end

	if not body.Killer or not body.DmgInfo then
		return
	end

	local isCp = false

	if impulse.Anim.GetModelClass(body:GetModel()) == "metrocop" then
		isCp = true
	end

	local wep = body.DmgWep or "unknown"
	local killer

	if isCp and math.random(1, 1) == 1 and IsValid(body.Killer) and body.Killer:IsPlayer() and not body.Killer:IsCP() and not body.Inspected then
		killer = body.Killer:Nick()
	end
	local cantBOL = false
	if (body.Killer.lastDeath or 0) > (body.creationTime or 0) then
		cantBOL = true
	end

	if (not body.NoBodycamID and killer and not body.Killer:IsDispatchBOL()) and (not cantBOL) then
		body.Killer:AddDispatchBOL(10, 1200) -- assault on pt and 20 mins
		ply:Notify(killer.." has been automatically added to the BOL index.")
	end

	net.Start("impulseHL2RPInspectBodyComplete")
	net.WriteBool(body.FallDeath or false)
	net.WriteString(wep)
	net.WriteString(killer or "")
	net.WriteBool(cantBOL)
	net.Send(ply)

	body.Inspected = true
end)

net.Receive("impulseHL2RPUseLocker", function(lem, ply)
	if (ply.nextLocker or 0) > CurTime() then return end
	ply.nextLocker = CurTime() + 1
	if not (ply:Team() == TEAM_CITIZEN or (ply:Team() == TEAM_CWU and ply.GetTeamClass and ply:GetTeamClass() == CLASS_MEDIC)) then return end
	if not IsValid(ply.currentLocker) then return end
	if (ply:GetPos() - ply.currentLocker:GetPos()):LengthSqr() > (120 ^ 2) then return end
	if ply.HasTier1Vest == true or ply.HasTier2Vest == true or ply.HasTier3Vest == true then
		return
	end

	if ply.IsARebel then
		ply:SetBodygroup(2, ply.lastTorsoBodygroup)
		ply:SetBodygroup(3, ply.lastLegBodgroup)
		ply.HasJacket = false
		ply.IsARebel = false
		ply.HasRadio = false
		ply.Frequency = 0
		hook.Run("HL2RPRebelState", ply, false)
	else
		ply.lastTorsoBodygroup = ply:GetBodygroup(2)
		ply.lastLegBodgroup = ply:GetBodygroup(3)
		if ply:Team() == TEAM_CWU and ply.GetTeamClass and ply:GetTeamClass() == CLASS_MEDIC then
			ply:SetBodygroup(2, 9)
			ply:SetBodygroup(3, 2)
		else
			ply:SetBodygroup(2, 10)
			ply:SetBodygroup(3, 6)
		end
		ply.HasRadio = true
		ply.Frequency = 1
		ply:SetBodygroup(3, 6)
		ply.IsARebel = true
		ply.HasJacket = true

		hook.Run("HL2RPRebelState", ply, true)
	end
end)

concommand.Add("inv_count_items", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsLeadAdmin() then
        if ply.Notify then
            ply:Notify("You must be a superadmin to run this command.")
        else
            ply:ChatPrint("You must be a superadmin to run this command.")
        end
        return
    end

    local className = args[1]
    if not className or className == "" then
        if IsValid(ply) then
            ply:ChatPrint("Usage: inv_count_items <item_class>")
        else
            impulse.debugPrint("Usage: inv_count_items <item_class>")
        end
        return
    end

    local total = 0

    for _, v in ipairs(player.GetAll()) do
        if v.beenInvSetup then
            local c1 = v.InventoryRegister and v.InventoryRegister[className] or 0
            local c2 = v.InventoryStorageRegister and v.InventoryStorageRegister[className] or 0
            total = total + (c1 or 0) + (c2 or 0)
        end
    end

    local query = mysql:Select("impulse_inventory")
    query:Select("uniqueid")
    query:Where("uniqueid", className)
    query:Callback(function(result)
        local offlineCount = result and #result or 0
        local totalCount = total + offlineCount

        local msg = string.format("[Inventory] Total '%s' count (online + offline): %d", className, totalCount)
        print(msg)
        if IsValid(ply) then
            ply:ChatPrint(msg)
        end
    end)
    query:Execute()
end)