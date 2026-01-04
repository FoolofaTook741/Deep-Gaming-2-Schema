GProfiler.Hooks = GProfiler.Hooks or {}
GProfiler.Hooks.Realm = GProfiler.Hooks.Realm or "Client"
GProfiler.Hooks.ProfileActive = GProfiler.Hooks.ProfileActive or false
GProfiler.Hooks.StartTime = GProfiler.Hooks.StartTime or 0
GProfiler.Hooks.EndTime = GProfiler.Hooks.EndTime or 0

local TabPadding = 10
local MenuColors = GProfiler.MenuColors

local function GetHookTable(realm, callback)
	if realm == "Server" then
		net.Start("GProfiler_Hooks_HookTbl")
		net.SendToServer()
		net.Receive("GProfiler_Hooks_HookTbl", function()
			local hookCount = net.ReadUInt(15)
			local hookTable = {}
			for i = 1, hookCount do
				hookTable[net.ReadString()] = net.ReadUInt(10)
			end
			callback(hookTable)
		end)
	else
		local hookTbl = {}
		local hooks = hook.GetTable()
		for hookName, hookReceivers in pairs(hooks) do
			hookTbl[hookName] = table.Count(hookReceivers)
		end

		callback(hookTbl)
	end
end

function GProfiler.Hooks.DoTab(Content)
	local Header = vgui.Create("DPanel", Content)
	Header:SetSize(Content:GetWide(), 40)
	Header:SetPos(0, 10)
	Header.Paint = nil

	local RealmSelector = GProfiler.Menu.CreateRealmSelector(Header, "Hooks", Header:GetWide() - TabPadding - 110, Header:GetTall() / 2 - 30 / 2, function(s, _, value)
		GProfiler.Hooks.Realm = value
		GProfiler.Menu.OpenTab("Hooks", GProfiler.Hooks.DoTab)
	end)
	RealmSelector:SetPos(Header:GetWide() - RealmSelector:GetWide() - TabPadding, Header:GetTall() / 2 - RealmSelector:GetTall() / 2)

	local StartButton = vgui.Create("DButton", Header)
	StartButton:SetText(GProfiler.Hooks.ProfileActive and GProfiler.Language.GetPhrase("profiler_stop") or GProfiler.Language.GetPhrase("profiler_start"))
	StartButton:SetTextColor(MenuColors.White)
	StartButton:SetFont("GProfiler.Menu.StartButton")
	StartButton:SizeToContents()
	StartButton:SetTall(RealmSelector:GetTall())
	StartButton:SetPos(Header:GetWide() - StartButton:GetWide() - RealmSelector:GetWide() - TabPadding * 2, Header:GetTall() / 2 - StartButton:GetTall() / 2)
	StartButton.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, MenuColors.ButtonOutline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonBackground)

		if s:IsHovered() then
			draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonHover)
		end
	end

	local HookTimeRunning = vgui.Create("DLabel", Header)
	HookTimeRunning:SetFont("GProfiler.Menu.SectionHeader")
	HookTimeRunning:SetText(GProfiler.TimeRunning(GProfiler.Hooks.StartTime, GProfiler.Hooks.EndTime, GProfiler.Hooks.ProfileActive) .. "s")
	HookTimeRunning:SizeToContents()
	HookTimeRunning:SetPos(Header:GetWide() - HookTimeRunning:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - HookTimeRunning:GetTall() / 2)
	HookTimeRunning:SetTextColor(MenuColors.White)
	function HookTimeRunning:Think()
		if GProfiler.Hooks.ProfileActive then
			self:SetText(GProfiler.Hooks.Override or GProfiler.TimeRunning(GProfiler.Hooks.StartTime, 0, GProfiler.Hooks.ProfileActive) .. "s")
			self:SizeToContents()
			self:SetPos(Header:GetWide() - self:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - self:GetTall() / 2)
		end
	end

	local ReceivingData = vgui.Create("DLabel", Header)
	ReceivingData:SetFont("GProfiler.Menu.SectionHeader")
	ReceivingData:SetText("Receiving data...    ")
	ReceivingData:SizeToContents()
	ReceivingData:SetPos(Header:GetWide() - ReceivingData:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - HookTimeRunning:GetWide() - TabPadding * 3, Header:GetTall() / 2 - ReceivingData:GetTall() / 2)
	ReceivingData:SetTextColor(Color(225, 66, 66))
	function ReceivingData:Think()
		if GProfiler.Hooks.ReceivingData then
			self:SetVisible(true)
		else
			self:SetVisible(false)
		end
	end


	StartButton.DoClick = function()
		if GProfiler.Hooks.ProfileActive then
			GProfiler.Hooks.EndTime = SysTime()
			GProfiler.Hooks.Override = GProfiler.TimeRunning(GProfiler.Hooks.StartTime, SysTime(), GProfiler.Hooks.ProfileActive) .. "s"
			if GProfiler.Hooks.Realm == "Server" then
				net.Start("GProfiler_Hooks_ToggleServerProfile")
					net.WriteBool(false)
				net.SendToServer()
				GProfiler.Hooks.ReceivingData = true
			else
				GProfiler.Hooks:RestoreHooks()
				GProfiler.Hooks.ProfileActive = false
				GProfiler.Menu.OpenTab("Hooks", GProfiler.Hooks.DoTab)
			end
		else
			GProfiler.Hooks.StartTime = SysTime()
			GProfiler.Hooks.EndTime = 0
			GProfiler.Hooks.Override = nil
			if GProfiler.Hooks.Realm == "Server" then
				net.Start("GProfiler_Hooks_ToggleServerProfile")
					net.WriteBool(true)
				net.SendToServer()
			else
				GProfiler.Hooks:StartProfiler()
				GProfiler.Hooks.ProfileActive = true
				StartButton:SetText(GProfiler.Language.GetPhrase("profiler_stop"))
			end
		end
	end

	local SectionHeader = vgui.Create("DPanel", Content)
	SectionHeader:SetSize(Content:GetWide(), 40)
	SectionHeader:SetPos(0, Header:GetTall())
	SectionHeader.Paint = nil

	local leftFraction = .7
	local rightFraction = .3

	local LeftHeader, LeftHeaderText = GProfiler.Menu.CreateHeader(SectionHeader, GProfiler.Language.GetPhrase("profiler_results"), 0, 0, SectionHeader:GetWide() * leftFraction - 5, SectionHeader:GetTall())
	local RightHeader, RightHeaderText = GProfiler.Menu.CreateHeader(SectionHeader, GProfiler.Language.GetPhrase("Hook Function"), LeftHeader:GetWide() + 10, 0, SectionHeader:GetWide() * rightFraction - 5, LeftHeader:GetTall())

	local LeftContent = vgui.Create("DPanel", Content)
	LeftContent:SetSize(LeftHeader:GetWide(), Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	LeftContent:SetPos(0, SectionHeader:GetTall() + Header:GetTall())
	LeftContent.Paint = nil

	local RightContent = vgui.Create("DPanel", Content)
	RightContent:SetSize(RightHeader:GetWide(), Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	RightContent:SetPos(LeftContent:GetWide() + 10, SectionHeader:GetTall() + Header:GetTall())
	RightContent.Paint = nil

	local HookProfiler = vgui.Create("DListView", LeftContent)
	HookProfiler:SetSize(LeftContent:GetWide() - TabPadding * 2, (LeftContent:GetTall() - TabPadding * 2) / 2 - 10)
	HookProfiler:SetPos(TabPadding, TabPadding)
	HookProfiler:SetMultiSelect(false)
	HookProfiler:AddColumn(GProfiler.Language.GetPhrase("name"))
	HookProfiler:AddColumn(GProfiler.Language.GetPhrase("receiver"))
	HookProfiler:AddColumn(GProfiler.Language.GetPhrase("file"))
	HookProfiler:AddColumn(GProfiler.Language.GetPhrase("total_time"))
	HookProfiler:AddColumn(GProfiler.Language.GetPhrase("times_called"))

	local HookList = vgui.Create("DListView", LeftContent)
	HookList:SetSize(HookProfiler:GetWide(), HookProfiler:GetTall())
	HookList:SetPos(TabPadding, HookProfiler:GetTall() + TabPadding * 2)
	HookList:SetMultiSelect(false)
	HookList:AddColumn(GProfiler.Language.GetPhrase("name"))
	HookList:AddColumn(GProfiler.Language.GetPhrase("receivers"))

	local FunctionDetailsBackground = vgui.Create("DPanel", RightContent)
	FunctionDetailsBackground:SetSize(RightContent:GetWide() - TabPadding * 2, RightContent:GetTall() - TabPadding * 2)
	FunctionDetailsBackground:SetPos(TabPadding, TabPadding)
	FunctionDetailsBackground.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, MenuColors.CodeBackground) end

	local FunctionDetails = vgui.Create("DTextEntry", FunctionDetailsBackground)
	FunctionDetails:Dock(FILL)
	FunctionDetails:SetMultiline(true)
	FunctionDetails:SetKeyboardInputEnabled(false)
	FunctionDetails:SetVerticalScrollbarEnabled(true)
	FunctionDetails:SetDrawBackground(false)
	FunctionDetails:SetTextColor(MenuColors.White)
	FunctionDetails:SetFont("GProfiler.Menu.FunctionDetails")
	FunctionDetails:SetText(GProfiler.Language.GetPhrase("hook_select"))

	table.sort(GProfiler.Hooks.ProfileData, function(a, b) return a.t > b.t end)
	local LastSelected = ""
	for k, v in pairs(GProfiler.Hooks.ProfileData) do
		if v.c == 0 then continue end
		local Line = HookProfiler:AddLine(v.h, v.r, v.Source, v.t, v.c)
		Line.OnRightClick = function()
			local menu = DermaMenu()
			menu:AddOption(GProfiler.CopyLang("name"), function() SetClipboardText(v.h) end):SetIcon("icon16/page_copy.png")
			menu:AddOption(GProfiler.CopyLang("receiver"), function() SetClipboardText(v.r) end):SetIcon("icon16/page_copy.png")
			menu:AddOption(GProfiler.CopyLang("total_time"), function() SetClipboardText(v.t) end):SetIcon("icon16/page_copy.png")
			menu:AddOption(GProfiler.CopyLang("times_called"), function() SetClipboardText(v.c) end):SetIcon("icon16/page_copy.png")
			menu:AddOption(GProfiler.Language.GetPhrase("remove"), function()
				if GProfiler.Hooks.Realm == "Server" then
					net.Start("GProfiler_Hooks_RemoveHook")
						net.WriteString(v.h)
						net.WriteString(v.r)
					net.SendToServer()
					HookProfiler:RemoveLine(Line:GetID())
				else
					hook.Remove(v.h, v.r)
					HookProfiler:RemoveLine(Line:GetID())
				end
			end):SetIcon("icon16/delete.png")
			menu:Open()
		end

		Line.OnSelect = function()
			if LastSelected == v.h..v.r then return end
			LastSelected = v.h..v.r

			FunctionDetails:SetText(GProfiler.Language.GetPhrase("requesting_source"))
			GProfiler.RequestFunctionSource(v.Source, tonumber(v.Lines[1]), tonumber(v.Lines[2]), function(source)
				if not IsValid(FunctionDetails) then return end
				FunctionDetails:SetText(table.concat(source, "\n"))
			end)
		end
	end

	HookProfiler:SortByColumn(3, true)

	local function UpdateLists()
		GProfiler.StyleDListView(HookList)
		GProfiler.StyleDListView(HookProfiler)
	end
	UpdateLists()

	GetHookTable(GProfiler.Hooks.Realm, function(hookTable)
		if not IsValid(HookList) then return end
		local hookTableSorted = {}
		for k, v in pairs(hookTable) do table.insert(hookTableSorted, {k, v}) end
		table.sort(hookTableSorted, function(a, b) return a[2] > b[2] end)

		for k, v in pairs(hookTableSorted) do
			local Line = HookList:AddLine(v[1], v[2])
			Line.OnRightClick = function()
				local menu = DermaMenu()
				menu:AddOption(GProfiler.CopyLang("name"), function() SetClipboardText(v[1]) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("receivers"), function() SetClipboardText(v[2]) end):SetIcon("icon16/page_copy.png")
				menu:Open()
			end
		end

		UpdateLists()
	end)
end

GProfiler.Menu.RegisterTab("Hooks", "icon16/bricks.png", 1, GProfiler.Hooks.DoTab, function()
	if GProfiler.Hooks.ProfileActive then
		return GProfiler.TimeRunning(GProfiler.Hooks.StartTime, 0, GProfiler.Hooks.ProfileActive) .. "s", MenuColors.ActiveProfile
	elseif GProfiler.Hooks.Override then
		return GProfiler.Hooks.Override, MenuColors.InactiveProfile
	end
end)

net.Receive("GProfiler_Hooks_ServerProfileStatus", function()
	local status = net.ReadBool()
	local ply = net.ReadEntity()
	GProfiler.Hooks.ProfileActive = status

	if ply == LocalPlayer() and not status then
		GProfiler.Menu.OpenTab("Hooks", GProfiler.Hooks.DoTab)
	end
end)

net.Receive("GProfiler_Hooks_SendData", function()
	local data = {}
	for i = 1, net.ReadUInt(20) do
		local hookName = net.ReadString()
		data[hookName] = {
			h = net.ReadString(),
			r = hookName,
			c = net.ReadUInt(32),
			t = net.ReadFloat(),
			Source = net.ReadString(),
			Lines = {net.ReadUInt(16), net.ReadUInt(16)}
		}
	end
	GProfiler.Hooks.ProfileData = data
	GProfiler.Hooks.ReceivingData = false
	GProfiler.Menu.OpenTab("Hooks", GProfiler.Hooks.DoTab)
end)

hook.Add("ExpressLoaded", "GProfiler_Hooks", function()
	express.Receive("GProfiler_Hooks_SendData", function(data)
		GProfiler.Hooks.ProfileData = data
		GProfiler.Hooks.ReceivingData = false
		GProfiler.Menu.OpenTab("Hooks", GProfiler.Hooks.DoTab)
	end)
end)