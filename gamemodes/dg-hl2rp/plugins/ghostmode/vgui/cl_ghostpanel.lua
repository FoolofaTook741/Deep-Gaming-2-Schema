local PANEL = {}

--function PANEL:AddAction(tab,)

function PANEL:CreateTabs()
    self.Sheet = vgui.Create("DPropertySheet",self)
    self.Sheet:Dock(FILL)
end

function PANEL:Init()
    
    self:SetTitle("Ghost Control Panel")
    self:SetSize(400,600)
    self:Center()
    self:MakePopup()

end

vgui.Register("landisGhostPanel",PANEL,"DFrame")

net.Receive("landisGhostPanel",function()
    local a = vgui.Create("landisGhostPanel")
end)