local COL_BG = Color(6, 10, 20, 230)
local COL_BG_HOVER = Color(10, 18, 32, 240)
local COL_BORDER = Color(0, 0, 0, 180)

local function ApplyPortraitBodygroups(modelIcon, ply)
    timer.Simple(0, function()
        if not IsValid(modelIcon) then return end
        local ent = modelIcon.Entity
        if not IsValid(ent) or not IsValid(ply) then return end

        local targetGroups = {"hair", "beard"}
        for _, groupName in ipairs(targetGroups) do
            local groupID = ent:FindBodygroupByName(groupName)
            if groupID and groupID > -1 then
                ent:SetBodygroup(groupID, ply:GetBodygroup(groupID))
            end
        end
    end)
end

local ROW = {}

function ROW:Init()
    self:SetTall(28)
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 4)
    self:SetText("")
end

function ROW:SetPlayer(ply)
    self.Player = ply
    self.RPName = ply:Nick()
end

function ROW:DoClick()
    if IsValid(self.Player) then
        OpenCivicMeritsEditor(self.Player)
    end
end

function ROW:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and COL_BG_HOVER or COL_BG)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(COL_BORDER)
    surface.DrawOutlinedRect(0, 0, w, h)

    if IsValid(self.Player) then
        draw.SimpleText(self.RPName, "DebugFixed", 10, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("CID: " .. self.Player:GetCivicID(), "DebugFixed", w - 10, h / 2, Color(160, 160, 160), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("impulseCivicMeritsRow", ROW, "DButton")

local LISTPANEL = {}

function LISTPANEL:Init()
    self:SetSize(360, 460)

    self.search = vgui.Create("DTextEntry", self)
    self.search:Dock(TOP)
    self.search:DockMargin(0, 0, 0, 6)
    self.search:SetTall(28)
    self.search:SetFont("DebugFixed")
    self.search:SetPlaceholderText("SEARCH BY NAME...")
    self.search:SetUpdateOnType(true)

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)

    local panel = self
    function self.search:OnValueChange(text)
        panel:Refresh(text)
    end

    self:Refresh("")
end

function LISTPANEL:Refresh(filter)
    self.scroll:Clear()
    filter = string.lower(filter or "")

    local players = player.GetAll()
    table.sort(players, function(a, b) return a:Nick() < b:Nick() end)

    for _, ply in ipairs(players) do
        if IsValid(ply) and (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) then
            local matchesName = string.find(string.lower(ply:Nick()), filter, 1, true)
            local matchesID = string.find(tostring(ply:GetCivicID()), filter, 1, true)

            if filter == "" or matchesName or matchesID then
                local row = vgui.Create("impulseCivicMeritsRow", self.scroll)
                row:SetPlayer(ply)
            end
        end
    end
end

vgui.Register("impulseCivicMeritsList", LISTPANEL, "DPanel")

local EDITOR = {}

function EDITOR:Init()
    self:SetSize(360, 305)
    self:Center()
    self:SetTitle("")
    self:SetSkin("combine")
    self:MakePopup()

    if IsValid(self.lblTitle) then
        self.lblTitle:SetVisible(false)
    end

    function self:Paint(w, h)
        surface.SetDrawColor(Color(3, 6, 12, 240))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(Color(0, 120, 180, 140))
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end

function EDITOR:SetPlayer(ply)
    self.Player = ply

    self.modelIcon = vgui.Create("impulseSpawnIcon", self)
    self.modelIcon:SetPos(12, 30)
    self.modelIcon:SetSize(100, 100)
    self.modelIcon:SetModel(ply:GetModel(), ply:GetSkin())
    self.modelIcon:SetTooltip(false)
    self.modelIcon:SetDisabled(true)
    self.modelIcon:SetMouseInputEnabled(false)

    ApplyPortraitBodygroups(self.modelIcon, ply)

    self.nameLbl = vgui.Create("DLabel", self)
    self.nameLbl:SetPos(124, 34)
    self.nameLbl:SetSize(220, 20)
    self.nameLbl:SetFont("DebugFixed")
    self.nameLbl:SetTextColor(color_white)
    self.nameLbl:SetText("NAME: " .. ply:Nick())

    self.cidLbl = vgui.Create("DLabel", self)
    self.cidLbl:SetPos(124, 58)
    self.cidLbl:SetSize(220, 20)
    self.cidLbl:SetFont("DebugFixed")
    self.cidLbl:SetTextColor(color_white)
    self.cidLbl:SetText("CIVIC ID: " .. ply:GetCivicID())

    self.tierLbl = vgui.Create("DLabel", self)
    self.tierLbl:SetPos(124, 82)
    self.tierLbl:SetSize(220, 20)
    self.tierLbl:SetFont("DebugFixed")
    self.tierLbl:SetTextColor(color_white)
    self.tierLbl:SetText("LOYALIST TIER: " .. ply:GetLoyalistLevel())

    self.meritsLbl = vgui.Create("DLabel", self)
    self.meritsLbl:SetPos(124, 106)
    self.meritsLbl:SetSize(220, 20)
    self.meritsLbl:SetFont("DebugFixed")
    self.meritsLbl:SetTextColor(color_white)
    self.meritsLbl:SetText("CIVIC MERITS: " .. ply:GetCivicMerits())

    self.reasonCombo = vgui.Create("DComboBox", self)
    self.reasonCombo:SetPos(12, 145)
    self.reasonCombo:SetSize(336, 28)
    self.reasonCombo:SetFont("DebugFixed")
    self.reasonCombo:SetTextColor(color_black   )
    self.reasonCombo:SetValue("SELECT REASON...")
    self.reasonCombo:SetSortItems(false)
    self.reasonCombo:AddChoice("Workshift Detail")
    self.reasonCombo:AddChoice("Contraband Turnover")
    self.reasonCombo:AddChoice("Loyalist Activity")
    self.reasonCombo:AddChoice("Other")

    self.otherReasonEntry = vgui.Create("DTextEntry", self)
    self.otherReasonEntry:SetPos(12, 177)
    self.otherReasonEntry:SetSize(336, 28)
    self.otherReasonEntry:SetFont("DebugFixed")
    self.otherReasonEntry:SetPlaceholderText("DESCRIBE WHAT HAPPENED...")
    self.otherReasonEntry:SetVisible(false)

    local editor = self

    function self.reasonCombo:OnSelect(index, value)
        editor.otherReasonEntry:SetVisible(value == "Other")
    end

    self.amountEntry = vgui.Create("DTextEntry", self)
    self.amountEntry:SetPos(12, 213)
    self.amountEntry:SetSize(336, 28)
    self.amountEntry:SetFont("DebugFixed")
    self.amountEntry:SetPlaceholderText("AMOUNT")
    self.amountEntry:SetNumeric(true)

    self.addBtn = vgui.Create("DButton", self)
    self.addBtn:SetPos(12, 253)
    self.addBtn:SetSize(165, 32)
    self.addBtn:SetText("ADD")
    self.addBtn:SetFont("DebugFixed")

    self.subBtn = vgui.Create("DButton", self)
    self.subBtn:SetPos(183, 253)
    self.subBtn:SetSize(165, 32)
    self.subBtn:SetText("SUBTRACT")
    self.subBtn:SetFont("DebugFixed")

    local function submit(isAddition)
        local amount = math.floor(math.abs(tonumber(editor.amountEntry:GetValue()) or 0))

        if amount == 0 then
            return
        end

        if not IsValid(editor.Player) then
            return LocalPlayer():Notify("Target left the game.")
        end

        local reasonText = editor.reasonCombo:GetSelected()

        if not reasonText then
            return LocalPlayer():Notify("You must select a reason.")
        end

        local finalReason = reasonText

        if reasonText == "Other" then
            local otherText = string.Trim(editor.otherReasonEntry:GetValue() or "")

            if otherText == "" then
                return LocalPlayer():Notify("You must describe what happened when selecting Other.")
            end

            finalReason = otherText
        end

        net.Start("impulseHL2RPAdjustCivicMerits")
            net.WriteEntity(editor.Player)
            net.WriteBool(isAddition)
            net.WriteUInt(amount, 16)
            net.WriteString(finalReason)
        net.SendToServer()

        editor:Remove()
    end

    function self.addBtn:DoClick() submit(true) end
    function self.subBtn:DoClick() submit(false) end
end

function EDITOR:Think()
    if not IsValid(self.Player) then
        return self:Remove()
    end

    if IsValid(self.tierLbl) then
        self.tierLbl:SetText("LOYALIST TIER: " .. self.Player:GetLoyalistLevel())
    end

    if IsValid(self.meritsLbl) then
        self.meritsLbl:SetText("CIVIC MERITS: " .. self.Player:GetCivicMerits())
    end
end

vgui.Register("impulseCivicMeritsEditor", EDITOR, "DFrame")

function OpenCivicMeritsEditor(ply)
    if IsValid(CIVIC_MERITS_EDITOR) then
        CIVIC_MERITS_EDITOR:Remove()
    end

    CIVIC_MERITS_EDITOR = vgui.Create("impulseCivicMeritsEditor")
    CIVIC_MERITS_EDITOR:SetPlayer(ply)
end