if not impulse then impulse = {} end
if not impulse.GroupInventory then impulse.GroupInventory = {} end

function impulse.GroupInventory:ClearInventory(groupid)
    local storetype = 3
    impulse.Inventory.DBClearInventory(groupid, storetype)
    impulse.Inventory.Group.Data[groupid] = {}
	impulse.Inventory.Group.Data[groupid].Register = {}
	impulse.Inventory.Group.Data[groupid].Weight = 0
end

function meta:HasInventoryItemSpecificGroup(id, storetype)
    if not self.beenInvSetup then return false end
    storetype = storetype or 1
    local ownerid = (storetype == 3 and (self:GetGroupID() or self.impulseID)) or self.impulseID
    local has = nil
    if storetype == 3 then
        if impulse.Inventory.Group.Data[ownerid] and impulse.Inventory.Group.Data[ownerid][storetype] then
            has = impulse.Inventory.Group.Data[ownerid][storetype][id]
        end
    else
        if impulse.Inventory.Data[ownerid] and impulse.Inventory.Data[ownerid][storetype] then
            has = impulse.Inventory.Data[ownerid][storetype][id]
        end
    end
    if has then return true, has end
    return false
end

function meta:IsInventoryItemRestrictedGroup(id, storetype)
    if not self.beenInvSetup then return false end
    storetype = storetype or 1
    local ownerid = (storetype == 3 and (self:GetGroupID() or self.impulseID)) or self.impulseID
    local has = nil
    if storetype == 3 then
        if impulse.Inventory.Group.Data[ownerid] and impulse.Inventory.Group.Data[ownerid][storetype] then
            has = impulse.Inventory.Group.Data[ownerid][storetype][id]
        end
    else
        if impulse.Inventory.Data[ownerid] and impulse.Inventory.Data[ownerid][storetype] then
            has = impulse.Inventory.Data[ownerid][storetype][id]
        end
    end
    if has then return has.restricted end
    return false
end

function meta:MaxGroupInventoryWeight()
    local groupName = self:GetSyncVar(SYNC_GROUP_NAME)
    if not groupName then return 0 end

    local group = impulse.Group.Groups[groupName]

    local members = 0
    for _ in pairs(group.Members or {}) do
        members = members + 1
    end
    members = math.min(members, 50)

    local kgPerMember = 5
    local baseMax = members * kgPerMember

    local tier = group.StorageTier or 0
    return baseMax + (tier * 50)
end

function meta:CanHoldItemGroupStorage(itemclass, amount)
    local itemid = impulse.Inventory.ClassToNetID(itemclass)
    local item    = impulse.Inventory.Items[itemid] or {}
    local w       = (tonumber(item.Weight) or 0) * (amount or 1)

    local gid   = self:GetGroupID()
    local data  = impulse.Inventory.Group.Data[gid] or {}
    local curW  = data.Weight or 0
    local maxW  = self:MaxGroupInventoryWeight()
	
    return curW + w <= maxW
end

function meta:GiveInventoryItemGroup(itemclass, storetype, restricted, isLoaded, moving, clip)
     if not self.beenInvSetup and not isLoaded then return end
     storetype = storetype or 1
     restricted = restricted or false
     local itemid = impulse.Inventory.ClassToNetID(itemclass)
     local weight = impulse.Inventory.Items[itemid].Weight or 0
     local ownerid = (storetype == 3 and (self:GetGroupID() or self.impulseID)) or self.impulseID
 
     local targetInventory = (storetype == 3) and impulse.Inventory.Group.Data or impulse.Inventory.Data
     targetInventory[ownerid] = targetInventory[ownerid] or {}
     targetInventory[ownerid][storetype] = targetInventory[ownerid][storetype] or {}
     local inv = targetInventory[ownerid][storetype]
 
     local invid
     for i = 1, table.Count(inv) + 1 do
         if inv[i] == nil then
             invid = i
             inv[i] = {
                 id = itemid,
                 class = itemclass,
                 restricted = restricted,
                 equipped = false,
                 clip = clip or nil
             }
             break
         end
     end
 
     if not restricted and not isLoaded and not moving then
         impulse.Inventory.DBAddItem(ownerid, itemclass, storetype)
     end
 
     if storetype == 1 then
         self.InventoryWeight = self.InventoryWeight + weight
         self.InventoryRegister[itemclass] = (self.InventoryRegister[itemclass] or 0) + 1
     elseif storetype == 3 then
         --self.InventoryWeightGroupStorage  = self.InventoryWeightGroupStorage  + weight
         self.InventoryStorageRegister[itemclass] = (self.InventoryStorageRegister[itemclass] or 0) + 1
     end
 
     if not moving then
         net.Start("impulseInvGive")
         net.WriteUInt(itemid, 16)
         net.WriteUInt(invid, 16)
         net.WriteUInt(storetype, 4)
         net.WriteBool(restricted)
         net.Send(self)
     end
 
     return invid
 end

function meta:TakeInventoryItemGroup(invid, storetype, moving)
    if not self.beenInvSetup then return end
    storetype = storetype or 1
    local amount = 1
    local ownerid = (storetype == 3 and (self:GetGroupID() or self.impulseID)) or self.impulseID

    local targetInventory = (storetype == 3) and impulse.Inventory.Group.Data or impulse.Inventory.Data
    targetInventory[ownerid] = targetInventory[ownerid] or {}
    targetInventory[ownerid][storetype] = targetInventory[ownerid][storetype] or {}
    local item = targetInventory[ownerid][storetype][invid]
    if not item then
        return nil
    end
    local itemid = impulse.Inventory.ClassToNetID(item.class)
    local weight = (impulse.Inventory.Items[itemid].Weight or 0) * amount
    local dbOwner = (storetype == 3 and (self:GetGroupID() or self.impulseID)) or self.impulseID
    if not moving then
        impulse.Inventory.DBRemoveItem(dbOwner, item.class, storetype, 1)
    end
    if storetype == 1 then
        self.InventoryWeight = math.Clamp(self.InventoryWeight - weight, 0, 1000)
		self.InventoryRegister[item.class] = (self.InventoryRegister[item.class] or 1) - 1
		if self.InventoryRegister[item.class] <= 0 then
			self.InventoryRegister[item.class] = nil
		end
    elseif storetype == 3 then

    end
    if item.equipped then
        self:SetInventoryItemEquipped(invid, false)
    end
    local clip = item.clip
    hook.Run("OnInventoryItemRemoved", self, storetype, item.class, item.id, item.equipped, item.restricted, invid)
    targetInventory[ownerid][storetype][invid] = nil
    if not moving then
        net.Start("impulseInvRemove")
        net.WriteUInt(invid, 16)
        net.WriteUInt(storetype, 4)
        net.Send(self)
    end
    return clip
end

function meta:MoveInventoryItemGroup(invid, from, to)
    local groupid = self:GetGroupID()
    if not groupid then
        self:Notify("You’re not in a group.")
        return
    end

	impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
	impulse.Inventory.Group.Data[groupid] = impulse.Inventory.Group.Data[groupid] or {}
	impulse.Inventory.Group.Data[groupid][3] = impulse.Inventory.Group.Data[groupid][3] or {}

    local srcTbl = (from == 3)
       and (impulse.Inventory.Group.Data[groupid][3] or {})
       or (impulse.Inventory.Data[self.impulseID][1] or {})

    local entry = srcTbl[invid]
    if not entry then
        impulse.debugPrint("invalid slot:", invid)
        return
    end

    srcTbl[invid] = nil

    if from == 1 then
        self.InventoryRegister[entry.class] =
          (self.InventoryRegister[entry.class] or 1) - 1

        if self.InventoryRegister[entry.class] <= 0 then
            self.InventoryRegister[entry.class] = nil
        end

        impulse.Inventory.DBRemoveItem(self.impulseID, entry.class, 1, 1)
        impulse.Inventory.GroupDBAddItem(groupid, entry.class, 3)
    else
        impulse.Inventory.GroupDBRemoveItem(groupid, entry.class, 3, 1)
        impulse.Inventory.DBAddItem(self.impulseID, entry.class, 1)
    end

    local dstTbl = (to == 3)
       and impulse.Inventory.Group.Data[groupid][3]
       or impulse.Inventory.Data[self.impulseID][1]

    local newinvid
    for i = 1, (#dstTbl + 1) do
        if dstTbl[i] == nil then
            newinvid = i
            break
        end
    end
    dstTbl[newinvid] = entry

    if to == 1 then
        self.InventoryRegister[entry.class] =
          (self.InventoryRegister[entry.class] or 0) + 1
    end

    local targets = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetGroupID() == groupid then
            table.insert(targets, ply)
        end
    end

    local w = tonumber(impulse.Inventory.Items[entry.id].Weight) or 0
    local groupName = self:GetSyncVar(SYNC_GROUP_NAME, nil)
    if to == 1 then
        self.InventoryWeight = self.InventoryWeight + w
        LogWithdrawal(groupName, self, 1, "Withdraw: " .. entry.class)
    elseif to == 3 then
        self.InventoryWeight = self.InventoryWeight - w
        LogDeposit(groupName, self, 1, "Deposit: " .. entry.class)
    end

    
    net.Start("deepGroupinvMove")
	net.WriteUInt(1, 8)
	net.WriteEntity(self)
	net.WriteUInt(invid,    16)
	net.WriteUInt(newinvid, 16)
	net.WriteUInt(from,      4)
	net.WriteUInt(to,        4)
	net.WriteUInt(entry.id,  16)
    net.Send(targets)

    self:calcGroupStorageWeight()

    return newinvid
end





-- at the top of sv_groupinventory.lua, alongside your other netstrings:
function meta:MoveInventoryItemGroupMass(itemclass, from, to, amount)
    local groupid = self:GetGroupID()
    if not groupid then
        self:Notify("You are not in a group.")
        return
    end
	
	impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
	impulse.Inventory.Group.Data[groupid] = impulse.Inventory.Group.Data[groupid] or {}
	impulse.Inventory.Group.Data[groupid][3] = impulse.Inventory.Group.Data[groupid][3] or {}

    local targets = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetGroupID() == groupid then
            table.insert(targets, ply)
        end
    end

    local srcTbl = (from == 3)
       and impulse.Inventory.Group.Data[groupid][3]
       or impulse.Inventory.Data[self.impulseID][1]

    local dstTbl = (to == 3)
       and impulse.Inventory.Group.Data[groupid][3]
       or impulse.Inventory.Data[self.impulseID][1]

    local toMove = {}
    for slot, entry in pairs(srcTbl) do
        if #toMove >= amount then break end
        if entry.class == itemclass and not entry.restricted then
            table.insert(toMove, slot)
        end
    end

    local delta = {}
    for _, oldSlot in ipairs(toMove) do
        local entry = srcTbl[oldSlot]
        if not entry then continue end

        if from == 1 then
            impulse.Inventory.DBRemoveItem(self.impulseID, entry.class, 1, 1)
            impulse.Inventory.GroupDBAddItem(groupid, entry.class, 3)
        else
            impulse.Inventory.GroupDBRemoveItem(groupid, entry.class, 3, 1)
            impulse.Inventory.DBAddItem(self.impulseID, entry.class, 1)
        end

        srcTbl[oldSlot] = nil

        if from == 1 then
            self.InventoryRegister[entry.class] =
              (self.InventoryRegister[entry.class] or 1) - 1
            if self.InventoryRegister[entry.class] <= 0 then
                self.InventoryRegister[entry.class] = nil
            end
        end

        local w = tonumber(impulse.Inventory.Items[entry.id].Weight) or 0
        if to == 1 then
            self.InventoryWeight = self.InventoryWeight + w
        elseif to == 3 then
            self.InventoryWeight = self.InventoryWeight - w
        end

        local newSlot
        for i = 1, (#dstTbl + 1) do
            if dstTbl[i] == nil then newSlot = i break end
        end
        dstTbl[newSlot] = entry

        if to == 1 then
            self.InventoryRegister[entry.class] =
              (self.InventoryRegister[entry.class] or 0) + 1
        end

        table.insert(delta, {
            oldSlot = oldSlot,
            newSlot = newSlot,
            from    = from,
            to      = to,
            id      = entry.id,
        })
    end

    self:calcGroupStorageWeight()
    local groupName = self:GetSyncVar(SYNC_GROUP_NAME, nil)
    if to == 1 then
        LogWithdrawal(groupName, self, #delta, "Withdrawal: " .. itemclass)
    elseif to == 3 then
        LogDeposit(groupName, self, #delta, "Deposit: " .. itemclass)
    end
	net.Start("deepGroupinvMove")
	net.WriteUInt(#delta, 8)

	net.WriteEntity(self)

	for _, d in ipairs(delta) do
		net.WriteUInt(d.oldSlot,  16)
		net.WriteUInt(d.newSlot,  16)
		net.WriteUInt(d.from,      4)
		net.WriteUInt(d.to,        4)
		net.WriteUInt(d.id,       16)
	end
    net.Send(targets)
end

function meta:GetGroupInventory(storage)
    storage = storage or 1

    if storage == 3 then
        local gid = self:GetGroupID()
        if not gid then return {} end

        local grpData = impulse.Inventory.Group.Data[gid]
        if not grpData or not grpData[3] then
            return {}
        end

        return grpData[3]
    end

    local personal = impulse.Inventory.Data[self.impulseID] or {}
    return personal[storage] or {}
end

function meta:HasGroupInventoryItemStorage(itemclass, amount)
    local gid = self:GetGroupID()
    if not gid then
        return false, 0
    end

    local grpData = impulse.Inventory.Group.Data[gid]
    local register = (grpData and grpData.Register) or {}

    local has = register[itemclass] or 0

    if amount then
        if has >= amount then
            return true, has
        else
            return false, has
        end
    end

    if has > 0 then
        return true, has
    end

    return false, has
end


function meta:GetGroupID()
	local groupName = self:GetSyncVar(SYNC_GROUP_NAME, nil)
	if groupName and impulse.Group.Groups and impulse.Group.Groups[groupName] then
		local gid = impulse.Group.Groups[groupName].ID
		if gid then
			return tonumber(gid)
		end
	end
	return nil
end

function meta:calcGroupStorageWeight()
    local groupid = self:GetGroupID()
    if not groupid then return 0 end

    local gdata = impulse.Inventory.Group.Data and impulse.Inventory.Group.Data[groupid]
    if not gdata or not gdata[3] then
        if gdata then gdata.Weight = 0 end
        return 0
    end

    local total = 0
    for _, item in pairs(gdata[3]) do
        local itemID = impulse.Inventory.ClassToNetID(item.class)
        local w = tonumber((impulse.Inventory.Items[itemID] or {}).Weight) or 0
        total = total + w
    end

    total = math.Round(total, 1)
    gdata.Weight = total
    return total
end

function impulse.Group.InitializeInventories(onDone)
    local query = mysql:Select("impulse_rpgroups")
    query:Select("id")
    query:Select("name")
    query:Callback(function(results)
        if type(results) == "table" and #results > 0 then
            for _, groupData in ipairs(results) do
                local groupKey = tonumber(groupData.id)
                impulse.Inventory.Group = impulse.Inventory.Group or {}
                impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
                impulse.Inventory.Group.Data[groupKey] = {}
                impulse.Inventory.Group.Data[groupKey][3] = {}
                impulse.Group.LoadInventory(groupKey)
            end
        end
        if onDone then onDone() end
    end)
    query:Execute()
end

function impulse.Group.LoadInventory(groupKey, onLoaded)
    impulse.Inventory.Group = impulse.Inventory.Group      or {}
    impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
    impulse.Inventory.Group.Data[groupKey] = impulse.Inventory.Group.Data[groupKey]      or {}
    impulse.Inventory.Group.Data[groupKey][3] = impulse.Inventory.Group.Data[groupKey][3]   or {}

    local grpData = impulse.Inventory.Group.Data[groupKey]
    grpData.Register = {}

    local query = mysql:Select("impulse_group_inventory")
    query:Select("id")
    query:Select("uniqueid")
    query:Select("groupid")
    query:Select("storagetype")
    query:Where("groupid", groupKey)
    query:Where("storagetype", 3)
    query:Callback(function(result)
        grpData[3] = {}

        grpData.Weight = 0

        if type(result) == "table" and #result > 0 then
            for _, record in ipairs(result) do
                local netID = impulse.Inventory.ClassToNetID(record.uniqueid)
                local itemMeta = impulse.Inventory.Items[netID] or {}
                local w = tonumber(itemMeta.Weight) or 0

                table.insert(grpData[3], {
                    id         = netID,
                    class      = record.uniqueid,
                    restricted = false,
                    equipped   = false,
                    clip       = nil,
                    weight     = w,
                })

                grpData.Weight = grpData.Weight + w

                grpData.Register[record.uniqueid] =
                  (grpData.Register[record.uniqueid] or 0) + 1
            end
        end

        if onLoaded then onLoaded() end
    end)
    query:Execute()
end

impulse.Group.InitializeInventories()
