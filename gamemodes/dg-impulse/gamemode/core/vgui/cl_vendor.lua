local PANEL = {}

local BASE_W, BASE_H = 1170, 1050

function PANEL:Init()
    local sw, sh = ScrW(), ScrH()
    local w = math.min(BASE_W, sw * 0.85)
    local h = math.min(BASE_H, sh * 0.85)
    self:SetSize(w, h)
    self:Center()
    self:SetTitle("")
    self:MakePopup()
end

function PANEL:SetupVendor()
    local lp = LocalPlayer()

    local trace = {}
    trace.start = lp:EyePos()
    trace.endpos = trace.start + lp:GetAimVector() * 120
    trace.filter = lp

    local tr = util.TraceLine(trace)

    if not tr.Entity or not IsValid(tr.Entity) or tr.Entity:GetClass() ~= "impulse_vendor" then
        return self:Remove()
    end

    local npc = tr.Entity
    local vendorType = npc.GetVendorUID and npc:GetVendorUID() or npc:GetVendor()

    if not vendorType or vendorType == "" then
        return print("[impulse] Vendor has no VendorType set!")
    end

    if impulse.Vendor.LiveData and impulse.Vendor.LiveData[vendorType] then
        impulse.Vendor.Data[vendorType] = impulse.Vendor.LiveData[vendorType]
    end

    if not impulse.Vendor.Data[vendorType] then
        return print("[impulse] " .. vendorType .. " invalid.")
    end

    self.NPC = npc
    self.Vendor = impulse.Vendor.Data[vendorType]
    self.VendorUID = vendorType

    if self.Vendor.Talk and impulse.GetSetting("misc_vendorgreeting", true) then
        surface.PlaySound(impulse.GetRandomAmbientVO(self.Vendor.Gender))
    end

    local w, h = self:GetSize()
    local colW    = w * 0.435
    local rightX  = w * 0.564
    local listY   = h * 0.118

    local vNameLbl = vgui.Create("DLabel", self)
    vNameLbl:SetText(self.Vendor.Name or "Vendor")
    vNameLbl:SetFont("Impulse-Elements27-Shadow")
    vNameLbl:SetPos(10, 33)
    vNameLbl:SizeToContents()

    if vNameLbl:GetWide() >= colW - 20 then
        vNameLbl:SetFont("Impulse-Elements20A-Shadow")
        vNameLbl:SizeToContents()
    end

    local vDescLbl = vgui.Create("DLabel", self)
    vDescLbl:SetText(self.Vendor.Desc or "")
    vDescLbl:SetFont("Impulse-Elements14-Shadow")
    vDescLbl:SetPos(10, 58)
    vDescLbl:SetSize(colW - 10, 20)

    local yNameLbl = vgui.Create("DLabel", self)
    yNameLbl:SetText("You")
    yNameLbl:SetFont("Impulse-Elements27-Shadow")
    yNameLbl:SetPos(rightX, 33)
    yNameLbl:SizeToContents()

    local yDescLbl = vgui.Create("DLabel", self)
    yDescLbl:SetText("You have " .. LocalPlayer():GetMoney() .. " " .. impulse.Config.CurrencyName)
    yDescLbl:SetFont("Impulse-Elements17-Shadow")
    yDescLbl:SetPos(rightX, 58)
    yDescLbl:SetSize(colW - 10, 20)
    yDescLbl.lastMoney = LocalPlayer():GetMoney()

    function yDescLbl:Think()
        if self.lastMoney ~= LocalPlayer():GetMoney() then
            self.lastMoney = LocalPlayer():GetMoney()
            self:SetText("You have " .. LocalPlayer():GetMoney() .. " " .. impulse.Config.CurrencyName)
        end
    end

    local empty = true

    self.vendorScroll = vgui.Create("DScrollPanel", self)
    self.vendorScroll:SetPos(0, listY)
    self.vendorScroll:SetSize(colW, h - listY)

    local function AddSellRow(v, k)
        local itemid = impulse.Inventory.ClassToNetID(v)
        if not itemid then
            print("[impulse] " .. v .. " is invalid!")
            return
        end
        local item = impulse.Inventory.Items[itemid]
        if not item then
            print("[impulse] Failed to resolve ItemID " .. itemid .. "! (Class " .. v .. ")!")
            return
        end
        local vendorItem = self.vendorScroll:Add("impulseVendorItem")
        vendorItem:SetItem(item, k)
        vendorItem.Parent = self
        vendorItem:Dock(TOP)
        empty = false
    end

    for v, k in pairs(self.Vendor.Sell or {}) do
        if not k.CanBuy or k.CanBuy(LocalPlayer()) then
            AddSellRow(v, k)
        end
    end
    for v, k in pairs(self.Vendor.Sell or {}) do
        if k.CanBuy and not k.CanBuy(LocalPlayer()) then
            AddSellRow(v, k)
        end
    end

    if empty then
        local emptyLbl = vgui.Create("DLabel", self.vendorScroll)
        emptyLbl:SetText("Nothing to buy")
        emptyLbl:SetFont("Impulse-Elements18-Shadow")
        emptyLbl:SizeToContents()
        emptyLbl:Dock(TOP)
        emptyLbl:DockMargin(0, 20, 0, 0)
        emptyLbl:SetContentAlignment(5)
    end

    empty = true

    self.youScroll = vgui.Create("DScrollPanel", self)
    self.youScroll:SetPos(rightX, listY)
    self.youScroll:SetSize(colW, h - listY)

    for v, k in pairs(impulse.Inventory.Data[0][1] or {}) do
        if not k.restricted then
            local item = impulse.Inventory.Items[k.id]
            local class = item.UniqueID

            if self.Vendor.Buy and self.Vendor.Buy[class] then
                local vendorItem = self.youScroll:Add("impulseVendorItem")
                vendorItem.Selling = true
                vendorItem.ItemID = v
                vendorItem:SetItem(item, self.Vendor.Buy[class])
                vendorItem.Parent = self
                vendorItem:Dock(TOP)
                empty = false
            end
        end
    end

    if empty then
        local emptyLbl = vgui.Create("DLabel", self.youScroll)
        emptyLbl:SetText("Nothing to sell")
        emptyLbl:SetFont("Impulse-Elements18-Shadow")
        emptyLbl:SizeToContents()
        emptyLbl:Dock(TOP)
        emptyLbl:DockMargin(0, 20, 0, 0)
        emptyLbl:SetContentAlignment(5)
    end

    if LocalPlayer():IsSuperAdmin() and impulse.Vendor.InjectVendorEditButton then
        impulse.Vendor.InjectVendorEditButton(self, vendorType)
    end
end

local headerDark = Color(20, 20, 20, 180)
local listDark = Color(0, 0, 0, 28)
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "Frame", self, w, h)

    local colW   = w * 0.435
    local rightX = w * 0.564
    local listY  = h * 0.118
    local headerH = listY - (h * 0.0357)

    surface.SetDrawColor(headerDark)
    surface.DrawRect(0, h * 0.0357, colW, headerH)
    surface.DrawRect(rightX, h * 0.0357, colW, headerH)

    surface.SetDrawColor(listDark)
    surface.DrawRect(0, listY, colW, h)
    surface.DrawRect(rightX, listY, colW, h)
end

vgui.Register("impulseVendorMenu", PANEL, "DFrame")