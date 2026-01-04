local PANEL = {}
local f = math.floor
local c = math.Clamp

function PANEL:Init()
    local lp = LocalPlayer()
    if not lp:IsCP() then
        self:Remove()
        return
    end
    self:SetSize(500,400)
    self:SetTitle("<:: CALLSIGN MANAGER")
    self:Center()
    self:SetDraggable(false)
    self:MakePopup()
    self:SetSkin("combine")
    self:DockPadding(50, 50, 50, 50)
    
    self.nmlbl = vgui.Create("DLabel",self)
    self.nmlbl:SetFont("BudgetLabel")
    self.nmlbl:SetText("Select a tagline from the dropdown below.") 
    self.nmlbl:Dock(TOP)
    self.NameSelector = vgui.Create("DComboBox",self,"nameSel")
    self.NameSelector:SetSortItems(false)
    self.NameSelector:Dock(TOP)
    local CALLSIGNS = LocalPlayer():Team() == TEAM_CP and CP_CALLSIGNS_LINES or OTA_CALLSIGNS_LINES
    for k, v in ipairs(CALLSIGNS) do
        self.NameSelector:AddChoice(k .. " - " .. v.NiceName)
    end
        
    self.NameSelector:SetTextColor(color_black)
    self.NumSlider = vgui.Create("DNumSlider",self,"numsel")
    self.NumSlider:SetText("UNIT INDEX")
    if LocalPlayer():IsCPCommand() then
        self.NumSlider:SetMax(9)
    else
        self.NumSlider:SetMax(99)
    end
    self.NumSlider:SetDecimals(0)
    if LocalPlayer():IsCPCommand() then
        self.NumSlider:SetMin(0)
    else
        self.NumSlider:SetMin(10)
    end
    self.NumSlider:Dock(TOP)

    self.Save = vgui.Create("DButton",self)
    self.Save:SetFont("BudgetLabel")
    self.Save:SetText("SAVE DATA")
    self.Save.DoClick = function()
        net.Start("impulseHL2RPCallsignEdit")
        net.WriteUInt(c(self.NameSelector:GetSelectedID(),1,#CALLSIGNS),8)
        net.WriteUInt(self.NumSlider:GetValue(),8)
        net.SendToServer()
        self:Remove()
    end
    self.Save:Dock(BOTTOM)

end

vgui.Register("impulseHL2RPCallsigns",PANEL,"DFrame")
