local PANEL = {}

impulse.Segregation = false
impulse.CityLockdown = false

local unions = 0
local helixs = 0
local grids = 0
local ghosts = 0
local swords = 0

local echos = 0
local maces = 0
local rangers = 0
local fists = 0
local nomads = 0
local sweepers = 0
local paybacks = 0

local rogues = 0

local scs = 0
local civTax = 0
local cwuTax = 0
local doorPrice = 15

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

net.Receive("DeepSynchronizeSCCount", function()
    scs = net.ReadUInt(20)
end)

net.Receive("deepupdatetaxrate", function()
    local taxType = net.ReadUInt(2)
    local taxRate = net.ReadUInt(6)
    
    if taxType == 1 then
        civTax = taxRate
    elseif taxType == 2 then
        cwuTax = taxRate
    end
end)

net.Receive("deepupdatedoorprice", function()
    doorPrice = net.ReadUInt(6)
end)

net.Receive("DeepUnitMakeup", function()
    unions = net.ReadUInt(5)
    helixs = net.ReadUInt(5)
    grids = net.ReadUInt(5)
    ghosts = net.ReadUInt(5)
    swords = net.ReadUInt(5)

    echos = net.ReadUInt(5)
    maces = net.ReadUInt(5)
    rangers = net.ReadUInt(5)
    fists = net.ReadUInt(5)
    nomads = net.ReadUInt(5)
    sweepers = net.ReadUInt(5)
    paybacks = net.ReadUInt(5)

    rogues = net.ReadUInt(5)
end)

local pdaSounds = {
    [TEAM_CP] = {
        "npc/metropolice/vo/on1.wav",
        "npc/metropolice/vo/on2.wav",
        "npc/metropolice/vo/off1.wav",
        "npc/metropolice/vo/off2.wav",
        "npc/metropolice/vo/off3.wav"
    },
    [TEAM_OTA] = {
        "npc/combine_soldier/vo/on1.wav",
        "npc/combine_soldier/vo/on2.wav",
        "npc/combine_soldier/vo/off1.wav",
        "npc/combine_soldier/vo/off2.wav",
        "npc/combine_soldier/vo/off3.wav"
    }
}

local function pdaSound()
    local teamSounds = pdaSounds[LocalPlayer():Team()]

    if teamSounds then
        surface.PlaySound(teamSounds[math.random(1, #teamSounds)])
    end
end

local squadCol = Color(75, 155, 45)

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

    function self:Paint(w, h)
        DrawBlur(self, 4)

        surface.SetDrawColor(COMBINE_BG)
        surface.DrawRect(0, 0, w, h)

        local headerH = 28
        surface.SetDrawColor(5, 12, 26, 255)
        surface.DrawRect(0, 0, w, headerH)

        surface.SetDrawColor(COMBINE_ACCENT)
        surface.DrawRect(0, headerH - 2, w, 2)

        local title = "<:: PERSONAL DATA ASSISTANT ::>"
        draw.SimpleText(title, "BudgetLabel", 12, headerH / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local reserve = 12
        if IsValid(self.btnClose) then
            reserve = self.btnClose:GetWide() + 18
        end

        draw.SimpleText("ACCESS GRANTED / " .. LocalPlayer():Name(), "BudgetLabel", w - reserve, headerH / 2, COMBINE_MUTED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(Color(0, 0, 0, 220))
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        DrawScanlines(w, h, 3)
    end

    self:SetupPDA()
end

function PANEL:AddCombineTab(name, panelObj)
    local sheet = self.sheet:AddSheet(name, panelObj)
    local btn = sheet.Button
    local frame = self

    btn._cmbText = btn:GetText() or name
    btn:SetText("")
    btn:SetTall(26)
    btn:DockMargin(4, 2, 4, 2)
    btn:SetContentAlignment(4)

    local oldClick = btn.DoClick

    btn.Paint = function(selfBtn, w, h)
        local active = (frame.sheet:GetActiveButton() == selfBtn)
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
        if oldClick then oldClick(btn) end
        frame.sheet:SetActiveButton(btn)
        pdaSound()
    end

    return sheet
end

function PANEL:SetupPDA()
    self.sheet = vgui.Create("DColumnSheet", self)
    self.sheet:Dock(FILL)
    self.sheet.Navigation:SetWidth(160)

    function self.sheet.Navigation:Paint(w, h)
        surface.SetDrawColor(4, 8, 16, 240)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    function self.sheet.Content:Paint(w, h)
        surface.SetDrawColor(COMBINE_BG_INNER)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    if IsValid(self.make) then
        self.make:Remove()
    end

    if IsValid(self.scroll) then
        self.scroll:Remove()
    end

    local lp = LocalPlayer()
    local squad = lp:GetSyncVar(SYNC_SQUAD_ID)
    local isLeader = lp:GetSyncVar(SYNC_SQUAD_LEADER)
    local n = lp:Team() == TEAM_CP and "PT" or "SQUAD"
    local curSquads = 0

    self.squadPnl = vgui.Create("DPanel", self.sheet)
    self.squadPnl:Dock(FILL)
    StyleCombinePanel(self.squadPnl, 32)

    local squadSheet = self:AddCombineTab(n .. "S", self.squadPnl)
    squadSheet.Button:SetFont("DebugFixed")

    self.scroll = vgui.Create("DScrollPanel", self.squadPnl)
    self.scroll:SetPos(10, 80)
    self.scroll:SetSize(340, 370)

    local squads = {}
    for _, k in pairs(team.GetPlayers(lp:Team())) do
        local sqd = k:GetSyncVar(SYNC_SQUAD_ID)
        local isLdr = k:GetSyncVar(SYNC_SQUAD_LEADER)

        if not sqd then
            continue
        end

        local function addUnit(s)
            local base = vgui.Create("DPanel")
            base:SetSkin("combine")
            function base:Paint() end

            local lbl = vgui.Create("DLabel", base)
            lbl:SetPos(0, 0)
            lbl:SetText("  ⏺ " .. k:Nick() .. (isLdr and " (SL)" or ""))
            lbl:SetFont("DebugFixed")
            lbl:SizeToContents()

            if sqd == squad then
                lbl:SetTextColor(squadCol)
            else
                lbl:SetTextColor(COMBINE_TEXT)
            end

            if sqd == squad and isLeader and not k == LocalPlayer() then
                local kick = vgui.Create("DButton", base)
                kick:SetText("KICK")
                kick:SetFont("DebugFixed")
                kick:SetPos(290, 2)
                kick:SetSize(35, 16)

                function kick:Paint(w, h)
                    surface.SetDrawColor(8, 16, 28, 220)
                    surface.DrawRect(0, 0, w, h)
                    surface.SetDrawColor(COMBINE_WARNING)
                    surface.DrawOutlinedRect(0, 0, w, h)
                    draw.SimpleText("KICK", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                function kick:DoClick()
                    pdaSound()

                    if not IsValid(k) then
                        return LocalPlayer():Notify("This player disconnected!")
                    end
                    
                    net.Start("impulseSquadKick")
                    net.WriteEntity(k)
                    net.SendToServer()
                end
            end

            if isLdr then
                s.members:InsertAtTop(base)
                s.HasLeader = true
            else
                s.members:AddItem(base)
            end

            s.count = (s.count or 0) + 1
        end

        if not squads[sqd] then
            squads[sqd] = vgui.Create("DCollapsibleCategory", self.scroll)
            squads[sqd]:SetLabel(n .. " " .. sqd)
            squads[sqd]:Dock(TOP)
            squads[sqd].Header:SetFont("DebugFixed")

            if sqd == squad then
                squads[sqd].Header:SetTextColor(squadCol)
            else
                squads[sqd]:SetExpanded(false)
            end

            local colInv = Color(29, 50, 107, 120)
            squads[sqd].Paint = function(selfCat)
                selfCat:SetBGColor(colInv)
            end

            local oldMP = squads[sqd].Header.OnMousePressed
            squads[sqd].Header.OnMousePressed = function(selfHdr, code)
                oldMP(selfHdr, code)

                if code == MOUSE_RIGHT and ((isLeader and sqd ~= squad) or (lp:Team() == TEAM_CP and lp:GetTeamRank() >= RANK_OFC) or (lp:Team() == TEAM_OTA and lp:GetTeamRank() >= RANK_CCP)) then
                    local m = DermaMenu()

                    if isLeader and sqd ~= squad then
                        local requests, pRequests = m:AddSubMenu("Requests")
                        pRequests:SetIcon("icon16/transmit.png")

                        requests:AddOption("Reinforcement", function()
                            pdaSound()
                            if lp:Team() == TEAM_CP then
                                surface.PlaySound("npc/metropolice/vo/reinforcementteamscode3.wav")
                            else
                                surface.PlaySound("npc/combine_soldier/vo/overwatchrequestreinforcement.wav")
                            end
                            
                            net.Start("impulseSquadAction")
                            net.WriteBool(false)
                            net.WriteString("reinforce")
                            net.WriteUInt(sqd, 8)
                            net.SendToServer()
                        end):SetIcon("icon16/group_go.png")
                    end

                    if lp:IsCPCommand() then
                        local orders, pOrders = m:AddSubMenu("Orders")
                        pOrders:SetIcon("icon16/lightning_go.png")

                        orders:AddOption("Custom Order", function()
                            pdaSound()

                            local x = Derma_StringRequest("PDA", "ENTER ORDER (MAX. 85 CHARS)", "",
                                function(t)
                                    if not IsValid(selfHdr) then
                                        return
                                    end

                                    pdaSound()

                                    net.Start("DeepSquadOrder")
                                    net.WriteUInt(sqd, 8)
                                    net.WriteString(t)
                                    net.SendToServer()
                                end, 
                                nil, "SEND ORDER", "CANCEL")
                            x:SetSkin("combine")
                        end):SetIcon("icon16/lightning.png")

                        orders:AddOption("Disband", function()
                            pdaSound()

                            local x = Derma_Query("DISBAND CONFIRMATION", "PDA", "CONFIRM",
                                function()
                                    if not IsValid(selfHdr) then
                                        return
                                    end

                                    pdaSound()

                                    net.Start("DeepSquadDisband")
                                    net.WriteUInt(sqd, 8)
                                    net.SendToServer()
                                end, 
                                "CANCEL")
                            x:SetSkin("combine")
                        end):SetIcon("icon16/bomb.png")
                    end

                    m:Open()
                    pdaSound()
                end
            end

            local s = squads[sqd]
            s.squadId = sqd

            s.members = vgui.Create("DPanelList", s)
            s.members:EnableHorizontal(false)
            s:SetContents(s.members)

            if not squad or squad == sqd then
                s.join = vgui.Create("DButton", squads[sqd].Header)
                s.join:SetText(sqd == squad and "LEAVE" or "JOIN")
                s.join:SetFont("DebugFixed")
                s.join:SetPos(250, 0)
                s.join:SetSize(90, 20)

                function s.join:Paint(w, h)
                    local bg = Color(8, 16, 28, 220)
                    if self:IsDown() then
                        bg = Color(4, 8, 16, 220)
                    elseif self:IsHovered() then
                        bg = Color(12, 28, 48, 230)
                    end
                    surface.SetDrawColor(bg)
                    surface.DrawRect(0, 0, w, h)
                    surface.SetDrawColor(COMBINE_ACCENT_SOFT)
                    surface.DrawOutlinedRect(0, 0, w, h)
                    draw.SimpleText(self:GetText(), "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                if sqd ~= squad and not lp:SquadCanJoin(sqd) then
                    s.join:SetDisabled(true)
                end

                function s.join:DoClick()
                    if sqd ~= squad then
                        net.Start("impulseSquadJoin")
                        net.WriteUInt(sqd, 8)
                        net.SendToServer()
                    else
                        net.Start("impulseSquadLeave")
                        net.SendToServer()
                    end

                    pdaSound()
                end
            end

            addUnit(s)
            curSquads = curSquads + 1
            continue
        else
            addUnit(squads[sqd])
        end
    end

    for v, k in pairs(squads) do
        if not k.HasLeader and squad == v then
            k.claim = vgui.Create("DButton", k.Header)
            k.claim:SetText("CLAIM")
            k.claim:SetFont("DebugFixed")
            k.claim:SetPos(150, 0)
            k.claim:SetSize(90, 20)

            function k.claim:Paint(w, h)
                surface.SetDrawColor(8, 16, 28, 220)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(COMBINE_ACCENT)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText("CLAIM", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            function k.claim:DoClick()
                net.Start("impulseSquadClaim")
                net.SendToServer()
                pdaSound()
            end
        end

        k:SetLabel(n .. " " .. k.squadId .. "    (" .. k.count .. "/" .. (lp:Team() == TEAM_CP and impulse.Config.MaxSquadSizeCP or impulse.Config.MaxSquadSizeOTA) .. ")")
    end

    self.make = vgui.Create("DButton", self.squadPnl)
    self.make:SetPos(10, 50)
    self.make:SetSize(340, 20)
    self.make:SetFont("DebugFixed")
    self.make:SetText("CREATE " .. n .. " (" .. curSquads .. "/" .. (lp:Team() == TEAM_CP and impulse.Config.MaxSquadsCP or impulse.Config.MaxSquadsOTA) .. ")")

    function self.make:Paint(w, h)
        surface.SetDrawColor(8, 16, 28, 220)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(COMBINE_ACCENT)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText(self:GetText(), "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if not lp:SquadCanMake() then
        self.make:SetDisabled(true)
    end

    function self.make:DoClick()
        net.Start("impulseSquadMake")
        net.SendToServer()
        pdaSound()
    end

    self.utilPnl = vgui.Create("DPanel", self.sheet)
    self.utilPnl:Dock(FILL)
    StyleCombinePanel(self.utilPnl, 32)

    local utilSheet = self:AddCombineTab("UTIL", self.utilPnl)
    utilSheet.Button:SetFont("DebugFixed")
    utilSheet.Button.NoShowSquad = true

    self.medic = vgui.Create("DButton", self.utilPnl)
    self.medic:SetText("REQUEST MEDICAL ATTENTION")
    self.medic:SetFont("DebugFixed")
    self.medic:Dock(TOP)

    function self.medic:Paint(w, h)
        surface.SetDrawColor(8, 16, 28, 220)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(COMBINE_ACCENT_SOFT)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText("REQUEST MEDICAL ATTENTION", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function self.medic:Think()
        local hp = LocalPlayer():Health()
        self:SetEnabled(hp <= 90)
    end

    function self.medic:DoClick()
        net.Start("impulseHL2RPMedicCall")
        net.SendToServer()
        pdaSound()
    end

    local rank = LocalPlayer():GetTeamRank()

    if LocalPlayer():Team() == TEAM_CP then
        self.CallsignBtn = vgui.Create("DButton", self.utilPnl)
        self.CallsignBtn:SetFont("DebugFixed")
        self.CallsignBtn:SetText("EDIT/CREATE CALLSIGN")
        self.CallsignBtn:Dock(TOP)

        function self.CallsignBtn:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("EDIT/CREATE CALLSIGN", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        self.CallsignBtn.DoClick = function()
            vgui.Create("impulseHL2RPCallsigns")
            self:Remove()
        end
    end
    
    if LocalPlayer():Team() == TEAM_OTA then
        self.CallsignBtn = vgui.Create("DButton", self.utilPnl)
        self.CallsignBtn:SetFont("DebugFixed")
        self.CallsignBtn:SetText("EDIT/CREATE CALLSIGN")
        self.CallsignBtn:Dock(TOP)

        function self.CallsignBtn:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("EDIT/CREATE CALLSIGN", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        self.CallsignBtn.DoClick = function()
            vgui.Create("impulseHL2RPCallsigns")
            self:Remove()
        end
    end

    if (LocalPlayer():Team() == TEAM_CP and rank >= RANK_DVL) or (LocalPlayer():Team() == TEAM_OTA and rank >= RANK_ORD) or (LocalPlayer():Team() == TEAM_CA and rank >= RANK_CA) then
        self.objReason = vgui.Create("DTextEntry", self.utilPnl)
        self.objReason:SetPlaceholderText("Enter objective (max 72 characters)")
        self.objReason:SetFont("DebugFixed")
        self.objReason:DockMargin(0, 50, 0, 0)
        self.objReason:Dock(TOP)

        self.objSend = vgui.Create("DButton", self.utilPnl)
        self.objSend:SetFont("DebugFixed")
        self.objSend:SetText("SET OBJECTIVE")
        self.objSend:Dock(TOP)

        function self.objSend:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("SET OBJECTIVE", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local panel = self
        function self.objSend:DoClick()
            net.Start("impulseHL2RPObjectiveSet")
            net.WriteString(panel.objReason:GetValue())
            net.SendToServer()
            pdaSound()
        end
    end

    if (LocalPlayer():Team() == TEAM_OTA and rank >= RANK_CCP) then
        self.objOTAReason = vgui.Create("DTextEntry", self.utilPnl)
        self.objOTAReason:SetPlaceholderText("Enter objective (max 72 characters, local team)")
        self.objOTAReason:SetFont("DebugFixed")
        self.objOTAReason:DockMargin(0, 50, 0, 0)
        self.objOTAReason:Dock(TOP)

        self.objOTASend = vgui.Create("DButton", self.utilPnl)
        self.objOTASend:SetFont("DebugFixed")
        self.objOTASend:SetText("SET LOCAL TEAM OBJECTIVE")
        self.objOTASend:Dock(TOP)

        function self.objOTASend:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("SET LOCAL TEAM OBJECTIVE", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local panel = self
        function self.objOTASend:DoClick()
            net.Start("deepGamingOTAObjSet")
            net.WriteString(panel.objOTAReason:GetValue())
            net.SendToServer()
            pdaSound()
        end
    end

    if (LocalPlayer():Team() == TEAM_CP and rank >= RANK_DVL) or (LocalPlayer():Team() == TEAM_OTA and rank >= RANK_ORD) then
        self.sacCode = vgui.Create("DButton", self.utilPnl)
        self.sacCode:SetFont("DebugFixed")
        self.sacCode:SetText("ACTIVATE SACRIFICE CODE")
        self.sacCode:Dock(TOP)

        function self.sacCode:Paint(w, h)
            surface.SetDrawColor(20, 4, 4, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_WARNING)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("ACTIVATE SACRIFICE CODE", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.sacCode:DoClick()
            net.Start("deepSacrificeCodeSet")
            net.SendToServer()
            pdaSound()
        end
    end

    if ((LocalPlayer():Team() == TEAM_CP and rank >= RANK_OFC) or (LocalPlayer():Team() == TEAM_CA and rank >= RANK_DEPUTY) or (LocalPlayer():Team() == TEAM_OTA and rank >= RANK_OCP)) then
        if LocalPlayer():IsSuperAdmin() then
            self.citylockdown = vgui.Create("DButton", self.utilPnl)
            self.citylockdown:SetFont("DebugFixed")
            self.citylockdown:SetText("TOGGLE CITY LOCKDOWN")
            self.citylockdown:Dock(TOP)

            function self.citylockdown:Paint(w, h)
                surface.SetDrawColor(8, 16, 28, 220)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(COMBINE_WARNING)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText("TOGGLE CITY LOCKDOWN", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            function self.citylockdown:DoClick()
                if not timer.Exists("lockdowncooldown") then
                    timer.Create("lockdowncooldown", 90, 0, function()
                        timer.Remove("lockdowncooldown")
                    end)
                    net.Start("DeepGamingSendDecree")
                    net.WriteUInt(2, 8)
                    net.SendToServer()
                    surface.PlaySound("ambient/cmb_alarm.mp3")
                else
                    LocalPlayer():Notify("Please wait " .. math.floor(timer.TimeLeft("lockdowncooldown")) .. " seconds before using this button.")
                end
                pdaSound()
            end
        end
    end

    if (LocalPlayer():Team() == TEAM_OTA and rank >= RANK_ORD) or (LocalPlayer():Team() == TEAM_CP and rank >= RANK_DVL) or (LocalPlayer():Team() == TEAM_CA and rank >= RANK_CA) then
        self.rations = vgui.Create("DButton", self.utilPnl)
        self.rations:SetFont("DebugFixed")
        self.rations:SetText("TOGGLE RATIONS")
        self.rations:Dock(TOP)

        function self.rations:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("TOGGLE RATIONS", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.rations:DoClick()
            if not timer.Exists("rationcooldown") then
                timer.Create("rationcooldown", 90, 0, function()
                    timer.Remove("rationcooldown")
                end)
                net.Start("DeepGamingSendDecree")
                net.WriteUInt(1, 8)
                net.SendToServer()
                surface.PlaySound("ambient/cmb_alarm.mp3")
            else
                LocalPlayer():Notify("Please wait " .. math.floor(timer.TimeLeft("lockdowncooldown")) .. " seconds before using this button.")
            end
            pdaSound()
        end
    end

    if (LocalPlayer():Team() == TEAM_CP and rank >= RANK_DVL) or (LocalPlayer():Team() == TEAM_CA and rank >= RANK_CA) or (LocalPlayer():GetTeamClass() == CLASS_GHOST and LocalPlayer():GetTeamRank() == RANK_OFC and LocalPlayer():Team() == TEAM_CP) then
        self.separationpolicy = vgui.Create("DButton", self.utilPnl)
        self.separationpolicy:SetFont("DebugFixed")
        self.separationpolicy:SetText("TOGGLE SEPERATION POLICY")
        self.separationpolicy:Dock(TOP)

        function self.separationpolicy:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("TOGGLE SEPERATION POLICY", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.separationpolicy:DoClick()
            if not timer.Exists("segcooldown") then
                timer.Create("segcooldown", 90, 0, function()
                    timer.Remove("segcooldown")
                end)
                net.Start("DeepGamingSendDecree")
                net.WriteUInt(3, 8)
                net.SendToServer()
                surface.PlaySound("ambient/cmb_alarm.mp3")
            else
                LocalPlayer():Notify("Please wait " .. math.floor(timer.TimeLeft("segcooldown")) .. " seconds before using this button.")
            end
            pdaSound()
        end
    end

    self.bolPnl = vgui.Create("DPanel", self.sheet)
    self.bolPnl:Dock(FILL)
    StyleCombinePanel(self.bolPnl, 0)

    local bolSheet = self:AddCombineTab("BOL", self.bolPnl)
    bolSheet.Button:SetFont("DebugFixed")
    bolSheet.Button.NoShowSquad = true

    self.bolScroll = vgui.Create("DScrollPanel", self.bolPnl)
    self.bolScroll:Dock(FILL)

    for _, k in pairs(player.GetAll()) do
        local bol, crime = k:IsDispatchBOL()
        if bol then
            local entry = self.bolScroll:Add("impulseTerminalPlayer")
            entry.NoButtons = true
            entry.master = self
            entry:SetBOLPlayer(k, crime)
            entry:SetHeight(60)
            entry:Dock(TOP)
        end
    end

    self.tPnl = vgui.Create("DPanel", self.sheet)
    self.tPnl:Dock(FILL)
    StyleCombinePanel(self.tPnl, 0)

    local tmnlSheet = self:AddCombineTab("TMNL", self.tPnl)
    tmnlSheet.Button:SetFont("DebugFixed")
    tmnlSheet.Button.NoShowSquad = true

    self.tScroll = vgui.Create("DScrollPanel", self.tPnl)
    self.tScroll:Dock(FILL)

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then 
        self.economyPnl = vgui.Create("DPanel", self.sheet)
        self.economyPnl:Dock(FILL)
        StyleCombinePanel(self.economyPnl, 32)

        local econSheet = self:AddCombineTab("ECON", self.economyPnl)
        econSheet.Button:SetFont("DebugFixed")
        econSheet.Button.NoShowSquad = true
        econSheet.Button.EconText = true
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.armorSuits = vgui.Create("DButton", self.economyPnl)
        self.armorSuits:SetFont("DebugFixed")
        self.armorSuits:SetText("IMPROVED ARMOR CHARGERS (30m) - 12000C")
        self.armorSuits:Dock(TOP)

        function self.armorSuits:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("IMPROVED ARMOR CHARGERS (30m) - 12000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.armorSuits:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Armor")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.rationReward = vgui.Create("DButton", self.economyPnl)
        self.rationReward:SetFont("DebugFixed")
        self.rationReward:SetText("INCREASED RATION REWARD (30m) - 4000C")
        self.rationReward:Dock(TOP)

        function self.rationReward:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("INCREASED RATION REWARD (30m) - 4000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.rationReward:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Rations")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.ammoCrate = vgui.Create("DButton", self.economyPnl)
        self.ammoCrate:SetFont("DebugFixed")
        self.ammoCrate:SetText("INCREASED AMMO CAPACITY (30m) - 8000C")
        self.ammoCrate:Dock(TOP)

        function self.ammoCrate:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("INCREASED AMMO CAPACITY (30m) - 8000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.ammoCrate:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Ammo")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.healthVials = vgui.Create("DButton", self.economyPnl)
        self.healthVials:SetFont("DebugFixed")
        self.healthVials:SetText("VENDORS: ENHANCED HEALTH VIALS (15m) - 9000C")
        self.healthVials:Dock(TOP)

        function self.healthVials:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("VENDORS: ENHANCED HEALTH VIALS (15m) - 9000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.healthVials:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Health")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.incendiaries = vgui.Create("DButton", self.economyPnl)
        self.incendiaries:SetFont("DebugFixed")
        self.incendiaries:SetText("VENDORS: INCENDIARY GRENADES (10m) - 15000C")
        self.incendiaries:Dock(TOP)

        function self.incendiaries:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("VENDORS: INCENDIARY GRENADES (10m) - 15000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.incendiaries:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Incendiary")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.researchFunding = vgui.Create("DButton", self.economyPnl)
        self.researchFunding:SetFont("DebugFixed")
        self.researchFunding:SetText("C.W. RESEARCH FUNDING (No Cooldown) - 1000C")
        self.researchFunding:Dock(TOP)

        function self.researchFunding:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("C.W. RESEARCH FUNDING (No Cooldown) - 1000C", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.researchFunding:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("ResearchFunding")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_CA and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.distribute = vgui.Create("DButton", self.economyPnl)
        self.distribute:SetFont("DebugFixed")
        self.distribute:SetText("DISTRIBUTE TREASURY TO ALL COMBINE (12h) - ALL MONEY")
        self.distribute:Dock(TOP)

        function self.distribute:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_WARNING)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("DISTRIBUTE TREASURY TO ALL COMBINE (12h) - ALL MONEY", "DebugFixed", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.distribute:DoClick()
            net.Start("DeepFundingOperation")
            net.WriteString("Distribution")
            net.SendToServer()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then 
        self.taxPnl = vgui.Create("DPanel", self.sheet)
        self.taxPnl:Dock(FILL)
        StyleCombinePanel(self.taxPnl, 32)

        local taxSheet = self:AddCombineTab("TAX", self.taxPnl)
        taxSheet.Button:SetFont("DebugFixed")
        taxSheet.Button.NoShowSquad = true
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.CivTaxSlider = vgui.Create("DNumSlider", self.taxPnl)
        self.CivTaxSlider:SetText("R.T.R. - CIVIC POPULACE")
        self.CivTaxSlider:SetMax(50)
        self.CivTaxSlider:SetDecimals(0)
        self.CivTaxSlider:SetMin(0)
        self.CivTaxSlider:Dock(TOP)
        self.CivTaxSlider:SetValue(civTax)
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.SaveCivTax = vgui.Create("DButton", self.taxPnl)
        self.SaveCivTax:SetFont("BudgetLabel")
        self.SaveCivTax:SetText("APPLY CIVIC TAX RATE")
        self.SaveCivTax:Dock(TOP)

        function self.SaveCivTax:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("APPLY CIVIC TAX RATE", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.SaveCivTax:DoClick()
            net.Start("DeepCivilianTaxRate")
            net.WriteUInt(self:GetParent().CivTaxSlider:GetValue(), 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.RentSlider = vgui.Create("DNumSlider", self.taxPnl)
        self.RentSlider:SetText("RENT (PER DOOR)")
        self.RentSlider:SetMax(40)
        self.RentSlider:SetDecimals(0)
        self.RentSlider:SetMin(15)
        self.RentSlider:Dock(TOP)
        self.RentSlider:SetValue(doorPrice)
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.SaveRent = vgui.Create("DButton", self.taxPnl)
        self.SaveRent:SetFont("BudgetLabel")
        self.SaveRent:SetText("APPLY RENT")
        self.SaveRent:Dock(TOP)

        function self.SaveRent:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("APPLY RENT", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.SaveRent:DoClick()
            net.Start("DeepSetRent")
            net.WriteUInt(self:GetParent().RentSlider:GetValue(), 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end
    end
    
    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_REPRESENTATIVE and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.researchPnl = vgui.Create("DPanel", self.sheet)
        self.researchPnl:Dock(FILL)
        StyleCombinePanel(self.researchPnl, 32)

        self.researchScroll = vgui.Create("DScrollPanel", self.researchPnl)
        self.researchScroll:Dock(FILL)
        self.researchScroll:DockMargin(0, 30, 0, 0)

        local researchSheet = self:AddCombineTab("R&D", self.researchPnl)
        researchSheet.Button:SetFont("DebugFixed")
        researchSheet.Button.NoShowSquad = true

        function self:AddResearchItems(category, items)
            local catLabel = vgui.Create("DLabel", self.researchScroll)
            catLabel:SetText(category)
            catLabel:SetFont("DebugFixed")
            catLabel:SetTextColor(COMBINE_MUTED)
            catLabel:Dock(TOP)
            catLabel:DockMargin(8, 10, 8, 5)
            
            for _, item in ipairs(items) do
                local itemPanel = vgui.Create("DPanel", self.researchScroll)
                itemPanel:SetTall(30)
                itemPanel:Dock(TOP)
                itemPanel:DockMargin(8, 0, 8, 5)
                itemPanel.Paint = function(_, w, h)
                    surface.SetDrawColor(50, 50, 50, 200)
                    surface.DrawRect(0, 0, w, h)
                end

                local itemLabel = vgui.Create("DLabel", itemPanel)
                local text = item.name
                if item.progress == 1 then
                    text = text .. " - Complete"
                elseif item.progress ~= 0 then
                    text = text .. " - In progress"
                else
                    text = text .. " - Not complete"
                end
                itemLabel:SetText(text)
                itemLabel:SetFont("DebugFixed")
                itemLabel:SetTextColor(COMBINE_TEXT)
                itemLabel:Dock(FILL)
                itemLabel:DockMargin(8, 0, 8, 0)
            end
        end

        net.Receive("researchTableData", function()
            local techResearch = net.ReadTable()
            local weaponResearch = net.ReadTable()
            local ecoResearch = net.ReadTable()
            
            if IsValid(self.researchScroll) then
                self.researchScroll:Clear()
                self:AddResearchItems("Technology Research", techResearch)
                self:AddResearchItems("Weapon Research", weaponResearch)
                self:AddResearchItems("Economy Research", ecoResearch)
            end
        end)
        
        net.Start("researchTable")
        net.SendToServer()
    end

    if LocalPlayer():Team() == TEAM_CP and rank >= RANK_I3 then 
        self.scPnl = vgui.Create("DPanel", self.sheet)
        self.scPnl:Dock(FILL)
        StyleCombinePanel(self.scPnl, 32)

        local scSheet = self:AddCombineTab("SC", self.scPnl)
        scSheet.Button:SetFont("DebugFixed")
        scSheet.Button.NoShowSquad = true
        scSheet.Button.EconText = false

        self.sccount = vgui.Create("DLabel", self.scPnl)
        self.sccount:SetText("LOCAL UNIT STERILIZED CREDITS: " .. scs)
        self.sccount:SetFont("DebugFixed")
        self.sccount:SetTextColor(COMBINE_TEXT)
        self.sccount:Dock(TOP)

        self.blanklbl1 = vgui.Create("DLabel", self.scPnl)
        self.blanklbl1:SetText("")
        self.blanklbl1:SetFont("DebugFixed")
        self.blanklbl1:Dock(TOP)

        self.armslabel = vgui.Create("DLabel", self.scPnl)
        self.armslabel:SetText("FIREARMS:")
        self.armslabel:SetFont("DebugFixed")
        self.armslabel:SetTextColor(COMBINE_MUTED)
        self.armslabel:Dock(TOP)

        self.cz75button = vgui.Create("DButton", self.scPnl)
        self.cz75button:SetFont("BudgetLabel")
        self.cz75button:SetText("CZ-75 AUTO [40 SC]")
        self.cz75button:Dock(TOP)

        function self.cz75button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("CZ-75 AUTO [40 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.cz75button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_cz75")
            net.WriteInt(40, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.mp5button = vgui.Create("DButton", self.scPnl)
        self.mp5button:SetFont("BudgetLabel")
        self.mp5button:SetText("H&K MP5A2 [80 SC]")
        self.mp5button:Dock(TOP)

        function self.mp5button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("H&K MP5A2 [80 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.mp5button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_pm63")
            net.WriteInt(80, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.mp7button = vgui.Create("DButton", self.scPnl)
        self.mp7button:SetFont("BudgetLabel")
        self.mp7button:SetText("H&K MP7A1 [130 SC]")
        self.mp7button:Dock(TOP)

        function self.mp7button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("H&K MP7A1 [130 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.mp7button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_mp7")
            net.WriteInt(130, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.hbbutton = vgui.Create("DButton", self.scPnl)
        self.hbbutton:SetFont("BudgetLabel")
        self.hbbutton:SetText("AR-15 .50 [160 SC]")
        self.hbbutton:Dock(TOP)

        function self.hbbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("AR-15 .50 [160 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.hbbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_mp5sd")
            net.WriteInt(160, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.xm1014button = vgui.Create("DButton", self.scPnl)
        self.xm1014button:SetFont("BudgetLabel")
        self.xm1014button:SetText("XM1014 [300 SC]")
        self.xm1014button:Dock(TOP)

        function self.xm1014button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("XM1014 [300 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.xm1014button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_m500")
            net.WriteInt(300, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.spas12button = vgui.Create("DButton", self.scPnl)
        self.spas12button:SetFont("BudgetLabel")
        self.spas12button:SetText("FRANCHI SPAS-12 [350 SC]")
        self.spas12button:Dock(TOP)

        function self.spas12button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("FRANCHI SPAS-12 [350 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.spas12button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_shotgun")
            net.WriteInt(350, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.pythonbutton = vgui.Create("DButton", self.scPnl)
        self.pythonbutton:SetFont("BudgetLabel")
        self.pythonbutton:SetText("COLT PYTHON [425 SC]")
        self.pythonbutton:Dock(TOP)

        function self.pythonbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("COLT PYTHON [425 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.pythonbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_357")
            net.WriteInt(425, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.mp7a8button = vgui.Create("DButton", self.scPnl)
        self.mp7a8button:SetFont("BudgetLabel")
        self.mp7a8button:SetText("H&K MP7A8 [550 SC]")
        self.mp7a8button:Dock(TOP)

        function self.mp7a8button:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("H&K MP7A8 [550 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.mp7a8button:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_mp7a8")
            net.WriteInt(550, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.blanklbl2 = vgui.Create("DLabel", self.scPnl)
        self.blanklbl2:SetText("")
        self.blanklbl2:SetFont("DebugFixed")
        self.blanklbl2:Dock(TOP)

        self.utillabel = vgui.Create("DLabel", self.scPnl)
        self.utillabel:SetText("UTILITY ITEMS:")
        self.utillabel:SetFont("DebugFixed")
        self.utillabel:SetTextColor(COMBINE_MUTED)
        self.utillabel:Dock(TOP)

        self.armorbutton = vgui.Create("DButton", self.scPnl)
        self.armorbutton:SetFont("BudgetLabel")
        self.armorbutton:SetText("+10 ARMOR [15 SC]")
        self.armorbutton:Dock(TOP)

        function self.armorbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("+10 ARMOR [15 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.armorbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Armor")
            net.WriteString("10")
            net.WriteInt(15, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.ehvbutton = vgui.Create("DButton", self.scPnl)
        self.ehvbutton:SetFont("BudgetLabel")
        self.ehvbutton:SetText("ENHANCED HEALTH VIAL [30 SC]")
        self.ehvbutton:Dock(TOP)

        function self.ehvbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("ENHANCED HEALTH VIAL [30 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.ehvbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("item_enhancedvial")
            net.WriteInt(30, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.flashbangbutton = vgui.Create("DButton", self.scPnl)
        self.flashbangbutton:SetFont("BudgetLabel")
        self.flashbangbutton:SetText("FLASHBANG [50 SC]")
        self.flashbangbutton:Dock(TOP)

        function self.flashbangbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("FLASHBANG [50 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.flashbangbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("grenade_flashbang")
            net.WriteInt(50, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.teargasbutton = vgui.Create("DButton", self.scPnl)
        self.teargasbutton:SetFont("BudgetLabel")
        self.teargasbutton:SetText("TEAR GAS [60 SC]")
        self.teargasbutton:Dock(TOP)

        function self.teargasbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("TEAR GAS [60 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.teargasbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("wep_teargas")
            net.WriteInt(60, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.regenpillsbutton = vgui.Create("DButton", self.scPnl)
        self.regenpillsbutton:SetFont("BudgetLabel")
        self.regenpillsbutton:SetText("ANDROSTENDIONE PILLS [50 SC]")
        self.regenpillsbutton:Dock(TOP)

        function self.regenpillsbutton:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("ANDROSTENDIONE PILLS [50 SC]", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.regenpillsbutton:DoClick()
            net.Start("DeepSterilizedCreditsPurchase")
            net.WriteString("Item")
            net.WriteString("stimulant_regen")
            net.WriteInt(50, 16)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.CWTaxSlider = vgui.Create("DNumSlider", self.taxPnl)
        self.CWTaxSlider:SetText("R.T.R. - CIVIC WORKFORCE")
        self.CWTaxSlider:SetMax(50)
        self.CWTaxSlider:SetDecimals(0)
        self.CWTaxSlider:SetMin(0)
        self.CWTaxSlider:Dock(TOP)
        self.CWTaxSlider:SetValue(cwuTax)
    end

    if LocalPlayer():Team() == TEAM_CA and rank >= RANK_COUNCILMAN and LocalPlayer():GetTeamClass() == CLASS_BASE then
        self.SaveCWTax = vgui.Create("DButton", self.taxPnl)
        self.SaveCWTax:SetFont("BudgetLabel")
        self.SaveCWTax:SetText("APPLY C.W. TAX RATE")
        self.SaveCWTax:Dock(TOP)

        function self.SaveCWTax:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("APPLY C.W. TAX RATE", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.SaveCWTax:DoClick()
            net.Start("DeepWorkerTaxRate")
            net.WriteUInt(self:GetParent().CWTaxSlider:GetValue(), 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end
    end

    self.dataPnl = vgui.Create("DPanel", self.sheet)
    self.dataPnl:Dock(FILL)
    StyleCombinePanel(self.dataPnl, 32)

    local dataSheet = self:AddCombineTab("DATA", self.dataPnl)
    dataSheet.Button:SetFont("DebugFixed")
    dataSheet.Button.NoShowSquad = true
    dataSheet.Button.EconText = true

    self.mpftitle = vgui.Create("DLabel", self.dataPnl)
    self.mpftitle:SetText("METRO POLICE FORCE ROLE DISTRIBUTION:")
    self.mpftitle:SetFont("DebugFixed")
    self.mpftitle:SetTextColor(COMBINE_MUTED)
    self.mpftitle:Dock(TOP)

    self.unioncounter = vgui.Create("DLabel", self.dataPnl)
    self.unioncounter:SetText("MPF UNION: " .. unions)
    self.unioncounter:SetFont("DebugFixed")
    self.unioncounter:SetTextColor(COMBINE_TEXT)
    self.unioncounter:Dock(TOP)

    self.helixcounter = vgui.Create("DLabel", self.dataPnl)
    self.helixcounter:SetText("MPF HELIX: " .. helixs)
    self.helixcounter:SetFont("DebugFixed")
    self.helixcounter:SetTextColor(COMBINE_TEXT)
    self.helixcounter:Dock(TOP)

    self.gridcounter = vgui.Create("DLabel", self.dataPnl)
    self.gridcounter:SetText("MPF GRID: " .. grids)
    self.gridcounter:SetFont("DebugFixed")
    self.gridcounter:SetTextColor(COMBINE_TEXT)
    self.gridcounter:Dock(TOP)

    self.swordcounter = vgui.Create("DLabel", self.dataPnl)
    self.swordcounter:SetText("MPF SWORD: " .. swords)
    self.swordcounter:SetFont("DebugFixed")
    self.swordcounter:SetTextColor(COMBINE_TEXT)
    self.swordcounter:Dock(TOP)

    self.ghostcounter = vgui.Create("DLabel", self.dataPnl)
    self.ghostcounter:SetText("MPF GHOST: " .. ghosts)
    self.ghostcounter:SetFont("DebugFixed")
    self.ghostcounter:SetTextColor(COMBINE_TEXT)
    self.ghostcounter:Dock(TOP)

    self.gapspace = vgui.Create("DLabel", self.dataPnl)
    self.gapspace:SetText("")
    self.gapspace:SetFont("DebugFixed")
    self.gapspace:Dock(TOP)

    self.ctatitle = vgui.Create("DLabel", self.dataPnl)
    self.ctatitle:SetText("COMBINE TRANSHUMAN ARM ROLE DISTRIBUTION:")
    self.ctatitle:SetFont("DebugFixed")
    self.ctatitle:SetTextColor(COMBINE_MUTED)
    self.ctatitle:Dock(TOP)

    self.echocounter = vgui.Create("DLabel", self.dataPnl)
    self.echocounter:SetText("CTA ECHO: " .. echos)
    self.echocounter:SetFont("DebugFixed")
    self.echocounter:SetTextColor(COMBINE_TEXT)
    self.echocounter:Dock(TOP)

    self.macecounter = vgui.Create("DLabel", self.dataPnl)
    self.macecounter:SetText("CTA MACE: " .. maces)
    self.macecounter:SetFont("DebugFixed")
    self.macecounter:SetTextColor(COMBINE_TEXT)
    self.macecounter:Dock(TOP)

    self.rangercounter = vgui.Create("DLabel", self.dataPnl)
    self.rangercounter:SetText("CTA RANGER: " .. rangers)
    self.rangercounter:SetFont("DebugFixed")
    self.rangercounter:SetTextColor(COMBINE_TEXT)
    self.rangercounter:Dock(TOP)

    self.elitecounter = vgui.Create("DLabel", self.dataPnl)
    self.elitecounter:SetText("CTA FIST: " .. fists)
    self.elitecounter:SetFont("DebugFixed")
    self.elitecounter:SetTextColor(COMBINE_TEXT)
    self.elitecounter:Dock(TOP)

    self.apfcounter = vgui.Create("DLabel", self.dataPnl)
    self.apfcounter:SetText("CTA SWEEPER: " .. sweepers)
    self.apfcounter:SetFont("DebugFixed")
    self.apfcounter:SetTextColor(COMBINE_TEXT)
    self.apfcounter:Dock(TOP)

    self.nomadcounter = vgui.Create("DLabel", self.dataPnl)
    self.nomadcounter:SetText("CTA NOMAD: " .. nomads)
    self.nomadcounter:SetFont("DebugFixed")
    self.nomadcounter:SetTextColor(COMBINE_TEXT)
    self.nomadcounter:Dock(TOP)

    self.paybackcounter = vgui.Create("DLabel", self.dataPnl)
    self.paybackcounter:SetText("CTA PAYBACK: " .. paybacks)
    self.paybackcounter:SetFont("DebugFixed")
    self.paybackcounter:SetTextColor(COMBINE_TEXT)
    self.paybackcounter:Dock(TOP)

    self.gapspacetwo = vgui.Create("DLabel", self.dataPnl)
    self.gapspacetwo:SetText("")
    self.gapspacetwo:SetFont("DebugFixed")
    self.gapspacetwo:Dock(TOP)

    self.roguecounter = vgui.Create("DLabel", self.dataPnl)
    self.roguecounter:SetText("TOTAL ROGUES: " .. rogues)
    self.roguecounter:SetFont("DebugFixed")
    self.roguecounter:SetTextColor(COMBINE_WARNING)
    self.roguecounter:Dock(TOP)

    if game.GetMap() == "rp_city17_futuristic_cloudy" and LocalPlayer():IsCPCommand() then
        self.districtPnl = vgui.Create("DPanel", self.sheet)
        self.districtPnl:Dock(FILL)
        StyleCombinePanel(self.districtPnl, 32)

        local ctrlSheet = self:AddCombineTab("CTRL", self.districtPnl)
        ctrlSheet.Button:SetFont("DebugFixed")
        ctrlSheet.Button.NoShowSquad = true
        ctrlSheet.Button.EconText = true

        self.District2 = vgui.Create("DButton", self.districtPnl)
        self.District2:SetFont("BudgetLabel")
        self.District2:SetText("OPEN/CLOSE DISTRICT 2")
        self.District2:Dock(TOP)

        function self.District2:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("OPEN/CLOSE DISTRICT 2", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.District2:DoClick()
            net.Start("DeepAdjustDistrict")
            net.WriteUInt(2, 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.District3 = vgui.Create("DButton", self.districtPnl)
        self.District3:SetFont("BudgetLabel")
        self.District3:SetText("OPEN/CLOSE DISTRICT 3")
        self.District3:Dock(TOP)

        function self.District3:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("OPEN/CLOSE DISTRICT 3", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.District3:DoClick()
            net.Start("DeepAdjustDistrict")
            net.WriteUInt(3, 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end

        self.District4 = vgui.Create("DButton", self.districtPnl)
        self.District4:SetFont("BudgetLabel")
        self.District4:SetText("OPEN/CLOSE DISTRICT 4")
        self.District4:Dock(TOP)

        function self.District4:Paint(w, h)
            surface.SetDrawColor(8, 16, 28, 220)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(COMBINE_ACCENT_SOFT)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("OPEN/CLOSE DISTRICT 4", "BudgetLabel", w / 2, h / 2, COMBINE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function self.District4:DoClick()
            net.Start("DeepAdjustDistrict")
            net.WriteUInt(4, 8)
            net.SendToServer()
            self:GetParent():GetParent():Remove()
            pdaSound()
        end
    end
end

function PANEL:PaintOver()
    if not IsValid(self.sheet) then return end
    local activeBtn = self.sheet:GetActiveButton()
    if activeBtn and activeBtn.NoShowSquad then
        return
    end

    local lp = LocalPlayer()
    local squad = lp:GetSyncVar(SYNC_SQUAD_ID)
    local n = lp:Team() == TEAM_CP and "PT" or "SQUAD"
    if squad then
        draw.SimpleText("LOCAL " .. n .. ": " .. squad, "DebugFixed", 90, 30, COMBINE_TEXT)
    else
        draw.SimpleText("AWAITING " .. n .. " ASSIGNMENT - SELECT BELOW:", "DebugFixed", 90, 30, COMBINE_TEXT)
    end
end

function PANEL:Think()
    local t = LocalPlayer():Team()

    if t ~= TEAM_CP and t ~= TEAM_OTA and t ~= TEAM_CA then
        return self:Remove()
    end

    if not LocalPlayer():Alive() then
        return self:Remove()
    end
end

vgui.Register("impulsePDAMenu", PANEL, "DFrame")
