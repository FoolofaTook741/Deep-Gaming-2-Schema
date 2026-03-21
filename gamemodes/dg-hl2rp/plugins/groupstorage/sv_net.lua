util.AddNetworkString("deepGroupStorageOpen")
util.AddNetworkString("deepGroupStorageSync")
util.AddNetworkString("deepGroupInvContainerDoMove")
util.AddNetworkString("deepGroupInvContainerDoMoveMass")
util.AddNetworkString("deepGroupinvMove")
util.AddNetworkString("deepGroupLogsRequest")
util.AddNetworkString("deepGroupLogsSend")
util.AddNetworkString("impulseGroupDoStorageUpgrade")
util.AddNetworkString("impulseGroupStorageTierSync")
util.AddNetworkString("impulseGroupATMDeposit")
util.AddNetworkString("impulseGroupATMWithdraw")
util.AddNetworkString("impulseGroupBankSync")

net.Receive("deepGroupInvContainerDoMove", function(len, ply)
    if (ply.nextInvMove or 0) > CurTime() then return end
    ply.nextInvMove = CurTime() + 0.5

    if not ply.currentStorage or not IsValid(ply.currentStorage) then return end
    if ply.currentStorage:GetPos():DistToSqr(ply:GetPos()) > 100^2 then return end
    if ply:IsCP() then return end
    if ply:GetSyncVar(SYNC_ARRESTED, false) or not ply:Alive() then return end
	
	if not impulse.GroupStorageEnabled then ply:Notify("Group storage is currently disabled") return end

    local canUse = hook.Run("CanUseInventory", ply)
    if canUse ~= nil and canUse == false then return end


    local itemid = net.ReadUInt(16)
    local from = net.ReadUInt(4)
    if from ~= 1 and from ~= 3 then return end

    local to = (from == 1) and 3 or 1
    if to == 3 and (ply.NextStorage or 0) > CurTime() then
        ply.nextInvMove = CurTime() + 0.5
        return ply:Notify("Because you were recently in combat you must wait " ..string.NiceTime(ply.NextStorage - CurTime()) .." before depositing items into your storage.")
    end
	
	if from == 3 then
		if not ply.currentStorage:CanPlayerWithdraw(ply) then return end
	elseif from == 1 then
		if not ply.currentStorage:CanPlayerDeposit(ply) then return end
	end

    local hasItem, item = ply:HasInventoryItemSpecificGroup(itemid, from)
    if not hasItem then return end
    if item.restricted then return ply:Notify("You cannot store a restricted item.") end

    if from == 3 and not ply:CanHoldItem(item.class) then
        return ply:Notify("Item is too heavy to hold.")
    end
    if from == 1 and not ply:CanHoldItemGroupStorage(item.class) then
        return ply:Notify("Item is too heavy to store.")
    end
	
	if item.equipped then
        ply:SetInventoryItemEquipped(itemid, false)
    end

    local canStore = hook.Run("CanStoreItem", ply, ply.currentStorage, item.class, from)
    if canStore ~= nil and canStore == false then return end
	
    ply:MoveInventoryItemGroup(itemid, from, to)

    local direction = (from == 3) and "Withdrawal" or "Deposit"
    hook.Run("PlayerContainerTake", ply, item.class, ply.currentStorage:GetClass(), direction, "1")
    SyncDyeDataToClient(ply)
end)

net.Receive("deepGroupInvContainerDoMoveMass", function(len, ply)
    if (ply.nextInvMove or 0) > CurTime() then return end
    ply.nextInvMove = CurTime() + 0.8

    if not ply.currentStorage or not IsValid(ply.currentStorage) then return end
    if ply.currentStorage:GetPos():DistToSqr(ply:GetPos()) > (100 ^ 2) then return end
    if ply:IsCP() then return end
    if ply:GetSyncVar(SYNC_ARRESTED, false) or not ply:Alive() then return end
	
	if not impulse.GroupStorageEnabled then ply:Notify("Group storage is currently disabled") return end

    local canUse = hook.Run("CanUseInventory", ply)
    if canUse == false then return end
	local amount      = net.ReadUInt(8)
    local itemclassid = net.ReadUInt(10)
    local from        = net.ReadUInt(4)
    if from ~= 1 and from ~= 3 then return end
    local to = (from == 1) and 3 or 1
	
	if from == 3 then
		if not ply.currentStorage:CanPlayerWithdraw(ply) then return end
	elseif from == 1 then
		if not ply.currentStorage:CanPlayerDeposit(ply) then return end
	end

    local item = impulse.Inventory.Items[itemclassid]
    if not item then return end
    local class = item.UniqueID

    if to == 3 and (ply.NextStorage or 0) > CurTime() then
        ply.nextInvMove = CurTime() + 1
        return ply:Notify("Because you were recently in combat you must wait " ..string.NiceTime(ply.NextStorage - CurTime()) .." before depositing items into your storage.")
    end

    local item = impulse.Inventory.Items[itemclassid]
    if not item then return end
    local itemclass = item.UniqueID
    local hasItem
    if from == 1 then
        local need = amount
        for invid, invItem in pairs(ply:GetInventory()) do
            if invItem.class == itemclass and invItem.equipped then
                ply:SetInventoryItemEquipped(invid, false)
                need = need - 1
                if need <= 0 then break end
            end
        end
        hasItem = ply:HasInventoryItem(itemclass, amount)
    else
        hasItem = ply:HasGroupInventoryItemStorage(itemclass, amount)
    end
    if not hasItem then return end
    local runs = 0
    for _, k in pairs(ply:GetGroupInventory(from)) do
        runs = runs + 1
        if k.class == itemclass and k.restricted then
            return ply:Notify("You cannot store a restricted item.")
        end
        if runs >= amount then break end
    end

    if from == 3 then
        if not ply:CanHoldItem(itemclass, amount) then
            return ply:Notify("Items are too heavy to hold.")
        end
    elseif from == 1 then
        if not ply:CanHoldItemGroupStorage(itemclass, amount) then
            return ply:Notify("Items are too heavy to store.")
        end
    end

    local canStore = hook.Run("CanStoreItem", ply, ply.currentStorage, itemclass, from)
    if canStore == false then return end

    ply:MoveInventoryItemGroupMass(itemclass, from, to, amount)

    local gid = ply:GetGroupID()
    impulse.Inventory.Group.Data[gid] = impulse.Inventory.Group.Data[gid] or {}
    local grpData = impulse.Inventory.Group.Data[gid]
    grpData.Register = grpData.Register or {}

    if from == 1 then
        grpData.Register[itemclass] = (grpData.Register[itemclass] or 0) + amount
    else
        local newCount = (grpData.Register[itemclass] or amount) - amount
        if newCount > 0 then
            grpData.Register[itemclass] = newCount
        else
            grpData.Register[itemclass] = nil
        end
    end

    local direction = (from == 1) and "Deposit" or "Withdrawal"
    hook.Run("PlayerContainerTake", ply, itemclass, ply.currentStorage:GetClass(), direction, tostring(amount))
    SyncDyeDataToClient(ply)
end)
    
local logRequestCooldown = {}
local cooldown = 5

net.Receive("deepGroupLogsRequest", function(len, ply)
    local currentTime = CurTime()

    if logRequestCooldown[ply:SteamID()] and logRequestCooldown[ply:SteamID()] > currentTime then
        local waitTime = math.ceil(logRequestCooldown[ply:SteamID()] - currentTime)
        ply:Notify("Please wait " .. waitTime .. " second(s) before requesting logs again.")
        return
    end

    logRequestCooldown[ply:SteamID()] = currentTime + cooldown

    local groupName = ply:GetSyncVar(SYNC_GROUP_NAME, nil)
    if not groupName then return end

    local logs = GetLogs(groupName)

    net.Start("deepGroupLogsSend")
    net.WriteTable(logs)
    net.Send(ply)
end)

local STORAGE_TIER_BONUS = 50

net.Receive("impulseGroupDoStorageUpgrade", function(len, ply)
    if not ply:Alive() then return end
    if ply:IsCP() then return end

    local tier = net.ReadUInt(4)
    if tier < 1 or tier > 4 then return end

    local groupName = ply:GetSyncVar(SYNC_GROUP_NAME, nil)
    if not groupName then return end

    if not ply:GroupHasPermission(99) then
        return ply:Notify("You do not have permission to purchase storage upgrades.")
    end

    local group = impulse.Group.Groups[groupName]
    if not group then return end

    local currentTier = group.StorageTier or 0

    if tier != currentTier + 1 then
        return ply:Notify("You must purchase storage upgrades in order.")
    end

    local cost = impulse.Config.GroupStorageUpgradeCost
    if not ply:CanAfford(cost) then
        return ply:Notify("Your group cannot afford this storage upgrade.")
    end

    ply:TakeMoney(cost)

    group.StorageTier = tier

    local query = mysql:Update("impulse_rpgroups")
    query:Update("storageupgrade", tier)
    query:Where("id", group.ID)
    query:Execute()

    local rf = RecipientFilter()
    for _, p in pairs(player.GetAll()) do
        if p:GetSyncVar(SYNC_GROUP_NAME, nil) == groupName then
            rf:AddPlayer(p)
        end
    end

    net.Start("impulseGroupStorageTierSync")
    net.WriteUInt(tier, 4)
    net.Send(rf)

    ply:Notify("Storage upgraded to Tier " .. tier .. "! (+" .. (tier * STORAGE_TIER_BONUS) .. "kg bonus storage)")
end)

local function SyncGroupBankToOnline(groupName)
    local group = impulse.Group.Groups[groupName]
    if not group then return end

    local rf = RecipientFilter()
    for _, p in pairs(player.GetAll()) do
        if p:GetSyncVar(SYNC_GROUP_NAME, nil) == groupName then
            rf:AddPlayer(p)
        end
    end

    net.Start("impulseGroupBankSync")
    net.WriteUInt(group.GroupBank or 0, 32)
    net.Send(rf)
end

net.Receive("impulseGroupATMDeposit", function(len, ply)
    if (ply.nextGroupBank or 0) > CurTime() then return end
    ply.nextGroupBank = CurTime() + 1

    if not ply:Alive() then return end
    if ply:IsCP() then return end
    if ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    -- proximity check to group storage entity
    if not ply.currentStorage or not IsValid(ply.currentStorage) then
        return ply:Notify("You must be near a group storage to access the group bank.")
    end
    if ply.currentStorage:GetPos():DistToSqr(ply:GetPos()) > 100^2 then
        return ply:Notify("You are too far from the group storage.")
    end

    local groupName = ply:GetSyncVar(SYNC_GROUP_NAME, nil)
    if not groupName then return ply:Notify("You are not in a group.") end

    if not ply:GroupHasPermission(11) then
        return ply:Notify("You do not have permission to deposit into the group bank.")
    end

    local group = impulse.Group.Groups[groupName]
    if not group then return end

    local amount = net.ReadUInt(32)
    if not isnumber(amount) or amount < 1 or amount > 1000000000 then return end
    amount = math.floor(amount)

    if not ply:CanAfford(amount) then
        return ply:Notify("You cannot afford to deposit that amount.")
    end

    ply:TakeMoney(amount)
    group.GroupBank = (group.GroupBank or 0) + amount
    impulse.Group.DBUpdateGroupBank(group.ID, group.GroupBank)
    SyncGroupBankToOnline(groupName)

    LogDeposit(groupName, ply, amount, "Bank Deposit: " .. impulse.Config.CurrencyPrefix .. amount)
    ply:Notify("You deposited " .. impulse.Config.CurrencyPrefix .. amount .. " into the group bank.")
end)

net.Receive("impulseGroupATMWithdraw", function(len, ply)
    if (ply.nextGroupBank or 0) > CurTime() then return end
    ply.nextGroupBank = CurTime() + 1

    if not ply:Alive() then return end
    if ply:IsCP() then return end
    if ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    -- proximity check to group storage entity
    if not ply.currentStorage or not IsValid(ply.currentStorage) then
        return ply:Notify("You must be near a group storage to access the group bank.")
    end
    if ply.currentStorage:GetPos():DistToSqr(ply:GetPos()) > 100^2 then
        return ply:Notify("You are too far from the group storage.")
    end

    local groupName = ply:GetSyncVar(SYNC_GROUP_NAME, nil)
    if not groupName then return ply:Notify("You are not in a group.") end

    if not ply:GroupHasPermission(12) then
        return ply:Notify("You do not have permission to withdraw from the group bank.")
    end

    local group = impulse.Group.Groups[groupName]
    if not group then return end

    local amount = net.ReadUInt(32)
    if not isnumber(amount) or amount < 1 or amount > 1000000000 then return end
    amount = math.floor(amount)

    local balance = group.GroupBank or 0
    if amount > balance then
        return ply:Notify("The group bank does not have enough funds.")
    end

    group.GroupBank = balance - amount
    impulse.Group.DBUpdateGroupBank(group.ID, group.GroupBank)

    ply:GiveMoney(amount)
    SyncGroupBankToOnline(groupName)

    LogWithdrawal(groupName, ply, amount, "Bank Withdrawal: " .. impulse.Config.CurrencyPrefix .. amount)
    ply:Notify("You withdrew " .. impulse.Config.CurrencyPrefix .. amount .. " from the group bank.")
end)

function SyncGroupStorageForGroup(groupid, ply, delete)
    local groupItems = {}
	net.Start("deepGroupStorageSync")
	net.WriteBool(delete)
	if not delete then
	
		if impulse.Inventory.Group.Data[groupid] and impulse.Inventory.Group.Data[groupid][3] then
			groupItems = impulse.Inventory.Group.Data[groupid][3]
		end

        if impulse.Inventory.Group.Data[groupid] then
            impulse.Inventory.Group.Data[groupid].Weight = nil
            ply:calcGroupStorageWeight()
        end
		
		local cnt = 0
		for _ in pairs(groupItems) do cnt = cnt + 1 end

		net.WriteUInt(cnt, 16)
		for slot, entry in pairs(groupItems) do
			net.WriteUInt( slot, 16 )
			net.WriteUInt( entry.id, 16 )
			net.WriteBool( entry.restricted )
			net.WriteBool( entry.equipped )
		end
	end
	net.Send(ply)
end


hook.Add("PlayerGroupCreated", "InitializeNewGroupInventory", function(groupName, groupID, creator)
	SyncGroupStorageForGroup(groupID, creator)
end)

hook.Add("PlayerGroupStorageSync", "syncClientGroupInventory", function(groupName, groupID, target, delete)
    if IsValid(target) then
		SyncGroupStorageForGroup(groupID, target, delete)
    end
end)


hook.Add("PlayerGroupDeleted", "CleanupGroupInventory", function(groupName, groupID,ply)
    groupID = tonumber(groupID)

    if impulse.Inventory.Group and impulse.Inventory.Group.Data then
        impulse.Inventory.Group.Data[groupID] = nil
    end

    local query = mysql:Delete("impulse_group_inventory")
    query:Where("groupid", groupID)
    query:Execute()
	SyncGroupStorageForGroup(groupID,ply,true)

end)

hook.Add("GroupDataLoaded", "SyncPlayerGroupStorage", function(ply, name, rank)
    -- Defer
    timer.Simple(0, function()
        if not IsValid(ply) then return end
        if not name then return end

        local grp = impulse.Group and impulse.Group.Groups and impulse.Group.Groups[name]
        if not grp or not grp.ID then return end

        SyncGroupStorageForGroup(grp.ID, ply)

        impulse.debugPrint("Synced group storage for player: " .. ply:Nick() .." Group ID: " .. grp.ID .. " Group Name " .. name)

        if ply.calcGroupStorageWeight then
            ply:calcGroupStorageWeight()
        end
    end)
end)