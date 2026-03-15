include("shared.lua")

local grey       = Color(209, 209, 209)
local white      = Color(255, 255, 255)
local accentBlue = Color(80, 160, 220)

local function GetItemData(class)
    for _, itemData in pairs(impulse.Inventory.Items) do
        if itemData.UniqueID == class then
            return itemData
        end
    end
end

local SLOT_OFFSETS = { --fwd and right are messed up lol
    { fwd = -22, right =  1, up = 37 },
    { fwd =   0, right =  1, up = 37 },
    { fwd =  22, right =  1, up = 37 },
    { fwd = -22, right =  -1, up = 23 },
    { fwd =   0, right =  -1, up = 23 },
    { fwd =  22, right =  -1, up = 23 },
    { fwd = -22, right =  -3, up =  12 },
    { fwd =   0, right =  -3, up =  12 },
    { fwd =  22, right =  -3, up =  12 },
}

local ICON_SIZE   = 24
local ICON_SCALE  = 0.08
local MODEL_SCALE = 1
local X_BACK_OFFSET = 18
local X_BG_COLOR  = Color(5, 5, 5, 240)
local X_LINE_COLOR = Color(160, 160, 160, 200)

function ENT:Initialize()
    self.SlotModels    = {}
    self.LastSlotState = {}
end

function ENT:OnRemove()
    for i = 1, 9 do
        if IsValid(self.SlotModels[i]) then
            self.SlotModels[i]:Remove()
        end
    end
end

function ENT:Think()
    for i = 1, 9 do
        local class = self:GetNWString("Slot_" .. i .. "_Item", "")
        if class ~= self.LastSlotState[i] then
            self.LastSlotState[i] = class
            self:RefreshSlotModel(i, class)
        end

        if IsValid(self.SlotModels[i]) then
            local off = SLOT_OFFSETS[i]
            self.SlotModels[i]:SetPos(self:GetPos()
                + self:GetForward() * off.fwd
                + self:GetRight()   * off.right
                + self:GetUp()      * off.up)
            self.SlotModels[i]:SetAngles(self:GetAngles())
        end
    end
end

function ENT:RefreshSlotModel(i, class)
    if IsValid(self.SlotModels[i]) then
        self.SlotModels[i]:Remove()
        self.SlotModels[i] = nil
    end

    if class == "" then return end

    local itemData = GetItemData(class)
    if not itemData or not itemData.Model then return end

    local off = SLOT_OFFSETS[i]
    local mdl = ClientsideModel(itemData.Model, RENDERGROUP_OPAQUE)

    mdl:SetPos(self:GetPos()
        + self:GetForward() * off.fwd
        + self:GetRight()   * off.right
        + self:GetUp()      * off.up)
    mdl:SetAngles(self:GetAngles())
    mdl:SetModelScale(MODEL_SCALE)

    self.SlotModels[i] = mdl
end

function ENT:Draw()
    self:DrawModel()
    self:DrawWorldItems()
end

function ENT:DrawWorldItems()
    local ply = LocalPlayer()
    if self:GetNWString("OwnerSID", "") ~= ply:SteamID() then return end

    local dist = self:GetPos():Distance(ply:GetPos())
    if dist > 300 then return end

    local entPos   = self:GetPos()
    local fwdVec   = self:GetForward()
    local rightVec = self:GetRight()
    local upVec    = self:GetUp()
    local eyePos   = ply:EyePos()

    for i = 1, 9 do
        local class = self:GetNWString("Slot_" .. i .. "_Item", "")
        if class == "" then
            local off = SLOT_OFFSETS[i]
            local slotPos = entPos
                + fwdVec   * off.fwd
                + rightVec * X_BACK_OFFSET
                + upVec    * (off.up + 7)

            local toEye   = (eyePos - slotPos):GetNormalized()
            local billAng = toEye:Angle()
            billAng:RotateAroundAxis(billAng:Right(), 90)
            billAng:RotateAroundAxis(billAng:Up(),   -90)

            cam.Start3D2D(slotPos, billAng, ICON_SCALE)
                local half = ICON_SIZE / 2
                draw.RoundedBox(3, -half - 2, -half - 2, ICON_SIZE + 4, ICON_SIZE + 4, X_BG_COLOR)
                surface.SetDrawColor(X_LINE_COLOR.r, X_LINE_COLOR.g, X_LINE_COLOR.b, X_LINE_COLOR.a)
                surface.DrawLine(-half + 4, -half + 4,  half - 4,  half - 4)
                surface.DrawLine( half - 4, -half + 4, -half + 4,  half - 4)
            cam.End3D2D()
        end
    end
end

net.Receive("CWUCooler_OpenOwner", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    if IsValid(LocalPlayer().CWUCoolerOwnerPanel) then
        LocalPlayer().CWUCoolerOwnerPanel:Remove()
    end

    local panel = vgui.Create("CWUCooler_OwnerPanel")
    panel.Ent = ent
    panel:Populate()
    LocalPlayer().CWUCoolerOwnerPanel = panel
end)

net.Receive("CWUCooler_OpenBuyer", function()
    local ent       = net.ReadEntity()
    local isCombine = net.ReadBool()
    if not IsValid(ent) then return end

    if IsValid(LocalPlayer().CWUCoolerBuyerPanel) then
        LocalPlayer().CWUCoolerBuyerPanel:Remove()
    end

    local panel = vgui.Create("CWUCooler_BuyerPanel")
    panel.Ent       = ent
    panel.IsCombine = isCombine
    panel:Populate()
    LocalPlayer().CWUCoolerBuyerPanel = panel
end)

local OWNER = {}

function OWNER:Init()
    self:SetSize(700, 540)
    self:Center()
    self:SetTitle("Cooler Management")
    self:MakePopup()
end

function OWNER:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 240))
    draw.RoundedBox(0, 0, 0, w, 30, Color(40, 40, 40, 255))
end

function OWNER:Populate()
    if IsValid(self.grid) then self.grid:Remove() end
    if IsValid(self.discountArea) then self.discountArea:Remove() end

    local w, h = self:GetSize()
    local ent  = self.Ent

    self.discountArea = vgui.Create("DPanel", self)
    self.discountArea:SetPos(10, 38)
    self.discountArea:SetSize(w - 20, 36)
    function self.discountArea:Paint(pw, ph)
        draw.RoundedBox(4, 0, 0, pw, ph, Color(35, 35, 35, 200))
    end

    local discLabel = vgui.Create("DLabel", self.discountArea)
    discLabel:SetPos(8, 8)
    discLabel:SetFont("Impulse-Elements18-Shadow")
    discLabel:SetText("Combine Discount %:")
    discLabel:SetTextColor(grey)
    discLabel:SizeToContents()

    local discEntry = vgui.Create("DTextEntry", self.discountArea)
    discEntry:SetPos(180, 5)
    discEntry:SetSize(60, 26)
    discEntry:SetFont("Impulse-Elements18-Shadow")
    discEntry:SetValue(tostring(ent:GetNWInt("CombineDiscount", 0)))
    function discEntry:Paint(pw, ph)
        draw.RoundedBox(4, 0, 0, pw, ph, Color(50, 50, 50, 210))
        self:DrawTextEntryText(grey, Color(100, 100, 100), grey)
    end

    local discBtn = vgui.Create("DButton", self.discountArea)
    discBtn:SetPos(248, 5)
    discBtn:SetSize(80, 26)
    discBtn:SetText("Set")
    discBtn:SetFont("Impulse-Elements18-Shadow")
    discBtn:SetTextColor(white)
    function discBtn:Paint(pw, ph)
        draw.RoundedBox(4, 0, 0, pw, ph, Color(60, 100, 160, 220))
    end
    function discBtn:DoClick()
        local val = tonumber(discEntry:GetValue()) or 0
        val = math.Clamp(math.Round(val), 0, 100)
        net.Start("CWUCooler_SetDiscount")
            net.WriteEntity(ent)
            net.WriteUInt(val, 7)
        net.SendToServer()
    end

    self.grid = vgui.Create("DPanel", self)
    self.grid:SetPos(10, 82)
    self.grid:SetSize(w - 20, h - 92)
    function self.grid:Paint() end

    local cols  = 3
    local cellW = math.floor((self.grid:GetWide() - (cols + 1) * 8) / cols)
    local cellH = 130
    local padX  = 8
    local padY  = 8

    for i = 1, 9 do
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        local x   = padX + col * (cellW + padX)
        local y   = padY + row * (cellH + padY)

        local cell = vgui.Create("DPanel", self.grid)
        cell:SetPos(x, y)
        cell:SetSize(cellW, cellH)
        cell.SlotIndex = i
        cell.Ent = ent

        function cell:Paint(pw, ph)
            draw.RoundedBox(6, 0, 0, pw, ph, Color(35, 35, 35, 220))
            draw.SimpleText("Slot " .. self.SlotIndex, "Impulse-Elements18-Shadow", 6, 4, grey)

            local class = self.Ent:GetNWString("Slot_" .. self.SlotIndex .. "_Item", "")
            if class ~= "" then
                local itemData = GetItemData(class)
                local name = itemData and itemData.Name or class
                draw.SimpleText(name, "Impulse-Elements18-Shadow", pw / 2, 46, accentBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if itemData and itemData.Icon then
                    local mat = Material(itemData.Icon, "smooth mips")
                    surface.SetDrawColor(255, 255, 255, 200)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(pw / 2 - 16, 18, 32, 32)
                end

                local price = self.Ent:GetNWInt("Slot_" .. self.SlotIndex .. "_Price", 0)
                draw.SimpleText(price .. " cr", "Impulse-Elements14", pw / 2, 60, grey, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Empty", "Impulse-Elements18-Shadow", pw / 2, 50, Color(100, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        local priceLabel = vgui.Create("DLabel", cell)
        priceLabel:SetPos(4, cellH - 50)
        priceLabel:SetFont("Impulse-Elements18-Shadow")
        priceLabel:SetText("Price:")
        priceLabel:SetTextColor(grey)
        priceLabel:SizeToContents()

        local priceEntry = vgui.Create("DTextEntry", cell)
        priceEntry:SetPos(48, cellH - 53)
        priceEntry:SetSize(cellW - 120, 24)
        priceEntry:SetFont("Impulse-Elements18-Shadow")
        priceEntry:SetValue(tostring(ent:GetNWInt("Slot_" .. i .. "_Price", 0)))
        function priceEntry:Paint(pw, ph)
            draw.RoundedBox(4, 0, 0, pw, ph, Color(50, 50, 50, 210))
            self:DrawTextEntryText(grey, Color(100, 100, 100), grey)
        end

        local priceBtn = vgui.Create("DButton", cell)
        priceBtn:SetPos(cellW - 66, cellH - 53)
        priceBtn:SetSize(62, 24)
        priceBtn:SetText("Set")
        priceBtn:SetFont("Impulse-Elements18-Shadow")
        priceBtn:SetTextColor(white)
        local si = i
        function priceBtn:Paint(pw, ph)
            draw.RoundedBox(4, 0, 0, pw, ph, Color(60, 100, 160, 220))
        end
        function priceBtn:DoClick()
            local val = tonumber(priceEntry:GetValue()) or 0
            val = math.Clamp(math.Round(val), 0, 65535)
            net.Start("CWUCooler_SetPrice")
                net.WriteEntity(ent)
                net.WriteUInt(si, 4)
                net.WriteUInt(val, 16)
            net.SendToServer()
        end

        local pickBtn = vgui.Create("DButton", cell)
        pickBtn:SetPos(4, cellH - 25)
        pickBtn:SetSize(cellW - 60, 22)
        pickBtn:SetText("Set Item")
        pickBtn:SetFont("Impulse-Elements18-Shadow")
        pickBtn:SetTextColor(white)
        function pickBtn:Paint(pw, ph)
            draw.RoundedBox(4, 0, 0, pw, ph, Color(50, 80, 50, 220))
        end
        local si2 = i
        function pickBtn:DoClick()
            if IsValid(LocalPlayer().CWUCoolerItemPicker) then
                LocalPlayer().CWUCoolerItemPicker:Remove()
            end
            local picker = vgui.Create("CWUCooler_ItemPicker")
            picker.SlotIndex  = si2
            picker.Ent        = ent
            picker.OwnerPanel = self:GetParent():GetParent()
            picker:Populate()
            LocalPlayer().CWUCoolerItemPicker = picker
        end

        local clearBtn = vgui.Create("DButton", cell)
        clearBtn:SetPos(cellW - 52, cellH - 25)
        clearBtn:SetSize(48, 22)
        clearBtn:SetText("Clear")
        clearBtn:SetFont("Impulse-Elements18-Shadow")
        clearBtn:SetTextColor(white)
        function clearBtn:Paint(pw, ph)
            draw.RoundedBox(4, 0, 0, pw, ph, Color(120, 50, 50, 220))
        end
        local si3 = i
        function clearBtn:DoClick()
            net.Start("CWUCooler_ClearSlot")
                net.WriteEntity(ent)
                net.WriteUInt(si3, 4)
            net.SendToServer()
            local root = self:GetParent():GetParent():GetParent()
            timer.Simple(0.2, function()
                if IsValid(root) then root:Populate() end
            end)
        end
    end
end

vgui.Register("CWUCooler_OwnerPanel", OWNER, "DFrame")

local PICKER = {}

function PICKER:Init()
    self:SetSize(360, 420)
    self:Center()
    self:SetTitle("Select Item for Slot")
    self:MakePopup()
end

function PICKER:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 240))
    draw.RoundedBox(0, 0, 0, w, 30, Color(40, 40, 40, 255))
    draw.SimpleText("Select Item — Slot " .. (self.SlotIndex or "?"), "Impulse-Elements23-Shadow", w / 2, 15, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PICKER:Populate()
    if IsValid(self.scroll) then self.scroll:Remove() end

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:SetPos(5, 35)
    self.scroll:SetSize(self:GetWide() - 10, self:GetTall() - 40)

    local inv = table.Copy(impulse.Inventory.Data[0][1]) or {}

    if table.Count(inv) == 0 then
        local empty = vgui.Create("DLabel", self.scroll)
        empty:Dock(TOP)
        empty:SetText("Your inventory is empty.")
        empty:SetFont("Impulse-Elements18-Shadow")
        empty:SetTextColor(grey)
        empty:SetContentAlignment(5)
        return
    end

    local ALLOWED_CATEGORIES = {
        ["Rations"]    = true,
        ["Food"]       = true,
        ["Components"] = true,
        ["Meals"]      = true,
        ["Medical"]    = true,
    }

    local count = 0
    for invKey, entry in pairs(inv) do
        if not entry.restricted then
            local itemData = GetItemData(entry.id) or impulse.Inventory.Items[entry.id]
            if itemData and ALLOWED_CATEGORIES[itemData.Category] then
                count = count + 1
                local row = vgui.Create("DButton", self.scroll)
                row:Dock(TOP)
                row:DockMargin(0, 0, 0, 3)
                row:SetTall(36)
                row:SetText("")
                row.ItemID   = itemData.UniqueID
                row.InvKey   = invKey
                row.ItemName = itemData.Name
                row.Picker   = self

                function row:Paint(pw, ph)
                    draw.RoundedBox(4, 0, 0, pw, ph, Color(40, 40, 40, 220))
                    if itemData.Icon then
                        local mat = Material(itemData.Icon, "smooth mips")
                        surface.SetDrawColor(255, 255, 255, 200)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(4, 2, 30, 30)
                    end
                    draw.SimpleText(self.ItemName, "Impulse-Elements18-Shadow", 42, ph / 2, grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                function row:DoClick()
                    local picker = self.Picker
                    net.Start("CWUCooler_SetSlot")
                        net.WriteEntity(picker.Ent)
                        net.WriteUInt(picker.SlotIndex, 4)
                        net.WriteString(self.ItemID)
                        net.WriteUInt(self.InvKey, 16)
                    net.SendToServer()
                    timer.Simple(0.3, function()
                        if IsValid(picker.OwnerPanel) then
                            picker.OwnerPanel:Populate()
                        end
                    end)
                    picker:Remove()
                end
            end
        end
    end

    if count == 0 then
        local empty = vgui.Create("DLabel", self.scroll)
        empty:Dock(TOP)
        empty:SetText("No eligible items in your inventory.")
        empty:SetFont("Impulse-Elements18-Shadow")
        empty:SetTextColor(grey)
        empty:SetContentAlignment(5)
    end
end

vgui.Register("CWUCooler_ItemPicker", PICKER, "DFrame")

local BUYER = {}

function BUYER:Init()
    self:SetSize(560, 480)
    self:Center()
    self:SetTitle("Cooler")
    self:MakePopup()
end

function BUYER:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 240))
    draw.RoundedBox(0, 0, 0, w, 30, Color(40, 40, 40, 255))
    draw.SimpleText("Purchase Goods", "Impulse-Elements23-Shadow", w / 2, 15, grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if self.IsCombine then
        draw.SimpleText("Combine discount active", "Impulse-Elements18-Shadow", w / 2, 32, accentBlue, TEXT_ALIGN_CENTER)
    end
end

function BUYER:Populate()
    if IsValid(self.scroll) then self.scroll:Remove() end

    local w, h     = self:GetSize()
    local ent      = self.Ent
    local isComb   = self.IsCombine
    local discount = ent:GetNWInt("CombineDiscount", 0)

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:SetPos(10, 40)
    self.scroll:SetSize(w - 20, h - 50)

    local anyItem = false

    for i = 1, 9 do
        local class = ent:GetNWString("Slot_" .. i .. "_Item", "")
        if class ~= "" then
            anyItem = true
            local itemData   = GetItemData(class)
            local price      = ent:GetNWInt("Slot_" .. i .. "_Price", 0)
            local finalPrice = price
            if isComb and discount > 0 then
                finalPrice = math.floor(price * ((100 - discount) / 100))
            end

            local row = vgui.Create("DPanel", self.scroll)
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 6)
            row:SetTall(56)
            row.SlotIndex  = i
            row.Ent        = ent
            row.FinalPrice = finalPrice
            row.OrigPrice  = price
            row.ItemClass  = class
            row.IsCombine  = isComb

            function row:Paint(pw, ph)
                draw.RoundedBox(6, 0, 0, pw, ph, Color(35, 35, 35, 220))

                if itemData and itemData.Icon then
                    local mat = Material(itemData.Icon, "smooth mips")
                    surface.SetDrawColor(255, 255, 255, 200)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(6, 6, 44, 44)
                end

                local name = itemData and itemData.Name or class
                draw.SimpleText(name, "Impulse-Elements23-Shadow", 58, 10, white)

                local priceStr = self.FinalPrice .. " cr"
                if self.IsCombine and self.FinalPrice ~= self.OrigPrice then
                    priceStr = self.FinalPrice .. " cr  [was " .. self.OrigPrice .. "]"
                end
                draw.SimpleText(priceStr, "Impulse-Elements18-Shadow", 58, 32, self.IsCombine and accentBlue or grey)
            end

            local buyBtn = vgui.Create("DButton", row)
            buyBtn:SetPos(row:GetWide() - 90, 14)
            buyBtn:SetSize(82, 28)
            buyBtn:SetText("Buy")
            buyBtn:SetFont("Impulse-Elements23-Shadow")
            buyBtn:SetTextColor(white)
            local si     = i
            local entRef = ent
            function buyBtn:Paint(pw, ph)
                draw.RoundedBox(4, 0, 0, pw, ph, Color(60, 120, 60, 230))
            end
            function buyBtn:DoClick()
                net.Start("CWUCooler_Purchase")
                    net.WriteEntity(entRef)
                    net.WriteUInt(si, 4)
                net.SendToServer()
                timer.Simple(0.3, function()
                    local panel = LocalPlayer().CWUCoolerBuyerPanel
                    if IsValid(panel) then
                        panel:Populate()
                    end
                end)
            end

            row.Think = function(self)
                if IsValid(buyBtn) then
                    buyBtn:SetPos(self:GetWide() - 90, 14)
                end
            end
        end
    end

    if not anyItem then
        local empty = vgui.Create("DLabel", self.scroll)
        empty:Dock(TOP)
        empty:SetText("Nothing for sale.")
        empty:SetFont("Impulse-Elements23-Shadow")
        empty:SetTextColor(grey)
        empty:SetContentAlignment(5)
        empty:SetTall(60)
    end
end

vgui.Register("CWUCooler_BuyerPanel", BUYER, "DFrame")