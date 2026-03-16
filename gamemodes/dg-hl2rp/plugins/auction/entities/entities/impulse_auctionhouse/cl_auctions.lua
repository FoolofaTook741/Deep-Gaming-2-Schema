local browseBuffer  = { total = 0, chunks = 0, received = {}, count = 0 }
local myAucBuffer   = { total = 0, chunks = 0, received = {}, count = 0 }
local saleHistBuf   = { total = 0, chunks = 0, received = {}, count = 0 }

local function tryFinalize(buf, callback)
    if buf.count < buf.chunks then return end
    local assembled = table.concat(buf.received)
    buf.total = 0; buf.chunks = 0; buf.received = {}; buf.count = 0
    local json = util.Decompress(assembled)
    if not json or json == "" then return end
    local data = util.JSONToTable(json)
    if type(data) ~= "table" then return end
    callback(data)
end

net.Receive("AuctionHouse_BrowseData", function()
    browseBuffer.total    = net.ReadUInt(32)
    browseBuffer.chunks   = net.ReadUInt(16)
    browseBuffer.received = {}
    browseBuffer.count    = 0
end)

net.Receive("AuctionHouse_BrowseDataChunk", function()
    local idx   = net.ReadUInt(16)
    local size  = net.ReadUInt(16)
    local chunk = net.ReadData(size)
    browseBuffer.received[idx] = chunk
    browseBuffer.count = browseBuffer.count + 1
    tryFinalize(browseBuffer, function(data)
        if IsValid(impulse.AuctionHousePanel) then
            impulse.AuctionHousePanel:ReceiveBrowseData(data)
        end
    end)
end)

net.Receive("AuctionHouse_MyAuctions", function()
    myAucBuffer.total    = net.ReadUInt(32)
    myAucBuffer.chunks   = net.ReadUInt(16)
    myAucBuffer.received = {}
    myAucBuffer.count    = 0
end)

net.Receive("AuctionHouse_MyAuctionsChunk", function()
    local idx   = net.ReadUInt(16)
    local size  = net.ReadUInt(16)
    local chunk = net.ReadData(size)
    myAucBuffer.received[idx] = chunk
    myAucBuffer.count = myAucBuffer.count + 1
    tryFinalize(myAucBuffer, function(data)
        if IsValid(impulse.AuctionHousePanel) then
            impulse.AuctionHousePanel:ReceiveMyAuctions(data)
        end
    end)
end)

net.Receive("AuctionHouse_SaleHistory", function()
    saleHistBuf.total    = net.ReadUInt(32)
    saleHistBuf.chunks   = net.ReadUInt(16)
    saleHistBuf.received = {}
    saleHistBuf.count    = 0
end)

net.Receive("AuctionHouse_SaleHistoryChunk", function()
    local idx   = net.ReadUInt(16)
    local size  = net.ReadUInt(16)
    local chunk = net.ReadData(size)
    saleHistBuf.received[idx] = chunk
    saleHistBuf.count = saleHistBuf.count + 1
    tryFinalize(saleHistBuf, function(data)
        if IsValid(impulse.AuctionHousePanel) then
            impulse.AuctionHousePanel:ReceiveSaleHistory(data)
        end
    end)
end)

net.Receive("AuctionHouse_ActionResult", function()
    local success = net.ReadBool()
    local message = net.ReadString()

    if IsValid(impulse.AuctionHousePanel) then
        impulse.AuctionHousePanel:ShowActionResult(success, message)
    end
end)