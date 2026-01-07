local PANEL = {}

function PANEL:Init()
	self:SetSize(900, 810)
	self:Center()
	self:SetTitle("ops support tools")
	self:MakePopup()

	local sheet = vgui.Create("DColumnSheet", self)
	sheet:Dock(FILL)

	local b = vgui.Create("DPanel", sheet)
	b:Dock(FILL)
	b.Paint = function() end

	local header = vgui.Create("DPanel", b)
	header:Dock(TOP)
	header:SetTall(110)
	header.Paint = function() end

	local lbl = vgui.Create("DLabel", header)
	lbl:SetText("Target (Steam64 ID):")
	lbl:SetFont("Impulse-Elements18")
	lbl:SetPos(0, 0)
	lbl:SizeToContents()

	local s64 = vgui.Create("DTextEntry", header)
	s64:SetFont("Impulse-Elements18")
	s64:SetPos(0, 20)
	s64:SetSize(900, 30)
	s64:SetPlaceholderText("Steam64 ID")

	local lblRefund = vgui.Create("DLabel", header)
	lblRefund:SetText("Refund:")
	lblRefund:SetFont("Impulse-Elements18")
	lblRefund:SetPos(0, 80)
	lblRefund:SizeToContents()

	local search = vgui.Create("DTextEntry", header)
	search:SetFont("Impulse-Elements18")
	search:SetPos(0, 55)
	search:SetSize(900, 24)
	search:SetUpdateOnType(true)
	search:SetPlaceholderText("Search items (name / uniqueID / category)...")

	local scroll = vgui.Create("DScrollPanel", b)
	scroll:Dock(TOP)
	scroll:SetTall(500)

	local refund = {}
	local refund2 = {}
	local cats = {}

	local catPanels = {}
	local allButtons = {}

	local function ApplyFilter()
		local q = string.lower(string.Trim(search:GetValue() or ""))

		for _, entry in ipairs(allButtons) do
			local item = entry.item
			local hay = string.lower((item.Name or "") .. " " .. (item.UniqueID or "") .. " " .. (item.Category or "Unknown"))
			local show = (q == "") or (string.find(hay, q, 1, true) ~= nil)

			entry.btn:SetVisible(show)
			entry.btn:InvalidateLayout(true)
		end

		for catName, list in pairs(cats) do
			local anyVisible = false
			for _, pnl in ipairs(list:GetItems() or {}) do
				if IsValid(pnl) and pnl:IsVisible() then
					anyVisible = true
					break
				end
			end

			local cat = catPanels[catName]
			if IsValid(cat) then
				cat:SetVisible(anyVisible)
				cat:InvalidateLayout(true)
			end
		end

		scroll:InvalidateLayout(true)

		timer.Simple(0, function()
			if not IsValid(scroll) then return end
			local vbar = scroll:GetVBar()
			if IsValid(vbar) then
				vbar:SetScroll(0)
			end
		end)
	end

	search.OnValueChange = ApplyFilter

	for _, k in pairs(impulse.Inventory.Items) do
		local catName = k.Category or "Unknown"

		if not cats[catName] then
			local cat = scroll:Add("DCollapsibleCategory")
			cat:Dock(TOP)
			cat:SetLabel(catName)
			cat:SetExpanded(false)

			catPanels[catName] = cat

			local list = vgui.Create("DPanelList", cat)
			list:Dock(FILL)
			list:SetSpacing(5)

			cat:SetContents(list)
			cats[catName] = list
		end

		local btn = vgui.Create("DButton")
		btn:SetText("  "..k.Name.." ("..k.UniqueID..")")
		btn:SetContentAlignment(4)
		btn:Dock(TOP)
		btn:SetFont("Impulse-Elements18")
		btn:DockMargin(0, 0, 0, 5)
		btn.ItemClass = k.UniqueID

		table.insert(allButtons, { btn = btn, item = k })

		function btn:DoClick()
			Derma_StringRequest("impulse", "Amount of "..k.Name.." to refund", "1", function(val)
				if not tonumber(val) then
					return LocalPlayer():Notify("Not a number.")
				end

				val = math.Clamp(math.floor(val), 0, 30)

				if val == 0 then
					refund[self.ItemClass] = nil

					for i, t in pairs(refund2) do
						if t[1] == self.ItemClass then
							refund2[i] = nil
						end
					end

					return LocalPlayer():Notify("Removed "..self.ItemClass)
				end

				for i, t in pairs(refund2) do
					if t[1] == self.ItemClass then
						refund2[i] = nil
					end
				end

				refund[self.ItemClass] = val
				table.insert(refund2, { self.ItemClass, val })

				LocalPlayer():Notify("Selected "..k.Name.." x"..val..".")
			end)
		end

		cats[catName]:AddItem(btn)
	end

	ApplyFilter()

	local bottom = vgui.Create("DPanel", b)
	bottom:Dock(FILL)
	bottom.Paint = function() end
	bottom:DockMargin(0, 8, 0, 0)

	local totalTitle = vgui.Create("DLabel", bottom)
	totalTitle:Dock(TOP)
	totalTitle:SetFont("Impulse-Elements18")
	totalTitle:SetText("Total:")
	totalTitle:DockMargin(0, 0, 0, 4)

	local totalLbl = vgui.Create("DLabel", bottom)
	totalLbl:Dock(TOP)
	totalLbl:SetFont("Impulse-Elements18")
	totalLbl:SetText("Nothing")
	totalLbl:SetContentAlignment(7)
	totalLbl:SetWrap(true)
	totalLbl:SetTall(70)

	function totalLbl:Think()
		local t = ""
		for _, it in pairs(refund2) do
			t = t .. it[1] .. " x" .. it[2] .. ", "
		end
		self:SetText(t ~= "" and t or "Nothing")
	end

	local confirm = vgui.Create("DButton", bottom)
	confirm:Dock(TOP)
	confirm:SetTall(60)
	confirm:DockMargin(0, 6, 0, 0)
	confirm:SetText("Issue Refund")

	function confirm:DoClick()
		local id = string.Trim(s64:GetValue(), " ")

		if id == "" or not tonumber(id) then
			return LocalPlayer():Notify("Invalid Steam64ID.")
		end

		if not refund2 or table.Count(refund2) < 1 then
			return LocalPlayer():Notify("No refund items selected.")
		end

		local data = pon.encode(refund)

		net.Start("impulseOpsSTDoRefund")
		net.WriteString(id)
		net.WriteUInt(#data, 32)
		net.WriteData(data, #data)
		net.SendToServer()
	end

	sheet:AddSheet("Refunder", b, "icon16/bricks.png")


	local b = vgui.Create("DPanel", sheet)
	b:Dock(FILL)
	b.Paint = function() end

	local header = vgui.Create("DPanel", b)
	header:Dock(TOP)
	header:SetTall(120)
	header.Paint = function() end

	local btn = vgui.Create("DButton", b)
	btn:Dock(TOP)
	btn:SetText("Enable OOC")

	function btn:DoClick()
		net.Start("impulseOpsSTDoOOCEnabled")
		net.WriteBool(true)
		net.SendToServer()
	end

	local btn = vgui.Create("DButton", b)
	btn:Dock(TOP)
	btn:SetText("Disable OOC")

	function btn:DoClick()
		net.Start("impulseOpsSTDoOOCEnabled")
		net.WriteBool(false)
		net.SendToServer()
	end

	sheet:AddSheet("Chat", b, "icon16/bricks.png")

	local b = vgui.Create("DPanel", sheet)
	b:Dock(FILL)
	b.Paint = function() end

	local scroll = vgui.Create("DScrollPanel", b)
	scroll:Dock(FILL)

	for v,k in pairs(impulse.Teams.Data) do
		local t = scroll:Add("DPanel")
		t:SetTall(60)
		t:Dock(TOP)

		function t:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 200))
		end

		local lbl = vgui.Create("DLabel", t)
		lbl:SetText(k.name.." (ID: "..v..") (Current players: "..#team.GetPlayers(v)..")")
		lbl:SetFont("Impulse-Elements18")
		lbl:SizeToContents()
		lbl:SetPos(5, 5)

		local btn = vgui.Create("DButton", t)
		btn:SetPos(5, 25)
		btn:SetSize(80, 25)
		btn:SetText("Lock Team")

		function btn:DoClick()
			net.Start("impulseOpsSTDoTeamLocked")
			net.WriteUInt(v, 8)
			net.WriteBool(true)
			net.SendToServer()
		end

		local btn = vgui.Create("DButton", t)
		btn:SetPos(90, 25)
		btn:SetSize(80, 25)
		btn:SetText("Unlock Team")

		function btn:DoClick()
			net.Start("impulseOpsSTDoTeamLocked")
			net.WriteUInt(v, 8)
			net.WriteBool(false)
			net.SendToServer()
		end
	end

	sheet:AddSheet("Teams", b, "icon16/bricks.png")

	local b = vgui.Create("DPanel", sheet)
	b:Dock(FILL)
	b.Paint = function() end

	local text = vgui.Create("DTextEntry", b)
	text:Dock(TOP)
	text:SetPlaceholderText("Enter group name (exactly)")

	local btn = vgui.Create("DButton", b)
	btn:Dock(TOP)
	btn:SetText("Remove Group")

	function btn:DoClick()
		Derma_Query("Are you sure you want to remove the "..text:GetValue().." group?", "impulse",
		"Remove", function()
			net.Start("impulseOpsSTDoGroupRemove")
			net.WriteString(text:GetValue())
			net.SendToServer()
		end, "Cancel")
	end

	sheet:AddSheet("Groups", b, "icon16/bricks.png")
	do
		local gsPanel = vgui.Create("DPanel", sheet)
		gsPanel:Dock(FILL)
		gsPanel.Paint = function() end

		local title = vgui.Create("DLabel", gsPanel)
		title:Dock(TOP)
		title:SetFont("Impulse-Elements18")
		title:SetText("Group Storage Control")
		title:DockMargin(0,0,0,10)

		local enableBtn = vgui.Create("DButton", gsPanel)
		enableBtn:Dock(TOP)
		enableBtn:SetText("Enable Group Storage")
		enableBtn:SetTall(40)
		enableBtn:DockMargin(0,0,0,5)
		function enableBtn:DoClick()
			net.Start("impulseOpsGroupStorage")
			net.WriteBool(true)
			net.SendToServer()
		end

		local disableBtn = vgui.Create("DButton", gsPanel)
		disableBtn:Dock(TOP)
		disableBtn:SetText("Disable Group Storage")
		disableBtn:SetTall(40)
		function disableBtn:DoClick()
			net.Start("impulseOpsGroupStorage")
			net.WriteBool(false)
			net.SendToServer()
		end

		sheet:AddSheet("Group Storage", gsPanel, "icon16/bricks.png")
	end
end

vgui.Register("impulseSupportTool", PANEL, "DFrame")