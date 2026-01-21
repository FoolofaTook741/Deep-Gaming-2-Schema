local PANEL = {}
local c = math.Clamp

local COMBINE_BG          = Color(3, 6, 12, 240)
local COMBINE_HEADER      = Color(5, 12, 26, 255)
local COMBINE_ACCENT      = Color(0, 170, 220, 220)
local COMBINE_ACCENT_SOFT = Color(0, 120, 180, 160)
local COMBINE_TEXT        = Color(220, 230, 240)
local COMBINE_MUTED       = Color(140, 150, 170)

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
    surface.SetDrawColor(255, 255, 255, alpha or 4)
    for i = 0, h, 2 do
        surface.DrawLine(0, i, w, i)
    end
end

function PANEL:Init()
    local lp = LocalPlayer()
    if not lp:IsCP() then
        self:Remove()
        return
    end

    self:SetSize(460, 260)
    self:Center()
    self:SetDraggable(false)
    self:MakePopup()
    self:SetTitle("")
    self:SetSkin("combine")
    self:DockPadding(24, 56, 24, 24)

    if IsValid(self.lblTitle) then
        self.lblTitle:SetVisible(false)
    end

    if IsValid(self.btnMaxim) then self.btnMaxim:SetVisible(false) end
    if IsValid(self.btnMinim) then self.btnMinim:SetVisible(false) end

    self.nmlbl = vgui.Create("DLabel", self)
    self.nmlbl:SetFont("BudgetLabel")
    self.nmlbl:SetText("Select a callsign tagline and unit index below.")
    self.nmlbl:SetTextColor(COMBINE_MUTED)
    self.nmlbl:SetContentAlignment(5)
    self.nmlbl:Dock(TOP)
    self.nmlbl:DockMargin(0, 0, 0, 8)

    self.NameSelector = vgui.Create("DComboBox", self, "nameSel")
    self.NameSelector:SetSortItems(false)
    self.NameSelector:Dock(TOP)
    self.NameSelector:DockMargin(0, 0, 0, 8)
    self.NameSelector:SetTall(26)
    self.NameSelector:SetValue("Select tagline")
    self.NameSelector:SetTextColor(color_black)

    local CALLSIGNS = lp:Team() == TEAM_CP and CP_CALLSIGNS_LINES or OTA_CALLSIGNS_LINES
    for k, v in ipairs(CALLSIGNS) do
        self.NameSelector:AddChoice(k .. " - " .. v.NiceName)
    end

    self.NumSlider = vgui.Create("DNumSlider", self, "numsel")
    self.NumSlider:SetText("UNIT INDEX")
    self.NumSlider:SetDecimals(0)
    if lp:IsCPCommand() then
        self.NumSlider:SetMax(9)
        self.NumSlider:SetMin(0)
    else
        self.NumSlider:SetMax(99)
        self.NumSlider:SetMin(10)
    end
    self.NumSlider:Dock(TOP)
    self.NumSlider:DockMargin(0, 0, 0, 12)

    self.Save = vgui.Create("DButton", self)
    self.Save:SetFont("BudgetLabel")
    self.Save:SetText("SAVE CALLSIGN")
    self.Save:Dock(BOTTOM)
    self.Save:DockMargin(0, 8, 0, 0)
    self.Save:SetTall(28)

    self.Save.DoClick = function()
        local id = self.NameSelector:GetSelectedID()
        if not id then return end

        net.Start("impulseHL2RPCallsignEdit")
        net.WriteUInt(c(id, 1, #CALLSIGNS), 8)
        net.WriteUInt(self.NumSlider:GetValue(), 8)
        net.SendToServer()
        self:Remove()
    end
end

function PANEL:Paint(w, h)
    DrawBlur(self, 4)

    surface.SetDrawColor(COMBINE_BG)
    surface.DrawRect(0, 0, w, h)

    local headerH = 32
    surface.SetDrawColor(COMBINE_HEADER)
    surface.DrawRect(0, 0, w, headerH)

    surface.SetDrawColor(COMBINE_ACCENT)
    surface.DrawRect(0, headerH - 2, w, 2)

    draw.SimpleText("<:: CALLSIGN MANAGER ::>", "BudgetLabel", 12, headerH / 2, COMBINE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local reserve = 12
    if IsValid(self.btnClose) then
        reserve = self.btnClose:GetWide() + 18
    end

    draw.SimpleText(LocalPlayer():Name(), "BudgetLabel", w - reserve, headerH / 2, COMBINE_MUTED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(COMBINE_ACCENT_SOFT)
    surface.DrawOutlinedRect(0, 0, w, h)

    surface.SetDrawColor(Color(0, 0, 0, 220))
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

    DrawScanlines(w, h, 3)
end

function PANEL:Think()
    local lp = LocalPlayer()
    if not IsValid(lp) or not lp:IsCP() then
        self:Remove()
    end
end

vgui.Register("impulseHL2RPCallsigns", PANEL, "DFrame")
