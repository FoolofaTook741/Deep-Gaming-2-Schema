if CLIENT then
    local PANEL = {}

    local grey = Color(209, 209, 209)
    local bodyCol = Color(50, 50, 50, 210)
    local red = Color(255, 0, 0)
    local green = Color(0, 255, 0)
    local restrictedCol = Color(255, 223, 0, 255)

    function PANEL:Init()
        self:SetSize(720, 520)
        self:Center()
        self:MakePopup()

        self.canRemoveInv = false
        self.canRemoveStore = false
        self.selected = { [1] = {}, [2] = {} }

        self.scrollInv = vgui.Create("DScrollPanel", self)
        self.scrollInv:SetPos(8, 55)
        self.scrollInv:SetSize(352, 420)

        self.scrollStore = vgui.Create("DScrollPanel", self)
        self.scrollStore:SetPos(360, 55)
        self.scrollStore:SetSize(352, 420)

        self.btnRemove = vgui.Create("DButton", self)
        self.btnRemove:SetPos(8, 482)
        self.btnRemove:SetSize(704, 30)
        self.btnRemove:SetText("Remove selected")
        self.btnRemove.DoClick = function()
            self:DoRemoveSelected()
        end
    end

    function PANEL:PaintOver(w, h)
        draw.SimpleText("Inventory", "Impulse-Elements23-Shadow", 8, 30, grey, TEXT_ALIGN_LEFT)
        draw.SimpleText("Storage", "Impulse-Elements23-Shadow", w - 8, 30, grey, TEXT_ALIGN_RIGHT)
    end

    function PANEL:SetTarget(ply)
        self.targ = ply
        self:SetTitle(IsValid(ply) and (ply:Nick() .. "'s Storage") or "Storage")
    end

    function PANEL:SetPerms(canInv, canStore)
        self.canRemoveInv   = canInv and true or false
        self.canRemoveStore = canStore and true or false

        local allow = self.canRemoveInv or self.canRemoveStore
        self.btnRemove:SetVisible(allow)
        self.btnRemove:SetEnabled(allow)
    end

    local function AddItemRow(panel, parent, storetype, row)
        local itemNetID = row[1]
        local restricted = row[2]
        local equipped = row[3]
        local keyStr = row[4]
        local dispID = row[5] or keyStr

        if not itemNetID or not keyStr or keyStr == "" then return end

        local itemDef = impulse.Inventory.Items[itemNetID]
        if not itemDef then return end

        local bg = parent:Add("DPanel")
        bg:SetTall(42)
        bg:Dock(TOP)
        bg:DockMargin(5, 3, 5, 3)

        bg.ItemName = itemDef.Name or "Unknown"
        bg.ItemClass = itemDef.UniqueID or "unknown"
        bg.ItemIllegal = itemDef.Illegal or false
        bg.ItemRestrict = restricted or false
        bg.ItemEquipped = equipped or false
        bg.ItemKey = keyStr
        bg.ItemID = dispID

        function bg:Paint(w, h)
            surface.SetDrawColor(bodyCol)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(self.ItemName, "Impulse-Elements18-Shadow", 10, 4, color_white)
            draw.SimpleText(self.ItemClass .. "  #" .. self.ItemID, "Impulse-Elements16-Shadow", 10, 22, color_white)

            if self.ItemEquipped then
                draw.SimpleText("equipped", "Impulse-Elements16-Shadow", w - 145, 6, green)
            end

            if self.ItemRestrict then
                draw.SimpleText("restricted", "Impulse-Elements16-Shadow", w - 145, 22, restrictedCol)
            elseif self.ItemIllegal then
                draw.SimpleText("illegal", "Impulse-Elements16-Shadow", w - 145, 22, red)
            end
        end

        local allowRemove =
            (storetype == 1 and panel.canRemoveInv) or
            (storetype == 2 and panel.canRemoveStore)

        if not allowRemove then return end

        local cb = vgui.Create("DCheckBox", bg)
        cb:SetValue(panel.selected[storetype][keyStr] and 1 or 0)

        cb.Think = function()
            if IsValid(bg) then
                cb:SetPos(bg:GetWide() - 22, 12)
            end
        end

        cb.OnChange = function(_, val)
            panel.selected[storetype][keyStr] = val and true or nil
        end

        local lbl = vgui.Create("DLabel", bg)
        lbl:SetText("Remove")
        lbl:SizeToContents()

        lbl.Think = function()
            if IsValid(bg) then
                lbl:SetPos(bg:GetWide() - 80, 12)
            end
        end
    end

    function PANEL:SetLists(invList, storeList)
        self.scrollInv:Clear()
        self.scrollStore:Clear()
        self.selected = { [1] = {}, [2] = {} }

        table.sort(invList or {}, function(a, b)
            local ia = impulse.Inventory.Items[a[1]]
            local ib = impulse.Inventory.Items[b[1]]
            return ((ia and ia.Name) or "") < ((ib and ib.Name) or "")
        end)

        table.sort(storeList or {}, function(a, b)
            local ia = impulse.Inventory.Items[a[1]]
            local ib = impulse.Inventory.Items[b[1]]
            return ((ia and ia.Name) or "") < ((ib and ib.Name) or "")
        end)

        for _, row in ipairs(invList or {}) do
            AddItemRow(self, self.scrollInv, 1, row)
        end

        for _, row in ipairs(storeList or {}) do
            AddItemRow(self, self.scrollStore, 2, row)
        end
    end

    function PANEL:DoRemoveSelected()
        if not IsValid(self.targ) then
            LocalPlayer():Notify("Player left the server.")
            return self:Close()
        end

        local payload = {}

        if self.canRemoveInv then
            for keyStr in pairs(self.selected[1]) do
                payload[#payload + 1] = { 1, keyStr }
            end
        end

        if self.canRemoveStore then
            for keyStr in pairs(self.selected[2]) do
                payload[#payload + 1] = { 2, keyStr }
            end
        end

        if #payload == 0 then
            return self:Close()
        end

        net.Start("dgOpsRemoveStorageItems")
            net.WriteUInt(self.targ:EntIndex(), 8)
            net.WriteUInt(#payload, 16)

            for _, it in ipairs(payload) do
                net.WriteUInt(it[1], 2)
                net.WriteString(it[2])
            end
        net.SendToServer()

        self:Close()
    end

    vgui.Register("dgOpsStorageAdmin", PANEL, "DFrame")

    net.Receive("dgOpsViewStorage", function()
        local targ = net.ReadEntity()
        local canInv = net.ReadBool()
        local canStore = net.ReadBool()
        local invList = net.ReadTable()
        local storeList = net.ReadTable()

        local pnl = vgui.Create("dgOpsStorageAdmin")
        pnl:SetTarget(targ)
        pnl:SetPerms(canInv, canStore)
        pnl:SetLists(invList, storeList)
    end)
end
