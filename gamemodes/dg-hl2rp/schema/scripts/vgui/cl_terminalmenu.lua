local PANEL = {}

local COMBINE_BG          = Color(3, 6, 12, 240)
local COMBINE_BG_INNER    = Color(6, 12, 24, 240)
local COMBINE_ACCENT      = Color(0, 170, 220, 220)
local COMBINE_ACCENT_SOFT = Color(0, 120, 180, 140)
local COMBINE_WARNING     = Color(200, 81, 81, 230)
local COMBINE_TEXT        = Color(220, 230, 240)
local COMBINE_MUTED       = Color(130, 140, 160)

local blurMat = Material("pp/blurscreen")

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blurMat)

    for i = 1, 3 do
        blurMat:SetFloat("$blur", (i / 3) * (amount or 4))
        blurMat:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, scrW, scrH)
    end
end

local function DrawScanlines(w, h, alpha)
    alpha = alpha or 4
    surface.SetDrawColor(255, 255, 255, alpha)
    for i = 0, h, 2 do
        surface.DrawLine(0, i, w, i)
    end
end

local function StyleCombinePanel(panel, topInset)
    topInset = topInset or 0
    function panel:Paint(w, h)
        surface.SetDrawColor(COMBINE_BG_INNER)
        surface.DrawRect(0, topInset, w, h - topInset)

        surface.SetDrawColor(Color(0, 0, 0, 180))
        surface.DrawOutlinedRect(0, topInset, w, h - topInset)

        surface.SetDrawColor(Color(15, 25, 45, 240))
        surface.DrawOutlinedRect(1, topInset + 1, w - 2, h - topInset - 2)

        DrawScanlines(w, h, 2)
    end
end

local function StyleCombineButton(btn, isDanger)
    btn._cmbText = btn._cmbText or btn:GetText() or ""
    btn:SetText("")
    btn:SetTall(btn:GetTall() > 0 and btn:GetTall() or 26)
    btn:SetTextColor(COMBINE_TEXT)
    btn:SetFont("BudgetLabel")

    function btn:SetCMBText(t)
        self._cmbText = t or ""
    end

    function btn:Paint(w, h)
        local bg = Color(8, 16, 28, 220)

        if self:IsDown() then
            bg = Color(4, 8, 16, 220)
        elseif self:IsHovered() then
            bg = Color(12, 28, 48, 230)
        end

        surface.SetDrawColor(bg)
        surface.DrawRect(0, 0, w, h)

        local borderCol = isDanger and COMBINE_WARNING or COMBINE_ACCENT
        surface.SetDrawColor(borderCol)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        draw.SimpleText(self._cmbText or "", "BudgetLabel", 8, h / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

local function StyleListView(list)
    if not IsValid(list) then return end

    function list:Paint(w, h)
        surface.SetDrawColor(5, 10, 18, 230)
        surface.DrawRect(0, 0, w, h)
    end

    -- Style each column header (no GetHeader() to avoid nil on some gmod versions)
    timer.Simple(0, function()
        if not IsValid(list) then return end
        if not list.Columns then return end

        for _, col in ipairs(list.Columns) do
            if IsValid(col) and IsValid(col.Header) then
                local header = col.Header
                function header:Paint(w, h)
                    surface.SetDrawColor(8, 20, 40, 255)
                    surface.DrawRect(0, 0, w, h)
                    surface.SetDrawColor(COMBINE_ACCENT_SOFT)
                    surface.DrawOutlinedRect(0, 0, w, h)
                end
            end
        end
    end)
end


function PANEL:Init()
    self:SetSize(720, 520)
    self:Center()
    self:SetSkin("combine")
    self:MakePopup()
    self:SetTitle("")

    if IsValid(self.lblTitle) then
        self.lblTitle:SetVisible(false)
    end

    self:DockPadding(12, 40, 12, 12)

    local lp = LocalPlayer()

    local trace = {}
    trace.start = lp:EyePos()
    trace.endpos = trace.start + lp:GetAimVector() * 85
    trace.filter = lp

    local tr = util.TraceLine(trace)

    if IsValid(tr.Entity) and tr.Entity:GetClass() == "impulse_hl2rp_terminal" then
        self.terminalEnt = tr.Entity
    else
        return self:Remove()
    end

    self.displayTitle = "<:: TERMINAL #" .. self.terminalEnt:EntIndex() .. " ::>"

    function self:Paint(w, h)
        DrawBlur(self, 4)

        surface.SetDrawColor(COMBINE_BG)
        surface.DrawRect(0, 0, w, h)

        local headerH = 28
        surface.SetDrawColor(5, 12, 26, 255)
        surface.DrawRect(0, 0, w, headerH)

        surface.SetDrawColor(COMBINE_ACCENT)
        surface.DrawRect(0, headerH - 2, w, 2)

        draw.SimpleText(self.displayTitle or "", "BudgetLabel", 12, headerH / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local cityCode = impulse.Dispatch.GetCityCode()

        -- reserve space for the close button so we don't overlap it
        local reserve = 12
        if IsValid(self.btnClose) then
            reserve = self.btnClose:GetWide() + 18
        end

	draw.SimpleText("ACCESS GRANTED / " .. LocalPlayer():Name(), "BudgetLabel",
    	w - reserve, headerH / 2, COMBINE_MUTED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(Color(0, 0, 0, 220))
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        DrawScanlines(w, h, 3)
    end
end

function PANEL:SetupUI()
    self.menu = vgui.Create("DColumnSheet", self)
    self.menu:Dock(FILL)
    self.menu.Navigation:SetWidth(160)  
    self.menu.Content:InvalidateLayout(true)

   
    function self.menu.Navigation:Paint(w, h)
        surface.SetDrawColor(4, 8, 16, 240)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    function self.menu.Content:Paint(w, h)
        surface.SetDrawColor(COMBINE_BG_INNER)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local panel = self
    local lp = LocalPlayer()

    if self.ArrestedPlayer and IsValid(self.ArrestedPlayer) and lp:Team() == TEAM_CP then
        self.charges = vgui.Create("DPanel", self.menu)
        self.charges:Dock(FILL)
        StyleCombinePanel(self.charges, 26)

        self.chargesInfo = vgui.Create("DLabel", self.charges)
        self.chargesInfo:SetText("ACTIVE CIVIL CHARGES FOR: " .. self.ArrestedPlayer:Name())
        self.chargesInfo:SetFont("BudgetLabel")
        self.chargesInfo:SetTextColor(COMBINE_TEXT)
        self.chargesInfo:Dock(TOP)
        self.chargesInfo:DockMargin(8, 6, 8, 4)

        self.chargesBody = vgui.Create("impulseChargesMenu", self.charges)
        self.chargesBody:Dock(FILL)
        self.chargesBody:DockMargin(8, 2, 8, 8)
        self.chargesBody.master = self
    end

    self.bulletin = vgui.Create("DPanel", self.menu)
    self.bulletin:Dock(FILL)
    StyleCombinePanel(self.bulletin, 32)

    local bulletinHeader = vgui.Create("DLabel", self.bulletin)
    bulletinHeader:SetText("CMB SECTOR BULLETIN / LOCAL TELEMETRY")
    bulletinHeader:SetFont("BudgetLabel")
    bulletinHeader:SetTextColor(COMBINE_MUTED)
    bulletinHeader:Dock(TOP)
    bulletinHeader:DockMargin(8, 6, 8, 0)

    local cityCode = impulse.Dispatch.GetCityCode()
    local cityCodeData = impulse.Dispatch.CityCodes[cityCode]

    self.lblCityCode = vgui.Create("DLabel", self.bulletin)
    self.lblCityCode:Dock(TOP)
    self.lblCityCode:DockMargin(8, 4, 8, 0)
    self.lblCityCode:SetText("CITY CODE: " .. cityCode .. " (" .. cityCodeData[1] .. ")")
    self.lblCityCode:SetColor(cityCodeData[2])
    self.lblCityCode:SetFont("BudgetLabel")

    self.lblCitizenCount = vgui.Create("DLabel", self.bulletin)
    self.lblCitizenCount:Dock(TOP)
    self.lblCitizenCount:DockMargin(8, 2, 8, 0)
    self.lblCitizenCount:SetText("CITIZEN POPULATION COUNT: " .. tostring(#team.GetPlayers(TEAM_CITIZEN) + #team.GetPlayers(TEAM_CWU)))
    self.lblCitizenCount:SetTextColor(COMBINE_TEXT)
    self.lblCitizenCount:SetFont("BudgetLabel")

    self.lblLocalUnit = vgui.Create("DLabel", self.bulletin)
    self.lblLocalUnit:SetText("\nLOCAL UNIT: " .. lp:Name() ..
        "\nLOCAL DIVISION: " .. lp:GetTeamClassName() ..
        "\nLOCAL RANK: " .. lp:GetTeamRankName() .. "\n")
    self.lblLocalUnit:SizeToContents()
    self.lblLocalUnit:Dock(TOP)
    self.lblLocalUnit:DockMargin(8, 4, 8, 0)
    self.lblLocalUnit:SetTextColor(COMBINE_TEXT)
    self.lblLocalUnit:SetFont("BudgetLabel")

    self.lblReminder = vgui.Create("DLabel", self.bulletin)
    self.lblReminder:SetFont("BudgetLabel")
    self.lblReminder:SetTextColor(COMBINE_MUTED)
    self.lblReminder:SetText("\nCHAIN OF COMMAND REGISTRY\n" ..
        "---------------------------------\n" ..
        "Acting Sovereign Protection Unit: Commander PATROL-5\n" ..
        "---------------------------------\n" ..
        "Acting Sovereign Transhuman Unit: Commander SPEAR-3\n" ..
        "---------------------------------\n" ..
        "Acting City Administrator: Jesqo Smith\n" ..
        "---------------------------------")
    self.lblReminder:SizeToContents()
    self.lblReminder:Dock(TOP)
    self.lblReminder:DockMargin(8, 4, 8, 0)

    if lp:Team() == TEAM_CP and lp:GetTeamClass() == CLASS_GRID and lp:GetTeamRank() >= RANK_I2 then
        self.btnScanner = vgui.Create("DButton", self.bulletin)
        self.btnScanner:SetText("DEPLOY GRID SCANNER")
        self.btnScanner:Dock(TOP)
        self.btnScanner:DockMargin(8, 10, 8, 0)
        StyleCombineButton(self.btnScanner)
        self.btnScanner:SetCMBText("DEPLOY GRID SCANNER")

        function self.btnScanner:DoClick()
            net.Start("impulseHL2RPDeployScanner")
            net.WriteBool(false)
            net.SendToServer()
        end
    end

    if lp:Team() == TEAM_OTA and lp:GetTeamClass() == CLASS_NOMAD then
        self.btnScanner = vgui.Create("DButton", self.bulletin)
        self.btnScanner:SetText("DEPLOY CLAW SCANNER")
        self.btnScanner:Dock(TOP)
        self.btnScanner:DockMargin(8, 6, 8, 0)
        StyleCombineButton(self.btnScanner)
        self.btnScanner:SetCMBText("DEPLOY CLAW SCANNER")

        function self.btnScanner:DoClick()
            net.Start("impulseHL2RPDeployScanner")
            net.WriteBool(false)
            net.SendToServer()
        end
    end

    self.humanIndex = vgui.Create("DPanel", self)
    self.humanIndex:Dock(FILL)
    StyleCombinePanel(self.humanIndex, 0)

    self.humanIndexList = vgui.Create("DListView", self.humanIndex)
    self.humanIndexList:Dock(FILL)
    self.humanIndexList:DockMargin(8, 8, 8, 8)
    self.humanIndexList:SetMultiSelect(false)
    self.humanIndexList:SetSortable(true)
    self.humanIndexList:SetSkin("combine")
    StyleListView(self.humanIndexList)

    local title1 = self.humanIndexList:AddColumn("NAME")
    local title2 = self.humanIndexList:AddColumn("CID")
    title1.Header:SetFont("BudgetLabel")
    title2.Header:SetFont("BudgetLabel")

    for _, k in pairs(player.GetAll()) do
        if not k:IsCP() then
            local line = self.humanIndexList:AddLine(k:Name(), k:SteamID64())
            for _, col in pairs(line.Columns) do
                col:SetFont("BudgetLabel")
            end

            line.Ent = k

            function line:UpdateColors()
                return COMBINE_TEXT, COMBINE_TEXT, COMBINE_TEXT
            end
        end
    end

    function self.humanIndexList:OnRowSelected(index, row)
        local m = DermaMenu()
        m:SetSkin("combine")
        m:AddOption("Declare Manhunt", function()
            if not IsValid(row) then
                LocalPlayer():Notify("Invalid row.")
                return
            end

            if not IsValid(row.Ent) then
                LocalPlayer():Notify("Invalid entity.")
                return
            end

            if not LocalPlayer():IsCPCommand() then
                LocalPlayer():Notify("You must be a supervisor to use this command.")
                return
            end

            net.Start("deepPriorityOneSuspect")
            net.WriteEntity(row.Ent)
            net.SendToServer()
        end):SetIcon("icon16/flag_red.png")
        m:Open()
    end

    local doConvicts = false

    if self.Convicts and lp:CanUseTerminalConvicts() then
        doConvicts = true

        self.convictIndex = vgui.Create("DPanel", self)
        self.convictIndex:Dock(FILL)
        StyleCombinePanel(self.convictIndex, 0)

        self.convictIndexList = vgui.Create("DScrollPanel", self.convictIndex)
        self.convictIndexList:Dock(FILL)
        self.convictIndexList:DockMargin(8, 8, 8, 8)

        for v, k in pairs(self.Convicts) do
            if IsValid(v) and v:IsPlayer() then
                local entry = self.convictIndexList:Add("impulseTerminalPlayer")
                entry:SetPlayer(v, 1)
                entry:SetHeight(60)
                entry:Dock(TOP)
                entry:DockMargin(0, 0, 0, 4)
                entry.convictData = k
                entry.master = self
            end
        end
    end

    local doDispatch = false

    if IsValid(self.terminalEnt) and self.terminalEnt:GetOverwatchIndex() and
        (LocalPlayer():IsCPCommand() or (LocalPlayer():Team() == TEAM_OTA and LocalPlayer():GetTeamRank() >= RANK_OCP) or
        (LocalPlayer():Team() == TEAM_CP and LocalPlayer():GetTeamRank() >= RANK_OFC) or
        (LocalPlayer():Team() == TEAM_CA and LocalPlayer():GetTeamRank() >= RANK_COUNCILOR)) then

        doDispatch = true

        self.dispatch = vgui.Create("DPanel", self)
        self.dispatch:Dock(FILL)
        StyleCombinePanel(self.dispatch, 40)

        if (LocalPlayer():GetTeamClass() == CLASS_DISPATCH and LocalPlayer():Team() == TEAM_CP) then
            self.dispatchPlayerButton = vgui.Create("DButton", self.dispatch)
            self.dispatchPlayerButton:SetText("INITIATE DISPATCH BOOTUP SEQUENCE")
            self.dispatchPlayerButton:SetFont("BudgetLabel")
            self.dispatchPlayerButton:SetTextColor(COMBINE_WARNING)
            self.dispatchPlayerButton:Dock(BOTTOM)
            self.dispatchPlayerButton:DockMargin(8, 4, 8, 8)
            StyleCombineButton(self.dispatchPlayerButton, true)
            self.dispatchPlayerButton:SetCMBText("INITIATE DISPATCH BOOTUP SEQUENCE")

            self.dispatchPlayerButton.DoClick = function()
                if not LocalPlayer():GetTeamClass() == CLASS_DISPATCH then
                    return LocalPlayer():Notify("You must be on the dispatch class to use this feature.")
                end

                LocalPlayer():SendCombineMessage("DISPATCH IS ONLINE - FULL ACTIVE...", Color(0, 100, 0))
                if impulse.GetSetting("dispbootskip") then
                    vgui.Create("impulsePlayableDispatch")
                    return self:Close()
                end
                vgui.Create("DispatchInitMenu")
                self:Close()
            end
        end

        self.changeStateLbl = vgui.Create("DLabel", self.dispatch)
        self.changeStateLbl:SetText("CHANGE CITY CODE:")
        self.changeStateLbl:SetFont("BudgetLabel")
        self.changeStateLbl:SetTextColor(COMBINE_TEXT)
        self.changeStateLbl:SizeToContents()
        self.changeStateLbl:Dock(TOP)
        self.changeStateLbl:DockMargin(8, 8, 8, 2)

        self.changeStateBtn = vgui.Create("DComboBox", self.dispatch)
        self.changeStateBtn:SetValue(cityCodeData[1])
        self.changeStateBtn.lastThingy = cityCodeData[1]
        self.changeStateBtn:SetTextColor(cityCodeData[2])
        self.changeStateBtn:SetDark(true)
        self.changeStateBtn:SetSortItems(false)
        self.changeStateBtn:Dock(TOP)
        self.changeStateBtn:DockMargin(8, 0, 8, 8)

        function self.changeStateBtn:Paint(w, h)
            local alpha = 130
            surface.SetDrawColor(10, 20, 40, alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)

            draw.SimpleText(self:GetText() or "", "BudgetLabel", 8, h / 2, self:GetTextColor() or COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            return true
        end

        local panelRef = self

        function self.changeStateBtn:OnSelect(index, text, value)
            local ply = LocalPlayer()
            if self.skip then
                self.skip = false
                return
            end

            if not ply:IsCPCommand() then
                return ply:Notify("You must be a higher rank to perform this action.")
            end

            if index > 0 then
                local function ConfirmChange(idx)
                    local name = impulse.Dispatch.CityCodes[idx][1]
                    local confirm = Derma_Query("Change City Code to: " .. name .. "?", "CONFIRMATION REQUIRED",
                        "CONFIRM", function()
                            if IsValid(self) and IsValid(panelRef) then
                                self.lastThingy = idx
                                net.Start("impulseHL2RPDispatchCityCode")
                                net.WriteUInt(idx, 4)
                                net.SendToServer()

                                self.skip = true
                                self:ChooseOptionID(self.lastThingy or 1)

                                panelRef:Remove()
                            end
                        end,
                        "ABORT", function()
                            if IsValid(self) and IsValid(panelRef) then
                                panelRef:Remove()
                                return ply:Notify("Aborted.")
                            end
                        end)
                    confirm:SetSkin("combine")
                end

                if index == CODE_LOST and ply:IsSuperAdmin() then
                    ConfirmChange(index)
                elseif index == CODE_AJ and (ply:IsCommander() or ply:IsLeadAdmin()) then
                    ConfirmChange(index)
                elseif index ~= CODE_AJ and index ~= CODE_LOST then
                    ConfirmChange(index)
                end
            else
                panelRef:Remove()
                return ply:Notify("You must be a higher rank to perform this action.")
            end
        end

        for v, k in SortedPairs(impulse.Dispatch.CityCodes) do
            local name = k[1]
            if cityCodeData[1] == name then
                name = name .. " (CURRENT CODE)"
            end

            self.changeStateBtn:AddChoice(name, v)
        end
    end

    if LocalPlayer():IsCPCommand() then
        self.disipline = vgui.Create("DPanel", self.menu)
        self.disipline:Dock(FILL)
        StyleCombinePanel(self.disipline, 0)

        self.disiplineList = vgui.Create("DListView", self.disipline)
        self.disiplineList:Dock(FILL)
        self.disiplineList:DockMargin(8, 8, 8, 8)
        self.disiplineList:SetMultiSelect(false)
        self.disiplineList:SetSortable(true)
        self.disiplineList:SetSkin("combine")
        StyleListView(self.disiplineList)

        local title1M = self.disiplineList:AddColumn("UNIT")
        local title2M = self.disiplineList:AddColumn("CID")
        title1M.Header:SetFont("BudgetLabel")
        title2M.Header:SetFont("BudgetLabel")

        for _, k in pairs(player.GetAll()) do
            if k:IsCP() then
                local line = self.disiplineList:AddLine(k:Name(), k:SteamID64())
                for _, col in pairs(line.Columns) do
                    col:SetFont("BudgetLabel")
                end

                function line:UpdateColors()
                    return COMBINE_TEXT, COMBINE_TEXT, COMBINE_TEXT
                end
            end
        end

        local warning = "Misuse of any of the Terminal systems will result in a server ban or combine ban."

        function self.disiplineList:OnRowSelected(index, row)
            local ply = LocalPlayer()
            local m = DermaMenu()
            m:SetSkin("combine")
            m:AddOption("Toggle Rogue", function()
                Derma_Query("Are you sure you want to mark " .. row:GetValue(1) ..
                    " autonomous?\nThis will mark them for death from all Combine and disable their comms.\n\n" .. warning,
                    "CONFIRMATION OF ROGUE TOGGLE",
                    "TOGGLE ROGUE",
                    function()
                        local targ = player.GetBySteamID64(row:GetValue(2))
                        net.Start("DeepToggleRogue")
                        net.WriteEntity(targ)
                        net.SendToServer()
                    end,
                    "CANCEL"):SetSkin("combine")
            end):SetIcon("icon16/error.png")

            m:AddOption("Promote", function()
                Derma_Query("Are you sure you want to promote " .. row:GetValue(1) .. "?" .. warning,
                    "CONFIRMATION OF PROMOTION",
                    "PROMOTE",
                    function()
                        local targ = player.GetBySteamID64(row:GetValue(2))
                        local team = ply:Team()
                        local teamstring = ""
                        if teamstring then
                            net.Start("DeepTerminalWhitelistChange")
                            net.WriteEntity(targ)
                            net.WriteBool(true)
                            net.SendToServer()
                        end
                    end,
                    "CANCEL"):SetSkin("combine")
            end):SetIcon("icon16/add.png")

            m:AddOption("Demote", function()
                Derma_Query("Are you sure you want to demote " .. row:GetValue(1) .. "?" .. warning,
                    "CONFIRMATION OF DEMOTION",
                    "DEMOTE",
                    function()
                        local targ = player.GetBySteamID64(row:GetValue(2))
                        local team = ply:Team()
                        local teamstring = ""
                        if teamstring then
                            net.Start("DeepTerminalWhitelistChange")
                            net.WriteEntity(targ)
                            net.WriteBool(false)
                            net.SendToServer()
                        end
                    end,
                    "CANCEL"):SetSkin("combine")
            end):SetIcon("icon16/cancel.png")

            m:AddOption("Blacklist", function()
                Derma_StringRequest("combine",
                    "Enter duration of blacklist in minutes (1440 = 1d, 10080 = 1w, 43800 = 1m, 525600 = 1y):",
                    nil, function(text)
                        local targ = player.GetBySteamID64(row:GetValue(2))
                        if not tonumber(text) then
                            return LocalPlayer():Notify("You must enter a number.")
                        end
                        local length = math.floor(tonumber(text))
                        if length <= 0 then
                            LocalPlayer():Notify("A positive integer must be inserted.")
                            return
                        elseif length > 525600 then
                            LocalPlayer():Notify("The maximum blacklist time is 1 year.")
                            return
                        end

                        net.Start("DeepTerminalBlacklist")
                        net.WriteEntity(targ)
                        net.WriteUInt(length, 20)
                        net.SendToServer()
                    end, nil, "Issue Blacklist")
            end):SetIcon("icon16/delete.png")

            if LocalPlayer():Team() == TEAM_CP then
                m:AddOption("Award Sterilized Credits", function()
                    Derma_StringRequest("combine",
                        "Enter amount to issue:",
                        nil, function(text)
                            local targ = player.GetBySteamID64(row:GetValue(2))
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
                end):SetIcon("icon16/flag_green.png")
            end

            m:Open()
        end
    end

    self.bolIndex = vgui.Create("DPanel", self)
    self.bolIndex:Dock(FILL)
    StyleCombinePanel(self.bolIndex, 0)
    local lp = LocalPlayer()

    if (lp:GetTeamClass() == CLASS_GHOST and lp:GetTeamRank() >= RANK_I2) or lp:IsCPCommand() or lp:GetTeamRank() >= RANK_I1 then
        self.bolPlayer = vgui.Create("DComboBox", self.bolIndex)
        self.bolPlayer:SetPos(8, 8)
        self.bolPlayer:SetSize(450, 20)
        self.bolPlayer:SetValue("Select Citizen...")
        self.bolPlayer:SetSkin("Default")

        function self.bolPlayer:Paint(w, h)
            surface.SetDrawColor(10, 20, 40, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText(self:GetText() or "Select Citizen...", "BudgetLabel", 6, h / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            return true
        end

        for _, k in pairs(player.GetAll()) do
            if not k:IsCP() and not k:IsDispatchBOL() then
                self.bolPlayer:AddChoice(k:Name(), k)
            end
        end

        self.bolCrime = vgui.Create("DComboBox", self.bolIndex)
        self.bolCrime:SetPos(8, 32)
        self.bolCrime:SetSize(450, 20)
        self.bolCrime:SetValue("Select Conviction...")
        self.bolCrime:SetSkin("Default")

        function self.bolCrime:Paint(w, h)
            surface.SetDrawColor(10, 20, 40, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText(self:GetText() or "Select Conviction...", "BudgetLabel", 6, h / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            return true
        end

        for v, k in pairs(impulse.Config.ArrestCharges) do
            self.bolCrime:AddChoice(k.name, v)
        end

        self.bolAdd = vgui.Create("DButton", self.bolIndex)
        self.bolAdd:SetText("ADD BOL")
        self.bolAdd:SetPos(8, 56)
        self.bolAdd:SetSize(450, 22)
        StyleCombineButton(self.bolAdd)
        self.bolAdd:SetCMBText("ADD BOL")

        function self.bolAdd:Think()
            if panel.bolCrime:GetValue() == "Select Conviction..." or panel.bolPlayer:GetValue() == "Select Citizen..." then
                self:SetDisabled(true)
            else
                self:SetDisabled(false)
            end
        end

        local xx = self

        function self.bolAdd:DoClick()
            local name, ply = panel.bolPlayer:GetSelected()
            local charge, crime = panel.bolCrime:GetSelected()

            if not IsValid(ply) and not ply:IsDispatchBOL() then
                return
            end

            local qPanel = Derma_Query("Please confirm that you wish to set the BOL status of " .. name .. ".",
                "BOL ADD CONFIRMATION",
                "ADD BOL",
                function()
                    net.Start("impulseHL2RPAddBOL")
                    net.WriteEntity(ply)
                    net.WriteUInt(crime, 8)
                    net.SendToServer()

                    xx:Remove()
                end, "CANCEL")
            qPanel:SetSkin("combine")
        end
    end

    self.bolIndexList = vgui.Create("DScrollPanel", self.bolIndex)
    self.bolIndexList:SetPos(8, 86)
    self.bolIndexList:SetSize(500, 450)

    for _, k in pairs(player.GetAll()) do
        local bol, crime = k:IsDispatchBOL()
        if bol then
            local entry = self.bolIndexList:Add("impulseTerminalPlayer")
            entry:SetBOLPlayer(k, crime)
            entry:SetHeight(60)
            entry:Dock(TOP)
            entry:DockMargin(0, 0, 0, 4)
            entry.master = self
        end
    end

    self.camIndex = vgui.Create("DPanel", self)
    self.camIndex:Dock(FILL)
    StyleCombinePanel(self.camIndex, 0)

    self.camExit = vgui.Create("DButton", self.camIndex)
    self.camExit:SetPos(8, 8)
    self.camExit:SetSize(450, 22)
    self.camExit:SetText("EXIT CAMERA VIEW")
    StyleCombineButton(self.camExit, true)
    self.camExit:SetCMBText("EXIT CAMERA VIEW")

    if not WATCHING_CAM then
        self.camExit:SetDisabled(true)
    end

    function self.camExit:DoClick()
        WATCHING_CAM = nil
        impulse.hudEnabled = true
        self:SetDisabled(true)
    end

    self.camList = vgui.Create("DListView", self.camIndex)
    self.camList:SetPos(8, 36)
    self.camList:SetSize(450, 460)
    self.camList:SetMultiSelect(false)
    self.camList:SetSortable(true)
    self.camList:SetSkin("combine")
    StyleListView(self.camList)

    local camTitle1 = self.camList:AddColumn("CAM")
    local camTitle2 = self.camList:AddColumn("STATUS")
    camTitle1.Header:SetFont("BudgetLabel")
    camTitle2.Header:SetFont("BudgetLabel")

    for _, k in pairs(ents.FindByClass("npc_combine_camera")) do
        local camid = k:GetSyncVar(SYNC_CAM_CAMID, nil)
        if not camid then continue end

        local line = self.camList:AddLine(camid, k:IsCameraEnabled() and "ONLINE" or "OFFLINE")
        for _, col in pairs(line.Columns) do
            col:SetFont("BudgetLabel")
        end

        function line:UpdateColors()
            local status = self:GetColumnText(2)
            if status == "ONLINE" then
                return COMBINE_TEXT, Color(80, 200, 80), COMBINE_TEXT
            else
                return COMBINE_TEXT, Color(200, 80, 80), COMBINE_TEXT
            end
        end

        line.Ent = k
    end

    self.camList:SortByColumn(1)

    function self.camList:OnRowSelected(index, row)
        local m = DermaMenu()
        m:AddOption("View Camera", function()
            if not IsValid(row) then return end
            if not IsValid(row.Ent) then return end

            if not row.Ent:IsCameraEnabled() then
                return LocalPlayer():Notify("Camera is offline.")
            end

            net.Start("impulseHL2RPCameraView")
            net.WriteEntity(row.Ent)
            net.SendToServer()

            WATCHING_CAM = row.Ent
            WATCHING_CAM_POS = LocalPlayer():GetPos()
            impulse.hudEnabled = false

            panel.camExit:SetDisabled(false)
        end)
        m:Open()
    end

    self:AddTab("BULLETIN", self.bulletin)

    if self.ArrestedPlayer and IsValid(self.ArrestedPlayer) and LocalPlayer():Team() == TEAM_CP then
        self:AddTab("CIVIL CHARGES", self.charges)
    end

    self:AddTab("BOL INDEX", self.bolIndex)
    self:AddTab("CAM INDEX", self.camIndex)
    self:AddTab("HUMN. INDEX", self.humanIndex)

    if doConvicts then
        self:AddTab("CONV. INDEX", self.convictIndex)
    end

    if self.terminalEnt:GetOverwatchIndex() and (LocalPlayer():IsCPCommand() or (LocalPlayer():Team() == TEAM_CA and LocalPlayer():GetTeamRank() >= RANK_COUNCILOR)) then
        self:AddTab("DISPATCH", self.dispatch)
    end

    if LocalPlayer():IsCPCommand() then
        self:AddTab("MANAGEMENT", self.disipline)
    end

    hook.Run("TerminalExtraUI", self)
end

function PANEL:OnRemove()
    net.Start("impulseHL2RPTerminalLeave")
    net.SendToServer()

    WATCHING_CAM = nil
    impulse.hudEnabled = true
end

local useSounds = {
    "ambient/machines/combine_terminal_idle1.wav",
    "ambient/machines/combine_terminal_idle2.wav",
    "ambient/machines/combine_terminal_idle4.wav"
}

function PANEL:AddTab(name, panelObj)
    local newSheet = self.menu:AddSheet(name, panelObj)
    local btn = newSheet.Button
    local frame = self

    -- prevent Derma default label drawing & fix overlap
    btn._cmbText = btn:GetText() or name
    btn:SetText("")
    btn:SetTall(26)
    btn:DockMargin(4, 2, 4, 2)
    btn:SetContentAlignment(4)

    local oldClick = btn.DoClick

    btn.Paint = function(selfBtn, w, h)
        local active = (frame.menu.ActiveButton == selfBtn)
        local hovered = selfBtn:IsHovered()

        local bg = Color(6, 10, 20, 230)
        if active then
            bg = Color(8, 20, 40, 240)
        elseif hovered then
            bg = Color(10, 18, 32, 240)
        end

        surface.SetDrawColor(bg)
        surface.DrawRect(0, 0, w, h)

        if active then
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawRect(0, 0, 3, h)
        elseif hovered then
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawRect(0, 0, 2, h)
        end

        draw.SimpleText(selfBtn._cmbText or "", "BudgetLabel", 10, h / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    btn.DoClick = function()
        if oldClick then oldClick() end
        frame.menu.ActiveButton = btn

        if IsValid(frame.terminalEnt) then
            frame.terminalEnt:EmitSound(useSounds[math.random(1, #useSounds)], 60)
        end
    end
end

vgui.Register("impulseTerminalMenu", PANEL, "DFrame")
