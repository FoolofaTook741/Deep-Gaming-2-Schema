util.AddNetworkString("DeepStartWorkshift")
util.AddNetworkString("DeepOpenCWMenu")
util.AddNetworkString("DeepUpdateResearch")
util.AddNetworkString("DeepPurchaseRC")
util.AddNetworkString("DeepUpdateResin")
util.AddNetworkString("researchTable")
util.AddNetworkString("researchTableData")

TECHRESEARCHITEMS = {
    [1] = { id = 1, name = "Recycler", description = "This will unlock the Recycler for use by Researchers and Maintenance teams.", cost = 100, time = 300, creditReward = 500, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_RECYCLER" },
    [2] = { id = 2, name = "M.G.R.C.", description = "This will allow the M.G.R.C. to be purchased with Research Funding.", cost = 500, time = 600, creditReward = 1000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_MGRC" },
    [3] = { id = 3, name = "Fabricator", description = "This will allow Combine units to enhance their gear.", cost = 2000, time = 1200, creditReward = 2000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_FABRICATOR" },
    [4] = { id = 4, name = "H.G.R.C", description = "This will allow the H.G.R.C.", cost = 5000, time = 1800,  creditReward = 300, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_HGRC" },
    [5] = { id = 5, name = "A.C.F", description = "Enables the A.C.F. for purchase", cost = 18000, time = 3600, creditReward = 4000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_ACF" },
}

WEAPONRESEARCHITEMS = {
    [1] = { id = 1, name = "Bandoliers", description = "This will increase Combine ammunition capacity.",  cost = 250, time = 300, creditReward = 500, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_BANDOLIERS" },
    [2] = { id = 2, name = "S.L.A.M.s", description = "This will allow Combine MACE units to use S.L.A.M. mines.", cost = 1000, time = 900, creditReward = 1500, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_SLAMS" },
	[3] = { id = 3, name = "Mass Production", description = "This will allow Combine units to gather gear available to a rank above theirs.", cost = 6000, time = 7200, creditReward = 4000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_MASSPRODUCTION" },
}

ECORESEARCHITEMS = {
    [1] = { id = 1, name = "Internal Finance", description = "This will increase Research stimulus checks by 1.1x",  cost = 50, time = 60, creditReward = 100, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_IF" },
    [2] = { id = 2, name = "Tax Revenue Investments", description = "This will invest Combine tax money to receive a 2x yield", cost = 250, time = 240, creditReward = 400, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_TAX" },
	[3] = { id = 3, name = "Vendor Investments", description = "This will invest Combine vendor kickback to receive a 1.25x yield", cost = 750, time = 600, creditReward = 1000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_VENDOR" },
    [4] = { id = 4, name = "OCAAB Treasury Conservation", description = "This will decrease OCAAB package costs by 25%", cost = 1750, time = 1800, creditReward = 3000, progress = 0, isResearching = false, status = "Waiting", rewardVar = "RES_OCAAB" },
}

local enableResearch = {
    RES_IF = function(val) RES_IF = val end,
    RES_TAX = function(val) RES_TAX = val end,
	RES_VENDOR = function(val) RES_VENDOR = val end,
	RES_OCAAB = function(val) RES_OCAAB = val end,
    RES_ACF = function(val) RES_ACF = val end,
	
	RES_BANDOLIERS = function(val) RES_BANDOLIERS = val end,
	RES_SLAMS = function(val) RES_SLAMS = val end,
	RES_MASSPRODUCTION = function(val) RES_MASSPRODUCTION = val end,
	
	RES_RECYCLER = function(val) RES_RECYCLER = val end,
	RES_MGRC = function(val) RES_MGRC = val end,
	RES_FABRICATOR = function(val) RES_FABRICATOR = val end,
	RES_HGRC = function(val) RES_HGRC = val end
}

function StartResearchTimer(terminalEnt, researchItem, researchID, netString, updateResearchLevel)
    researchItem.isResearching = true
    researchItem.progress = 0
    researchItem.status = "In Progress"
    local waitTime = 0
	local tickCount = 0

    timer.Create(netString .. "_" .. researchID, 1, researchItem.time, function()
		tickCount = tickCount + 1
	
        if tickCount >= researchItem.time then --hacky
            researchItem.progress = 1
        else
            researchItem.progress = researchItem.progress + (1 / researchItem.time)
        end
		
        if CurTime() >= waitTime then
            if IsValid(terminalEnt) then
                terminalEnt:EmitSound("ambient/machines/keyboard_fast" .. math.random(1, 3) .. "_1second.wav")
            end
            waitTime = CurTime() + 8
        end

        if researchItem.progress >= 1 then
            researchItem.progress = 1
            researchItem.isResearching = false
            researchItem.status = "Complete"
            updateResearchLevel(researchID)

            local eligibleCount = 0
            local players = player.GetAll()
            for _, ply in ipairs(players) do
                if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and ply:GetTeamClass() == CLASS_RESEARCH then
                    eligibleCount = eligibleCount + 1
                end
            end
            for _, ply in ipairs(players) do
                if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and ply:GetTeamClass() == CLASS_RESEARCH then
                    local reward = math.floor((researchItem.creditReward) / eligibleCount)
                    ply:GiveMoney(reward)
                    ply:Notify("You have received C" .. reward .. " for completing a research project.")
                end
            end
			
			if researchItem.rewardVar and enableResearch[researchItem.rewardVar] then
				enableResearch[researchItem.rewardVar](true)
			end

            net.Start(netString)
            net.WriteInt(researchID, 32)
            net.WriteFloat(researchItem.progress)
            net.WriteString("Research Complete")
            net.Broadcast()

            timer.Remove(netString .. "_" .. researchID)
        else
            researchItem.status = "In Progress (" .. math.floor(researchItem.progress * 100) .. "%)"
            net.Start(netString)
            net.WriteInt(researchID, 32)
            net.WriteFloat(researchItem.progress)
            net.WriteString(researchItem.status)
            net.Broadcast()
        end
    end)
end

net.Receive("researchTable", function(len, ply)
		net.Start("researchTableData")
        net.WriteTable(TECHRESEARCHITEMS)
        net.WriteTable(WEAPONRESEARCHITEMS)
        net.WriteTable(ECORESEARCHITEMS)
		net.Send(ply)
end)

local nextRPcalc = 0
local nextPDAUpdate = 0

hook.Add("Think", "ResearchThinkFunction", function()
    if CurTime() >= nextRPcalc then
        CWU_RP = CWU_RP + 1
        for k,v in pairs(ents.FindByClass("deep_lgrc")) do
            CWU_RP = CWU_RP + 1
        end
        for k,v in pairs(ents.FindByClass("deep_mgrc")) do
            CWU_RP = CWU_RP + 3
        end
        for k,v in pairs(ents.FindByClass("deep_hgrc")) do
            CWU_RP = CWU_RP + 7
        end
        nextRPcalc = CurTime() + 10
        CWU_FUNDING = CWU_FUNDING + 50
        net.Start("DeepUpdateResin")
        net.WriteFloat(CWU_RESIN)
        net.Broadcast()
    end
    if CurTime() >= nextPDAUpdate then
        CWU_RAF = CalculateRP()
        net.Start("DeepUpdateResearch")
        net.WriteFloat(CWU_RESIN)
        net.WriteUInt(math.Clamp(CWU_RP, 0, 100000),32)
        net.WriteUInt(math.Clamp(CWU_FUNDING, 0, 100000),32)
        net.WriteUInt(math.Clamp(CWU_WEPTECHLVL, 0, 100000),32)
        net.WriteUInt(math.Clamp(CWU_TECHRESLVL, 0, 100000),32)
        net.WriteUInt(math.Clamp(CWU_ECORESLVL, 0, 100000),32)
        net.WriteUInt(math.Clamp(CWU_RAF, 0, 100000),32)
        net.Broadcast()
        nextPDAUpdate = CurTime() + 5
    end
end)

net.Receive("DeepPurchaseRC", function(len, ply)
    if ply:Team() != TEAM_CWU then
        return
    end
	
    if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and ply:GetTeamClass() != CLASS_RESEARCH then
        return
    end
	
	local comp = net.ReadString()
	
    local costs = {["lgrc"] = 2500, ["mgrc"] = 7000, ["hgrc"] = 15000, ["resin"] = 3000, ["fabricator"] = 8000, ["plastic"] = 250, ["recycler"] = 5000, ["acf"] = 15000}
    if CWU_FUNDING < costs[comp] then
        ply:Notify("You do not have enough funding for this operation.")
        return
    end
	
    if comp == "mgrc" and RES_MGRC == false then
        ply:Notify("You have not researched this technology yet.")
        return
    end
    if comp == "hgrc" and RES_HGRC == false then
        ply:Notify("You have not researched this technology yet.")
        return
    end
	if comp == "recycler" and not RES_RECYCLER then
        ply:Notify("You have not researched this technology yet.")
        return
	end
	if comp == "fabricator" and not RES_FABRICATOR then
        ply:Notify("You have not researched this technology yet.")
        return
	end
	if comp == "acf" and not RES_ACF then
        ply:Notify("You have not researched this technology yet.")
        return
	end
    if comp == "lgrc" or comp == "mgrc" or comp == "hgrc" or comp == "fabricator" or comp == "recycler" or comp == "acf" then
        if comp == "acf" then
            ACF_COUNT = ACF_COUNT or 0
            if ACF_COUNT >= 2 then
                ply:Notify("You may only have a total of 2 A.C.F units at a time.")
                return
            end
            ACF_COUNT = ACF_COUNT + 1
        elseif comp == "mgrc" then
            MGRC_COUNT = MGRC_COUNT or 0
            if MGRC_COUNT >= 5 then
                ply:Notify("You may only have a total of 5 M.G.R.C units at a time.")
                return
            end
            MGRC_COUNT = MGRC_COUNT + 1
		elseif comp == "recycler" then
            RECYCLER_COUNT = RECYCLER_COUNT or 0
            if RECYCLER_COUNT >= 3 then
                ply:Notify("You may only have a total of 3 Recycler units at a time.")
                return
            end
            RECYCLER_COUNT = RECYCLER_COUNT + 1
        elseif comp == "lgrc" then
            LGRC_COUNT = LGRC_COUNT or 0
             if LGRC_COUNT >= 10 then
                ply:Notify("You may only have a total of 10 L.G.R.C units at a time.")
                return
            end
            LGRC_COUNT = LGRC_COUNT + 1
        elseif comp == "hgrc" then
            HGRC_COUNT = HGRC_COUNT or 0
            if HGRC_COUNT >= 3 then
                ply:Notify("You may only have a total of 3 H.G.R.C units at a time.")
                return
            end
            HGRC_COUNT = HGRC_COUNT + 1
        end
		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

    	local tr = util.TraceLine(trace)

		local rc = ents.Create("deep_" .. comp)
		rc:SetPos(tr.HitPos)
		rc:SetAngles(ply:GetAngles())
		rc:Spawn()
		rc:CPPISetOwner(ply)
        ply:Notify("Transaction Completed!")
	else
        timer.Simple(30, function()
		    impulse.Inventory.SpawnItem(comp .. "_box", impulse.Config.SpawnPos1 + Vector(math.random(-100,100), math.random(-100,100), 100))
        end)
        ply:Notify("Transaction Completed! A box will arrive at the intake hub momentarily, make sure to pick it up before another person does.")
	end
    CWU_FUNDING = math.Clamp(CWU_FUNDING - costs[comp], 0, 999999)
end)