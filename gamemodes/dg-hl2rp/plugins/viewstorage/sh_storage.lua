if SERVER then
    util.AddNetworkString("dgOpsViewStorage")
    util.AddNetworkString("dgOpsRemoveStorageItems")
end

local function BuildContainerListFromPlayer(targ, storetype)
    local out = {}

    local impulseID = targ.impulseID
    if not impulseID then return out end

    local container = (impulse.Inventory.Data[impulseID] or {})[storetype] or {}
    local display = 0

    for invid, entry in pairs(container) do
        display = display + 1

        local itemNetID =
            (entry.class and impulse.Inventory.ClassToNetID(entry.class)) or
            tonumber(entry.id) or 0

        if itemNetID <= 0 then continue end

        out[#out + 1] = {
            itemNetID,
            entry.restricted or false,
            entry.equipped or false,
            tostring(invid),
            display
        }
    end

    return out
end

impulse.RegisterChatCommand("/viewstorage", {
    description = "View a player's inventory + storage (admin)",
    adminOnly = true,
    requiresArg = true,

    onRun = function(ply, args)
        if CLIENT then return end
        if not IsValid(ply) or not ply:IsAdmin() then return end

        local targ = impulse.FindPlayer(args[1])
        if not IsValid(targ) then
            return ply:Notify("Player not found (must be online).")
        end

        local invList   = BuildContainerListFromPlayer(targ, 1)
        local storeList = BuildContainerListFromPlayer(targ, 2)

        net.Start("dgOpsViewStorage")
		net.WriteEntity(targ)
		net.WriteBool(ply:IsAdmin())
		net.WriteBool(ply:IsLeadAdmin())
		net.WriteTable(invList)
		net.WriteTable(storeList)
        net.Send(ply)
    end
})

if SERVER then
    net.Receive("dgOpsRemoveStorageItems", function(_, ply)
        if not IsValid(ply) or not ply:IsAdmin() then return end

        local targIdx = net.ReadUInt(8)
        local count   = net.ReadUInt(16)

        local targ = Entity(targIdx)
        if not IsValid(targ) or not targ:IsPlayer() then return end
        if count <= 0 or count > 2000 then return end
        if not targ.beenInvSetup then return end

        local impulseID = targ.impulseID
        if not impulseID then return end

        local removedInv, removedStore = 0, 0
        local removedLines = {}

        for i = 1, count do
            local storetype = net.ReadUInt(2)
            local keyStr    = net.ReadString()

            if (storetype ~= 1 and storetype ~= 2) or keyStr == "" then continue end
            if storetype == 2 and not ply:IsLeadAdmin() then continue end

            local inv = (impulse.Inventory.Data[impulseID] or {})[storetype]
            if not inv then continue end

            local key
            if inv[keyStr] ~= nil then
                key = keyStr
            else
                local n = tonumber(keyStr)
                if n and inv[n] ~= nil then key = n end
            end

            if key == nil then continue end

            local entry = inv[key]
            if not entry then continue end

            local uniqueID = entry.class or entry.uniqueid or entry.UniqueID
            local netid = uniqueID and impulse.Inventory.ClassToNetID(uniqueID)
            local itemDef = netid and impulse.Inventory.Items[netid]
            local itemName = (itemDef and itemDef.Name) or (uniqueID or "Unknown Item")
            local where = (storetype == 1) and "Inv" or "Storage"

            targ:TakeInventoryItem(key, storetype, false)

            if inv[key] == nil then
                if storetype == 1 then
                    removedInv = removedInv + 1
                else
                    removedStore = removedStore + 1
                end

                removedLines[#removedLines + 1] =
                    string.format("[%s] %s (%s)", where, itemName, uniqueID or "?")
            end
        end

        ply:Notify(("Removed %d inv item(s) and %d storage item(s) from %s."):format(removedInv, removedStore, targ:Nick()))

        if #removedLines > 0 then
            ply:ChatPrint("[ViewStorage] Removed from " .. targ:Nick() .. ":")
            for _, line in ipairs(removedLines) do
                ply:ChatPrint(" - " .. line)
            end

            print(("[ViewStorage] %s removed items from %s (%s):"):format(ply:Nick(), targ:Nick(), targ:SteamID()))
            for _, line in ipairs(removedLines) do
                print("  - " .. line)
            end
        else
            ply:ChatPrint("[ViewStorage] No items were removed.")
        end

        if IsValid(targ) and #removedLines > 0 then
            targ:ChatPrint("[ViewStorage] " .. ply:SteamName() .. " removed the following items:\n")

            for _, line in ipairs(removedLines) do
                targ:ChatPrint(" - " .. line .. "\n")
            end

            targ:Notify(("%s removed %d item(s) from your inventory or storage. See your console for details."):format(ply:SteamName(), #removedLines))
        end
    end)
end
