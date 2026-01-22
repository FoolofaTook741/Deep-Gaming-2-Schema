local PANEL = {}

local text
local steamid
local CurrentCivilDossierPanel

if CLIENT then
    impulse.RadioLogs = impulse.RadioLogs or {}
    
    -- Function to add message to logs
    function impulse.AddRadioLog(frequency, sender, message, timestamp)
        if not impulse.RadioLogs[frequency] then
            impulse.RadioLogs[frequency] = {}
        end
        
        table.insert(impulse.RadioLogs[frequency], {
            sender = sender,
            message = message,
            timestamp = timestamp or os.time()
        })
        
        if #impulse.RadioLogs[frequency] > 50 then
            table.remove(impulse.RadioLogs[frequency], 1)
        end
    end
    
    function impulse.GetRadioLogs(frequency)
        return impulse.RadioLogs[frequency] or {}
    end
end

local function SteamIDTo64(sid)
    if not isstring(sid) then return sid end
    local a, b, c = sid:match("^STEAM_([0-5]):([01]):(%d+)$")
    if not a then return sid end
    local base = "76561197960265728"
    local c_num = tonumber(c)
    local b_num = tonumber(b)
    local id64 = tostring(c_num * 2 + b_num)
    local function add_str(a, b)
        local res, carry = "", 0
        a, b = a:reverse(), b:reverse()
        for i = 1, math.max(#a, #b) do
            local d1 = tonumber(a:sub(i,i)) or 0
            local d2 = tonumber(b:sub(i,i)) or 0
            local sum = d1 + d2 + carry
            res = (sum % 10) .. res
            carry = math.floor(sum / 10)
        end
        if carry > 0 then res = carry .. res end
        return res
    end
    return add_str(base, id64)
end

local applications = {
	["Cameras"] = {
		img = "impulse/icons/detective-256.png",
		xPos = 120,
		yPos = 120,
		w = 600,
		h = 400,
		panel = function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:SetSkin("Combine")
			pnl.Paint = function(self, w, h)
				draw.SimpleText("Cameras", "combineTextSmol", w/2, h/2, Color(255,255,255,5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(0, 0, w, h)
			end
	
			local camList = vgui.Create("DListView", pnl)
			camList:SetPos(0, 30)
			camList:SetSize(200, 500)
			camList:SetMultiSelect(false)
			camList:SetSortable(true)
			camList:SetSkin("combine")
	
			local title1 = camList:AddColumn("CAM")
			local title2 = camList:AddColumn("STATUS")
			title1.Header:SetFont("BudgetLabel")
			title2.Header:SetFont("BudgetLabel")
	
			local camView = vgui.Create("DPanel", pnl)
			camView:SetPos(210, 30)
			camView:SetSize(400, 300)
			camView:SetSkin("Combine")
			camView.CamEnt = nil
	
			local rtName = "impulse_dispatch_cam_rt"
			local rtWidth, rtHeight = 400, 300
			local camRT = GetRenderTarget(rtName, rtWidth, rtHeight, false)
			local camMat = CreateMaterial("impulse_dispatch_cam_mat", "UnlitGeneric", {
				["$basetexture"] = camRT:GetName(),
				["$vertexcolor"] = 1,
				["$vertexalpha"] = 1
			})
	
			hook.Add("Think", "UpdateCameraRender", function()
				if not IsValid(camView.CamEnt) then return end
	
				local att = camView.CamEnt:GetAttachment(camView.CamEnt:LookupAttachment("eyes"))
				local camPos, camAng
				if att then
					camPos = att.Pos + att.Ang:Forward() * 16
					camAng = att.Ang
				else
					camPos = camView.CamEnt:GetPos()
					camAng = camView.CamEnt:GetAngles()
				end
	
				render.PushRenderTarget(camRT)
				render.Clear(0,0,0,255)
				render.ClearDepth()
				cam.Start3D(camPos, camAng, 90, 0, 0, rtWidth, rtHeight)
					render.SuppressEngineLighting(true)
					render.RenderView({
						origin = camPos,
						angles = camAng,
						x = 0,
						y = 0,
						w = rtWidth,
						h = rtHeight,
						drawviewmodel = false,
						drawhud = false
					})
					render.SuppressEngineLighting(false)
				cam.End3D()
				render.PopRenderTarget()
			end)
	
			camView.Paint = function(self, w, h)
				if IsValid(self.CamEnt) then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(camMat)
					surface.DrawTexturedRect(0,0,w,h)
				else
					draw.SimpleText("Select a camera to view", "BudgetLabel", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
	
			-- Populate camera list
			for _, camEnt in pairs(ents.FindByClass("npc_combine_camera")) do
				local camid = camEnt:GetSyncVar(SYNC_CAM_CAMID, nil)
				if not camid then continue end
	
				local line = camList:AddLine(camid, camEnt:IsCameraEnabled() and "ONLINE" or "OFFLINE")
				for _, col in pairs(line.Columns) do
					col:SetFont("BudgetLabel")
				end
				line.Ent = camEnt
			end
	
			camList:SortByColumn(1)
	
			function camList:OnRowSelected(index, row)
				camView.CamEnt = (row.Ent and IsValid(row.Ent)) and row.Ent or nil
			end
	
			return pnl
		end
	},
	
	["Patrol Manager"] = {
		img = "impulse/icons/group-256.png",
		xPos = 120,
		yPos = 120,
		w = 800,
		h = 500,
		panel = function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:SetSkin("Combine")

			local ptList = vgui.Create("DListView", pnl)
			ptList:SetPos(180, 10)
			ptList:SetSize(160, 400)
			ptList:AddColumn("PT ID")
			ptList:SetMultiSelect(false)
			ptList:SetSkin("Combine")

			local memberList = vgui.Create("DListView", pnl)
			memberList:SetPos(350, 10)
			memberList:SetSize(160, 400)
			memberList:AddColumn("Member")
			memberList:AddColumn("CID")
			memberList:SetMultiSelect(false)
			memberList:SetSkin("Combine")

			-- Move Objective box left
			local objBox = vgui.Create("DTextEntry", pnl)
			objBox:SetPos(520, 210)
			objBox:SetSize(150, 60)
			objBox:SetMultiline(true)
			objBox:SetPlaceholderText("PT Objective...")

			local assignLeaderBtn = vgui.Create("DButton", pnl)
			assignLeaderBtn:SetText("Assign PT Leader")
			assignLeaderBtn:SetPos(520, 10)
			assignLeaderBtn:SetSize(120, 30)

			local assignMemberBtn = vgui.Create("DButton", pnl)
			assignMemberBtn:SetText("Assign Member")
			assignMemberBtn:SetPos(520, 50)
			assignMemberBtn:SetSize(120, 30)

			local removeMemberBtn = vgui.Create("DButton", pnl)
			removeMemberBtn:SetText("Remove Member")
			removeMemberBtn:SetPos(520, 90)
			removeMemberBtn:SetSize(120, 30)

			local disbandBtn = vgui.Create("DButton", pnl)
			disbandBtn:SetText("Disband PT")
			disbandBtn:SetPos(520, 130)
			disbandBtn:SetSize(120, 30)

			local setObjBtn = vgui.Create("DButton", pnl)
			setObjBtn:SetText("Set PT Objective")
			setObjBtn:SetPos(520, 170)
			setObjBtn:SetSize(120, 30)

			local selectedPT, selectedMember

			function RefreshPTs()
				ptList:Clear()
				local pts = {}
				for _, ply in ipairs(player.GetAll()) do
					if ply:Team() == TEAM_CP then
						local pt = ply:GetSyncVar(SYNC_SQUAD_ID)
						local isLdr = ply:GetSyncVar(SYNC_SQUAD_LEADER)
						if pt then
							pts[pt] = pts[pt] or {leader = nil, members = {}}
							if isLdr then
								pts[pt].leader = ply
							end
							table.insert(pts[pt].members, ply)
						end
					end
				end
				for ptid, data in pairs(pts) do
					local line = ptList:AddLine(ptid)
					line.ptid = ptid
					line.members = data.members
				end
			end

			function ptList:OnRowSelected(_, row)
				selectedPT = row.ptid
				memberList:Clear()
				if row.members then
					for _, ply in ipairs(row.members) do
						memberList:AddLine(ply:Nick(), ply:SteamID64()).ply = ply
					end
				end
			end

			function memberList:OnRowSelected(_, row)
				selectedMember = row.ply
			end

			local cpList = vgui.Create("DListView", pnl)
			cpList:SetPos(10, 10)
			cpList:SetSize(160, 400)
			cpList:AddColumn("CP")
			cpList:AddColumn("PT")
			cpList:SetMultiSelect(false)
			cpList:SetSkin("Combine")

			function cpList:OnRowSelected(_, row)
				selectedMember = row.ply
			end

			local function RefreshCPs()
				cpList:Clear()
				for _, ply in ipairs(player.GetAll()) do
					if ply:Team() == TEAM_CP then
						local pt = ply:GetSyncVar(SYNC_SQUAD_ID)
						local ptText = pt or "UNASIGNED"
						local line = cpList:AddLine(ply:Nick(), ptText)
						line.ply = ply -- This is crucial!
					end
				end
			end

			assignLeaderBtn.DoClick = function()
				if not selectedMember then impulse.debugPrint("No member or PT selected") return end
				net.Start("impulseDISPSquadMake")
					net.WritePlayer(selectedMember)
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
				timer.Simple(0.2, RefreshPTs)
			end

			assignMemberBtn.DoClick = function()
				if not selectedMember or not selectedPT then return end
				local ptid = tonumber(selectedPT)
				net.Start("impulseSquadAssignment")
					net.WritePlayer(selectedMember)
					net.WriteUInt(ptid, 8)
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
				timer.Simple(0.2, RefreshPTs)
			end

			removeMemberBtn.DoClick = function()
				if not selectedMember then return end
				net.Start("impulseSquadKick")
					net.WritePlayer(selectedMember)
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
				timer.Simple(0.2, RefreshPTs)
			end

			disbandBtn.DoClick = function()
				if not selectedPT then return end
				local ptid = tonumber(selectedPT)
				if not ptid then return end
				net.Start("impulseHL2RPDisbandSquad")
					net.WriteUInt(ptid, 8)
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
				timer.Simple(0.2, RefreshPTs)
			end

			setObjBtn.DoClick = function()
				if not selectedPT then return end
				local ptid = tonumber(selectedPT)
				local obj = objBox:GetValue()
				net.Start("DeepSquadOrder")
					net.WriteUInt(ptid, 8)
					net.WriteString(obj)
					net.WriteBool(true)
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
			end

			RefreshCPs()
			RefreshPTs()
		end
	},
	["Civil Dossier"] = {
		img = "impulse/icons/cog-128.png",
		w = 700,
		h = 600,
		panel = function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			CurrentCivilDossierPanel = pnl

			pnl.Dossiers = pnl.Dossiers or {}

			local playerList = vgui.Create("DListView", pnl)
			playerList:SetPos(10, 10)
			playerList:SetSize(250, 120)
			playerList:AddColumn("Player")
			playerList:AddColumn("UID")
			playerList:SetMultiSelect(false)
			playerList:SetSkin("Combine")

			for _, ply in ipairs(player.GetAll()) do
				playerList:AddLine(ply:Nick(), ply:SteamID64())
			end

			local steamidEntry = vgui.Create("DTextEntry", pnl)
			steamidEntry:SetPos(270, 10)
			steamidEntry:SetSize(200, 24)
			steamidEntry:SetPlaceholderText("Enter SteamID...")

			local loadBtn = vgui.Create("DButton", pnl)
			loadBtn:SetText("Load File")
			loadBtn:SetPos(480, 10)
			loadBtn:SetSize(100, 24)

			local dossierBox = vgui.Create("DTextEntry", pnl)
			dossierBox:SetPos(10, 150)
			dossierBox:SetSize(570, 300)
			dossierBox:SetMultiline(true)
			dossierBox:SetPlaceholderText("Write content here...")

			local saveBtn = vgui.Create("DButton", pnl)
			saveBtn:SetText("Save File")
			saveBtn:SetPos(10, 475)
			saveBtn:SetSize(120, 28)

			local currentSteamID = nil


			local function LoadDossier(steamid)
				currentSteamID = steamid
				dossierBox:SetValue("Loading...")
				
				net.Start("impulse_dispatch_dossier_load")
					net.WriteString(steamid)
				net.SendToServer()

			
			    net.Receive("impulse_dispatch_dossier_data", function()
					local steamid = net.ReadString()
					local text = net.ReadString()
					
					if IsValid(CurrentCivilDossierPanel) and IsValid(dossierBox) then
						dossierBox:SetValue(text)
						CurrentCivilDossierPanel.Dossiers[steamid] = text
					end
            	end)

			end

			function playerList:OnRowSelected(_, row)
				local steamid = row:GetColumnText(2)
				LoadDossier(steamid)
			end

			loadBtn.DoClick = function()
				local input = steamidEntry:GetValue()
				if input and input:len() > 0 then
					local steamid64 = input
					if input:find("STEAM_") then
						steamid64 = SteamIDTo64(input)
						steamidEntry:SetValue(steamid64)
					end
					LoadDossier(steamid64)
				end
			end

			saveBtn.DoClick = function()
				if not currentSteamID then return end
				net.Start("impulse_dispatch_dossier_save")
					net.WriteString(currentSteamID)
					net.WriteString(dossierBox:GetValue())
				net.SendToServer()
				surface.PlaySound("buttons/button15.wav")
			end

			function pnl:Think()
				if self.PendingDossierUpdate then
					dossierBox:SetValue(self.PendingDossierUpdate)
					self.PendingDossierUpdate = nil
				end
			end

			pnl.OnRemove = function()
				if CurrentCivilDossierPanel == pnl then
					CurrentCivilDossierPanel = nil
				end
			end

			return pnl
		end
	},
--[[	["Map"] = {
		img = "impulse/icons/brain-3-256.png",
		xPos = 120,
		yPos = 120,
		w=800,
		h=600,
		panel = function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)

			local mapImage = vgui.Create("DImage", pnl)
			mapImage:SetSize(800, 600)
			mapImage:SetPos(0, 0)
			mapImage:SetImage("overview_i17.jpg")


			local worldOrigin = Vector(-3800, -3600, 0)
			local worldSize = Vector(12000, 13000, 0) 
			local mapSize = {w = 800, h = 600}

			local function WorldToMap(pos)
				local relX = (pos.x - worldOrigin.x) / worldSize.x
				local relY = (pos.y - worldOrigin.y) / worldSize.y
				relY = 1 - relY
				return relX * mapSize.w, relY * mapSize.h
			end

			mapImage.PaintOver = function(self, w, h)
				for _, ply in ipairs(player.GetAll()) do
					if not IsValid(ply) then continue end
						if ply:Team() == TEAM_CP and ply:GetSyncVar(SYNC_SQUAD_LEADER, false) then
							local pos = ply:GetPos()
							local x, y = WorldToMap(pos)
							surface.SetDrawColor(255, 0, 0, 255)
							surface.DrawRect(x - 4, y - 4, 8, 8)
							draw.SimpleText(ply:Nick().." (PTL:"..ply:GetSyncVar(SYNC_SQUAD_ID, -1)..")", "DermaDefault", x + 8, y - 8, color_white)
						end
				end
			end
		end
	},]]
	["Unit Management"] = {
    img = "impulse/icons/group-256.png",
    xPos = 120,
    yPos = 120,
    w = 900,
    h = 650,
    panel = function(parent)
        local pnl = vgui.Create("DPanel", parent)
        pnl:Dock(FILL)
        pnl:SetSkin("Combine")

        -- Create tabs for different management functions
        local tabs = vgui.Create("DPropertySheet", pnl)
        tabs:Dock(FILL)
        tabs.Paint = function() end

        -- Unit List Panel
        local unitPanel = vgui.Create("DPanel", tabs)
        unitPanel:Dock(FILL)

        local unitList = vgui.Create("DListView", unitPanel)
        unitList:SetPos(10, 10)
        unitList:SetSize(400, 550)
        unitList:AddColumn("Unit Name"):SetFixedWidth(150)
        unitList:AddColumn("Rank"):SetFixedWidth(100)
        unitList:AddColumn("Squad"):SetFixedWidth(80)
        unitList:AddColumn("Status"):SetFixedWidth(70)
        unitList:SetMultiSelect(false)
        unitList:SetSkin("Combine")

        -- Management Controls Panel
        local controlsPanel = vgui.Create("DPanel", unitPanel)
        controlsPanel:SetPos(420, 10)
        controlsPanel:SetSize(450, 550)
        controlsPanel:SetSkin("Combine")

        -- Selected unit display
        local selectedLabel = vgui.Create("DLabel", controlsPanel)
        selectedLabel:SetPos(10, 10)
        selectedLabel:SetSize(430, 25)
        selectedLabel:SetText("Selected Unit: None")
        selectedLabel:SetFont("DermaDefaultBold")

        -- Unit Actions Section
        local actionsLabel = vgui.Create("DLabel", controlsPanel)
        actionsLabel:SetPos(10, 50)
        actionsLabel:SetText("Unit Actions:")
        actionsLabel:SetFont("DermaDefaultBold")
        actionsLabel:SizeToContents()

        local promoteBtn = vgui.Create("DButton", controlsPanel)
        promoteBtn:SetText("Promote Unit")
        promoteBtn:SetPos(10, 75)
        promoteBtn:SetSize(120, 30)
        promoteBtn:SetDisabled(true)

        local demoteBtn = vgui.Create("DButton", controlsPanel)
        demoteBtn:SetText("Demote Unit")
        demoteBtn:SetPos(140, 75)
        demoteBtn:SetSize(120, 30)
        demoteBtn:SetDisabled(true)

        local meritBtn = vgui.Create("DButton", controlsPanel)
        meritBtn:SetText("Merit Unit")
        meritBtn:SetPos(270, 75)
        meritBtn:SetSize(120, 30)
        meritBtn:SetDisabled(true)

        local awardSCBtn = vgui.Create("DButton", controlsPanel)
        awardSCBtn:SetText("Award SC")
        awardSCBtn:SetPos(10, 115)
        awardSCBtn:SetSize(120, 30)
        awardSCBtn:SetDisabled(true)

        -- Unit Information Section
        local infoLabel = vgui.Create("DLabel", controlsPanel)
        infoLabel:SetPos(10, 235)
        infoLabel:SetText("Unit Information:")
        infoLabel:SetFont("DermaDefaultBold")
        infoLabel:SizeToContents()

        local infoBox = vgui.Create("DTextEntry", controlsPanel)
        infoBox:SetPos(10, 260)
        infoBox:SetSize(410, 240)
        infoBox:SetMultiline(true)
        infoBox:SetEditable(false)
        infoBox:SetText("Select a unit to view information...")

        local selectedUnit = nil
        local function RefreshUnits()
            unitList:Clear()
            for _, ply in ipairs(player.GetAll()) do
                if ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA or ply:Team() == TEAM_CA then
                    local rank = ply:GetTeamRankName() or "Unknown"
                    local squad = ply:GetSyncVar(SYNC_SQUAD_ID) or "None"
                    local status = ply:Alive() and "Alive" or "Dead"
                    
                    local line = unitList:AddLine(ply:Nick(), rank, squad, status)
                    line.ply = ply
                end
            end
        end
        local function UpdateUnitInfo(ply)
            if not IsValid(ply) then
                infoBox:SetText("Select a unit to view information...")
                return
            end

            local playtime = "Unknown"
            if ply.GetUTime then
                playtime = string.NiceTime(ply:GetUTime())
            elseif ply.GetUTimeTotalTime then
                playtime = string.NiceTime(ply:GetUTimeTotalTime())
            elseif ply.GetSessionTime then
                playtime = string.NiceTime(ply:GetSessionTime())
            end

            local info = string.format([[
				Unit: %s
				SteamID: %s
				Rank: %s (%d)
				Team: %s
				Squad: %s
				Squad Leader: %s
				Health: %d/%d
				Armor: %d
				Position: %s
				Playtime: %s
            ]], 
                ply:Nick(),
                ply:SteamID(),
                ply:GetTeamRankName() or "Unknown",
                ply:GetTeamRank() or 0,
                team.GetName(ply:Team()),
                ply:GetSyncVar(SYNC_SQUAD_ID) or "None",
                ply:GetSyncVar(SYNC_SQUAD_LEADER) and "Yes" or "No",
                ply:Health(),
                ply:GetMaxHealth(),
                ply:Armor(),
                tostring(ply:GetPos()),
                playtime
            )
            
            infoBox:SetText(info)
        end

        unitList.OnRowSelected = function(self, index, row)
            selectedUnit = row.ply
            selectedLabel:SetText("Selected Unit: " .. (IsValid(selectedUnit) and selectedUnit:Nick() or "None"))
            
            local isValidUnit = IsValid(selectedUnit)
            promoteBtn:SetDisabled(not isValidUnit)
            demoteBtn:SetDisabled(not isValidUnit)
            meritBtn:SetDisabled(not isValidUnit)
            awardSCBtn:SetDisabled(not isValidUnit)
            
            UpdateUnitInfo(selectedUnit)
        end

        promoteBtn.DoClick = function()
            if not IsValid(selectedUnit) then return end
            
            Derma_Query("Promote " .. selectedUnit:Nick() .. "?", "Unit Management", "Confirm", function()
                net.Start("DeepTerminalWhitelistChange")
                net.WriteEntity(selectedUnit)
                net.WriteBool(true)
                net.SendToServer()
                
                timer.Simple(0.5, RefreshUnits)
            end, "Cancel")
        end

        demoteBtn.DoClick = function()
            if not IsValid(selectedUnit) then return end
            
            Derma_Query("Demote " .. selectedUnit:Nick() .. "?", "Unit Management", "Confirm", function()

                net.Start("DeepTerminalWhitelistChange")
                net.WriteEntity(selectedUnit)
                net.WriteBool(false) 
                net.SendToServer()
                
                timer.Simple(0.5, RefreshUnits)
            end, "Cancel")
        end

        meritBtn.DoClick = function()
            if not IsValid(selectedUnit) then return end
            
            Derma_StringRequest("Merit Unit", "Enter merit reason:", "", function(reason)
                if reason == "" then return end
                
                local cmd = "/merit " .. selectedUnit:Nick() .. " " .. reason
                RunConsoleCommand("say", cmd)
                
                surface.PlaySound("buttons/button15.wav")
            end)
        end

        awardSCBtn.DoClick = function()
            if not IsValid(selectedUnit) then return end
            
            Derma_StringRequest("combine", 
				"Enter amount to issue:",
				nil, function(text)
					local targ = player.GetBySteamID64(selectedUnit:SteamID64())
					if not tonumber(text) then
						return LocalPlayer():Notify("You must enter a number.")
					end
					local amount = math.floor(tonumber(text))
					if amount <= 0 then
						LocalPlayer():Notify("A positive integer must be inserted.")
						return
					elseif amount > 240 then
						LocalPlayer():Notify("The maximum is 240.")
						return
					end
					
					net.Start("DeepAwardSCs")
					net.WriteEntity(targ)
					net.WriteUInt(amount, 20)
					net.SendToServer()
			end, nil, "Issue Credits")
        end

        -- Auto-refresh timer
        local lastRefresh = 0
        unitPanel.Think = function()
            if CurTime() - lastRefresh > 3 then
                RefreshUnits()
                if IsValid(selectedUnit) then
                    UpdateUnitInfo(selectedUnit)
                end
                lastRefresh = CurTime()
            end
        end

        tabs:AddSheet("Unit Management", unitPanel, "icon16/group.png")

        RefreshUnits()

        return pnl
    end
},
	["Scanner"] = {
		img = "impulse/icons/search-3-256.png",
		xPos = 120,
		yPos = 120,
		w = 250,
		h = 90,
		panel = function(parent)
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)

			local initButton = vgui.Create("DButton", pnl)
			initButton:SetText("Initialize Scanner")
			initButton:SetSize(200, 30)
			initButton:SetPos(10, 10)
			initButton.DoClick = function()
				local frame = parent
				while frame and not frame.Close do
					frame = frame:GetParent()
				end

				if IsValid(frame) then
					frame:Close()
				end

				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDeployScanner")
				net.WriteBool(true)
				net.SendToServer()
			end
		end
	},
	["Radio"] = {
    img = "impulse/icons/megaphone-128.png",
    xPos = 120,
    yPos = 120,
    w = 800,
    h = 600,
    panel = function(parent)
        selection = 1
        local pnl = vgui.Create("DPanel", parent)
        pnl:Dock(FILL)
        pnl:SetSkin("Combine")

        local tabs = vgui.Create("DPropertySheet", pnl)
        tabs:Dock(FILL)

		tabs.Paint = function()
		end

        local controlPanel = vgui.Create("DPanel", tabs)
        controlPanel:Dock(FILL)

        local textInput = vgui.Create("DTextEntry", controlPanel)
        textInput:SetPos(5, 50)
        textInput:SetSize(500, 20)
        textInput:RequestFocus()
        textInput:SetUpdateOnType(true)

        local mpfBtn = vgui.Create("DButton", controlPanel)
        mpfBtn:SetText("MPF Radio")
        mpfBtn:SetPos(5, 5)
        mpfBtn:SetSize(100, 30)
        mpfBtn.DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            selection = 1
        end

        local ctaBtn = vgui.Create("DButton", controlPanel)
        ctaBtn:SetText("CTA Radio")
        ctaBtn:SetPos(130, 5)
        ctaBtn:SetSize(100, 30)
        ctaBtn.DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            selection = 2
        end

        local globalBtn = vgui.Create("DButton", controlPanel)
        globalBtn:SetText("Overwatch Radio")
        globalBtn:SetPos(255, 5)
        globalBtn:SetSize(160, 30)
        globalBtn.DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            selection = 3
        end

        local submit = vgui.Create("DButton", controlPanel)
        submit:SetText("Issue Message")
        submit:SetPos(130, 125)
        submit:SetSize(160, 30)
        submit.DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            local message = textInput:GetValue()
            net.Start("impulseHL2RPOVWDispatchRadio")
                net.WriteString(message)
                net.WriteUInt(selection, 8)
            net.SendToServer()
            textInput:SetText("")
        end

        tabs:AddSheet("Radio Control", controlPanel, "icon16/sound.png")

        local logsPanel = vgui.Create("DPanel", tabs)
        logsPanel:Dock(FILL)
        logsPanel:DockPadding(5, 5, 5, 5)

        local logList = vgui.Create("DListView", logsPanel)
        logList:Dock(FILL)
        logList:SetMultiSelect(false)
        logList:AddColumn("Time"):SetFixedWidth(80)
        logList:AddColumn("Frequency"):SetFixedWidth(120)
        logList:AddColumn("Sender"):SetFixedWidth(150)
        logList:AddColumn("Message")

        local function RefreshAllLogs()
            logList:Clear()
            
            local allLogs = {}
            
            for frequency, logs in pairs(impulse.RadioLogs or {}) do
                for _, log in ipairs(logs) do
                    table.insert(allLogs, {
                        frequency = frequency,
                        sender = log.sender,
                        message = log.message,
                        timestamp = log.timestamp
                    })
                end
            end
            
            table.sort(allLogs, function(a, b)
                return a.timestamp > b.timestamp
            end)
            
            for _, log in ipairs(allLogs) do
                local line = logList:AddLine(
                    os.date("%H:%M:%S", log.timestamp),
                    log.frequency,
                    log.sender,
                    log.message
                )
            end
        end

        local lastRefresh = 0
        logsPanel.Think = function()
            if CurTime() - lastRefresh > 5 then
                RefreshAllLogs()
                lastRefresh = CurTime()
            end
        end

        RefreshAllLogs()

        tabs:AddSheet("Radio Logs", logsPanel, "icon16/book.png")

        return pnl
    end
},
	["City Code"] = {
		img = "impulse/icons/info-128.png",
		xPos = 120,
		yPos = 120,
		w = 860,
		h = 100,
		panel = function(parent)
			selection = 1
			local pnl = vgui.Create("DPanel", parent)
			pnl:Dock(FILL)
			pnl:SetSkin("Combine")

			local stbl = vgui.Create("DButton", pnl)
			stbl:SetText("STABLE")
			stbl:SetPos(5, 5)
			stbl:SetSize(130, 30)
			stbl.DoClick = function()
				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDispatchCityCode")
				net.WriteUInt(1, 4)
				net.SendToServer()
			end

			local marginal = vgui.Create("DButton", pnl)
			marginal:SetText("MARGINAL")
			marginal:SetPos(145, 5)
			marginal:SetSize(130, 30)
			marginal.DoClick = function()
				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDispatchCityCode")
				net.WriteUInt(2, 4)
				net.SendToServer()
			end

			local fracture = vgui.Create("DButton", pnl)
			fracture:SetText("FRACTURED")
			fracture:SetPos(285, 5)
			fracture:SetSize(130, 30)
			fracture.DoClick = function()
				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDispatchCityCode")
				net.WriteUInt(3, 4)
				net.SendToServer()
			end

			local aj = vgui.Create("DButton", pnl)
			aj:SetText("AUTONOMOUS JUDGEMENT")
			aj:SetPos(425, 5)
			aj:SetSize(220, 30)
			aj.DoClick = function()
				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDispatchCityCode")
				net.WriteUInt(4, 4)
				net.SendToServer()
			end

			local jw = vgui.Create("DButton", pnl)
			jw:SetText("JUDGEMENT WAIVER")
			jw:SetPos(655, 5)
			jw:SetSize(220, 30)
			jw.DoClick = function()
				surface.PlaySound("buttons/button15.wav")
				net.Start("impulseHL2RPDispatchCityCode")
				net.WriteUInt(5, 4)
				net.SendToServer()
			end

			return pnl
		end
	},
	["C.A.S"] = {
        img = "impulse/icons/clenched-fist-256.png",
        xPos = 120,
        yPos = 120,
        panel = function(parent)
            local pnl = vgui.Create("DPanel", parent)
            pnl:Dock(FILL)
            pnl.Paint = function(self, w, h)
                draw.SimpleText("civil address system", "combineTextSmol", w/2, h/2, Color(255,255,255,5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

			pnl.dispatchLineScroll = vgui.Create("DScrollPanel", pnl)
			pnl.dispatchLineScroll:SetPos(0, 5)
			pnl.dispatchLineScroll:SetSize(450, 300)

			for v,k in pairs(impulse.Config.DispatchLines) do
				local dispatchBtn = pnl.dispatchLineScroll:Add("DButton")
				dispatchBtn:SetText(k.name)
				dispatchBtn:SetFont("DebugFixed")
				dispatchBtn:Dock(TOP)
				dispatchBtn:DockMargin(0, 0, 0, 5)
				dispatchBtn.Announcement = v

				function dispatchBtn:DoClick()
					net.Start("impulseHL2RPDispatchAnnounce")
					net.WriteUInt(self.Announcement, 8)
					net.SendToServer()
				end
			end

            return pnl
        end
    },
}

function PANEL:Init()
    self.IsEscaped = false
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle(" ")
    self:MakePopup()

    surface.PlaySound("oakman/deadspace/ui/obj_complete.wav")

    self.OpenAppWindows = {}

    local iconSize = 64
    local margin = 32
    local startX = margin
    local startY = margin
    local spacing = iconSize + 48

    local i = 0
    for appName, appData in pairs(applications) do
		local entry = vgui.Create("DButton", self)
		local btnW, btnH = iconSize + 48, iconSize + 56
		entry:SetSize(btnW, btnH)
		entry:SetPos(startX, startY + i * spacing)
		entry:SetText("")

		entry.HoverLerp = 0
		entry.Dragging = false
		entry.DragOffset = {x = 0, y = 0}
		entry._wasHovered = false

		entry.Paint = function(pnl, w, h)
			local hovered = pnl:IsHovered()
			if hovered then
				pnl.HoverLerp = math.min(pnl.HoverLerp + FrameTime() * 8, 1)
			else
				pnl.HoverLerp = math.max(pnl.HoverLerp - FrameTime() * 8, 0)
			end

			if hovered and not pnl._wasHovered then
				surface.PlaySound("oakman/deadspace/ui/ui_hover.wav")
			end
			pnl._wasHovered = hovered

			local scale = 1 + 0.08 * pnl.HoverLerp
			local drawW, drawH = iconSize * scale, iconSize * scale
			local drawX = (w - drawW) / 2
			local drawY = 4

			surface.SetDrawColor(255, 255, 255, 220)
			surface.SetMaterial(Material(appData.img or "icon16/error.png", "smooth"))
			surface.DrawTexturedRect(drawX, drawY, drawW, drawH)
			draw.SimpleText(appName, "DermaDefaultBold", w / 2, drawY + drawH + 4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		entry.OnMousePressed = function(pnl, mcode)
			if mcode == MOUSE_LEFT then
				pnl.Dragging = true
				local mx, my = gui.MousePos()
				local x, y = pnl:GetPos()
				pnl.DragOffset.x = mx - x
				pnl.DragOffset.y = my - y
				pnl.DragStartPos = {x = mx, y = my}
				pnl:MouseCapture(true)
			end
		end

		entry.OnMouseReleased = function(pnl, mcode)
			if mcode == MOUSE_LEFT then
				pnl.Dragging = false
				pnl:MouseCapture(false)
				local mx, my = gui.MousePos()
				if pnl.DragStartPos and math.Distance(mx, my, pnl.DragStartPos.x, pnl.DragStartPos.y) < 6 then
					if pnl.DoClick then pnl:DoClick() end
				end
			end
		end

		entry.Think = function(pnl)
			if pnl.Dragging then
				local mx, my = gui.MousePos()
				local newX = math.Clamp(mx - pnl.DragOffset.x, 0, self:GetWide() - pnl:GetWide())
				local newY = math.Clamp(my - pnl.DragOffset.y, 0, self:GetTall() - pnl:GetTall())
				pnl:SetPos(newX, newY)
			end
		end

		entry.DoClick = function()
			surface.PlaySound("oakman/deadspace/ui/hud_save_confirm.wav")
			local win = vgui.Create("DFrame")
			win:SetTitle(appName)
			win:SetSize(appData.w or 400,appData.h or 300)
			win:Center()
			win:SetSkin("combine")
			win:MakePopup()
			win:MoveToFront()

			if appData.panel then
				appData.panel(win)
			else
				local label = vgui.Create("DLabel", win)
				label:SetText("This is the " .. appName .. " application.")
				label:Dock(FILL)
				label:SetContentAlignment(5)
				label:SetFont("DermaDefaultBold")
			end

			table.insert(self.OpenAppWindows, win)
			win.OnClose = function()
			end
		end
		i = i + 1
	end

	local taskbarH = 48
    local taskbar = vgui.Create("DPanel", self)
    taskbar:SetPos(0, self:GetTall() - taskbarH)
    taskbar:SetSize(self:GetWide(), taskbarH)
    taskbar.Paint = function(pnl, w, h)
        surface.SetDrawColor(20, 30, 40, 230)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(60, 120, 180, 120)
        surface.DrawRect(0, 0, w, 2)
    end

    local powerBtnSize = 40
    local powerBtn = vgui.Create("DButton", self)
    powerBtn:SetSize(powerBtnSize, powerBtnSize)
    powerBtn:SetPos(4, self:GetTall() - taskbarH + (taskbarH - powerBtnSize) / 2)
    powerBtn:SetText("")
    powerBtn.Paint = function(pnl, w, h)
        if pnl:IsHovered() then
            surface.SetDrawColor(200, 60, 60, 255)
        else
            surface.SetDrawColor(255, 255, 255, 220)
        end
        surface.SetMaterial(Material("mrp/icons/logout.png", "smooth"))
        surface.DrawTexturedRect(4, 4, w - 8, h - 8)
    end
    powerBtn.DoClick = function()
        surface.PlaySound("oakman/deadspace/ui/hud_save_confirm.wav")
        self:Close()
    end

    self.OnSizeChanged = function(s, w, h)
        taskbar:SetPos(0, h - taskbarH)
        taskbar:SetSize(w, taskbarH)
        powerBtn:SetPos(4, h - taskbarH + (taskbarH - powerBtnSize) / 2)
    end

    self.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("overlays/cmb_terminal_bg.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 25)
        surface.SetMaterial(Material("impulse_redux/propaganda.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(32, 200, 255, 255)
        surface.SetMaterial(Material("impulse_redux/corner_brackets.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 200)
        surface.SetMaterial(Material("overlays/cmb_bg_animated1"))
        surface.DrawTexturedRect(0, 0, w, h)

        local logoW, logoH = 512, 512
        local logoX = (w - logoW) / 2
        local logoY = (h - logoH) / 2
        surface.SetDrawColor(0, 232, 255, 2)
        surface.SetMaterial(Material("icons/combineclaw_upright_logo.png", "mip smooth"))
        surface.DrawTexturedRect(logoX, logoY, logoW, logoH)

        if self.OpenAppWindows then
            for _, win in ipairs(self.OpenAppWindows) do
                if IsValid(win) then
                    win:MoveToFront()
                end
            end
        end
    end

    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)
    self:SetDraggable(false)
    self:ShowCloseButton(false)
end

function PANEL:OnClose()
    if self.OpenAppWindows then
        for _, win in ipairs(self.OpenAppWindows) do
            if IsValid(win) then
                win:Close()
            end
        end
        self.OpenAppWindows = {}
    end
end

function PANEL:AddTab(name, panel)
	local newSheet = self.menu:AddSheet(name, panel)

	newSheet.Button:SetFont("BudgetLabel")

	local btnClick = newSheet.Button.DoClick
	local panel = self
	newSheet.Button.DoClick = function()
		btnClick()
	end
end

vgui.Register("impulsePlayableDispatch", PANEL, "DFrame")