if CLIENT then
    net.Receive("impulseOpsItemSpawner", function()
        local panel = vgui.Create("DFrame")
        panel:SetSize(600, 800)
        panel:Center()
        panel:SetTitle("Item Spawner")
        panel:MakePopup()

        local lbl = vgui.Create("DLabel", panel)
        lbl:SetPos(5, 32)
        lbl:SetText("Target: ")
        lbl:SizeToContents()

        local targetBox = vgui.Create("DComboBox", panel)
        targetBox:SetPos(50, 30)
        targetBox:SetWide(400)

        targetBox:AddChoice("Me")
        targetBox:AddChoice("Custom SteamID (Offline User)")

        for v,k in pairs(player.GetAll()) do
            targetBox:AddChoice("PLAYER: "..k:Nick().." ("..k:SteamName()..")", k:SteamID())
        end

        targetBox:SetSortItems(false)

        function targetBox:OnSelect(index, text, sid)
            if text == "Me" then
                panel.Selected = LocalPlayer():SteamID()
            elseif text == "Custom SteamID (Offline User)" then
                Derma_StringRequest("impulse", "Enter the SteamID (not 64 format) below:", "", function(sid)
                    if IsValid(panel) then
                        sid = string.Trim(sid, " ")
                        panel.Selected = sid
                        self:SetText("Custom SteamID ("..sid..")")
                    end
                end)
            else
                panel.Selected = sid
            end
        end

        local restrictedBox = vgui.Create("DCheckBoxLabel", panel)
        restrictedBox:SetText("Restricted (can't drop)")
        restrictedBox:SetPos( 460, 35 )

        local scroll = vgui.Create("DScrollPanel", panel)
        scroll:SetPos(5, 90)
        scroll:SetSize(595, 710)

        -- Search bar
        local search = vgui.Create("DTextEntry", panel)
        search:SetPos(5, 60)
        search:SetSize(595, 24)
        search:SetUpdateOnType(true)
        search:SetPlaceholderText("Search items (name / uniqueID / category)...")

        local cats = {}
        local catPanels = {}
        local allButtons = {}

        -- Filter function
        local function ApplyFilter()
            local q = string.lower(string.Trim(search:GetValue() or ""))

            for _, entry in ipairs(allButtons) do
                local item = entry.item
                local hay = string.lower((item.Name or "") .. " " .. (item.UniqueID or "") .. " " .. (item.Category or "Unknown"))
                local show = (q == "") or (string.find(hay, q, 1, true) ~= nil)

                entry.btn:SetVisible(show)
                entry.btn:InvalidateLayout(true)
            end

            -- hide empty categories
            for catName, list in pairs(cats) do
                local anyVisible = false
                for _, pnl in ipairs(list:GetItems() or {}) do
                    if IsValid(pnl) and pnl:IsVisible() then
                        anyVisible = true
                        break
                    end
                end

                if IsValid(catPanels[catName]) then
                    catPanels[catName]:SetVisible(anyVisible)
                    catPanels[catName]:InvalidateLayout(true)
                end
            end

            scroll:InvalidateLayout(true)
        end

        search.OnValueChange = ApplyFilter

        for _, k in pairs(impulse.Inventory.Items) do
            local catName = k.Category or "Unknown"
            if not cats[catName] then
                local cat = scroll:Add("DCollapsibleCategory")
                cat:Dock(TOP)
                cat:SetLabel(catName)
                cat:SetExpanded(false)

                catPanels[catName] = cat

                local list = vgui.Create("DPanelList", panel)
                list:Dock(FILL)
                list:SetSpacing(5)
                cat:SetContents(list)
                cats[catName] = list
            end

            local btn = vgui.Create("DButton")
            btn:SetText("Give "..k.Name.." ("..k.UniqueID..")")
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, 5)
            btn.ItemClass = k.UniqueID

            function btn:DoClick()
                if not panel.Selected then
                    return LocalPlayer():Notify("No target selected.")
                end

                local restricted = tostring( restrictedBox:GetChecked() or false )

                LocalPlayer():ConCommand("say /giveitem "..panel.Selected.." "..self.ItemClass.." "..restricted)
            end

            cats[k.Category or "Unknown"]:AddItem(btn)
            table.insert(allButtons, { btn = btn, item = k, cat = catName })
        end

        ApplyFilter()
    end)
else
    util.AddNetworkString("impulseOpsItemSpawner")
end


local giveItemCommand = {
    description = "Gives a player the specified item. Use /itemspawner instead.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then
            return
        end

        local steamid = arg[1]
        local item = arg[2]
        local restricted = tobool(arg[3] or "false")

        if not item then
            return ply:Notify("No item uniqueID supplied.")
        end

        if steamid:len() > 25 then
            return ply:Notify("SteamID too long.")
        end

        local query = mysql:Select("impulse_players")
        query:Select("id")
        query:Where("steamid", steamid)
        query:Callback(function(result)
            if not IsValid(ply) then
                return
            end

            if not type(result) == "table" or #result == 0 then
                return ply:Notify("This Steam account has not joined the server yet or the SteamID is invalid.")
            end

            if not impulse.Inventory.ItemsRef[item] then
                return ply:Notify("Item: "..item.." does not exist.")
            end

            local target = player.GetBySteamID(steamid)
            local nameValue = "Offline Player ("..steamid..")"
            if target and IsValid(target) then
                target:GiveInventoryItem(item, 1, restricted)
                nameValue = target:SteamName().." ("..steamid..")"
            end
            local embeds = {{
                title = "ITEM Spawned",
                description = "Manager spawned item.",
                url = "https://discord.com/channels/1365688835777757295/1367695815635763200",
                color = 5763719,
                fields = {
                    {
                        name = "Manager:",
                        value = ply:SteamName().." ("..steamid..")"
                    },
                    {
                        name = "Target:",
                        value = nameValue
                    },
                    {
                        name = "Item:",
                        value = item
                    },
                }
            }}
            
            if target and IsValid(target) then
                ReqwestLog(embeds, DG_SENT)
                return ply:Notify("You have given "..target:Nick().." a "..item..".")
            end
            local impulseID = result[1].id
            if restricted then
                return ply:Notify("You cannot give offline players restricted items.")
            end
            ReqwestLog(embeds, DG_SENT)
            impulse.Inventory.DBAddItem(impulseID, item, nil, ply)
            ply:Notify("Offline player ("..steamid..") has been given a "..item..".")
        end)

        query:Execute()
    end
}

impulse.RegisterChatCommand("/giveitem", giveItemCommand)

local itemSpawnerCommand = {
    description = "Opens the item spawner.",
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then
            return
        end

        net.Start("impulseOpsItemSpawner")
        net.Send(ply)
    end
}

impulse.RegisterChatCommand("/itemspawner", itemSpawnerCommand)