local PANEL = {}

local grey = Color(209, 209, 209)
local darkHeader = Color(30, 30, 30, 200)
local filterBar = Color(40, 40, 40, 210)
local dropdownBg = Color(50, 50, 50, 210)
local searchCursor = Color(100, 100, 100)
local bankGreen = Color(100, 200, 100)

local function formatMoney(amount)
    local formatted = tostring(math.floor(amount))
    local result = ""
    local count = 0
    for i = #formatted, 1, -1 do
        if count > 0 and count % 3 == 0 then
            result = "," .. result
        end
        result = formatted:sub(i, i) .. result
        count = count + 1
    end
    return result
end

function PANEL:Init()
    local sw, sh = ScrW(), ScrH()
    local w = math.min(1094, sw - 5)
    local h = math.min(734, sh - 5)
    self:SetSize(w, h)
    self:Center()
    self:SetTitle("Storage")
    self:MakePopup()

    self:SetupItems()
end

function PANEL:Think()
	local lp = LocalPlayer()
	local isCollab = lp:IsCollaborator()
	local maxInv = isCollab and impulse.Config.InventoryMaxWeightCOLLABORATOR or impulse.Config.InventoryMaxWeight
	local maxStorage = lp:GetMaxGroupInventoryStorage()

	if self._cachedInvWeight ~= self.invWeight or self._cachedMaxInv ~= maxInv then
		self._cachedInvWeight = self.invWeight
		self._cachedMaxInv = maxInv
		self._invWeightStr = (self.invWeight or 0) .. "kg/" .. maxInv .. "kg"
	end

	if self._cachedStorageWeight ~= self.storageWeight or self._cachedMaxStorage ~= maxStorage then
		self._cachedStorageWeight = self.storageWeight
		self._cachedMaxStorage = maxStorage
		self._storageWeightStr = (self.storageWeight or 0) .. "kg/" .. maxStorage .. "kg"
	end
end

function PANEL:PaintOver(w, h)
	draw.SimpleText("You", "Impulse-Elements23-Shadow", 5, 30, grey)
	if self._invWeightStr then
		draw.SimpleText(self._invWeightStr, "Impulse-Elements18-Shadow", (w / 2) - 5, 35, grey, TEXT_ALIGN_RIGHT)
	end

	draw.SimpleText("Storage", "Impulse-Elements23-Shadow", w - 5, 30, grey, TEXT_ALIGN_RIGHT)
	if self._storageWeightStr then
		draw.SimpleText(self._storageWeightStr, "Impulse-Elements18-Shadow", (w / 2) + 5, 35, grey, TEXT_ALIGN_LEFT)
	end
end

function PANEL:SetupItems(invscroll, storescroll)
	local sw = ScrW()
	local w, h = self:GetSize()

	local preservedCategory = self.currentCategory or "All"
	local preservedSearch = self.searchText or ""
	local preservedInvScroll = 0
	local preservedStorageScroll = 0

	if IsValid(self.invScroll) then
		preservedInvScroll = self.invScroll:GetVBar():GetScroll()
	end
	if IsValid(self.invStorageScroll) then
		preservedStorageScroll = self.invStorageScroll:GetVBar():GetScroll()
	end

	if self.tabContainer and IsValid(self.tabContainer) then self.tabContainer:Remove() end
	if self.bankPanel and IsValid(self.bankPanel) then self.bankPanel:Remove() end
	if self.invScroll and IsValid(self.invScroll) then self.invScroll:Remove() end
	if self.invStorageScroll and IsValid(self.invStorageScroll) then self.invStorageScroll:Remove() end

	local bankBalance = (impulse.Group.Groups[1] and impulse.Group.Groups[1].GroupBank) or 0
	local prefix = impulse.Config.CurrencyPrefix

	local categories = {}
	local localInv = table.Copy(impulse.Inventory.Data[0][1]) or {}
	local localInvStorage = table.Copy(impulse.Inventory.Group.Data[0][3]) or {}

	for v, k in pairs(localInv) do
		local itemData = impulse.Inventory.Items[k.id]
		if itemData and itemData.Category then categories[itemData.Category] = true end
	end
	for v, k in pairs(localInvStorage) do
		local itemData = impulse.Inventory.Items[k.id]
		if itemData and itemData.Category then categories[itemData.Category] = true end
	end

	local sortedCategories = {}
	local numCategories = 0
	for cat, _ in pairs(categories) do
		table.insert(sortedCategories, cat)
		numCategories = numCategories + 1
	end
	table.sort(sortedCategories)

	local showFilter = numCategories > 1
	if sw > 900 and showFilter then
		table.insert(sortedCategories, 1, "All") 
	end

	self.currentCategory = preservedCategory
	self.searchText = preservedSearch

	self.tabContainer = vgui.Create("DPanel", self)
	self.tabContainer:SetTall(35)
	self.tabContainer:SetPos(0, 55)
	self.tabContainer:SetSize(w, 35)
	function self.tabContainer:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, filterBar)
	end

	-- Bank balance label
	self.bankBalLabel = vgui.Create("DLabel", self.tabContainer)
	self.bankBalLabel:SetText("Bank: " .. prefix .. " " .. formatMoney(bankBalance))
	self.bankBalLabel:SetFont("Impulse-Elements18-Shadow")
	self.bankBalLabel:SetTextColor(bankGreen)
	self.bankBalLabel:SetPos(10, 8)
	self.bankBalLabel:SizeToContents()

	-- Deposit
local depositEntry = vgui.Create("DTextEntry", self.tabContainer)
depositEntry:SetPos(150, 6)
depositEntry:SetSize(100, 22)
depositEntry:SetNumeric(true)
depositEntry:SetPlaceholderText("Deposit...")

local depositBtn = vgui.Create("DButton", self.tabContainer)
depositBtn:SetText("Deposit")
depositBtn:SetPos(255, 6)
depositBtn:SetSize(70, 22)
function depositBtn:DoClick()
    local num = tonumber(depositEntry:GetValue())
    if not num or num < 1 then return end
    net.Start("impulseGroupATMDeposit")
    net.WriteUInt(math.floor(num), 32)
    net.SendToServer()
    depositEntry:SetValue("")
end

-- Withdraw
local withdrawEntry = vgui.Create("DTextEntry", self.tabContainer)
withdrawEntry:SetPos(335, 6)
withdrawEntry:SetSize(100, 22)
withdrawEntry:SetNumeric(true)
withdrawEntry:SetPlaceholderText("Withdraw...")

local withdrawBtn = vgui.Create("DButton", self.tabContainer)
withdrawBtn:SetText("Withdraw")
withdrawBtn:SetPos(440, 6)
withdrawBtn:SetSize(70, 22)
function withdrawBtn:DoClick()
    local num = tonumber(withdrawEntry:GetValue())
    if not num or num < 1 then return end
    net.Start("impulseGroupATMWithdraw")
    net.WriteUInt(math.floor(num), 32)
    net.SendToServer()
    withdrawEntry:SetValue("")
end

	if sw > 900 and showFilter then
		local searchLabel = vgui.Create("DLabel", self.tabContainer)
		searchLabel:SetPos(w - 520, 8)
		searchLabel:SetFont("Impulse-Elements18-Shadow")
		searchLabel:SetText("Filter:")
		searchLabel:SetTextColor(grey)
		searchLabel:SizeToContents()

		self.categoryDropdown = vgui.Create("DComboBox", self.tabContainer)
		self.categoryDropdown:SetPos(w - 460, 5)
		self.categoryDropdown:SetSize(200, 25)
		self.categoryDropdown:SetValue(preservedCategory)
		self.categoryDropdown:SetFont("Impulse-Elements18-Shadow")
		self.categoryDropdown.panel = self
		function self.categoryDropdown:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, dropdownBg)
			return false
		end
		function self.categoryDropdown:OnSelect(index, value, data)
			self.panel:SwitchCategory(value)
		end
		for i, category in ipairs(sortedCategories) do
			self.categoryDropdown:AddChoice(category)
		end
	end

	local searchLabel2 = vgui.Create("DLabel", self.tabContainer)
	searchLabel2:SetPos(w - 250, 8)
	searchLabel2:SetFont("Impulse-Elements18-Shadow")
	searchLabel2:SetText("Search:")
	searchLabel2:SetTextColor(grey)
	searchLabel2:SizeToContents()

	self.searchBar = vgui.Create("DTextEntry", self.tabContainer)
	self.searchBar:SetPos(w - 190, 5)
	self.searchBar:SetSize(180, 25)
	self.searchBar:SetFont("Impulse-Elements18-Shadow")
	self.searchBar:SetPlaceholderText("Item name...")
	self.searchBar:SetValue(preservedSearch)
	self.searchBar.panel = self
	self.searchBar.lastValue = preservedSearch
	function self.searchBar:Paint(pw, ph)
		draw.RoundedBox(4, 0, 0, pw, ph, dropdownBg)
		self:DrawTextEntryText(grey, searchCursor, grey)
	end
	function self.searchBar:Think()
		local currentValue = self:GetValue()
		if currentValue ~= self.lastValue then
			self.lastValue = currentValue
			self.panel.searchText = string.lower(currentValue)
			self.panel:PopulateInventories()
		end
	end
	--[[
	else
		self.tabContainer:Hide() ]]--

	local topOffset = 90
	local panelWidth = (w - 8) / 2

	self.invScroll = vgui.Create("DScrollPanel", self)
	self.invScroll:SetPos(0, topOffset)
	self.invScroll:SetSize(panelWidth, h - topOffset)

	self.invStorageScroll = vgui.Create("DScrollPanel", self)
	self.invStorageScroll:SetPos(panelWidth + 8, topOffset)
	self.invStorageScroll:SetSize(panelWidth, h - topOffset)

	self.items = {}
	self.itemPanels = {}
	self.itemsStorage = {}
	self.itemPanelsStorage = {}

	self:PopulateInventories()

	if invscroll then
		self.invScroll:GetVBar():AnimateTo(invscroll, 0)
		self.invStorageScroll:GetVBar():AnimateTo(storescroll, 0)
	else
		timer.Simple(0, function()
			if IsValid(self) and IsValid(self.invScroll) and IsValid(self.invStorageScroll) then
				self.invScroll:GetVBar():SetScroll(preservedInvScroll)
				self.invStorageScroll:GetVBar():SetScroll(preservedStorageScroll)
			end
		end)
	end
end

function PANEL:PopulateInventories()
	local preservedInvScroll = 0
	local preservedStorageScroll = 0

	if IsValid(self.invScroll) then preservedInvScroll = self.invScroll:GetVBar():GetScroll() end
	if IsValid(self.invStorageScroll) then preservedStorageScroll = self.invStorageScroll:GetVBar():GetScroll() end

	self.invScroll:Clear()
	self.invStorageScroll:Clear()
	self.items = {}
	self.itemsStorage = {}

	local w = self:GetWide()
	local invWeight = 0
	local storageWeight = 0
	local localInv = table.Copy(impulse.Inventory.Data[0][1]) or {}
	local localInvStorage = table.Copy(impulse.Inventory.Group.Data[0][3]) or {}
	local reccurTemp = {}
	local sortMethod = impulse.GetSetting("inv_sortweight", "Inventory only")
	local invertSort = true

	for v, k in pairs(localInv) do
		k.realKey = v
		if sortMethod == "Always" or sortMethod == "Containers only" then
			reccurTemp[k.id] = (reccurTemp[k.id] or 0) + (impulse.Inventory.Items[k.id].Weight or 0)
			k.sortWeight = reccurTemp[k.id]
		else
			k.sortWeight = impulse.Inventory.Items[k.id].Name
			invertSort = false
		end
	end

	reccurTemp = {}
	for v, k in pairs(localInvStorage) do
		k.realKey = v
		if sortMethod == "Always" or sortMethod == "Containers only" then
			reccurTemp[k.id] = (reccurTemp[k.id] or 0) + (impulse.Inventory.Items[k.id].Weight or 0)
			k.sortWeight = reccurTemp[k.id]
		else
			k.sortWeight = impulse.Inventory.Items[k.id].Name
			invertSort = false
		end
	end

	if localInv and table.Count(localInv) > 0 then
		for v, k in SortedPairsByMemberValue(localInv, "sortWeight", invertSort) do
			local itemX = impulse.Inventory.Items[k.id]
			local categoryMatch = self.currentCategory == "All" or (itemX.Category == self.currentCategory)
			local searchMatch = (not self.searchText or self.searchText == "") or string.find(string.lower(itemX.Name), self.searchText, 1, true)
			if categoryMatch and searchMatch then
				local otherItem = self.items[k.id]
				if itemX.CanStack and otherItem then
					otherItem.Count = (otherItem.Count or 1) + 1
				else
					local item = self.invScroll:Add("deepInventoryItem")
					item:Dock(TOP)
					item:DockMargin(0, 0, 0, 5)
					item.Basic = true
					item.Type = 1
					item:SetItem(k, w)
					item.InvID = k.realKey
					item.InvPanel = self
					self.items[k.id] = item
				end
			end
			invWeight = invWeight + (itemX.Weight or 0)
		end
	else
		self.empty = self.invScroll:Add("DLabel", self)
		self.empty:SetContentAlignment(5)
		self.empty:Dock(TOP)
		self.empty:SetText("Empty")
		self.empty:SetFont("Impulse-Elements19-Shadow")
		self.empty:SetTextColor(grey)
	end

	if localInvStorage and table.Count(localInvStorage) > 0 then
		for v, k in SortedPairsByMemberValue(localInvStorage, "sortWeight", invertSort) do
			local itemX = impulse.Inventory.Items[k.id]
			local categoryMatch = self.currentCategory == "All" or (itemX.Category == self.currentCategory)
			local searchMatch = (not self.searchText or self.searchText == "") or string.find(string.lower(itemX.Name), self.searchText, 1, true)
			if categoryMatch and searchMatch then
				local otherItem = self.itemsStorage[k.id]
				if itemX.CanStack and otherItem then
					otherItem.Count = (otherItem.Count or 1) + 1
				else
					local item = self.invStorageScroll:Add("deepInventoryItem")
					item:Dock(TOP)
					item:DockMargin(0, 0, 0, 5)
					item.Basic = true
					item.Type = 3
					item:SetItem(k, w)
					item.InvID = k.realKey
					item.InvPanel = self
					self.itemsStorage[k.id] = item
				end
			end
			storageWeight = storageWeight + (itemX.Weight or 0)
		end
	else
		self.empty = self.invStorageScroll:Add("DLabel", self)
		self.empty:SetContentAlignment(5)
		self.empty:Dock(TOP)
		self.empty:SetText("Empty")
		self.empty:SetFont("Impulse-Elements19-Shadow")
		self.empty:SetTextColor(grey)
	end

	self.invWeight = invWeight
	self.storageWeight = storageWeight

	timer.Simple(0, function()
		if IsValid(self) and IsValid(self.invScroll) and IsValid(self.invStorageScroll) then
			self.invScroll:GetVBar():SetScroll(preservedInvScroll)
			self.invStorageScroll:GetVBar():SetScroll(preservedStorageScroll)
		end
	end)
end

function PANEL:SwitchCategory(category)
	self.currentCategory = category
	self:PopulateInventories()
end

vgui.Register("deepGroupInventory", PANEL, "DFrame")