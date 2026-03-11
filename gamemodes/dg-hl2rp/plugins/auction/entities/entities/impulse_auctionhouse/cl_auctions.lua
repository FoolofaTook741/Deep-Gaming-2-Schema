net.Receive("AuctionHouse_BrowseData", function()
    local json = net.ReadString()
    if not json or json == "" then return end

    local data = util.JSONToTable(json)
    if type(data) ~= "table" then return end

    if IsValid(impulse.AuctionHousePanel) then
        impulse.AuctionHousePanel:ReceiveBrowseData(data)
    end
end)

net.Receive("AuctionHouse_MyAuctions", function()
    local json = net.ReadString()
    if not json or json == "" then return end

    local data = util.JSONToTable(json)
    if type(data) ~= "table" then return end

    if IsValid(impulse.AuctionHousePanel) then
        impulse.AuctionHousePanel:ReceiveMyAuctions(data)
    end
end)

net.Receive("AuctionHouse_ActionResult", function()
    local success = net.ReadBool()
    local message = net.ReadString()

    if IsValid(impulse.AuctionHousePanel) then
        impulse.AuctionHousePanel:ShowActionResult(success, message)
    end
end)
