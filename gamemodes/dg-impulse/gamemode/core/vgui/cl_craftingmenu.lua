local PANEL = {}

function PANEL:Init()
	self:SetSize(780, 610)
	self:Center()
	self:SetTitle("")
	self:MakePopup()
end

local bodyCol = Color(50, 50, 50, 210)
function PANEL:SetupCrafting()
	local lp = LocalPlayer()

	local trace = {}
	trace.start = lp:EyePos()
	trace.endpos = trace.start + lp:GetAimVector() * 120
	trace.filter = lp

	local tr = util.TraceLine(trace)

	if not tr.Entity or not IsValid(tr.Entity) or tr.Entity:GetClass() != "impulse_bench" then
		return self:Remove()
	end

	self.bench = tr.Entity

	local benchType = tr.Entity:GetBenchType()
	local benchClass = impulse.Inventory.Benches[benchType]
	local panel = self

	self:SetTitle(benchClass.Name)

	self.upper = vgui.Create("DPanel", self)
	self.upper:SetTall(40)
	self.upper:Dock(TOP)
	self.upper:DockMargin(0, 0, 0, 5)

	function self.upper:Paint(w, h)
		return true
	end

	self.mixes = {}

	self.craftLbl = vgui.Create("DLabel", self.upper)
	self.craftLbl:SetPos(5, 5)
	self.craftLbl:SetFont("Impulse-Elements22-Shadow")
	self.craftLbl:SetText("Crafting Level: "..LocalPlayer():GetSkillLevel("craft"))
	self.craftLbl:SizeToContents()

	self.tabContainer = vgui.Create("DPanel", self)
	self.tabContainer:SetTall(35)
	self.tabContainer:Dock(TOP)
	self.tabContainer:DockMargin(0, 0, 0, 5)

	function self.tabContainer:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 210))
	end

	local level = LocalPlayer():GetSkillLevel("craft")
	local mix = impulse.Inventory.Mixtures[benchType]
	local categories = {}
	local categoryMixes = {}
	local allMixes = {}

	local function findItemByUniqueID(uniqueID)
		for id, itemData in pairs(impulse.Inventory.Items) do
			if itemData.UniqueID == uniqueID then
				return itemData
			end
		end
		return nil
	end

	for v, k in pairs(mix) do
		if k.isSpecial and !k.isSpecial[LocalPlayer():SteamID()] then continue end

		table.insert(allMixes, k)

		if k.Multi then
			-- Multi-output mixes always go into Scrapping
			if not categories["Scrapping"] then
				categories["Scrapping"] = true
				categoryMixes["Scrapping"] = {}
			end
			table.insert(categoryMixes["Scrapping"], k)
		else
			local item = findItemByUniqueID(k.Output)
			if item and item.Category then
				local category = item.Category

				if not categories[category] then
					categories[category] = true
					categoryMixes[category] = {}
				end

				table.insert(categoryMixes[category], k)
			else
				if not categories["Misc"] then
					categories["Misc"] = true
					categoryMixes["Misc"] = {}
				end
				--print("Misc: " .. tostring(k.Class) .. " | Output: " .. tostring(k.Output))
				table.insert(categoryMixes["Misc"], k)
			end
		end
	end

	if categoryMixes["Misc"] and table.Count(categoryMixes["Misc"]) == 0 then
		categories["Misc"] = nil
		categoryMixes["Misc"] = nil
	end

	local sortedCategories = {}
	local numCategories = 0
	for cat, _ in pairs(categories) do
		table.insert(sortedCategories, cat)
		numCategories = numCategories + 1
	end
	table.sort(sortedCategories)

	local showTabs = numCategories > 1

	if showTabs then
		table.insert(sortedCategories, 1, "All")
	end

	self.tabs = {}
	self.activeTab = nil

	if showTabs then
		self.tabScroll = vgui.Create("DHorizontalScroller", self.tabContainer)
		self.tabScroll:Dock(FILL)
		self.tabScroll:SetOverlap(-2)

		local padding = 10
		surface.SetFont("Impulse-Elements18-Shadow")

		for i, category in ipairs(sortedCategories) do
			local textWidth = surface.GetTextSize(category)
			local buttonWidth = math.max(60, textWidth + padding * 2)

			local tab = vgui.Create("DButton")
			tab:SetSize(buttonWidth, 30)
			tab:SetText(category)
			tab:SetFont("Impulse-Elements18-Shadow")
			tab.category = category
			tab.panel = self

			function tab:Paint(w, h)
				local bgCol = self.panel.activeTab == self and Color(70, 70, 70, 210) or Color(50, 50, 50, 210)
				draw.RoundedBox(4, 0, 0, w, h, bgCol)
				return false
			end

			function tab:DoClick()
				self.panel:SwitchTab(self.category)
			end

			self.tabs[category] = tab
			self.tabScroll:AddPanel(tab)
		end
	else
		self.tabContainer:Hide()
	end

	self.contentContainer = vgui.Create("DPanel", self)
	self.contentContainer:Dock(FILL)

	function self.contentContainer:Paint()
		return true
	end

	self.scrollPanels = {}

	local categoriesToCreate = showTabs and sortedCategories or {"All"}

	for _, category in ipairs(categoriesToCreate) do
		local scroll = vgui.Create("DScrollPanel", self.contentContainer)
		scroll:Dock(FILL)
		scroll:Hide()

		local availibleMixes = vgui.Create("DCollapsibleCategory", scroll)
		availibleMixes:SetLabel("Unlocked mixes")
		availibleMixes:Dock(TOP)

		function availibleMixes:Paint()
			self:SetBGColor(colInv)
		end

		local availibleMixesLayout = vgui.Create("DListLayout")
		availibleMixesLayout:Dock(FILL)
		availibleMixes:SetContents(availibleMixesLayout)

		local unAvailibleMixes = scroll:Add("DCollapsibleCategory")
		unAvailibleMixes:SetLabel("Locked mixes")
		unAvailibleMixes:Dock(TOP)

		function unAvailibleMixes:Paint()
			self:SetBGColor(colInv)
		end

		local unAvailibleMixesLayout = vgui.Create("DListLayout")
		unAvailibleMixesLayout:Dock(FILL)
		unAvailibleMixes:SetContents(unAvailibleMixesLayout)

		local mixesToShow = category == "All" and allMixes or (categoryMixes[category] or {})

		table.sort(mixesToShow, function(a, b)
			return a.Level < b.Level
		end)

		for v, k in pairs(mixesToShow) do
			local cat = availibleMixesLayout

			if level < k.Level then
				cat = unAvailibleMixesLayout
			end

			local mixItem = cat:Add("impulseCraftingItem")
			mixItem:Dock(TOP)
			mixItem:SetMix(k)
			mixItem.dad = self

			table.insert(self.mixes, mixItem)
		end

		self.scrollPanels[category] = scroll
	end

	if showTabs then
		self:SwitchTab("All")
	else
		self.scrollPanels["All"]:Show()
	end
end

function PANEL:SwitchTab(category)
	self.activeTab = self.tabs[category]

	for cat, scroll in pairs(self.scrollPanels) do
		scroll:Hide()
	end

	if self.scrollPanels[category] then
		self.scrollPanels[category]:Show()
	end
end

function PANEL:Think()
	if self.bench and (not IsValid(self.bench) or self.bench:GetPos():DistToSqr(LocalPlayer():GetPos()) > (120 ^ 2)) then
		return self:Remove()
	end

	if not LocalPlayer():Alive() or LocalPlayer():IsCP() then
		return self:Remove()
	end

	if LocalPlayer():GetSyncVar(SYNC_ARRESTED, false) then
		return self:Remove()
	end

	if self.IsCrafting and input.IsKeyDown(KEY_SPACE) then
        self:OnCraftCancel()
    end
end

function PANEL:ShowNormal(should)
	if should then
		if self.scrollPanels and self.activeTab then
			self.scrollPanels[self.activeTab.category]:Show()
		elseif self.scrollPanels and self.scrollPanels["All"] then
			self.scrollPanels["All"]:Show()
		end
		self.craftLbl:Show()
		self.upper:Show()
		if self.tabContainer then
			self.tabContainer:Show()
		end
		self.contentContainer:Show()
	else
		if self.scrollPanels then
			for cat, scroll in pairs(self.scrollPanels) do
				scroll:Hide()
			end
		end
		self.craftLbl:Hide()
		self.upper:Hide()
		if self.tabContainer then
			self.tabContainer:Hide()
		end
		self.contentContainer:Hide()
	end
end

function PANEL:PaintOver(w, h)
	if self.IsCrafting then
		draw.SimpleText("Scrapping "..self.CraftingItem.."...", "Impulse-Elements22-Shadow", w / 2, 380, color_white, TEXT_ALIGN_CENTER)
	end
end

function PANEL:DoCraft(item, mix)
	local wide = self:GetWide()
	local panel = self
	local length = impulse.Inventory.GetCraftingTime(mix)

	self:ShowNormal(false)
	self:ShowCloseButton(false)
	self.IsCrafting = true
	self.CraftingItem = item.Name

	-- For multi-output mixes, show "Scrapping X..." instead of "Crafting X..."
	if mix.Multi then
		function self:PaintOver(w, h)
			if self.IsCrafting then
				draw.SimpleText("Scrapping "..self.CraftingItem.."...", "Impulse-Elements22-Shadow", w / 2, 380, color_white, TEXT_ALIGN_CENTER)
			end
		end
	else
		function self:PaintOver(w, h)
			if self.IsCrafting then
				draw.SimpleText("Crafting "..self.CraftingItem.."...", "Impulse-Elements22-Shadow", w / 2, 380, color_white, TEXT_ALIGN_CENTER)
			end
		end
	end

	self.craftBar = vgui.Create("DProgress", self)
	self.craftBar:SetPos((wide / 2) - 300, 410)
	self.craftBar:SetSize(600, 38)
	self.craftBar:SetFraction(0.5)
	self.StartTime = CurTime()
	self.EndTime = CurTime() + length

	function self.craftBar:Think()
		local timeDist = panel.EndTime - CurTime()
		local progress = math.Clamp(((panel.StartTime - CurTime()) / (panel.StartTime - panel.EndTime)), 0, 1)

		self:SetFraction(progress)
		panel.model:SetColor(Color(255, 255, 255, progress * 255))

		if progress == 1 then
			panel:ShowNormal(true)
			panel:ShowCloseButton(true)
			panel.craftBar:Remove()
			panel.model:Remove()
			panel.IsCrafting = false
			if IsValid(panel.cancelLabel) then panel.cancelLabel:Remove() end

			timer.Simple(0.2, function()
				if IsValid(panel) then
					for v,k in pairs(panel.mixes) do
						if IsValid(k) then
							k:RefreshCanCraft()
						end
					end
				end
			end)
		end
	end

	function self:OnCraftCancel()
	    if not self.IsCrafting then return end
	    self.IsCrafting = false
	    self:ShowNormal(true)
	    self:ShowCloseButton(true)

	    if IsValid(self.craftBar) then self.craftBar:Remove() end
	    if IsValid(self.model) then self.model:Remove() end
	    if IsValid(self.cancelLabel) then self.cancelLabel:Remove() end  -- add this

	    net.Start("impulseCancelCraft")
	    net.SendToServer()
	end

	self.cancelLabel = vgui.Create("DLabel", self)
	self.cancelLabel:SetPos((wide / 2) - 300, 452)
	self.cancelLabel:SetSize(600, 20)
	self.cancelLabel:SetText("Press SPACE to cancel")
	self.cancelLabel:SetFont("Impulse-Elements16")
	self.cancelLabel:SetContentAlignment(5)

	self.model = vgui.Create("DModelPanel", self)
	self.model:SetPaintBackground(false)
	self.model:SetPos((wide / 2) - 150, 100)
	self.model:SetSize(300, 300)
	self.model:SetMouseInputEnabled(true)
	self.model:SetModel(item.Model)
	self.model:SetSkin(item.Skin or 0)
	self.model:SetFOV(item.FOV or 35)
	self.model:SetCursor("none")

	function self.model:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 90, 0))

		if item.Material then
			ent:SetMaterial(item.Material)
		end

		if not item.NoCenter then
			self:SetLookAt(Vector(0, 0, 0))
		end
	end

	function self.model:Think()
		if self.Entity and IsValid(self.Entity) and not self.Entity.rmSet then
			self.Entity:SetRenderMode(RENDERMODE_TRANSCOLOR)
			self.Entity.rmSet = true
		end
	end

	local camPos = self.model.Entity:GetPos()
	camPos:Add(Vector(0, 25, 25))

	local min, max = self.model.Entity:GetRenderBounds()

	if item.CamPos then
		self.model:SetCamPos(item.CamPos)
	else
		self.model:SetCamPos(camPos - Vector(10, 0, 16))
	end

	self.model:SetLookAt((max + min) / 2)
end

vgui.Register("impulseCraftingMenu", PANEL, "DFrame")