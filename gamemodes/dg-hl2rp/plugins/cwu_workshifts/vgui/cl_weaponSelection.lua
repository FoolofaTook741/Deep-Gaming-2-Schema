local PANEL = {}

function PANEL:Init()
    self:SetSize(350, 500)
    self:Center()
    self:SetTitle("Select Weapon for Fabrication")
    self:ShowCloseButton(true)
    self:MakePopup()
    self.darkOverlay = Color(40, 40, 40, 160)
    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:SetPos(0, 25)
    self.scroll:SetSize(350, 440)

    self.selectedWeapon = nil
end

local bodyCol = Color(50, 50, 50, 210)

function PANEL:SetWeapons(weapons, fabricator)
    local panel = self

    for _, weapon in ipairs(weapons) do
        local bg = self.scroll:Add("DPanel")
        bg:SetTall(38)
        bg:DockMargin(5, 3, 5, 3)
        bg:Dock(TOP)
        bg.WeaponClass = weapon.class
        bg.WeaponName = weapon.name

        function bg:Paint(w, h)
            surface.SetDrawColor(bodyCol)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(self.WeaponName, "Impulse-Elements18-Shadow", 10, 5, color_white)
        end

        local selectBtn = vgui.Create("DButton", bg)
        selectBtn:SetPos(260, 6)
        selectBtn:SetSize(80, 26)
        selectBtn:SetText("Select")

        function selectBtn:DoClick()
            panel.selectedWeapon = weapon.class
			panel.selectedWeaponName = weapon.name
            panel:SelectWeapon()
        end
    end

    self.confirmBtn = vgui.Create("DButton", self)
    self.confirmBtn:SetPos(0, 470)
    self.confirmBtn:SetSize(350, 30)
    self.confirmBtn:SetText("Confirm Selection")

    function self.confirmBtn:DoClick()
        if not panel.selectedWeapon then
            LocalPlayer():Notify("Please select a weapon to upgrade.")
            return
        end

        if not IsValid(fabricator) then
            return
        end

        net.Start("SelectFabricatorWeapon")
        net.WriteString(panel.selectedWeapon)
        net.WriteEntity(fabricator)
        net.SendToServer()

        panel:Remove()
    end
end


function PANEL:SelectWeapon()
    self.confirmBtn:SetText("Confirm Selection: " .. self.selectedWeaponName)
end

vgui.Register("WeaponSelectionMenu", PANEL, "DFrame")

net.Receive("OpenFabricatorMenu", function()
    local weaponcount = net.ReadUInt(4)
    local weapons = {}

    for i = 1, weaponcount do
        local class = net.ReadString()
        local name = net.ReadString()
        table.insert(weapons, { class = class, name = name })
    end

    local fabricator = net.ReadEntity()

    if IsValid(menu) and menu:IsVisible() then
        return
    end

    menu = vgui.Create("WeaponSelectionMenu")
    menu:SetWeapons(weapons, fabricator)
end)