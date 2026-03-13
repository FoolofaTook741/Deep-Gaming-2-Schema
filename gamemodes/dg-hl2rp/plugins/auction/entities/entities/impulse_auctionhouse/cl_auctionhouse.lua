local grey        = Color(209, 209, 209)
local darkBg      = Color(30, 30, 30, 230)
local panelBg     = Color(40, 40, 40, 210)
local panelBg2    = Color(50, 50, 50, 210)
local accentColor = Color(180, 140, 60)
local green       = Color(80, 200, 100)
local red         = Color(200, 80, 80)
local white       = Color(255, 255, 255)
local TAB_BROWSE  = 1
local TAB_SELL    = 2
local TAB_MYAUCTS = 3
local DURATION_OPTIONS = {
    { label = "2 Minutes", hours = 0   },
    { label = "2 Hours",   hours = 2   },
    { label = "8 Hours",   hours = 8   },
    { label = "1 Day",     hours = 24  },
    { label = "3 Days",    hours = 72  },
    { label = "7 Days",    hours = 168 },
}
local DEPOSIT_RATE    = 0.02
local SALE_FEE_RATE   = 0.06
local function FormatCredits(n)
    n = math.floor(n or 0)
    return tostring(n) .. "cr"
end
local function MakeButton(parent, x, y, w, h, text, col, textCol)
    local btn = vgui.Create("DButton", parent)
    btn:SetPos(x, y)
    btn:SetSize(w, h)
    btn:SetText("")
    btn.label   = text
    btn.col     = col     or panelBg2
    btn.textCol = textCol or grey
    function btn:Paint(bw, bh)
        local bg = self.hovered and Color(self.col.r + 20, self.col.g + 20, self.col.b + 20, self.col.a) or self.col
        draw.RoundedBox(4, 0, 0, bw, bh, bg)
        draw.SimpleText(self.label, "Impulse-Elements18-Shadow", bw / 2, bh / 2, self.textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function btn:OnCursorEntered() self.hovered = true  end
    function btn:OnCursorExited()  self.hovered = false end
    return btn
end
local ITEMS_PER_PAGE = 25

local function MakePageBar(parent, x, y, w, h, panel, pageKey, populateFn)
    local bar = vgui.Create("DPanel", parent)
    bar:SetPos(x, y)
    bar:SetSize(w, h)
    function bar:Paint(bw, bh)
        draw.RoundedBox(0, 0, 0, bw, bh, panelBg)
    end
    function bar:Rebuild(currentPage, totalPages)
        bar:Clear()
        local barW  = bar:GetWide()
        local btnW  = 28
        local cx    = math.floor(barW / 2)
        local prevBtn = MakeButton(bar, cx - 90, 4, btnW, h - 8, "<", panelBg2, grey)
        prevBtn.DoClick = function()
            if panel[pageKey] > 1 then
                panel[pageKey] = panel[pageKey] - 1
                panel[populateFn](panel)
            end
        end
        local nextBtn = MakeButton(bar, cx + 62, 4, btnW, h - 8, ">", panelBg2, grey)
        nextBtn.DoClick = function()
            if panel[pageKey] < totalPages then
                panel[pageKey] = panel[pageKey] + 1
                panel[populateFn](panel)
            end
        end
        local pageLabel = vgui.Create("DLabel", bar)
        pageLabel:SetPos(cx - 60, 0)
        pageLabel:SetSize(120, h)
        pageLabel:SetFont("Impulse-Elements18-Shadow")
        pageLabel:SetTextColor(grey)
        pageLabel:SetText("Page " .. currentPage .. " / " .. math.max(1, totalPages))
        pageLabel:SetContentAlignment(5)
    end
    return bar
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(1200, 734)
    self:Center()
    self:SetTitle("Auction House")
    self:MakePopup()
    self.currentTab = TAB_BROWSE
    self:BuildChrome()
    self:SwitchTab(TAB_BROWSE)
    self:RequestBrowseData()
end
function PANEL:BuildChrome()
    local w = self:GetWide()
    self.tabBar = vgui.Create("DPanel", self)
    self.tabBar:SetPos(0, 25)
    self.tabBar:SetSize(w, 35)
    function self.tabBar:Paint(tw, th)
        draw.RoundedBox(0, 0, 0, tw, th, panelBg)
    end
    local tabs = {
        { id = TAB_BROWSE,  label = "Browse Auctions" },
        { id = TAB_SELL,    label = "Sell Item"        },
        { id = TAB_MYAUCTS, label = "My Auctions"      },
    }
    local tabW = 180
    local tabH = 28
    local startX = 8
    self.tabButtons = {}
    for i, t in ipairs(tabs) do
        local tid  = t.id
        local btn  = vgui.Create("DButton", self.tabBar)
        btn:SetPos(startX + (i - 1) * (tabW + 4), 4)
        btn:SetSize(tabW, tabH)
        btn:SetText("")
        btn.panel  = self
        btn.tabID  = tid
        function btn:Paint(bw, bh)
            local active = self.panel.currentTab == self.tabID
            local bg = active and accentColor or (self.hovered and panelBg2 or Color(35, 35, 35, 210))
            draw.RoundedBox(4, 0, 0, bw, bh, bg)
            local tc = active and Color(20, 20, 20) or grey
            draw.SimpleText(t.label, "Impulse-Elements18-Shadow", bw / 2, bh / 2, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        function btn:DoClick()
            self.panel:SwitchTab(self.tabID)
        end
        function btn:OnCursorEntered() self.hovered = true  end
        function btn:OnCursorExited()  self.hovered = false end
        self.tabButtons[tid] = btn
    end
end
function PANEL:SwitchTab(tabID)
    self.currentTab = tabID
    if IsValid(self.tabContent) then
        self.tabContent:Remove()
    end
    local w, h = self:GetSize()
    self.tabContent = vgui.Create("DPanel", self)
    self.tabContent:SetPos(0, 60)
    self.tabContent:SetSize(w, h - 60)
    function self.tabContent:Paint() end
    if tabID == TAB_BROWSE  then self:BuildBrowseTab()  end
    if tabID == TAB_SELL    then self:BuildSellTab()    end
    if tabID == TAB_MYAUCTS then self:BuildMyAuctions() self:RequestMyAuctions() end
end
function PANEL:BuildBrowseTab()
    local p   = self.tabContent
    local w   = p:GetWide()
    local h   = p:GetTall()
    local filterRow = vgui.Create("DPanel", p)
    filterRow:SetPos(0, 0)
    filterRow:SetSize(w, 36)
    function filterRow:Paint(fw, fh)
        draw.RoundedBox(0, 0, 0, fw, fh, Color(40, 40, 40, 210))
    end
    local searchLabel = vgui.Create("DLabel", filterRow)
    searchLabel:SetPos(8, 9)
    searchLabel:SetFont("Impulse-Elements18-Shadow")
    searchLabel:SetText("Search:")
    searchLabel:SetTextColor(grey)
    searchLabel:SizeToContents()
    self.browseSearch = vgui.Create("DTextEntry", filterRow)
    self.browseSearch:SetPos(70, 5)
    self.browseSearch:SetSize(200, 26)
    self.browseSearch:SetFont("Impulse-Elements18-Shadow")
    self.browseSearch:SetPlaceholderText("Item name...")
    self.browseSearch.lastVal = ""
    function self.browseSearch:Paint(bw, bh)
        draw.RoundedBox(4, 0, 0, bw, bh, panelBg2)
        self:DrawTextEntryText(grey, Color(100, 100, 100), grey)
    end
    local panel = self
    function self.browseSearch:Think()
        local v = self:GetValue()
        if v ~= self.lastVal then
            self.lastVal = v
            panel.browsePage = 1
            panel:PopulateBrowseList()
        end
    end
    local catLabel = vgui.Create("DLabel", filterRow)
    catLabel:SetPos(284, 9)
    catLabel:SetFont("Impulse-Elements18-Shadow")
    catLabel:SetText("Category:")
    catLabel:SetTextColor(grey)
    catLabel:SizeToContents()
    self.categoryFilter = vgui.Create("DComboBox", filterRow)
    self.categoryFilter:SetPos(360, 5)
    self.categoryFilter:SetSize(170, 26)
    self.categoryFilter:SetFont("Impulse-Elements18-Shadow")
    self.categoryFilter:SetValue("All")
    self.categoryFilter.panel = self
    self.browseCategory = "All"
    function self.categoryFilter:Paint(dw, dh)
        draw.RoundedBox(4, 0, 0, dw, dh, panelBg2)
        return false
    end
    function self.categoryFilter:OnSelect(idx, value)
        self.panel.browseCategory = value
        self.panel.browsePage = 1
        self.panel:PopulateBrowseList()
    end
    self:RebuildCategoryDropdown()
    local sortLabel = vgui.Create("DLabel", filterRow)
    sortLabel:SetPos(544, 9)
    sortLabel:SetFont("Impulse-Elements18-Shadow")
    sortLabel:SetText("Sort:")
    sortLabel:SetTextColor(grey)
    sortLabel:SizeToContents()
    self.sortDropdown = vgui.Create("DComboBox", filterRow)
    self.sortDropdown:SetPos(584, 5)
    self.sortDropdown:SetSize(180, 26)
    self.sortDropdown:SetFont("Impulse-Elements18-Shadow")
    self.sortDropdown:SetValue("Time Remaining")
    self.sortDropdown.panel = self
    function self.sortDropdown:Paint(dw, dh)
        draw.RoundedBox(4, 0, 0, dw, dh, panelBg2)
        return false
    end
    for _, v in ipairs({ "Time Remaining", "Price: Low→High", "Price: High→Low", "Name A→Z" }) do
        self.sortDropdown:AddChoice(v)
    end
    function self.sortDropdown:OnSelect(idx, value)
        self.panel.browsePage = 1
        self.panel:SortBrowseList(value)
    end
    local refreshBtn = MakeButton(filterRow, w - 110, 5, 100, 26, "⟳  Refresh", accentColor, Color(20, 20, 20))
    refreshBtn.DoClick = function() panel:RequestBrowseData() end
    local headerH = 26
    local colPanel = vgui.Create("DPanel", p)
    colPanel:SetPos(0, 36)
    colPanel:SetSize(w, headerH)
    function colPanel:Paint(cw, ch)
        draw.RoundedBox(0, 0, 0, cw, ch, Color(35, 35, 35, 220))
    end
    local cols = {
        { label = "Item",           x = 10  },
        { label = "Seller",         x = 360 },
        { label = "Current Bid",    x = 530 },
        { label = "Buyout",         x = 670 },
        { label = "Time Left",      x = 800 },
        { label = "Bids",           x = 940 },
    }
    for _, col in ipairs(cols) do
        local lbl = vgui.Create("DLabel", colPanel)
        lbl:SetPos(col.x, 4)
        lbl:SetFont("Impulse-Elements18-Shadow")
        lbl:SetText(col.label)
        lbl:SetTextColor(accentColor)
        lbl:SizeToContents()
    end
    local pageBarH = 34
    self.browseScroll = vgui.Create("DScrollPanel", p)
    self.browseScroll:SetPos(0, 62)
    self.browseScroll:SetSize(w, h - 62 - pageBarH)
    self.browseScroll.rowW = w - 16
    self.browsePage = self.browsePage or 1
    self.browsePageBar = MakePageBar(p, 0, h - pageBarH, w, pageBarH, self, "browsePage", "PopulateBrowseList")
    self:PopulateBrowseList()
end
function PANEL:RebuildCategoryDropdown()
    if not IsValid(self.categoryFilter) then return end
    local categories = {}
    for _, auc in ipairs(self.auctionData or {}) do
        local cat = auc.item_category or "Misc"
        categories[cat] = true
    end
    local sorted = {}
    for cat in pairs(categories) do
        table.insert(sorted, cat)
    end
    table.sort(sorted)
    table.insert(sorted, 1, "All")
    for i, v in ipairs(sorted) do
        if v == "Misc" and i ~= #sorted then
            table.remove(sorted, i)
            table.insert(sorted, "Misc")
            break
        end
    end
    self.categoryFilter:Clear()
    for _, cat in ipairs(sorted) do
        self.categoryFilter:AddChoice(cat)
    end
    self.categoryFilter:SetValue(self.browseCategory or "All")
end
function PANEL:PopulateBrowseList()
    if not IsValid(self.browseScroll) then return end
    self.browseScroll:Clear()
    local auctions = self.auctionData or {}
    local search   = (self.browseSearch and string.lower(self.browseSearch:GetValue())) or ""
    local category = self.browseCategory or "All"
    if #auctions == 0 then
        local empty = self.browseScroll:Add("DLabel")
        empty:Dock(TOP)
        empty:SetContentAlignment(5)
        empty:SetTall(40)
        empty:SetText("No auctions found.")
        empty:SetFont("Impulse-Elements19-Shadow")
        empty:SetTextColor(grey)
        if IsValid(self.browsePageBar) then self.browsePageBar:Rebuild(1, 1) end
        return
    end
    local filtered = {}
    for _, auc in ipairs(auctions) do
        local itemName = string.lower(auc.item_name or "")
        local itemCat  = auc.item_category or "Misc"
        local matchSearch   = search == "" or string.find(itemName, search, 1, true)
        local matchCategory = category == "All" or itemCat == category
        if matchSearch and matchCategory then
            table.insert(filtered, auc)
        end
    end
    if #filtered == 0 then
        local empty = self.browseScroll:Add("DLabel")
        empty:Dock(TOP)
        empty:SetContentAlignment(5)
        empty:SetTall(40)
        empty:SetText("No auctions match your filters.")
        empty:SetFont("Impulse-Elements19-Shadow")
        empty:SetTextColor(grey)
        if IsValid(self.browsePageBar) then self.browsePageBar:Rebuild(1, 1) end
        return
    end
    local isSearching = search ~= ""
    if isSearching then
        for _, auc in ipairs(filtered) do
            self:AddBrowseRow(auc)
        end
        if IsValid(self.browsePageBar) then self.browsePageBar:Rebuild(1, 1) end
    else
        local totalPages = math.ceil(#filtered / ITEMS_PER_PAGE)
        self.browsePage  = math.Clamp(self.browsePage or 1, 1, totalPages)
        local startIdx   = (self.browsePage - 1) * ITEMS_PER_PAGE + 1
        local endIdx     = math.min(startIdx + ITEMS_PER_PAGE - 1, #filtered)
        for i = startIdx, endIdx do
            self:AddBrowseRow(filtered[i])
        end
        if IsValid(self.browsePageBar) then self.browsePageBar:Rebuild(self.browsePage, totalPages) end
    end
end
function PANEL:AddBrowseRow(auc)
    local rowW = self.browseScroll.rowW or 1060
    local row = self.browseScroll:Add("DPanel")
    row:Dock(TOP)
    row:DockMargin(2, 0, 2, 3)
    row:SetTall(52)
    row.auc     = auc
    row.hovered = false
    function row:Paint(rw, rh)
        local isHighBidder = self.auc.i_am_high_bidder
        local bg
        if isHighBidder then
            bg = self.hovered and Color(40, 75, 55, 230) or Color(30, 60, 45, 220)
        else
            bg = self.hovered and Color(55, 55, 55, 220) or Color(45, 45, 45, 200)
        end
        draw.RoundedBox(4, 0, 0, rw, rh, bg)
        if isHighBidder then
            draw.RoundedBox(4, 0, 0, 4, rh, green)
        end
        draw.SimpleText(self.auc.item_name or "Unknown Item", "Impulse-Elements19-Shadow", 10,  rh / 2, white,       TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(self.auc.seller_name or "Unknown",    "Impulse-Elements18-Shadow", 360, rh / 2, grey,        TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local bidText = self.auc.current_bid and FormatCredits(self.auc.current_bid) or "No bids"
        local bidCol  = isHighBidder and green or ((self.auc.current_bid and self.auc.current_bid > 0) and green or grey)
        draw.SimpleText(bidText, "Impulse-Elements18-Shadow", 530, rh / 2, bidCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if isHighBidder then
            draw.SimpleText("[winning]", "Impulse-Elements18-Shadow", 530, rh / 2 + 14, Color(80, 200, 120), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        local buyText = self.auc.buyout_price and FormatCredits(self.auc.buyout_price) or "—"
        draw.SimpleText(buyText, "Impulse-Elements18-Shadow", 670, rh / 2, accentColor,  TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local timeLeft = (self.auc.expires_at or 0) - os.time()
        local timeStr  = timeLeft > 0 and string.NiceTime(timeLeft) or "Expired"
        local timeCol  = timeLeft < 3600 and red or grey
        draw.SimpleText(timeStr, "Impulse-Elements18-Shadow", 800, rh / 2, timeCol,      TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self.auc.bid_count or 0), "Impulse-Elements18-Shadow", 940, rh / 2, grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    function row:OnCursorEntered() self.hovered = true  end
    function row:OnCursorExited()  self.hovered = false end
    local panel = self
    if auc.buyout_price then
        local buyoutBtn = MakeButton(row, 990, 10, 90, 32, "Buyout", Color(60, 160, 60), white)
        buyoutBtn.DoClick = function() panel:PromptBuyout(auc) end
    end
    local bidBtn = MakeButton(row, 1090, 10, 80, 32, "Bid", accentColor, Color(20, 20, 20))
    bidBtn.DoClick = function() panel:PromptBid(auc) end
end
function PANEL:SortBrowseList(method)
    if not self.auctionData then return end
    if method == "Time Remaining" then
        table.sort(self.auctionData, function(a, b) return (a.expires_at or 0) < (b.expires_at or 0) end)
    elseif method == "Price: Low→High" then
        table.sort(self.auctionData, function(a, b) return (a.current_bid or 0) < (b.current_bid or 0) end)
    elseif method == "Price: High→Low" then
        table.sort(self.auctionData, function(a, b) return (a.current_bid or 0) > (b.current_bid or 0) end)
    elseif method == "Name A→Z" then
        table.sort(self.auctionData, function(a, b) return (a.item_name or "") < (b.item_name or "") end)
    end
    self:PopulateBrowseList()
end
function PANEL:PromptBid(auc)
    if IsValid(self.popup) then self.popup:Remove() end
    local pop = vgui.Create("DFrame", self)
    pop:SetSize(360, 220)
    pop:Center()
    pop:SetTitle("Place Bid — " .. (auc.item_name or "Item"))
    pop:MakePopup()
    self.popup = pop
    function pop:Paint(pw, ph)
        draw.RoundedBox(6, 0, 0, pw, ph, darkBg)
        draw.RoundedBox(6, 0, 0, pw, 24, panelBg)
    end
    local minBid = math.max((auc.current_bid or 0) + 1, (auc.starting_bid or 1))
    local infoLbl = vgui.Create("DLabel", pop)
    infoLbl:SetPos(14, 34)
    infoLbl:SetSize(332, 20)
    infoLbl:SetFont("Impulse-Elements18-Shadow")
    infoLbl:SetTextColor(grey)
    infoLbl:SetText("Minimum bid: " .. FormatCredits(minBid))
    local entry = vgui.Create("DTextEntry", pop)
    entry:SetPos(14, 62)
    entry:SetSize(332, 32)
    entry:SetFont("Impulse-Elements19-Shadow")
    entry:SetPlaceholderText("Enter bid amount...")
    entry:SetNumeric(true)
    function entry:Paint(ew, eh)
        draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
        self:DrawTextEntryText(white, Color(100, 180, 100), white)
    end
    local feeLbl = vgui.Create("DLabel", pop)
    feeLbl:SetPos(14, 104)
    feeLbl:SetSize(332, 18)
    feeLbl:SetFont("Impulse-Elements18-Shadow")
    feeLbl:SetTextColor(grey)
    feeLbl:SetText("You will be charged when the auction ends if you win.")
    local panel = self
    local confirmBtn = MakeButton(pop, 14, 136, 156, 32, "Confirm Bid", green, Color(20, 20, 20))
    confirmBtn.DoClick = function()
        local amount = tonumber(entry:GetValue()) or 0
        if amount < minBid then
            feeLbl:SetText("Bid must be at least " .. FormatCredits(minBid) .. "!")
            feeLbl:SetTextColor(red)
            return
        end
        net.Start("AuctionHouse_PlaceBid")
        net.WriteUInt(auc.id, 32)
        net.WriteUInt(amount, 32)
        net.SendToServer()
        pop:Remove()
    end
    local cancelBtn = MakeButton(pop, 180, 136, 156, 32, "Cancel", red, white)
    cancelBtn.DoClick = function() pop:Remove() end
    if auc.reserve_met == false then
        local resLbl = vgui.Create("DLabel", pop)
        resLbl:SetPos(14, 178)
        resLbl:SetSize(332, 18)
        resLbl:SetFont("Impulse-Elements18-Shadow")
        resLbl:SetTextColor(Color(220, 180, 60))
        resLbl:SetText("⚠ Reserve price not yet met.")
    end
end
function PANEL:PromptBuyout(auc)
    if IsValid(self.popup) then self.popup:Remove() end
    local pop = vgui.Create("DFrame", self)
    pop:SetSize(360, 180)
    pop:Center()
    pop:SetTitle("Confirm Buyout — " .. (auc.item_name or "Item"))
    pop:MakePopup()
    self.popup = pop
    function pop:Paint(pw, ph)
        draw.RoundedBox(6, 0, 0, pw, ph, darkBg)
        draw.RoundedBox(6, 0, 0, pw, 24, panelBg)
    end
    local fee     = math.floor((auc.buyout_price or 0) * SALE_FEE_RATE)
    local total   = (auc.buyout_price or 0)
    local lbl = vgui.Create("DLabel", pop)
    lbl:SetPos(14, 34)
    lbl:SetSize(332, 50)
    lbl:SetFont("Impulse-Elements18-Shadow")
    lbl:SetTextColor(grey)
    lbl:SetText(
        "Buyout price: " .. FormatCredits(total) .. "\n" ..
        "You will receive the item immediately."
    )
    lbl:SetWrap(true)
    local panel = self
    local confirmBtn = MakeButton(pop, 14, 120, 156, 32, "Buy Now  " .. FormatCredits(total), green, Color(20, 20, 20))
    confirmBtn.DoClick = function()
        net.Start("AuctionHouse_Buyout")
        net.WriteUInt(auc.id, 32)
        net.SendToServer()
        panel.pendingBuyoutID = auc.id
        pop:Remove()
    end
    local cancelBtn = MakeButton(pop, 180, 120, 156, 32, "Cancel", red, white)
    cancelBtn.DoClick = function() pop:Remove() end
end
function PANEL:BuildSellTab()
    local p = self.tabContent
    local w = p:GetWide()
    local h = p:GetTall()
    local leftW = math.floor(w * 0.45)
    local leftPanel = vgui.Create("DPanel", p)
    leftPanel:SetPos(0, 0)
    leftPanel:SetSize(leftW, h)
    function leftPanel:Paint(lw, lh)
        draw.RoundedBox(0, 0, 0, lw, lh, panelBg)
    end
    local invLabel = vgui.Create("DLabel", leftPanel)
    invLabel:SetPos(10, 8)
    invLabel:SetFont("Impulse-Elements19-Shadow")
    invLabel:SetTextColor(grey)
    invLabel:SetText("Select item from your inventory:")
    invLabel:SizeToContents()
    self.sellItemScroll = vgui.Create("DScrollPanel", leftPanel)
    self.sellItemScroll:SetPos(4, 34)
    self.sellItemScroll:SetSize(leftW - 8, h - 38)
    self:PopulateSellItemList()
    local rightX = leftW + 8
    local rightW = w - rightX
    local rightPanel = vgui.Create("DPanel", p)
    rightPanel:SetPos(rightX, 0)
    rightPanel:SetSize(rightW, h)
    function rightPanel:Paint(rw, rh)
        draw.RoundedBox(0, 0, 0, rw, rh, panelBg)
    end
    local formY = 10
    local labelX = 14
    local selLabel = vgui.Create("DLabel", rightPanel)
    selLabel:SetPos(labelX, formY)
    selLabel:SetFont("Impulse-Elements19-Shadow")
    selLabel:SetTextColor(accentColor)
    selLabel:SetText("Listing Details")
    selLabel:SizeToContents()
    formY = formY + 30
    self.sellSelectedItem = vgui.Create("DLabel", rightPanel)
    self.sellSelectedItem:SetPos(labelX, formY)
    self.sellSelectedItem:SetFont("Impulse-Elements18-Shadow")
    self.sellSelectedItem:SetTextColor(grey)
    self.sellSelectedItem:SetText("No item selected.")
    self.sellSelectedItem:SizeToContents()
    formY = formY + 30
    local durLabel = vgui.Create("DLabel", rightPanel)
    durLabel:SetPos(labelX, formY)
    durLabel:SetFont("Impulse-Elements18-Shadow")
    durLabel:SetTextColor(grey)
    durLabel:SetText("Duration:")
    durLabel:SizeToContents()
    formY = formY + 22
    self.durationCombo = vgui.Create("DComboBox", rightPanel)
    self.durationCombo:SetPos(labelX, formY)
    self.durationCombo:SetSize(rightW - 28, 28)
    self.durationCombo:SetFont("Impulse-Elements18-Shadow")
    self.durationCombo:SetSortItems(false)
    self.durationCombo:SetValue(DURATION_OPTIONS[1].label)
    self.selectedDuration = DURATION_OPTIONS[1].hours
    function self.durationCombo:Paint(dw, dh)
        draw.RoundedBox(4, 0, 0, dw, dh, panelBg2)
        return false
    end
    local panel = self
    function self.durationCombo:OnSelect(idx, value, data)
        panel.selectedDuration = data
    end
    for _, opt in ipairs(DURATION_OPTIONS) do
        self.durationCombo:AddChoice(opt.label, opt.hours)
    end
    formY = formY + 36
    local sbLabel = vgui.Create("DLabel", rightPanel)
    sbLabel:SetPos(labelX, formY)
    sbLabel:SetFont("Impulse-Elements18-Shadow")
    sbLabel:SetTextColor(grey)
    sbLabel:SetText("Starting Bid (credits):")
    sbLabel:SizeToContents()
    formY = formY + 22
    self.startBidEntry = vgui.Create("DTextEntry", rightPanel)
    self.startBidEntry:SetPos(labelX, formY)
    self.startBidEntry:SetSize(rightW - 28, 28)
    self.startBidEntry:SetFont("Impulse-Elements18-Shadow")
    self.startBidEntry:SetPlaceholderText("e.g. 50")
    self.startBidEntry:SetNumeric(true)
    function self.startBidEntry:Paint(ew, eh)
        draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
        self:DrawTextEntryText(white, Color(100, 100, 100), white)
    end
    formY = formY + 36
    local resLabel = vgui.Create("DLabel", rightPanel)
    resLabel:SetPos(labelX, formY)
    resLabel:SetFont("Impulse-Elements18-Shadow")
    resLabel:SetTextColor(grey)
    resLabel:SetText("Reserve Price (optional, leave blank for none):")
    resLabel:SizeToContents()
    formY = formY + 22
    self.reserveEntry = vgui.Create("DTextEntry", rightPanel)
    self.reserveEntry:SetPos(labelX, formY)
    self.reserveEntry:SetSize(rightW - 28, 28)
    self.reserveEntry:SetFont("Impulse-Elements18-Shadow")
    self.reserveEntry:SetPlaceholderText("Hidden minimum bid...")
    self.reserveEntry:SetNumeric(true)
    function self.reserveEntry:Paint(ew, eh)
        draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
        self:DrawTextEntryText(white, Color(100, 100, 100), white)
    end
    formY = formY + 36
    local boLabel = vgui.Create("DLabel", rightPanel)
    boLabel:SetPos(labelX, formY)
    boLabel:SetFont("Impulse-Elements18-Shadow")
    boLabel:SetTextColor(grey)
    boLabel:SetText("Buyout Price (optional, leave blank for bid-only):")
    boLabel:SizeToContents()
    formY = formY + 22
    self.buyoutEntry = vgui.Create("DTextEntry", rightPanel)
    self.buyoutEntry:SetPos(labelX, formY)
    self.buyoutEntry:SetSize(rightW - 28, 28)
    self.buyoutEntry:SetFont("Impulse-Elements18-Shadow")
    self.buyoutEntry:SetPlaceholderText("Instant purchase price...")
    self.buyoutEntry:SetNumeric(true)
    function self.buyoutEntry:Paint(ew, eh)
        draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
        self:DrawTextEntryText(white, Color(100, 100, 100), white)
    end
    formY = formY + 42
    local qtyLabel = vgui.Create("DLabel", rightPanel)
    qtyLabel:SetPos(labelX, formY)
    qtyLabel:SetFont("Impulse-Elements18-Shadow")
    qtyLabel:SetTextColor(grey)
    qtyLabel:SetText("Quantity:")
    qtyLabel:SizeToContents()
    formY = formY + 22
    local qtyRowW = (rightW - 28)
    local halfW   = math.floor((qtyRowW - 8) / 2)
    self.stackQtyEntry = vgui.Create("DTextEntry", rightPanel)
    self.stackQtyEntry:SetPos(labelX, formY)
    self.stackQtyEntry:SetSize(halfW, 28)
    self.stackQtyEntry:SetFont("Impulse-Elements18-Shadow")
    self.stackQtyEntry:SetPlaceholderText("Qty (e.g. 3)")
    self.stackQtyEntry:SetNumeric(true)
    self.stackQtyEntry:SetValue("1")
    function self.stackQtyEntry:Paint(ew, eh)
        draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
        self:DrawTextEntryText(white, Color(100, 100, 100), white)
    end
    local qtyHintLabel = vgui.Create("DLabel", rightPanel)
    qtyHintLabel:SetPos(labelX + halfW + 8, formY + 6)
    qtyHintLabel:SetFont("Impulse-Elements18-Shadow")
    qtyHintLabel:SetTextColor(grey)
    qtyHintLabel:SetText("items per auction  (max: —)")
    qtyHintLabel:SizeToContents()
    self.qtyHintLabel = qtyHintLabel
    formY = formY + 36
    self.feeSummaryLabel = vgui.Create("DLabel", rightPanel)
    self.feeSummaryLabel:SetPos(labelX, formY)
    self.feeSummaryLabel:SetSize(rightW - 28, 40)
    self.feeSummaryLabel:SetFont("Impulse-Elements18-Shadow")
    self.feeSummaryLabel:SetTextColor(grey)
    self.feeSummaryLabel:SetText("Deposit: — cr  |  Sale fee on success: 6% of final price")
    self.feeSummaryLabel:SetWrap(true)
    formY = formY + 50
    local feeLabel = self.feeSummaryLabel
    local sbEntry  = self.startBidEntry
    local function updateFee()
        local sb   = tonumber(sbEntry:GetValue()) or 0
        local res  = tonumber(panel.reserveEntry:GetValue()) or 0
        local bo   = tonumber(panel.buyoutEntry:GetValue()) or 0
        local base
        if bo > 0 then
            base = bo
        elseif res > 0 then
            base = res
        else
            base = sb
        end
        local deposit = math.max(1, math.floor(base * DEPOSIT_RATE + 0.5))
        feeLabel:SetText(
            "Deposit (refunded if sold): " .. FormatCredits(deposit) ..
            "  |  Sale fee on success: 6% of final price"
        )
    end
    self.startBidEntry.lastVal = ""
    function self.startBidEntry:Think()
        local v = self:GetValue()
        if v ~= self.lastVal then
            self.lastVal = v
            updateFee()
        end
    end
    self.reserveEntry.lastVal = ""
    function self.reserveEntry:Think()
        local v = self:GetValue()
        if v ~= self.lastVal then
            self.lastVal = v
            updateFee()
        end
    end
    self.buyoutEntry.lastVal = ""
    function self.buyoutEntry:Think()
        local v = self:GetValue()
        if v ~= self.lastVal then
            self.lastVal = v
            updateFee()
        end
    end
    local postBtn = MakeButton(rightPanel, labelX, formY, rightW - 28, 36, "Post Auction", accentColor, Color(20, 20, 20))
    postBtn.panel = self
    postBtn.DoClick = function()
        self:SubmitListing()
    end
    self.sellErrorLabel = vgui.Create("DLabel", rightPanel)
    self.sellErrorLabel:SetPos(labelX, formY + 44)
    self.sellErrorLabel:SetSize(rightW - 28, 20)
    self.sellErrorLabel:SetFont("Impulse-Elements18-Shadow")
    self.sellErrorLabel:SetTextColor(red)
    self.sellErrorLabel:SetText("")
end
function PANEL:PopulateSellItemList()
    if not IsValid(self.sellItemScroll) then return end
    self.sellItemScroll:Clear()
    self.selectedRow = nil
    local inv = table.Copy(impulse.Inventory.Data[0][1]) or {}
    if table.Count(inv) == 0 then
        local empty = self.sellItemScroll:Add("DLabel")
        empty:Dock(TOP)
        empty:SetTall(36)
        empty:SetContentAlignment(5)
        empty:SetText("Your inventory is empty.")
        empty:SetFont("Impulse-Elements18-Shadow")
        empty:SetTextColor(grey)
        return
    end
    local seen = {}
    for key, entry in pairs(inv) do
        if not entry.restricted then
            local itemData = impulse.Inventory.Items[entry.id]
            if itemData then
                local uid = itemData.UniqueID or entry.class
                if itemData.CanStack and seen[uid] then
                    seen[uid].stackCount = seen[uid].stackCount + 1
                else
                    seen[uid] = {
                        itemData   = itemData,
                        itemEntry  = entry,
                        invKey     = key,
                        stackCount = 1,
                        canStack   = itemData.CanStack or false,
                    }
                end
            end
        end
    end
    for uid, data in pairs(seen) do
        local row = self.sellItemScroll:Add("DButton")
        row:Dock(TOP)
        row:DockMargin(2, 0, 2, 3)
        row:SetTall(44)
        row:SetText("")
        row.selected   = false
        row.hovered    = false
        row.itemEntry  = data.itemEntry
        row.itemData   = data.itemData
        row.invKey     = data.invKey
        row.stackCount = data.stackCount
        row.canStack   = data.canStack
        row.panel      = self
        function row:Paint(rw, rh)
            local bg
            if self.selected then
                bg = Color(80, 140, 80, 230)
            elseif self.hovered then
                bg = panelBg2
            else
                bg = Color(45, 45, 45, 200)
            end
            draw.RoundedBox(4, 0, 0, rw, rh, bg)
            local nameStr = self.itemData.Name or "Unknown"
            if self.stackCount > 1 then
                nameStr = self.stackCount .. "x " .. nameStr
            end
            draw.SimpleText(nameStr, "Impulse-Elements18-Shadow", 10, rh / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            local cat = self.itemData.Category or "Misc"
            draw.SimpleText("[" .. cat .. "]", "Impulse-Elements18-Shadow", rw - 10, rh / 2, grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        function row:OnCursorEntered() self.hovered = true  end
        function row:OnCursorExited()  self.hovered = false end
        function row:DoClick()
            if IsValid(self.panel.selectedRow) then
                self.panel.selectedRow.selected = false
            end
            self.selected = true
            self.panel.selectedRow        = self
            self.panel.selectedSellItem   = self.itemData
            self.panel.selectedSellKey    = self.invKey
            self.panel.selectedSellEntry  = self.itemEntry
            self.panel.selectedStackCount = self.stackCount
            self.panel.selectedCanStack   = self.canStack
            if IsValid(self.panel.sellSelectedItem) then
                local nameStr = self.itemData.Name or "Unknown"
                if self.stackCount > 1 then
                    nameStr = self.stackCount .. "x " .. nameStr
                end
                self.panel.sellSelectedItem:SetText("Selected: " .. nameStr)
                self.panel.sellSelectedItem:SizeToContents()
            end
            if IsValid(self.panel.sellErrorLabel) then
                self.panel.sellErrorLabel:SetTextColor(grey)
                self.panel.sellErrorLabel:SetText("")
            end
            self.panel:UpdateQuantityFields()
        end
    end
end
function PANEL:UpdateQuantityFields()
    local count    = self.selectedStackCount or 1
    local canStack = self.selectedCanStack   or false
    if IsValid(self.stackQtyEntry) then
        if not canStack then
            self.stackQtyEntry:SetValue("1")
            self.stackQtyEntry:SetEditable(false)
            function self.stackQtyEntry:Paint(ew, eh)
                draw.RoundedBox(4, 0, 0, ew, eh, Color(35, 35, 35, 210))
                self:DrawTextEntryText(Color(120, 120, 120), Color(100, 100, 100), white)
            end
        else
            self.stackQtyEntry:SetEditable(true)
            function self.stackQtyEntry:Paint(ew, eh)
                draw.RoundedBox(4, 0, 0, ew, eh, panelBg2)
                self:DrawTextEntryText(white, Color(100, 100, 100), white)
            end
        end
    end
    if IsValid(self.qtyHintLabel) then
        self.qtyHintLabel:SetText("items per auction  (max: " .. count .. ")")
        self.qtyHintLabel:SizeToContents()
    end
end
function PANEL:SubmitListing()
    if self.sellPending then
        self.sellErrorLabel:SetTextColor(red)
        self.sellErrorLabel:SetText("Still waiting on a response, please wait.")
        return
    end
    local now = CurTime()
    if (now - (self.lastPostTime or 0)) < 3 then
        local remaining = math.ceil(3 - (now - self.lastPostTime))
        self.sellErrorLabel:SetTextColor(red)
        self.sellErrorLabel:SetText("Please wait " .. remaining .. " second(s) before posting again.")
        return
    end
    if not self.selectedSellItem then
        self.sellErrorLabel:SetText("Please select an item first.")
        return
    end
    local startBid = tonumber(self.startBidEntry:GetValue()) or 0
    if startBid < 1 then
        self.sellErrorLabel:SetText("Starting bid must be at least 1 credit.")
        return
    end
    local reserve = tonumber(self.reserveEntry:GetValue()) or nil
    if reserve and reserve <= startBid then
        self.sellErrorLabel:SetText("Reserve must be greater than the starting bid.")
        return
    end
    local buyout = tonumber(self.buyoutEntry:GetValue()) or nil
    if buyout and buyout < startBid then
        self.sellErrorLabel:SetText("Buyout must be greater than the starting bid.")
        return
    end
    local canStack = self.selectedCanStack   or false
    local maxQty   = self.selectedStackCount or 1
    local stackQty = canStack and (tonumber(self.stackQtyEntry:GetValue()) or 1) or 1
    if stackQty < 1 then
        self.sellErrorLabel:SetText("Quantity must be at least 1.")
        return
    end
    if stackQty > maxQty then
        self.sellErrorLabel:SetText("You only have " .. maxQty .. " of this item.")
        return
    end
    net.Start("AuctionHouse_PostListing")
    net.WriteString(self.selectedSellItem.UniqueID)
    net.WriteUInt(self.selectedSellKey, 16)
    net.WriteUInt(startBid, 32)
    net.WriteUInt(reserve or 0, 32)
    net.WriteUInt(buyout or 0, 32)
    net.WriteUInt(self.selectedDuration or 24, 16)
    net.WriteUInt(stackQty, 16)
    net.SendToServer()
    self.lastPostTime = CurTime()
    self.sellPending = true
    self.sellErrorLabel:SetTextColor(grey)
    self.sellErrorLabel:SetText("Submitting...")
    timer.Simple(8, function()
        if not IsValid(self) then return end
        if not self.sellPending then return end
        self.sellPending = false
        if IsValid(self.sellErrorLabel) then
            self.sellErrorLabel:SetTextColor(red)
            self.sellErrorLabel:SetText("No response from server. Please try again.")
        end
    end)
end
function PANEL:BuildMyAuctions()
    local p = self.tabContent
    local w = p:GetWide()
    local h = p:GetTall()
    local headerH = 26
    local colPanel = vgui.Create("DPanel", p)
    colPanel:SetPos(0, 0)
    colPanel:SetSize(w, headerH)
    function colPanel:Paint(cw, ch)
        draw.RoundedBox(0, 0, 0, cw, ch, Color(35, 35, 35, 220))
    end
    local cols = {
        { label = "Item",        x = 10  },
        { label = "Current Bid", x = 370 },
        { label = "Buyout",      x = 530 },
        { label = "Bids",        x = 680 },
        { label = "Time Left",   x = 780 },
        { label = "Status",      x = 940 },
    }
    for _, col in ipairs(cols) do
        local lbl = vgui.Create("DLabel", colPanel)
        lbl:SetPos(col.x, 4)
        lbl:SetFont("Impulse-Elements18-Shadow")
        lbl:SetText(col.label)
        lbl:SetTextColor(accentColor)
        lbl:SizeToContents()
    end
    local pageBarH = 34
    self.myAucScroll = vgui.Create("DScrollPanel", p)
    self.myAucScroll:SetPos(0, headerH)
    self.myAucScroll:SetSize(w, h - headerH - pageBarH)
    self.myAucScroll.rowW = w - 16
    self.myAucPage = self.myAucPage or 1
    self.myAucPageBar = MakePageBar(p, 0, h - pageBarH, w, pageBarH, self, "myAucPage", "PopulateMyAuctions")
    self:PopulateMyAuctions()
end
function PANEL:PopulateMyAuctions()
    if not IsValid(self.myAucScroll) then return end
    self.myAucScroll:Clear()
    local auctions = self.myAuctionData or {}
    if #auctions == 0 then
        local empty = self.myAucScroll:Add("DLabel")
        empty:Dock(TOP)
        empty:SetTall(40)
        empty:SetContentAlignment(5)
        empty:SetText("You have no active auctions.")
        empty:SetFont("Impulse-Elements19-Shadow")
        empty:SetTextColor(grey)
        if IsValid(self.myAucPageBar) then self.myAucPageBar:Rebuild(1, 1) end
        return
    end
    local totalPages = math.ceil(#auctions / ITEMS_PER_PAGE)
    self.myAucPage   = math.Clamp(self.myAucPage or 1, 1, totalPages)
    local startIdx   = (self.myAucPage - 1) * ITEMS_PER_PAGE + 1
    local endIdx     = math.min(startIdx + ITEMS_PER_PAGE - 1, #auctions)
    for i = startIdx, endIdx do
        self:AddMyAuctionRow(auctions[i])
    end
    if IsValid(self.myAucPageBar) then self.myAucPageBar:Rebuild(self.myAucPage, totalPages) end
end
function PANEL:AddMyAuctionRow(auc)
    local rowW = self.myAucScroll.rowW or 1060
    local row = self.myAucScroll:Add("DPanel")
    row:Dock(TOP)
    row:DockMargin(2, 0, 2, 3)
    row:SetTall(52)
    row.auc     = auc
    row.hovered = false
    local statusColors = {
        [0] = grey,
        [1] = green,
        [2] = red,
        [3] = Color(180, 180, 180),
    }
    local statusLabels = {
        [0] = "Active",
        [1] = "Sold",
        [2] = "Expired",
        [3] = "Cancelled",
    }
    function row:Paint(rw, rh)
        local bg = self.hovered and Color(55, 55, 55, 220) or Color(45, 45, 45, 200)
        draw.RoundedBox(4, 0, 0, rw, rh, bg)
        draw.SimpleText(self.auc.item_name or "Unknown", "Impulse-Elements19-Shadow", 10, rh / 2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(FormatCredits(self.auc.current_bid or 0), "Impulse-Elements18-Shadow", 370, rh / 2, (self.auc.current_bid or 0) > 0 and green or grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(self.auc.buyout_price and FormatCredits(self.auc.buyout_price) or "—", "Impulse-Elements18-Shadow", 530, rh / 2, accentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(self.auc.bid_count or 0), "Impulse-Elements18-Shadow", 680, rh / 2, grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local timeLeft = (self.auc.expires_at or 0) - os.time()
        local timeStr  = timeLeft > 0 and string.NiceTime(timeLeft) or "—"
        draw.SimpleText(timeStr, "Impulse-Elements18-Shadow", 780, rh / 2, timeLeft < 3600 and red or grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        local status = self.auc.status or 0
        draw.SimpleText(statusLabels[status] or "Unknown", "Impulse-Elements18-Shadow", 940, rh / 2, statusColors[status] or grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    function row:OnCursorEntered() self.hovered = true  end
    function row:OnCursorExited()  self.hovered = false end
    if (auc.status or 0) == 0 and (auc.bid_count or 0) == 0 then
        local panel = self
        local cancelBtn = MakeButton(row, 1075, 10, 96, 32, "Cancel", red, white)
        cancelBtn.DoClick = function()
            net.Start("AuctionHouse_CancelListing")
            net.WriteUInt(auc.id, 32)
            net.SendToServer()
        end
    end
end
function PANEL:RequestBrowseData()
    net.Start("AuctionHouse_RequestBrowse")
    net.SendToServer()
end
function PANEL:RequestMyAuctions()
    net.Start("AuctionHouse_RequestMine")
    net.SendToServer()
end
function PANEL:ReceiveBrowseData(data)
    self.auctionData = data
    self:RebuildCategoryDropdown()
    if self.currentTab == TAB_BROWSE then
        self:PopulateBrowseList()
    end
end
function PANEL:ReceiveMyAuctions(data)
    self.myAuctionData = data
    if self.currentTab == TAB_MYAUCTS then
        self:PopulateMyAuctions()
    end
end
function PANEL:ShowActionResult(success, message)
    local col = success and green or red
    if self.currentTab == TAB_SELL and IsValid(self.sellErrorLabel) then
        self.sellPending = false
        self.sellErrorLabel:SetTextColor(col)
        self.sellErrorLabel:SetText(message)
        if success then
            self:PopulateSellItemList()
            self.selectedSellItem  = nil
            self.selectedSellKey   = nil
            self.selectedSellEntry = nil
            if IsValid(self.sellSelectedItem) then
                self.sellSelectedItem:SetText("No item selected.")
                self.sellSelectedItem:SizeToContents()
            end
            self:RequestBrowseData()
        end
    elseif self.currentTab == TAB_MYAUCTS then
        if success then
            self:RequestMyAuctions()
        end
        LocalPlayer():ChatPrint(message)
    elseif self.currentTab == TAB_BROWSE then
        if success then
            if self.pendingBuyoutID and self.auctionData then
                for i = #self.auctionData, 1, -1 do
                    if self.auctionData[i].id == self.pendingBuyoutID then
                        table.remove(self.auctionData, i)
                        break
                    end
                end
                self.pendingBuyoutID = nil
                self:PopulateBrowseList()
            end
            timer.Simple(1, function()
                if IsValid(self) then
                    self:RequestBrowseData()
                end
            end)
        end
        LocalPlayer():ChatPrint(message)
    end
end
function PANEL:PaintOver(w, h)
    surface.SetDrawColor(accentColor.r, accentColor.g, accentColor.b, 80)
    surface.DrawRect(0, 59, w, 1)
end
vgui.Register("impulseAuctionHouse", PANEL, "DFrame")