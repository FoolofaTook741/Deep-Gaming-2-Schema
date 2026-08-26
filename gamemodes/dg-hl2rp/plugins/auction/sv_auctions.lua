local DEPOSIT_RATE  = 0.025
local SALE_FEE_RATE = 0.08
local MAX_CREDIT_VALUE = 1000000
local USE_RANGE = 150
impulse.Auctions = impulse.Auctions or {}
local AH = impulse.Auctions
util.AddNetworkString("AuctionHouse_Open")
util.AddNetworkString("AuctionHouse_ShowNotification")
util.AddNetworkString("AuctionHouse_ClearNotification")
util.AddNetworkString("AuctionHouse_BrowseData")
util.AddNetworkString("AuctionHouse_BrowseDataChunk")
util.AddNetworkString("AuctionHouse_MyAuctions")
util.AddNetworkString("AuctionHouse_MyAuctionsChunk")
util.AddNetworkString("AuctionHouse_ActionResult")
util.AddNetworkString("AuctionHouse_PostListing")
util.AddNetworkString("AuctionHouse_PlaceBid")
util.AddNetworkString("AuctionHouse_Buyout")
util.AddNetworkString("AuctionHouse_CancelListing")
util.AddNetworkString("AuctionHouse_RequestBrowse")
util.AddNetworkString("AuctionHouse_RequestMine")
util.AddNetworkString("AuctionHouse_SaleHistory")
util.AddNetworkString("AuctionHouse_SaleHistoryChunk")
util.AddNetworkString("AuctionHouse_RequestSaleHistory")
local COOLDOWNS = {
    AuctionHouse_PostListing   = 3,
    AuctionHouse_PlaceBid      = 2,
    AuctionHouse_Buyout        = 2,
    AuctionHouse_CancelListing = 2,
    AuctionHouse_RequestBrowse       = 0.7,
    AuctionHouse_RequestMine         = 0.7,
    AuctionHouse_RequestSaleHistory  = 0.7,
}
local lastAction = {}
local function RateLimit(ply, msgName)
    if not IsValid(ply) then return false end
    local sid = ply:SteamID()
    local cd  = COOLDOWNS[msgName] or 1
    lastAction[sid] = lastAction[sid] or {}
    if CurTime() - (lastAction[sid][msgName] or 0) < cd then
        return false
    end
    lastAction[sid][msgName] = CurTime()
    return true
end
hook.Add("PlayerDisconnected", "AuctionHouse_CleanupRateLimit", function(ply)
    lastAction[ply:SteamID()] = nil
end)
local function NearAuctionHouse(ply)
    if not IsValid(ply) then return false end
    local pos = ply:GetPos()
    for _, ent in ipairs(ents.FindByClass("impulse_auctionhouse")) do
        if IsValid(ent) and pos:DistToSqr(ent:GetPos()) <= (USE_RANGE * USE_RANGE) then
            return true
        end
    end
    return false
end
local function ValidCredit(n)
    return type(n) == "number" and n >= 0 and n <= MAX_CREDIT_VALUE and math.floor(n) == n
end
local function ValidString(s, maxLen)
    return type(s) == "string" and #s > 0 and #s <= (maxLen or 64)
end
local function ValidSteamID(sid)
    return type(sid) == "string" and sid:match("^STEAM_%d:%d:%d+$") ~= nil
end
local function ValidDuration(d)
    return d == 2 or d == 8 or d == 24 or d == 72 or d == 168
end
local function SafeItemClass(s)
    return type(s) == "string" and #s > 0 and #s <= 64 and s:match("^[%w_%-]+$") ~= nil
end
local function ValidTeam(ply)
    local t = ply:Team()
    return t == TEAM_CWU or t == TEAM_CITIZEN or t == TEAM_VORT
end
local function CalcDeposit(startBid, reservePrice, buyoutPrice, isCollab)
    if isCollab then return 0 end
    local base
    if buyoutPrice and buyoutPrice > 0 then
        base = buyoutPrice
    elseif reservePrice and reservePrice > 0 then
        base = reservePrice
    else
        base = startBid
    end
    return math.max(1, math.floor(base * DEPOSIT_RATE + 0.5))
end
local function CalcSaleFee(finalPrice, isCollab)
    local rate = isCollab and 0.03 or SALE_FEE_RATE
    return math.floor(finalPrice * rate)
end
local function NotifyPlayer(steamid, message)
    if not ValidSteamID(steamid) then return end
    if not ValidString(message, 256) then return end
    local ply = player.GetBySteamID(steamid)
    for _, ent in ipairs(ents.FindByClass("impulse_auctionhouse")) do
        if IsValid(ent) then
            ent.PendingNotifications[steamid] = true
            if IsValid(ply) then
                net.Start("AuctionHouse_ShowNotification")
                net.WriteEntity(ent)
                net.Send(ply)
            end
        end
    end
    if IsValid(ply) then
        ply:Notify(message)
    end
end
local function SendResult(ply, success, message)
    if not IsValid(ply) then return end
    net.Start("AuctionHouse_ActionResult")
    net.WriteBool(success)
    net.WriteString(message or "")
    net.Send(ply)
end
local function GiveItems(ply, itemClass, quantity)
    for i = 1, quantity do
        ply:GiveInventoryItem(itemClass, 1)
    end
end
local function SerializeAuction(row)
    return {
        id             = tonumber(row.id),
        item_class     = row.item_class,
        item_name      = row.item_name,
        item_category  = row.item_category or "Misc",
        item_quantity  = tonumber(row.item_quantity) or 1,
        seller_steamid = row.seller_steamid,
        seller_name    = row.seller_name ~= "" and row.seller_name or row.seller_steamid,
        posted_at      = tonumber(row.posted_at),
        expires_at     = tonumber(row.expires_at),
        starting_bid   = tonumber(row.starting_bid),
        buyout_price   = row.buyout_price and tonumber(row.buyout_price) or nil,
        current_bid    = tonumber(row.current_bid) or 0,
        bid_count      = tonumber(row.bid_count) or 0,
        status         = tonumber(row.status) or 0,
        reserve_met    = (not row.reserve_price) or (tonumber(row.current_bid or 0) >= tonumber(row.reserve_price)),
    }
end
local CHUNK_SIZE = 32768
local function SendChunked(ply, startMsg, chunkMsg, compressed)
    local total  = #compressed
    local chunks = math.ceil(total / CHUNK_SIZE)
    net.Start(startMsg)
    net.WriteUInt(total, 32)
    net.WriteUInt(chunks, 16)
    net.Send(ply)
    for i = 1, chunks do
        local offset = (i - 1) * CHUNK_SIZE + 1
        local chunk  = string.sub(compressed, offset, offset + CHUNK_SIZE - 1)
        net.Start(chunkMsg)
        net.WriteUInt(i, 16)
        net.WriteUInt(#chunk, 16)
        net.WriteData(chunk, #chunk)
        net.Send(ply)
    end
end
local function SendBrowseData(ply, rows)
    if not IsValid(ply) then return end
    local sid      = ply:SteamID()
    local auctions = {}
    for _, row in ipairs(rows or {}) do
        local s = SerializeAuction(row)
        s.i_am_high_bidder = (row.high_bidder_steamid == sid)
        table.insert(auctions, s)
    end
    local compressed = util.Compress(util.TableToJSON(auctions))
    SendChunked(ply, "AuctionHouse_BrowseData", "AuctionHouse_BrowseDataChunk", compressed)
end
local function SendMyAuctions(ply, rows)
    if not IsValid(ply) then return end
    local auctions = {}
    for _, row in ipairs(rows or {}) do
        local s = SerializeAuction(row)
        s.high_bidder = row.high_bidder_steamid or nil
        table.insert(auctions, s)
    end
    local compressed = util.Compress(util.TableToJSON(auctions))
    SendChunked(ply, "AuctionHouse_MyAuctions", "AuctionHouse_MyAuctionsChunk", compressed)
end
local function ProcessExpiredAuction(row)
    local auctionID    = tonumber(row.id)
    local sellerSID    = row.seller_steamid
    local highBidder   = row.high_bidder_steamid
    local currentBid   = tonumber(row.current_bid) or 0
    local reservePrice = row.reserve_price and tonumber(row.reserve_price) or nil
    local deposit      = tonumber(row.deposit_paid) or 0
    local itemClass    = row.item_class
    local itemName     = row.item_name
    local itemQty      = tonumber(row.item_quantity) or 1
    if not ValidSteamID(sellerSID) then return end
    local reserveMet = (not reservePrice) or (currentBid >= reservePrice)
    if highBidder and ValidSteamID(highBidder) and currentBid > 0 and reserveMet then
        local isCollab   = tonumber(row.is_collaborator) == 1
        local fee        = CalcSaleFee(currentBid, isCollab)
        local sellerGets = currentBid - fee + deposit
        local ins = mysql:Insert("impulse_auction_history")
        ins:Insert("auction_id",       auctionID)
        ins:Insert("event_type",       1)
        ins:Insert("actor_steamid",    highBidder)
        ins:Insert("amount",           currentBid)
        ins:Insert("placed_at",        os.time())
        ins:Insert("item_class",       itemClass)
        ins:Insert("item_name",        itemName)
        ins:Insert("item_quantity",    itemQty)
        ins:Insert("seller_steamid",   sellerSID)
        ins:Insert("item_received",    0)
        ins:Insert("credits_received", 0)
        ins:Insert("seller_payout",    sellerGets)
        ins:Callback(function(result, status, lastID)
            if not status then
                print("[AuctionHouse] Expiry sold history insert FAILED for auction #" .. auctionID)
            else
                mysql:RawQuery("DELETE FROM `impulse_auction_history` WHERE `auction_id` = " .. math.floor(auctionID) .. " AND `event_type` = 0 AND `was_outbid` = 0")
                local del = mysql:Delete("impulse_auctions")
                del:Where("id", auctionID)
                del:Execute()
            end
        end)
        ins:Execute()
        NotifyPlayer(sellerSID,  "Your auction for " .. itemName .. " sold for " .. currentBid .. " credits! Visit the Auction House to collect.")
        NotifyPlayer(highBidder, "You won the auction for " .. itemName .. "! Visit the Auction House to collect your item.")
    else
        local ins = mysql:Insert("impulse_auction_history")
        ins:Insert("auction_id",       auctionID)
        ins:Insert("event_type",       2)
        ins:Insert("actor_steamid",    highBidder or sellerSID)
        ins:Insert("amount",           currentBid)
        ins:Insert("placed_at",        os.time())
        ins:Insert("item_class",       itemClass)
        ins:Insert("item_name",        itemName)
        ins:Insert("item_quantity",    itemQty)
        ins:Insert("seller_steamid",   sellerSID)
        ins:Insert("item_received",    0)
        ins:Insert("credits_received", (highBidder and currentBid > 0) and 0 or 1)
        ins:Callback(function(result, status, lastID)
            if not status then
                print("[AuctionHouse] Expiry unsold history insert FAILED for auction #" .. auctionID)
            else
                mysql:RawQuery("DELETE FROM `impulse_auction_history` WHERE `auction_id` = " .. math.floor(auctionID) .. " AND `event_type` = 0 AND `was_outbid` = 0")
                local del = mysql:Delete("impulse_auctions")
                del:Where("id", auctionID)
                del:Execute()
            end
        end)
        ins:Execute()
        NotifyPlayer(sellerSID, "Your auction for " .. itemName .. " has expired. Visit the Auction House to retrieve your item.")
        if highBidder and ValidSteamID(highBidder) and currentBid > 0 then
            NotifyPlayer(highBidder, "The auction for " .. itemName .. " expired. Visit the Auction House to collect your refunded bid.")
        end
    end
end
local expiryRunning = false
local expiryLastRun = 0
function AH.CheckExpired()
    if expiryRunning and (CurTime() - expiryLastRun) < 30 then return end
    expiryRunning = true
    expiryLastRun = CurTime()
    local q = mysql:Select("impulse_auctions")
    q:Where("status", 0)
    q:WhereLTE("expires_at", os.time())
    q:Callback(function(results)
        expiryRunning = false
        if type(results) ~= "table" or #results == 0 then return end
        for _, row in ipairs(results) do
            ProcessExpiredAuction(row)
        end
    end)
    q:Execute()
end
timer.Create("AuctionHouse_ExpiryCheck", 60, 0, function()
    AH.CheckExpired()
end)
net.Receive("AuctionHouse_PostListing", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_PostListing") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return SendResult(ply, false, "You cannot use this as your current team.") end
    local itemClass    = net.ReadString()
    local invKey       = net.ReadUInt(16)
    local startBid     = net.ReadUInt(32)
    local reservePrice = net.ReadUInt(32)
    local buyoutPrice  = net.ReadUInt(32)
    local duration     = net.ReadUInt(16)
    local stackQty     = net.ReadUInt(16)
    if not SafeItemClass(itemClass) then
        return SendResult(ply, false, "Invalid item.")
    end
    if not ValidDuration(duration) then
        return SendResult(ply, false, "Invalid auction duration.")
    end
    if not ValidCredit(startBid) or startBid < 1 then
        return SendResult(ply, false, "Starting bid must be between 1 and " .. MAX_CREDIT_VALUE .. " credits.")
    end
    if stackQty < 1 or stackQty > 100 then
        return SendResult(ply, false, "Invalid quantity.")
    end
    if reservePrice > 0 then
        if not ValidCredit(reservePrice) or reservePrice <= startBid then
            return SendResult(ply, false, "Reserve must be greater than the starting bid.")
        end
    end
    if buyoutPrice > 0 then
        if not ValidCredit(buyoutPrice) or buyoutPrice < startBid then
            return SendResult(ply, false, "Buyout must be at least equal to the starting bid.")
        end
        if reservePrice > 0 and buyoutPrice <= reservePrice then
            return SendResult(ply, false, "Buyout must be greater than the reserve price.")
        end
    end
    local invData = ply:GetInventory(1)
    if not invData then
        return SendResult(ply, false, "Could not read your inventory.")
    end
    local entry = invData[invKey]
    if not entry then
        return SendResult(ply, false, "Item not found in your inventory.")
    end
    local itemData = impulse.Inventory.Items[entry.id]
    if not itemData then
        return SendResult(ply, false, "Invalid item data.")
    end
    if itemData.UniqueID ~= itemClass then
        print("[AuctionHouse] EXPLOIT ATTEMPT: " .. ply:SteamID() .. " (" .. ply:Name() .. ") sent mismatched item class. Claimed: " .. tostring(itemClass) .. " | Actual: " .. tostring(itemData.UniqueID))
        return SendResult(ply, false, "Item mismatch. Please close and reopen the auction house.")
    end
    if entry.restricted then
        return SendResult(ply, false, "You cannot auction a restricted item.")
    end
    local hasItem, totalOwned = ply:HasInventoryItem(itemClass)
    totalOwned = totalOwned or 0
    local nonRestrictedCount = 0
    local invData2 = ply:GetInventory(1)
    for _, slot in pairs(invData2) do
        if slot.class == itemClass and not slot.restricted then
            nonRestrictedCount = nonRestrictedCount + 1
        end
    end
    if nonRestrictedCount < stackQty then
        return SendResult(ply, false, "You do not have " .. stackQty .. "x unrestricted " .. (itemData.Name or itemClass) .. " to auction.")
    end
    local isCollab = ply:IsCollaborator() and 1 or 0
    local deposit = CalcDeposit(startBid, reservePrice, buyoutPrice, isCollab == 1)
    if ply:GetMoney() < deposit then
        return SendResult(ply, false, "You cannot afford the deposit of " .. deposit .. " credits.")
    end
    local now        = os.time()
    local expiresAt  = now + (duration * 3600)
    local displayName = stackQty > 1 and (stackQty .. "x " .. (itemData.Name or itemClass)) or (itemData.Name or itemClass)
    local ins = mysql:Insert("impulse_auctions")
    ins:Insert("seller_steamid",  ply:SteamID())
    ins:Insert("seller_name",     ply:Name())
    ins:Insert("item_class",      itemClass)
    ins:Insert("item_data",       util.TableToJSON(entry))
    ins:Insert("item_name",       displayName)
    ins:Insert("item_category",   itemData.Category or "Misc")
    ins:Insert("item_quantity",   stackQty)
    ins:Insert("duration_chosen", duration)
    ins:Insert("posted_at",       now)
    ins:Insert("expires_at",      expiresAt)
    ins:Insert("starting_bid",    startBid)
    ins:Insert("current_bid",     0)
    ins:Insert("bid_count",       0)
    ins:Insert("deposit_paid",    deposit)
    ins:Insert("status",          0)
    ins:Insert("is_collaborator", isCollab)
    if reservePrice > 0 then ins:Insert("reserve_price", reservePrice) end
    if buyoutPrice  > 0 then ins:Insert("buyout_price",  buyoutPrice)  end
    ins:Callback(function(result, status, lastID)
        if not IsValid(ply) then return end
        if not status then
            return SendResult(ply, false, "Failed to post auction. Please try again.")
        end
        if ply:GetMoney() < deposit then
            local del = mysql:Delete("impulse_auctions")
            del:Where("id", lastID)
            del:Execute()
            return SendResult(ply, false, "You can no longer afford the deposit of " .. deposit .. " credits.")
        end
        ply:TakeMoney(deposit)
        local taken = 0
        local invData3 = ply:GetInventory(1)
        for invid, slot in pairs(invData3) do
            if taken >= stackQty then break end
            if slot.class == itemClass and not slot.restricted then
                ply:TakeInventoryItem(invid, 1)
                taken = taken + 1
            end
        end
        if taken < stackQty then
            ply:GiveMoney(deposit)
            local del = mysql:Delete("impulse_auctions")
            del:Where("id", lastID)
            del:Execute()
            return SendResult(ply, false, "Could not take all items from your inventory. Auction cancelled.")
        end
        SendResult(ply, true, "Auction posted! Deposit of " .. deposit .. " credits charged.")
        ply:Notify("Your auction for " .. displayName .. " has been posted.")
    end)
    ins:Execute()
end)
net.Receive("AuctionHouse_PlaceBid", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_PlaceBid") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return SendResult(ply, false, "You cannot use this as your current team.") end
    local auctionID = net.ReadUInt(32)
    local bidAmount = net.ReadUInt(32)
    if auctionID == 0 then return end
    if not ValidCredit(bidAmount) or bidAmount < 1 then
        return SendResult(ply, false, "Invalid bid amount.")
    end
    AH.CheckExpired()
    local q = mysql:Select("impulse_auctions")
    q:Where("id", auctionID)
    q:Callback(function(results)
        if not IsValid(ply) then return end
        if type(results) ~= "table" or #results == 0 then
            return SendResult(ply, false, "Auction not found.")
        end
        local row        = results[1]
        local currentBid = tonumber(row.current_bid) or 0
        local startBid   = tonumber(row.starting_bid) or 1
        local minBid     = math.max(currentBid + 1, startBid)
        local prevBidder = row.high_bidder_steamid
        local status     = tonumber(row.status) or 0
        local buyout     = row.buyout_price and tonumber(row.buyout_price) or nil
        local itemQty    = tonumber(row.item_quantity) or 1
        if status ~= 0 then
            return SendResult(ply, false, "This auction is no longer active.")
        end
        if tonumber(row.expires_at) <= os.time() then
            AH.CheckExpired()
            return SendResult(ply, false, "This auction has expired.")
        end
        if row.seller_steamid == ply:SteamID() then
            print("[AuctionHouse] EXPLOIT ATTEMPT: " .. ply:SteamID() .. " (" .. ply:Name() .. ") attempted to bid on their own auction #" .. auctionID)
            ply:Notify("You cannot bid on your own auction.")
            return SendResult(ply, false, "You cannot bid on your own auction.")
        end
        if prevBidder == ply:SteamID() then
            return SendResult(ply, false, "You are already the highest bidder.")
        end
        if bidAmount < minBid then
            return SendResult(ply, false, "Bid must be at least " .. minBid .. " credits.")
        end
        if ply:GetMoney() < bidAmount then
            return SendResult(ply, false, "You cannot afford this bid.")
        end
        if buyout and bidAmount >= buyout then
            if ply:GetMoney() < buyout then
                return SendResult(ply, false, "You cannot afford the buyout price of " .. buyout .. " credits.")
            end
            ply:TakeMoney(buyout)
            if prevBidder and prevBidder ~= "" and ValidSteamID(prevBidder) and currentBid > 0 then
                local ins = mysql:Insert("impulse_auction_history")
                ins:Insert("auction_id",       auctionID)
                ins:Insert("event_type",       0)
                ins:Insert("actor_steamid",    prevBidder)
                ins:Insert("amount",           currentBid)
                ins:Insert("placed_at",        os.time())
                ins:Insert("was_outbid",       1)
                ins:Insert("credits_received", 0)
                ins:Execute()
                NotifyPlayer(prevBidder, "Your bid on " .. (row.item_name or "an item") .. " was ended by a buyout. Visit the Auction House to collect your " .. currentBid .. " credit refund.")
            end
            local deposit    = tonumber(row.deposit_paid) or 0
            local isCollab   = tonumber(row.is_collaborator) == 1
            local fee        = CalcSaleFee(buyout, isCollab)
            local sellerGets = buyout - fee + deposit
            local ins = mysql:Insert("impulse_auction_history")
            ins:Insert("auction_id",       auctionID)
            ins:Insert("event_type",       1)
            ins:Insert("actor_steamid",    ply:SteamID())
            ins:Insert("amount",           buyout)
            ins:Insert("placed_at",        os.time())
            ins:Insert("item_class",       row.item_class)
            ins:Insert("item_name",        row.item_name)
            ins:Insert("item_quantity",    itemQty)
            ins:Insert("seller_steamid",   row.seller_steamid)
            ins:Insert("item_received",    1)
            ins:Insert("credits_received", 0)
            ins:Insert("seller_payout",    sellerGets)
            ins:Callback(function(result, status, lastID)
                if not status then
                    print("[AuctionHouse] Bid-buyout history insert FAILED for auction #" .. auctionID)
                else
                    local del = mysql:Delete("impulse_auctions")
                del:Where("id", auctionID)
                del:Execute()
                end
            end)
            ins:Execute()
            GiveItems(ply, row.item_class, itemQty)
            SendResult(ply, true, "Your bid met the buyout price! " .. (row.item_name or "Item") .. " has been added to your inventory.")
            ply:Notify("You bought out " .. (row.item_name or "an item") .. " for " .. buyout .. " credits.")
            NotifyPlayer(row.seller_steamid, "Your auction for " .. (row.item_name or "an item") .. " was bought out for " .. buyout .. " credits! Visit the Auction House to collect " .. sellerGets .. " credits.")
            return
        end
        ply:TakeMoney(bidAmount)
        if prevBidder and prevBidder ~= "" and ValidSteamID(prevBidder) then
            local ins = mysql:Insert("impulse_auction_history")
            ins:Insert("auction_id",       auctionID)
            ins:Insert("event_type",       0)
            ins:Insert("actor_steamid",    prevBidder)
            ins:Insert("amount",           currentBid)
            ins:Insert("placed_at",        os.time())
            ins:Insert("was_outbid",       1)
            ins:Insert("credits_received", 0)
            ins:Execute()
            NotifyPlayer(prevBidder, "You have been outbid on " .. (row.item_name or "an item") .. "! Your " .. currentBid .. " credits are ready to collect at the Auction House.")
        end
        local ins = mysql:Insert("impulse_auction_history")
        ins:Insert("auction_id",    auctionID)
        ins:Insert("event_type",    0)
        ins:Insert("actor_steamid", ply:SteamID())
        ins:Insert("amount",        bidAmount)
        ins:Insert("placed_at",     os.time())
        ins:Insert("was_outbid",    0)
        ins:Callback(function(result, status, lastID)
            if not status then
                print("[AuctionHouse] Bid history insert FAILED for auction #" .. auctionID .. " bidder=" .. ply:SteamID())
                return
            end
            local upd = mysql:Update("impulse_auctions")
            upd:Update("current_bid",         bidAmount)
            upd:Update("high_bidder_steamid", ply:SteamID())
            upd:Update("bid_count",           (tonumber(row.bid_count) or 0) + 1)
            upd:Update("last_bid_at",         os.time())
            upd:Where("id", auctionID)
            upd:Execute()
        end)
        ins:Execute()
        SendResult(ply, true, "Bid of " .. bidAmount .. " credits placed successfully.")
        ply:Notify("You placed a bid of " .. bidAmount .. "cr on " .. (row.item_name or "an item") .. ".")
    end)
    q:Execute()
end)
net.Receive("AuctionHouse_Buyout", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_Buyout") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return SendResult(ply, false, "You cannot use this as your current team.") end
    local auctionID = net.ReadUInt(32)
    if auctionID == 0 then return end
    AH.CheckExpired()
    local q = mysql:Select("impulse_auctions")
    q:Where("id", auctionID)
    q:Callback(function(results)
        if not IsValid(ply) then return end
        if type(results) ~= "table" or #results == 0 then
            return SendResult(ply, false, "Auction not found.")
        end
        local row        = results[1]
        local buyout     = row.buyout_price and tonumber(row.buyout_price) or nil
        local currentBid = tonumber(row.current_bid) or 0
        local prevBidder = row.high_bidder_steamid
        local deposit    = tonumber(row.deposit_paid) or 0
        local status     = tonumber(row.status) or 0
        local itemQty    = tonumber(row.item_quantity) or 1
        if status ~= 0 then
            return SendResult(ply, false, "This auction is no longer active.")
        end
        if tonumber(row.expires_at) <= os.time() then
            AH.CheckExpired()
            return SendResult(ply, false, "This auction has expired.")
        end
        if not buyout then
            print("[AuctionHouse] EXPLOIT ATTEMPT: " .. ply:SteamID() .. " (" .. ply:Name() .. ") attempted buyout on bid-only auction #" .. auctionID)
            return SendResult(ply, false, "This auction does not have a buyout price.")
        end
        if row.seller_steamid == ply:SteamID() then
            print("[AuctionHouse] EXPLOIT ATTEMPT: " .. ply:SteamID() .. " (" .. ply:Name() .. ") attempted to buy out their own auction #" .. auctionID)
            ply:Notify("You cannot buy out your own auction.")
            return SendResult(ply, false, "You cannot buy out your own auction.")
        end
        if ply:GetMoney() < buyout then
            return SendResult(ply, false, "You cannot afford the buyout price of " .. buyout .. " credits.")
        end
        ply:TakeMoney(buyout)
        if prevBidder and prevBidder ~= "" and ValidSteamID(prevBidder) and currentBid > 0 then
            local ins = mysql:Insert("impulse_auction_history")
            ins:Insert("auction_id",       auctionID)
            ins:Insert("event_type",       0)
            ins:Insert("actor_steamid",    prevBidder)
            ins:Insert("amount",           currentBid)
            ins:Insert("placed_at",        os.time())
            ins:Insert("was_outbid",       1)
            ins:Insert("credits_received", 0)
            ins:Execute()
            NotifyPlayer(prevBidder, "Your bid on " .. (row.item_name or "an item") .. " was ended by a buyout. Visit the Auction House to collect your " .. currentBid .. " credit refund.")
        end
        local isCollab   = tonumber(row.is_collaborator) == 1
        local fee        = CalcSaleFee(buyout, isCollab)
        local sellerGets = buyout - fee + deposit
        local rawInsert = string.format(
            "INSERT INTO `impulse_auction_history` (`auction_id`, `event_type`, `actor_steamid`, `amount`, `placed_at`, `item_class`, `item_name`, `item_quantity`, `seller_steamid`, `item_received`, `credits_received`, `seller_payout`) VALUES (%d, 1, '%s', %d, %d, '%s', '%s', %d, '%s', 1, 0, %d)",
            math.floor(auctionID),
            mysql:Escape(ply:SteamID()),
            math.floor(buyout),
            os.time(),
            mysql:Escape(row.item_class),
            mysql:Escape(row.item_name or ""),
            math.floor(itemQty),
            mysql:Escape(row.seller_steamid),
            math.floor(sellerGets)
        )
        mysql:RawQuery(rawInsert, function(result, status, lastID)
            if not status then
            else
                local del = mysql:Delete("impulse_auctions")
                del:Where("id", auctionID)
                del:Execute()
            end
        end)
        GiveItems(ply, row.item_class, itemQty)
        SendResult(ply, true, "Buyout successful! " .. (row.item_name or "Item") .. " has been added to your inventory.")
        ply:Notify("You bought out " .. (row.item_name or "an item") .. " for " .. buyout .. "cr.")
        NotifyPlayer(row.seller_steamid, "Your auction for " .. (row.item_name or "an item") .. " was bought out for " .. buyout .. " credits! Visit the Auction House to collect " .. sellerGets .. " credits.")
    end)
    q:Execute()
end)
net.Receive("AuctionHouse_CancelListing", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_CancelListing") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return SendResult(ply, false, "You cannot use this as your current team.") end
    local auctionID = net.ReadUInt(32)
    if auctionID == 0 then return end
    local q = mysql:Select("impulse_auctions")
    q:Where("id", auctionID)
    q:Where("seller_steamid", ply:SteamID())
    q:Callback(function(results)
        if not IsValid(ply) then return end
        if type(results) ~= "table" or #results == 0 then
            print("[AuctionHouse] EXPLOIT ATTEMPT: " .. ply:SteamID() .. " (" .. ply:Name() .. ") attempted to cancel auction #" .. auctionID .. " — not theirs or does not exist.")
            return SendResult(ply, false, "Auction not found.")
        end
        local row      = results[1]
        local status   = tonumber(row.status) or 0
        local bidCount = tonumber(row.bid_count) or 0
        local itemQty  = tonumber(row.item_quantity) or 1
        if status ~= 0 then
            return SendResult(ply, false, "This auction is no longer active.")
        end
        if bidCount > 0 then
            return SendResult(ply, false, "You cannot cancel an auction that has bids.")
        end
        GiveItems(ply, row.item_class, itemQty)
        local ins = mysql:Insert("impulse_auction_history")
        ins:Insert("auction_id",       auctionID)
        ins:Insert("event_type",       3)
        ins:Insert("actor_steamid",    ply:SteamID())
        ins:Insert("amount",           0)
        ins:Insert("placed_at",        os.time())
        ins:Insert("item_class",       row.item_class)
        ins:Insert("item_name",        row.item_name)
        ins:Insert("item_quantity",    itemQty)
        ins:Insert("seller_steamid",   ply:SteamID())
        ins:Insert("item_received",    1)
        ins:Insert("credits_received", 1)
        ins:Callback(function(result, status, lastID)
            if not status then
                print("[AuctionHouse] Cancel history insert FAILED for auction #" .. auctionID)
            else
                local del = mysql:Delete("impulse_auctions")
                del:Where("id", auctionID)
                del:Execute()
            end
        end)
        ins:Execute()
        SendResult(ply, true, "Auction cancelled. Your item has been returned. Note: the deposit is non-refundable.")
        ply:Notify("Your auction for " .. (row.item_name or "an item") .. " has been cancelled and returned to your inventory.")
    end)
    q:Execute()
end)
net.Receive("AuctionHouse_RequestBrowse", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_RequestBrowse") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return end
    AH.CheckExpired()
    local q = mysql:Select("impulse_auctions")
    q:Where("status", 0)
    q:Callback(function(results)
        if not IsValid(ply) then return end
        SendBrowseData(ply, results or {})
    end)
    q:Execute()
end)
net.Receive("AuctionHouse_RequestMine", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_RequestMine") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return end
    local q = mysql:Select("impulse_auctions")
    q:Where("seller_steamid", ply:SteamID())
    q:Callback(function(results)
        if not IsValid(ply) then return end
        SendMyAuctions(ply, results or {})
    end)
    q:Execute()
end)
local function SendSaleHistory(ply, rows)
    if not IsValid(ply) then return end
    local history = {}
    for _, row in ipairs(rows or {}) do
        table.insert(history, {
            auction_id   = tonumber(row.auction_id),
            item_name    = row.item_name,
            item_class   = row.item_class,
            item_quantity= tonumber(row.item_quantity) or 1,
            amount       = tonumber(row.amount) or 0,
            seller_payout= tonumber(row.seller_payout) or 0,
            placed_at    = tonumber(row.placed_at),
            event_type   = tonumber(row.event_type),
        })
    end
    local compressed = util.Compress(util.TableToJSON(history))
    SendChunked(ply, "AuctionHouse_SaleHistory", "AuctionHouse_SaleHistoryChunk", compressed)
end
net.Receive("AuctionHouse_RequestSaleHistory", function(len, ply)
    if not IsValid(ply) then return end
    if not RateLimit(ply, "AuctionHouse_RequestSaleHistory") then return end
    if not NearAuctionHouse(ply) then return end
    if not ValidTeam(ply) then return end
    local escapedSid = mysql:Escape(ply:SteamID())
    mysql:RawQuery(
        "SELECT * FROM `impulse_auction_history` WHERE `event_type` = 1 AND `seller_steamid` = '" .. escapedSid .. "' ORDER BY `placed_at` DESC LIMIT 100",
        function(results)
            if not IsValid(ply) then return end
            SendSaleHistory(ply, results or {})
        end
    )
end)
function AH.ProcessPickups(ply)
    if not IsValid(ply) then return end
    if not NearAuctionHouse(ply) then return end
    local sid = ply:SteamID()
    if not ValidSteamID(sid) then return end
    local escapedSid = mysql:Escape(sid)
    mysql:RawQuery(
        "SELECT * FROM `impulse_auction_history` WHERE `item_received` = 0 AND (`actor_steamid` = '" .. escapedSid .. "' OR `seller_steamid` = '" .. escapedSid .. "') AND `event_type` IN (1, 2)",
        function(results)
            if not IsValid(ply) then return end
            if type(results) ~= "table" then return end
            for _, row in ipairs(results) do
                local eventType = tonumber(row.event_type)
                local isSeller  = row.seller_steamid == sid
                local isActor   = row.actor_steamid == sid
                local shouldGetItem = (eventType == 2 and isSeller) or (eventType == 1 and isActor)
                if shouldGetItem and SafeItemClass(row.item_class or "") then
                    local qty = tonumber(row.item_quantity) or 1
                    GiveItems(ply, row.item_class, qty)
                    ply:Notify("You collected: " .. (row.item_name or row.item_class))
                    local upd = mysql:Update("impulse_auction_history")
                    upd:Update("item_received", 1)
                    upd:Where("id", tonumber(row.id))
                    upd:Execute()
                end
            end
        end
    )
    mysql:RawQuery(
        "SELECT * FROM `impulse_auction_history` WHERE `credits_received` = 0 AND (`actor_steamid` = '" .. escapedSid .. "' OR `seller_steamid` = '" .. escapedSid .. "')",
        function(results)
            if not IsValid(ply) then return end
            if type(results) ~= "table" then return end
            local totalCredits = 0
            local ids          = {}
            for _, row in ipairs(results) do
                local eventType = tonumber(row.event_type)
                local amount    = tonumber(row.amount) or 0
                local isSeller  = row.seller_steamid == sid
                local isActor   = row.actor_steamid == sid
                if eventType == 1 and isSeller then
                    local payout = tonumber(row.seller_payout) or 0
                    if payout > 0 then
                        ply:GiveMoney(payout)
                        ply:Notify("You collected " .. payout .. " credits from your auction sale.")
                    end
                    local upd = mysql:Update("impulse_auction_history")
                    upd:Update("credits_received", 1)
                    upd:Where("id", tonumber(row.id))
                    upd:Execute()
                elseif (eventType == 0 and isActor and tonumber(row.was_outbid) == 1) or (eventType == 2 and isActor) then
                    totalCredits = totalCredits + amount
                    table.insert(ids, tonumber(row.id))
                end
            end
            if totalCredits > 0 then
                ply:GiveMoney(totalCredits)
                ply:Notify("You collected " .. totalCredits .. " credits in bid refunds.")
                for _, id in ipairs(ids) do
                    local upd = mysql:Update("impulse_auction_history")
                    upd:Update("credits_received", 1)
                    upd:Where("id", id)
                    upd:Execute()
                end
            end
        end
    )
end
hook.Add("PlayerSpawn", "AuctionHouse_PendingNotify", function(ply)
    if not IsValid(ply) then return end
    local sid = ply:SteamID()
    timer.Simple(3, function()
        if not IsValid(ply) then return end
        local t = ply:Team()
        if t ~= TEAM_CWU and t ~= TEAM_CITIZEN and t ~= TEAM_VORT then return end
        local escapedSid = mysql:Escape(sid)
        mysql:RawQuery(
            "SELECT `id` FROM `impulse_auction_history` WHERE ((`event_type` = 0 AND `was_outbid` = 1 AND `credits_received` = 0 AND `actor_steamid` = '" .. escapedSid .. "') OR (`event_type` = 1 AND `item_received` = 0 AND `actor_steamid` = '" .. escapedSid .. "') OR (`event_type` = 1 AND `credits_received` = 0 AND `seller_steamid` = '" .. escapedSid .. "') OR (`event_type` = 2 AND `item_received` = 0 AND `seller_steamid` = '" .. escapedSid .. "') OR (`event_type` = 2 AND `credits_received` = 0 AND `actor_steamid` = '" .. escapedSid .. "'))",
            function(results)
                if not IsValid(ply) then return end
                if type(results) == "table" and #results > 0 then
                    ply:Notify("You have " .. #results .. " pending auction pickup(s). Visit the Auction House to collect.")
                    for _, ent in ipairs(ents.FindByClass("impulse_auctionhouse")) do
                        if IsValid(ent) then
                            ent.PendingNotifications[sid] = true
                            net.Start("AuctionHouse_ShowNotification")
                            net.WriteEntity(ent)
                            net.Send(ply)
                        end
                    end
                end
            end
        )
    end)
end)