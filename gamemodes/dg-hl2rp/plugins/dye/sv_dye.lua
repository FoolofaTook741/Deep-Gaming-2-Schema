DYE_SLOTS = {
    ["Torso"]     = { set = "SetTorsoColor",    get = "GetTorsoColor",    save = "torsoColor",    netMsg = "ixSetTorsoColor"    },
    ["Pants"]     = { set = "SetPantsColor",     get = "GetPantsColor",    save = "pantsColor",    netMsg = "ixSetPantsColor"    },
    ["Shirt"]     = { set = "SetShirtColor",     get = "GetShirtColor",    save = "shirtColor",    netMsg = "ixSetShirtColor"    },
    ["Head Gear"] = { set = "SetHeadGearColor",  get = "GetHeadGearColor", save = "headGearColor", netMsg = "ixSetHeadGearColor" },
}

local DYE_SHOP_COST = 75

util.AddNetworkString("ixSetTorsoColor")
util.AddNetworkString("ixSetPantsColor")
util.AddNetworkString("ixSetShirtColor")
util.AddNetworkString("ixSetHeadGearColor")
util.AddNetworkString("dye.SyncItemDyes")
util.AddNetworkString("dye.OpenItemPicker")
util.AddNetworkString("dye.ApplyToItem")
util.AddNetworkString("dye.PaintMachine.Open")
util.AddNetworkString("dye.PaintMachine.Apply")
util.AddNetworkString("dye.Shop.Open")
util.AddNetworkString("dye.Shop.Apply")

local function BroadcastColor(ply, slotData, color)
    net.Start(slotData.netMsg)
        net.WriteEntity(ply)
        net.WriteColor(color, true)
    net.Broadcast()
end

local function ApplyColor(ply, slotData, color)
    ply[slotData.set](ply, color)
    BroadcastColor(ply, slotData, color)
end

local WHITE = Color(255, 255, 255, 255)

function SyncDyeDataToClient(client)
    local dyeItems = {}

    local inv = impulse.Inventory.Data[client.impulseID]
    if inv then
        for storetype = 1, 2 do
            if inv[storetype] then
                for invid, item in pairs(inv[storetype]) do
                    if item.dyeData then
                        dyeItems[storetype .. "_" .. tostring(invid)] = item.dyeData
                    end
                end
            end
        end
    end

    local ok, gid = pcall(function() return client:GetGroupID() end)
    if ok and gid and impulse.Inventory.Group and impulse.Inventory.Group.Data and impulse.Inventory.Group.Data[gid] then
        local groupInv = impulse.Inventory.Group.Data[gid][3]
        if groupInv then
            for invid, item in pairs(groupInv) do
                if item.dyeData then
                    dyeItems["3_" .. tostring(invid)] = item.dyeData
                end
            end
        end
    end

    net.Start("dye.SyncItemDyes")
        net.WriteTable(dyeItems)
    net.Send(client)
end

local function GetDyeableItems(ply)
    local result = {}
    local inv = impulse.Inventory.Data[ply.impulseID]
    if not inv or not inv[1] then return result end

    for invid, item in pairs(inv[1]) do
        local itemclass = impulse.Inventory.Items[item.id]
        if itemclass and itemclass.DyeSlots then
            table.insert(result, {
                invid    = invid,
                class    = item.class,
                equipped = item.equipped,
                dyeSlots = itemclass.DyeSlots,
                dyeData  = item.dyeData or {}
            })
        end
    end
    return result
end

net.Receive("dye.ApplyToItem", function(len, client)
    local colorName = net.ReadString()
    local invid     = net.ReadUInt(16)
    local slotName  = net.ReadString()

    if not DYE_COLORS[colorName] then return end
    if not DYE_SLOTS[slotName] then return end

    local itemClass = "item_dye_" .. string.lower(colorName)
    if not client:HasInventoryItem(itemClass) then
        client:Notify("You no longer have that dye.")
        return
    end

    local inv = impulse.Inventory.Data[client.impulseID]
    if not inv or not inv[1] or not inv[1][invid] then return end

    local item = inv[1][invid]
    local itemclass = impulse.Inventory.Items[item.id]

    if not itemclass or not itemclass.DyeSlots then
        client:Notify("That item cannot be dyed.")
        return
    end

    if not table.HasValue(itemclass.DyeSlots, slotName) then
        client:Notify("That slot cannot be dyed on this item.")
        return
    end

    local color = DYE_COLORS[colorName]
    item.dyeData = item.dyeData or {}
    item.dyeData[slotName] = { r = color.r, g = color.g, b = color.b, a = 255 }

    client:SetInventoryItemDyeData(invid, item.dyeData, 1)

    if item.equipped then
        ApplyColor(client, DYE_SLOTS[slotName], color)
    end

    client:TakeInventoryItemClass(itemClass)
    client:Notify("You dye the " .. slotName:lower() .. " of your " .. itemclass.Name .. " " .. string.lower(colorName) .. ".")
    SyncDyeDataToClient(client)
end)

net.Receive("dye.PaintMachine.Apply", function(len, client)
    local machineEnt = net.ReadEntity()
    local color      = net.ReadColor()
    local invid      = net.ReadUInt(16)
    local slotName   = net.ReadString()

    if not IsValid(machineEnt) then return end
    if client:GetPos():Distance(machineEnt:GetPos()) > 150 then
        client:Notify("You are too far from the paint machine.")
        return
    end

    if not (client:IsCollaborator() or client:Team() == TEAM_CA) then
        client:Notify("This machine is for Collaborators only.")
        return
    end

    if not DYE_SLOTS[slotName] then return end

    local inv = impulse.Inventory.Data[client.impulseID]
    if not inv or not inv[1] or not inv[1][invid] then return end

    local item = inv[1][invid]
    local itemclass = impulse.Inventory.Items[item.id]

    if not itemclass or not itemclass.DyeSlots then
        client:Notify("That item cannot be dyed.")
        return
    end

    if not table.HasValue(itemclass.DyeSlots, slotName) then
        client:Notify("That slot cannot be dyed on this item.")
        return
    end

    color.r = math.Clamp(color.r, 0, 255)
    color.g = math.Clamp(color.g, 0, 255)
    color.b = math.Clamp(color.b, 0, 255)
    color.a = 255

    item.dyeData = item.dyeData or {}
    item.dyeData[slotName] = { r = color.r, g = color.g, b = color.b, a = 255 }

    client:SetInventoryItemDyeData(invid, item.dyeData, 1)

    if item.equipped then
        ApplyColor(client, DYE_SLOTS[slotName], color)
    end

    client:Notify("The machine dyes the " .. slotName:lower() .. " of your " .. itemclass.Name .. ".")
    SyncDyeDataToClient(client)
end)

function DyeOpenItemPicker(client, colorName)
    local items = GetDyeableItems(client)

    net.Start("dye.OpenItemPicker")
        net.WriteString(colorName)
        net.WriteUInt(#items, 8)
        for _, entry in ipairs(items) do
            net.WriteUInt(entry.invid, 16)
            net.WriteString(entry.class)
            net.WriteBool(entry.equipped)
            net.WriteUInt(#entry.dyeSlots, 4)
            for _, slotName in ipairs(entry.dyeSlots) do
                net.WriteString(slotName)
                local slotDye = entry.dyeData[slotName]
                net.WriteBool(slotDye ~= nil)
            end
        end
    net.Send(client)
end

function DyePaintMachineOpen(client, machine)
    local items = GetDyeableItems(client)

    net.Start("dye.PaintMachine.Open")
        net.WriteEntity(machine)
        net.WriteUInt(#items, 8)
        for _, entry in ipairs(items) do
            net.WriteUInt(entry.invid, 16)
            net.WriteString(entry.class)
            net.WriteBool(entry.equipped)
            net.WriteUInt(#entry.dyeSlots, 4)
            for _, slotName in ipairs(entry.dyeSlots) do
                net.WriteString(slotName)
                local slotDye = entry.dyeData[slotName]
                net.WriteBool(slotDye ~= nil)
            end
        end
    net.Send(client)
end

function DyeShopOpen(client, machine)
    local items = GetDyeableItems(client)

    if #items == 0 then
        client:Notify("You have no dyeable clothing items on you.")
        return
    end

    net.Start("dye.Shop.Open")
        net.WriteEntity(machine)
        net.WriteBool(client:IsDonator())
        net.WriteInt(client:GetMoney(), 32)
        net.WriteUInt(#items, 8)
        for _, entry in ipairs(items) do
            net.WriteUInt(entry.invid, 16)
            net.WriteString(entry.class)
            net.WriteBool(entry.equipped)
            net.WriteUInt(#entry.dyeSlots, 4)
            for _, slotName in ipairs(entry.dyeSlots) do
                net.WriteString(slotName)
                local slotDye = entry.dyeData[slotName]
                net.WriteBool(slotDye ~= nil)
            end
        end
    net.Send(client)
end

net.Receive("dye.Shop.Apply", function(len, client)
    local machineEnt = net.ReadEntity()
    local colorName  = net.ReadString()
    local invid      = net.ReadUInt(16)
    local slotName   = net.ReadString()

    if not IsValid(machineEnt) then return end
    if client:GetPos():Distance(machineEnt:GetPos()) > 150 then
        client:Notify("You are too far from the machine.")
        return
    end

    if not DYE_COLORS[colorName] then return end
    if not DYE_SLOTS[slotName] then return end

    local inv = impulse.Inventory.Data[client.impulseID]
    if not inv or not inv[1] or not inv[1][invid] then return end

    local item = inv[1][invid]
    local itemclass = impulse.Inventory.Items[item.id]

    if not itemclass or not itemclass.DyeSlots then
        client:Notify("That item cannot be dyed.")
        return
    end

    if not table.HasValue(itemclass.DyeSlots, slotName) then
        client:Notify("That slot cannot be dyed on this item.")
        return
    end

    if not client:IsDonator() and not client:IsCollaborator() and not client:Team() == TEAM_CA then
        if not client:CanAfford(DYE_SHOP_COST) then
            client:Notify("You cannot afford this dye.")
            return
        end
        client:TakeMoney(DYE_SHOP_COST)
    end

    local color = DYE_COLORS[colorName]
    item.dyeData = item.dyeData or {}
    item.dyeData[slotName] = { r = color.r, g = color.g, b = color.b, a = 255 }

    client:SetInventoryItemDyeData(invid, item.dyeData, 1)

    if item.equipped then
        ApplyColor(client, DYE_SLOTS[slotName], color)
    end

    client:Notify("Your " .. itemclass.Name .. " has been dyed " .. string.lower(colorName) .. ".")
    SyncDyeDataToClient(client)
end)

hook.Add("PostInventorySetup", "DyeSystem_SyncDyes", function(ply)
    timer.Simple(0.2, function()
        if IsValid(ply) then SyncDyeDataToClient(ply) end
    end)
end)

hook.Add("OnInventoryItemEquipped", "DyeSystem_ApplyColor", function(ply, item, itemclass, itemid)
    if not itemclass.DyeSlots then return end
    for _, slotName in ipairs(itemclass.DyeSlots) do
        local slotData = DYE_SLOTS[slotName]
        if not slotData then continue end
        if item.dyeData and item.dyeData[slotName] then
            local d = item.dyeData[slotName]
            ApplyColor(ply, slotData, Color(d.r or 255, d.g or 255, d.b or 255, 255))
        else
            ApplyColor(ply, slotData, WHITE)
        end
    end
end)

hook.Add("OnInventoryItemUnequipped", "DyeSystem_ResetColor", function(ply, item, itemclass, itemid)
    if not itemclass.DyeSlots then return end
    for _, slotName in ipairs(itemclass.DyeSlots) do
        local slotData = DYE_SLOTS[slotName]
        if not slotData then continue end
        ApplyColor(ply, slotData, WHITE)
    end
end)

hook.Add("PlayerSpawn", "DyeSystem_RestoreEquippedColors", function(ply)
    timer.Simple(0.6, function()
        if not IsValid(ply) or not ply.impulseID then return end
        local inv = impulse.Inventory.Data[ply.impulseID]
        if not inv or not inv[1] then return end

        for invid, item in pairs(inv[1]) do
            if not item.equipped then continue end
            local itemclass = impulse.Inventory.Items[item.id]
            if not itemclass or not itemclass.DyeSlots then continue end
            for _, slotName in ipairs(itemclass.DyeSlots) do
                local slotData = DYE_SLOTS[slotName]
                if not slotData then continue end
                if item.dyeData and item.dyeData[slotName] then
                    local d = item.dyeData[slotName]
                    ApplyColor(ply, slotData, Color(d.r or 255, d.g or 255, d.b or 255, 255))
                end
            end
        end
    end)
end)

hook.Add("OnInventoryItemMoved", "DyeSystem_ResyncOnMove", function(ply, invid, storetype)
    SyncDyeDataToClient(ply)
end)

hook.Add("PostInventorySetup", "DyeSystem_SyncOtherPlayerColors", function(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        for _, other in ipairs(player.GetAll()) do
            if other == ply then continue end
            if not other.impulseID then continue end

            local inv = impulse.Inventory.Data[other.impulseID]
            if not inv or not inv[1] then continue end

            for invid, item in pairs(inv[1]) do
                if not item.equipped then continue end
                local itemclass = impulse.Inventory.Items[item.id]
                if not itemclass or not itemclass.DyeSlots then continue end

                for _, slotName in ipairs(itemclass.DyeSlots) do
                    local slotData = DYE_SLOTS[slotName]
                    if not slotData then continue end

                    if item.dyeData and item.dyeData[slotName] then
                        local d = item.dyeData[slotName]
                        net.Start(slotData.netMsg)
                            net.WriteEntity(other)
                            net.WriteColor(Color(d.r or 255, d.g or 255, d.b or 255, 255), true)
                        net.Send(ply)
                    end
                end
            end
        end
    end)
end)

hook.Add("OnInventoryItemRemoved", "DyeSystem_ResyncOnRemove", function(ply, storetype, class, id, equipped, restricted, invid)
    local itemclass = impulse.Inventory.Items[id]
    if not itemclass or not itemclass.DyeSlots then return end
    SyncDyeDataToClient(ply)
end)