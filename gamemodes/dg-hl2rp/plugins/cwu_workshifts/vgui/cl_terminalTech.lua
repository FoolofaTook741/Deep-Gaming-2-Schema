if CLIENT then
    local researchPanels = {}
    local ResearchFrame = nil
    local orderedResearchItems = {}

    local function BuildResearchUI(terminalEnt, researchItems)
        if IsValid(ResearchFrame) then
            ResearchFrame:Remove()
        end

        ResearchFrame = vgui.Create("DFrame")
        ResearchFrame:SetTitle("")
        ResearchFrame:SetSize(600, 450)
        ResearchFrame:Center()
        ResearchFrame:MakePopup()
        ResearchFrame:SetDraggable(false)

        ResearchFrame.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 255))
            draw.RoundedBox(0, 10, 30, w - 20, h - 40, Color(40, 40, 40, 255))
            draw.SimpleText("Technology Research Projects", "Trebuchet24", 20, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        local scroll = vgui.Create("DScrollPanel", ResearchFrame)
        scroll:Dock(FILL)

        researchPanels = {}
        orderedResearchItems = {}

        for id, item in pairs(researchItems) do
            table.insert(orderedResearchItems, item)
        end
        table.sort(orderedResearchItems, function(a, b)
            return a.id < b.id
        end)

        for i, item in ipairs(orderedResearchItems) do
			local panel = vgui.Create("DPanel", scroll)
			panel:Dock(TOP)
			panel:DockMargin(5, 5, 5, 5)
			panel:SetTall(120)
			panel:SetCursor("hand")

			panel.Paint = function(self, w, h)
				local col = Color(50, 50, 50, 200)
				if self:IsHovered() then
					col = Color(70, 70, 70, 220)
				end
				draw.RoundedBox(8, 0, 0, w, h, col)
				draw.SimpleText(item.name, "Trebuchet24", 10, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end

			local descLabel = vgui.Create("DLabel", panel)
			descLabel:SetPos(10, 35)
			descLabel:SetSize(400, 20)
			descLabel:SetText(item.description or "")
			descLabel:SetTextColor(color_white)
			descLabel:SetFont("Trebuchet18")

			local infoLabel = vgui.Create("DLabel", panel)
			infoLabel:SetPos(10, 60)
			infoLabel:SetSize(400, 20)
			local minutes = item.time / 60
			local minuteText = minutes == 1 and "min" or "mins"
			infoLabel:SetText("Cost: " .. item.cost .. " RP  |  Time: " .. minutes .. " " .. minuteText)
			infoLabel:SetTextColor(color_white)
			infoLabel:SetFont("Trebuchet18")

			local progressBar = vgui.Create("DProgress", panel)
			progressBar:SetPos(10, 85)
			progressBar:SetSize(400, 20)
			progressBar:SetFraction(item.progress or 0)

			local timeLabel = vgui.Create("DLabel", panel)
			timeLabel:SetSize(400, 20)
			timeLabel:SetPos(10, 85)
			timeLabel:SetText("")
			timeLabel:SetTextColor(color_white)
			timeLabel:SetFont("Trebuchet18")
			timeLabel:SetContentAlignment(5)

			local researchButton = vgui.Create("DButton", panel)
			researchButton:SetPos(420, 85)
			researchButton:SetSize(150, 30)
			researchButton:SetText("Research")
			researchButton:SetCursor("hand")
			researchButton:SetTooltip("Click to start research")

			local canResearch = true
			for j = 1, i - 1 do
				if orderedResearchItems[j].status ~= "Complete" then
					canResearch = false
					break
				end
			end

			if (not canResearch) or item.isResearching or item.status == "Complete" then
				researchButton:SetDisabled(true)
				if item.status == "Complete" then
					researchButton:SetText("Complete")
					progressBar:SetFraction(1)
					timeLabel:SetText("Complete")
				end
			end

			researchButton.DoClick = function()
				researchButton:SetDisabled(true)
				surface.PlaySound("buttons/button14.wav")
				net.Start("researchStartTECH")
					net.WriteEntity(terminalEnt)
					net.WriteInt(item.id, 32)
				net.SendToServer()
			end

			researchPanels[item.id] = { 
				progressBar = progressBar, 
				button = researchButton, 
				timeLabel = timeLabel,
				totalTime = item.time 
			}
		end

    end

    local function RefreshButtons()
        for i, item in ipairs(orderedResearchItems) do
            if item.status ~= "Complete" and not item.isResearching then
                local panelData = researchPanels[item.id]
                if panelData and IsValid(panelData.button) then
                    panelData.button:SetDisabled(false)
                    panelData.button:SetText("Research")
                end
                break
            end
        end
    end

    net.Receive("researchUITECH", function()
        local terminalEnt = net.ReadEntity()
        local researchItems = net.ReadTable()
        BuildResearchUI(terminalEnt, researchItems)
    end)
    
    net.Receive("researchErrorTECH", function()
        local researchID = net.ReadInt(32)
        if researchPanels[researchID] and IsValid(researchPanels[researchID].button) then
            researchPanels[researchID].button:SetText("Cooldown...")
            researchPanels[researchID].button:SetDisabled(true)
            timer.Simple(3, function()
                if researchPanels[researchID] and IsValid(researchPanels[researchID].button) then
                    researchPanels[researchID].button:SetDisabled(false)
                    researchPanels[researchID].button:SetText("Research")
                end
            end)
        end
    end)

	net.Receive("researchProgressTECH", function()
		local researchID = net.ReadInt(32)
		local progress = net.ReadFloat()
		local status = net.ReadString()

		local panelData = researchPanels[researchID]
		if panelData and IsValid(panelData.progressBar) then
			panelData.progressBar:SetFraction(progress)
		end

		if panelData and IsValid(panelData.timeLabel) then
			if progress < 1 then
				local totalRemaining = math.ceil(panelData.totalTime * (1 - progress))
				local minutes = math.floor(totalRemaining / 60)
				local seconds = totalRemaining % 60
				local t = string.format("%d:%02d", minutes, seconds)
				panelData.timeLabel:SetText(t)
			else
				panelData.timeLabel:SetText("Complete")
			end
		end

		if panelData and IsValid(panelData.button) then
			panelData.button:SetText(status)
			if status == "Research Complete" then
				panelData.button:SetDisabled(true)
				for _, item in ipairs(orderedResearchItems) do
					if item.id == researchID then
						item.status = "Complete"
						item.isResearching = false
						item.progress = 1
						break
					end
				end
				RefreshButtons()
			end
		end
	end)
end
