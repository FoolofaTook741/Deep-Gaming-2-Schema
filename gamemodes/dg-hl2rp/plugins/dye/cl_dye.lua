net.Receive("dye.OpenItemPicker", function()
    local colorName = net.ReadString()
    local count     = net.ReadUInt(8)
    local items     = {}

    for i = 1, count do
        local entry = {
            invid    = net.ReadUInt(16),
            class    = net.ReadString(),
            equipped = net.ReadBool(),
            slots    = {}
        }
        local slotCount = net.ReadUInt(4)
        for j = 1, slotCount do
            local slotName = net.ReadString()
            local hasDye   = net.ReadBool()
            table.insert(entry.slots, { name = slotName, hasDye = hasDye })
        end
        table.insert(items, entry)
    end

    local color = DYE_COLORS[colorName]

    if #items == 0 then
        Derma_Message("You have no dyeable clothing items in your inventory.", "Dye", "OK")
        return
    end

    local totalButtons = 0
    for _, entry in ipairs(items) do totalButtons = totalButtons + #entry.slots end

    local frame = vgui.Create("DFrame")
    frame:SetSize(300, math.min(80 + totalButtons * 44, 500))
    frame:SetTitle("Apply " .. colorName .. " Dye")
    frame:Center()
    frame:MakePopup()

    local strip = vgui.Create("DPanel", frame)
    strip:SetPos(10, 28)
    strip:SetSize(280, 8)
    strip.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, color)
    end

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(10, 44)
    scroll:SetSize(280, frame:GetTall() - 90)

    for _, entry in ipairs(items) do
        local itemDef = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(entry.class)]
        local itemName = itemDef and itemDef.Name or entry.class

        for _, slot in ipairs(entry.slots) do
            local label = itemName .. " — " .. slot.name
            if entry.equipped then label = label .. " [Equipped]" end
            if slot.hasDye    then label = label .. " [Dyed]"     end

            local btn = vgui.Create("DButton", scroll)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, 4)
            btn:SetTall(38)
            btn:SetText(label)

            local invid    = entry.invid
            local slotName = slot.name
            btn.DoClick = function()
                net.Start("dye.ApplyToItem")
                    net.WriteString(colorName)
                    net.WriteUInt(invid, 16)
                    net.WriteString(slotName)
                net.SendToServer()
                frame:Close()
            end
        end
    end

    local cancel = vgui.Create("DButton", frame)
    cancel:SetPos(10, frame:GetTall() - 40)
    cancel:SetSize(280, 28)
    cancel:SetText("Cancel")
    cancel.DoClick = function() frame:Close() end
end)

net.Receive("dye.PaintMachine.Open", function()
    local machine = net.ReadEntity()
    local count   = net.ReadUInt(8)
    local items   = {}

    for i = 1, count do
        local entry = {
            invid    = net.ReadUInt(16),
            class    = net.ReadString(),
            equipped = net.ReadBool(),
            slots    = {}
        }
        local slotCount = net.ReadUInt(4)
        for j = 1, slotCount do
            local slotName = net.ReadString()
            local hasDye   = net.ReadBool()
            table.insert(entry.slots, { name = slotName, hasDye = hasDye })
        end
        table.insert(items, entry)
    end

    if #items == 0 then
        Derma_Message("You have no dyeable clothing items in your inventory.", "Paint Machine", "OK")
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(560, 500)
    frame:SetTitle("Paint Machine [Collaborator]")
    frame:Center()
    frame:MakePopup()

    local mixLabel = vgui.Create("DLabel", frame)
    mixLabel:SetPos(10, 28)
    mixLabel:SetSize(260, 18)
    mixLabel:SetText("1. Choose a color:")
    mixLabel:SetFont("DermaDefaultBold")

    local mixer = vgui.Create("DColorMixer", frame)
    mixer:SetPos(10, 48)
    mixer:SetSize(260, 270)
    mixer:SetPalette(false)
    mixer:SetAlphaBar(false)
    mixer:SetColor(Color(255, 255, 255))

    local swatchLabel = vgui.Create("DLabel", frame)
    swatchLabel:SetPos(10, 325)
    swatchLabel:SetSize(260, 18)
    swatchLabel:SetText("Preview:")
    swatchLabel:SetFont("DermaDefaultBold")

    local swatch = vgui.Create("DPanel", frame)
    swatch:SetPos(10, 344)
    swatch:SetSize(260, 28)
    swatch.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, mixer:GetColor())
    end

    local itemLabel = vgui.Create("DLabel", frame)
    itemLabel:SetPos(285, 28)
    itemLabel:SetSize(265, 18)
    itemLabel:SetText("2. Choose a slot to dye:")
    itemLabel:SetFont("DermaDefaultBold")

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(285, 48)
    scroll:SetSize(265, 340)

    local selectedInvID  = nil
    local selectedSlot   = nil
    local allButtons     = {}

    for _, entry in ipairs(items) do
        local itemDef  = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(entry.class)]
        local itemName = itemDef and itemDef.Name or entry.class

        for _, slot in ipairs(entry.slots) do
            local label = itemName .. " — " .. slot.name
            if entry.equipped then label = label .. " [Equipped]" end
            if slot.hasDye    then label = label .. " [Dyed]"     end

            local btn = vgui.Create("DButton", scroll)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, 4)
            btn:SetTall(38)
            btn:SetText("")
            btn.label    = label
            btn.selected = false
            table.insert(allButtons, btn)

            local invid    = entry.invid
            local slotName = slot.name

            btn.Paint = function(self, w, h)
                local bg = self.selected and Color(80, 160, 80) or Color(50, 50, 50)
                draw.RoundedBox(4, 0, 0, w, h, bg)
                draw.SimpleText(self.label, "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            btn.DoClick = function()
                selectedInvID = invid
                selectedSlot  = slotName
                for _, b in ipairs(allButtons) do b.selected = false end
                btn.selected = true
            end
        end
    end

    local applyBtn = vgui.Create("DButton", frame)
    applyBtn:SetPos(285, 418)
    applyBtn:SetSize(265, 32)
    applyBtn:SetText("Apply Color")
    applyBtn.DoClick = function()
        if not selectedInvID or not selectedSlot then
            Derma_Message("Please select a slot to dye.", "Paint Machine", "OK")
            return
        end

        net.Start("dye.PaintMachine.Apply")
            net.WriteEntity(machine)
            net.WriteColor(mixer:GetColor())
            net.WriteUInt(selectedInvID, 16)
            net.WriteString(selectedSlot)
        net.SendToServer()
    end

    local cancelBtn = vgui.Create("DButton", frame)
    cancelBtn:SetPos(285, 455)
    cancelBtn:SetSize(265, 28)
    cancelBtn:SetText("Cancel")
    cancelBtn.DoClick = function() frame:Close() end
end)

local clientDyeData = {}

net.Receive("dye.SyncItemDyes", function()
    clientDyeData = net.ReadTable() or {}
end)

local dyeGetterMap = {
    ["Torso"]     = "GetTorsoColor",
    ["Pants"]     = "GetPantsColor",
    ["Shirt"]     = "GetShirtColor",
    ["Head Gear"] = "GetHeadGearColor",
}

net.Receive("dye.Shop.Open", function()
    local machine   = net.ReadEntity()
    local isDonator = net.ReadBool()
    local money     = net.ReadInt(32)
    local count     = net.ReadUInt(8)
    local items     = {}

    for i = 1, count do
        local entry = {
            invid    = net.ReadUInt(16),
            class    = net.ReadString(),
            equipped = net.ReadBool(),
            slots    = {}
        }
        local slotCount = net.ReadUInt(4)
        for j = 1, slotCount do
            local slotName = net.ReadString()
            local hasDye   = net.ReadBool()
            table.insert(entry.slots, { name = slotName, hasDye = hasDye })
        end
        table.insert(items, entry)
    end

    if #items == 0 then
        Derma_Message("You have no dyeable clothing items on you.", "Dye Shop", "OK")
        return
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(580, 520)
    frame:SetTitle(isDonator and "Dye Shop [Donator — Free]" or "Dye Shop [75c per dye]")
    frame:Center()
    frame:MakePopup()

    local itemLabel = vgui.Create("DLabel", frame)
    itemLabel:SetPos(10, 28)
    itemLabel:SetSize(270, 18)
    itemLabel:SetText("1. Choose a clothing slot:")
    itemLabel:SetFont("DermaDefaultBold")

    local itemScroll = vgui.Create("DScrollPanel", frame)
    itemScroll:SetPos(10, 48)
    itemScroll:SetSize(270, 200)

    local selectedInvID = nil
    local selectedSlot  = nil
    local allItemBtns   = {}

    for _, entry in ipairs(items) do
        local itemDef  = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(entry.class)]
        local itemName = itemDef and itemDef.Name or entry.class

        for _, slot in ipairs(entry.slots) do
            local label = itemName .. " — " .. slot.name
            if entry.equipped then label = label .. " [Equipped]" end
            if slot.hasDye    then label = label .. " [Dyed]"     end

            local btn = vgui.Create("DButton", itemScroll)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, 3)
            btn:SetTall(36)
            btn:SetText("")
            btn.label    = label
            btn.selected = false
            table.insert(allItemBtns, btn)

            local invid    = entry.invid
            local slotName = slot.name

            btn.Paint = function(self, w, h)
                local bg = self.selected and Color(80, 160, 80) or Color(50, 50, 50)
                draw.RoundedBox(4, 0, 0, w, h, bg)
                draw.SimpleText(self.label, "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            btn.DoClick = function()
                selectedInvID = invid
                selectedSlot  = slotName
                for _, b in ipairs(allItemBtns) do b.selected = false end
                btn.selected = true
            end
        end
    end

    local colorLabel = vgui.Create("DLabel", frame)
    colorLabel:SetPos(10, 258)
    colorLabel:SetSize(270, 18)
    colorLabel:SetText("2. Choose a color:")
    colorLabel:SetFont("DermaDefaultBold")

    local colorScroll = vgui.Create("DScrollPanel", frame)
    colorScroll:SetPos(10, 278)
    colorScroll:SetSize(270, 190)

    local selectedColor = nil
    local colorBtns     = {}

    for colorName, color in SortedPairs(DYE_COLORS) do
        local btn = vgui.Create("DButton", colorScroll)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, 3)
        btn:SetTall(36)
        btn:SetText("")
        btn.colorName = colorName
        btn.col       = color
        btn.selected  = false
        colorBtns[colorName] = btn

        btn.Paint = function(self, w, h)
            local outline = self.selected and Color(255, 255, 255) or Color(40, 40, 40)
            draw.RoundedBox(4, 0, 0, w, h, outline)
            draw.RoundedBox(3, 2, 2, w-4, h-4, self.col)
            local brightness = (self.col.r * 0.299 + self.col.g * 0.587 + self.col.b * 0.114) / 255
            local textCol = brightness > 0.5 and Color(0,0,0) or Color(255,255,255)
            draw.SimpleText(self.colorName, "DermaDefault", w/2, h/2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn.DoClick = function()
            selectedColor = colorName
            for _, b in pairs(colorBtns) do b.selected = false end
            btn.selected = true
        end
    end

    local infoLabel = vgui.Create("DLabel", frame)
    infoLabel:SetPos(295, 28)
    infoLabel:SetSize(275, 18)
    infoLabel:SetFont("DermaDefaultBold")

    if isDonator then
        infoLabel:SetText("Status: Donator (Free)")
        infoLabel:SetColor(Color(100, 220, 100))
    else
        infoLabel:SetText("Cost per dye: 75c  |  Wallet: " .. money .. "c")
        infoLabel:SetColor(Color(220, 220, 100))
    end

    local swatchLabel = vgui.Create("DLabel", frame)
    swatchLabel:SetPos(295, 55)
    swatchLabel:SetSize(275, 18)
    swatchLabel:SetText("Selected color:")
    swatchLabel:SetFont("DermaDefaultBold")

    local swatch = vgui.Create("DPanel", frame)
    swatch:SetPos(295, 75)
    swatch:SetSize(275, 36)
    swatch.Paint = function(self, w, h)
        local col = selectedColor and DYE_COLORS[selectedColor] or Color(50, 50, 50)
        draw.RoundedBox(4, 0, 0, w, h, col)
        if not selectedColor then
            draw.SimpleText("No color selected", "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local applyBtn = vgui.Create("DButton", frame)
    applyBtn:SetPos(295, 460)
    applyBtn:SetSize(275, 36)
    applyBtn:SetText(isDonator and "Apply (Free)" or "Apply (75c)")

    applyBtn.DoClick = function()
        if not selectedColor then
            Derma_Message("Please select a color.", "Dye Shop", "OK")
            return
        end
        if not selectedInvID or not selectedSlot then
            Derma_Message("Please select a clothing slot.", "Dye Shop", "OK")
            return
        end

        net.Start("dye.Shop.Apply")
            net.WriteEntity(machine)
            net.WriteString(selectedColor)
            net.WriteUInt(selectedInvID, 16)
            net.WriteString(selectedSlot)
        net.SendToServer()
    end

    local cancelBtn = vgui.Create("DButton", frame)
    cancelBtn:SetPos(295, 420)
    cancelBtn:SetSize(275, 36)
    cancelBtn:SetText("Close")
    cancelBtn.DoClick = function() frame:Close() end
end)

hook.Add("InventoryItemLayoutEntity", "DyeSystem_ItemIcon", function(ent, itemclass, invid, modelPanel, storetype)
    if not itemclass.DyeSlots or not invid or not IsValid(modelPanel) then return end
    local storetype = storetype or 1
    local key = storetype .. "_" .. tostring(invid)
    local dyeData = clientDyeData[key]

    if not dyeData then
        modelPanel:SetColor(color_white)
        return
    end

    for _, slotName in ipairs(itemclass.DyeSlots) do
        local slotDye = dyeData[slotName]
        if slotDye then
            modelPanel:SetColor(Color(slotDye.r, slotDye.g, slotDye.b, 255))
            return
        end
    end
end)