if CLIENT then
    local storedLogs = {}
    local refreshLogsFunction
    local lastRefresh = 0

    net.Receive("deepGroupLogsSend", function()
        storedLogs = net.ReadTable() or {}
        if refreshLogsFunction then
            refreshLogsFunction()
        end
    end)

    local groupEditor = vgui.GetControlTable("impulseGroupEditor")
    if groupEditor and groupEditor.ShowGroup then
        local oldShowGroup = groupEditor.ShowGroup

        function groupEditor:ShowGroup(...)
            oldShowGroup(self, ...)

            local logsPanel = self:AddSheet("Logs", "icon16/book.png")
            logsPanel:Dock(FILL)

            logsPanel.Requested = false
            function logsPanel:Think()
                if self:IsVisible() and not self.Requested then
                    net.Start("deepGroupLogsRequest")
                    net.SendToServer()
                    lastRefresh = CurTime()
                    self.Requested = true
                end
            end

            local logsTabs = vgui.Create("DPropertySheet", logsPanel)
            logsTabs:Dock(FILL)
			--[[
            local atmPanel = vgui.Create("DPanel", logsTabs)
            atmPanel:Dock(FILL)
            atmPanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, Color(60, 60, 60, 240))
                draw.SimpleText("ATM Logs", "Trebuchet24", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            logsTabs:AddSheet("ATM", atmPanel, "icon16/money.png")
			--]]
            local storagePanel = vgui.Create("DPanel", logsTabs)
            storagePanel:Dock(FILL)
            storagePanel:DockPadding(5, 5, 5, 5)
            storagePanel.Paint = function(self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40, 220))
            end

            local filterPanel = vgui.Create("DPanel", storagePanel)
            filterPanel:Dock(TOP)
            filterPanel:SetTall(40)
            filterPanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 240))
            end

            local filterCombo = vgui.Create("DComboBox", filterPanel)
            filterCombo:Dock(LEFT)
            filterCombo:DockMargin(10, 10, 10, 10)
            filterCombo:AddChoice("All")
            filterCombo:AddChoice("Deposit")
            filterCombo:AddChoice("Withdrawal")
            filterCombo:SetValue("All")

            local memberCombo = vgui.Create("DComboBox", filterPanel)
            memberCombo:Dock(LEFT)
            memberCombo:DockMargin(10, 10, 10, 10)
            memberCombo:AddChoice("All Members")
            local members = impulse.Group.Groups[1] and impulse.Group.Groups[1].Members or {}
            for steamID, info in pairs(members) do
                memberCombo:AddChoice(info.Name .. " ("..steamID..")")
            end
            memberCombo:SetValue("All Members")
            memberCombo:SetWide(200)

            local refreshButton = vgui.Create("DButton", filterPanel)
            refreshButton:Dock(RIGHT)
            refreshButton:DockMargin(10, 10, 10, 10)
            refreshButton:SetText("Refresh")
            refreshButton.DoClick = function()
                local now = CurTime()
                if now < lastRefresh + 30 then
                    local rem = math.ceil(lastRefresh + 30 - now)
                    chat.AddText(Color(255,100,100), "Please wait "..rem.."s before refreshing.")
                    return
                end
                lastRefresh = now
                refreshButton:SetDisabled(true)
                net.Start("deepGroupLogsRequest")
                net.SendToServer()
                timer.Simple(30, function()
                    if IsValid(refreshButton) then
                        refreshButton:SetDisabled(false)
                    end
                end)
            end

            local logsList = vgui.Create("DListView", storagePanel)
            logsList:Dock(FILL)
            logsList:AddColumn("Time"):SetMinWidth(40)
            logsList:AddColumn("Qty"):SetMinWidth(20)
            logsList:AddColumn("Player"):SetMinWidth(40)
            logsList:AddColumn("Description"):SetMinWidth(40)

            refreshLogsFunction = function()
                logsList:Clear()
                local selType   = filterCombo:GetValue():lower()
                local selMember = memberCombo:GetValue()
                local selID     = selMember:match("%((.-)%)") or ""

                for _, entry in ipairs(storedLogs) do
                    if (selType == "all" or entry.type:lower() == selType)
                    and (selMember == "All Members" or (entry.player or ""):find(selID)) then

                        local timeStr = os.date("%Y-%m-%d %H:%M:%S", entry.time)
                        local line = logsList:AddLine(
                            timeStr,
                            tostring(entry.amount),
                            entry.player or "<unknown>",
                            entry.description
                        )

                        for colIndex, cell in ipairs(line.Columns) do
                            cell:SetMouseInputEnabled(true)
                            cell:SetCursor("hand")
                            cell:SetTooltip("Right‑click to copy: " .. line:GetColumnText(colIndex))
                            function cell:OnMousePressed(mouseCode)
                                if mouseCode == MOUSE_RIGHT then
                                    local txt = line:GetColumnText(colIndex)
                                    SetClipboardText(txt)
                                    chat.AddText(Color(0,255,0), "Copied: ", txt)
                                end
                            end
                        end
                    end
                end
            end

            filterCombo.OnSelect = refreshLogsFunction
            memberCombo.OnSelect = refreshLogsFunction

            refreshLogsFunction()

            logsTabs:AddSheet("Storage", storagePanel, "icon16/box.png")
        end
    end
end
