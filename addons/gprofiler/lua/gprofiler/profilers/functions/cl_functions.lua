GProfiler.Functions = GProfiler.Functions or {}
GProfiler.Functions.Realm = GProfiler.Functions.Realm or "Client"
GProfiler.Functions.ProfileActive = GProfiler.Functions.ProfileActive or false
GProfiler.Functions.StartTime = GProfiler.Functions.StartTime or 0
GProfiler.Functions.EndTime = GProfiler.Functions.EndTime or 0
GProfiler.Functions.ActiveFocus = GProfiler.Functions.ActiveFocus or {}
GProfiler.Functions.SourceFilter = GProfiler.Functions.SourceFilter or ""

local TabPadding = 10
local MenuColors = GProfiler.MenuColors

local function ValidateFocus(foc)
	return string.StartWith(foc or "", "function: 0x") or string.StartWith(foc or "", "0x")
end

local FocusColors = {
	Valid = Color(0, 255, 0),
	Invalid = Color(255, 0, 0)
}

local function bytesToReadable(bytes)
	if bytes < 1024 then
		return string.format("%d B", bytes)
	elseif bytes < 1048576 then
		return string.format("%.2f KB", bytes / 1024)
	else
		return string.format("%.2f MB", bytes / 1048576)
	end
end

function GProfiler.Functions.DoTab(Content)
	local Header = vgui.Create("DPanel", Content)
	Header:SetSize(Content:GetWide(), 40)
	Header:SetPos(0, 10)
	Header.Paint = nil

	local RealmSelector = GProfiler.Menu.CreateRealmSelector(Header, "Functions", Header:GetWide() - 110 - TabPadding, Header:GetTall() / 2 - 30 / 2, function(s, _, value)
		GProfiler.Functions.Realm = value
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end)
	RealmSelector:SetPos(Header:GetWide() - RealmSelector:GetWide() - TabPadding, Header:GetTall() / 2 - RealmSelector:GetTall() / 2)

	local StartButton = vgui.Create("DButton", Header)
	StartButton:SetText(GProfiler.Functions.ProfileActive and GProfiler.Language.GetPhrase("profiler_stop") or GProfiler.Language.GetPhrase("profiler_start"))
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

	local FunctionTimeRunning = vgui.Create("DLabel", Header)
	FunctionTimeRunning:SetFont("GProfiler.Menu.SectionHeader")
	FunctionTimeRunning:SetText(GProfiler.TimeRunning(GProfiler.Functions.StartTime, GProfiler.Functions.EndTime, GProfiler.Functions.ProfileActive) .. "s")
	FunctionTimeRunning:SizeToContents()
	FunctionTimeRunning:SetPos(Header:GetWide() - FunctionTimeRunning:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - FunctionTimeRunning:GetTall() / 2)
	FunctionTimeRunning:SetTextColor(MenuColors.White)
	function FunctionTimeRunning:Think()
		if GProfiler.Functions.ProfileActive then
			self:SetText(GProfiler.Functions.Override or GProfiler.TimeRunning(GProfiler.Functions.StartTime, 0, GProfiler.Functions.ProfileActive) .. "s")
			self:SizeToContents()
			self:SetPos(Header:GetWide() - self:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - TabPadding * 3, Header:GetTall() / 2 - self:GetTall() / 2)
		end
	end

	local ReceivingData = vgui.Create("DLabel", Header)
	ReceivingData:SetFont("GProfiler.Menu.SectionHeader")
	ReceivingData:SetText("Receiving data...    ")
	ReceivingData:SizeToContents()
	ReceivingData:SetPos(Header:GetWide() - ReceivingData:GetWide() - RealmSelector:GetWide() - StartButton:GetWide() - FunctionTimeRunning:GetWide() - TabPadding * 3, Header:GetTall() / 2 - ReceivingData:GetTall() / 2)
	ReceivingData:SetTextColor(Color(225, 66, 66))
	function ReceivingData:Think()
		if GProfiler.Functions.ReceivingData then
			self:SetVisible(true)
		else
			self:SetVisible(false)
		end
	end

	StartButton.DoClick = function()
		if GProfiler.Functions.ProfileActive then
			GProfiler.Functions.EndTime = SysTime()
			GProfiler.Functions.Override = GProfiler.TimeRunning(GProfiler.Functions.StartTime, SysTime(), GProfiler.Functions.ProfileActive) .. "s"
			if GProfiler.Functions.Realm == "Server" then
				net.Start("GProfiler_Functions_ToggleServerProfile")
				net.WriteBool(false)
				net.SendToServer()
				GProfiler.Functions.ReceivingData = true
			else
				GProfiler.Functions:RestoreFunctions()
				GProfiler.Functions.ProfileActive = false
				GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
			end
		else
			GProfiler.Functions.Override = nil
			GProfiler.Functions.StartTime = SysTime()
			GProfiler.Functions.EndTime = 0
			GProfiler.Functions.SourceFilter = ""
			if GProfiler.Functions.Realm == "Server" then
				net.Start("GProfiler_Functions_ToggleServerProfile")
				net.WriteBool(true)
				if not table.IsEmpty(GProfiler.Functions.ActiveFocus) then
					net.WriteBool(true)
					net.WriteUInt(#GProfiler.Functions.ActiveFocus, 5)
					for k, v in ipairs(GProfiler.Functions.ActiveFocus) do
						net.WriteString(v)
					end
				else
					net.WriteBool(false)
				end
				net.SendToServer()
			else
				GProfiler.Functions.Focus = {}
				for k, v in pairs(GProfiler.Functions.ActiveFocus or {}) do
					GProfiler.Functions.Focus[v] = true
				end

				if table.IsEmpty(GProfiler.Functions.ActiveFocus) then
					GProfiler.Functions.Focus = false
				end

				GProfiler.Functions:StartProfiler()
				GProfiler.Functions.ProfileActive = true
				StartButton:SetText(GProfiler.Language.GetPhrase("profiler_stop"))
			end
		end
	end

	local FilterFileLabel = vgui.Create("DLabel", Header)
	FilterFileLabel:SetFont("GProfiler.Menu.SectionHeader")
	FilterFileLabel:SetText(string.format("%s:", GProfiler.Language.GetPhrase("filter_source")))
	FilterFileLabel:SizeToContents()
	FilterFileLabel:SetPos(TabPadding, Header:GetTall() / 2 - FilterFileLabel:GetTall() / 2)
	FilterFileLabel:SetTextColor(MenuColors.White)

	local FilterFile = vgui.Create("DTextEntry", Header)
	FilterFile:SetFont("GProfiler.Menu.SectionHeader")
	FilterFile:SetText("")
	FilterFile:SetMouseInputEnabled(true)
	FilterFile:SetSize(150, Header:GetTall() - TabPadding * 1.5)
	FilterFile:SetPos(FilterFileLabel:GetWide() + FilterFileLabel:GetPos() + 5, Header:GetTall() / 2 - FilterFile:GetTall() / 2)
	FilterFile:SetTextColor(MenuColors.White)
	function FilterFile:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, MenuColors.RealmSelectorOutline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.RealmSelectorBackground)
		local x = draw.SimpleText(self:GetText(), "GProfiler.Menu.FocusEntry", 5, h / 2, MenuColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if self:IsEditing() and (x < w - 15) and (SysTime() % 1 > 0.5) then
			local caretPos = self:GetCaretPos()
			local text = self:GetText()
			surface.SetFont("GProfiler.Menu.FocusEntry")
			local textWidth = surface.GetTextSize(text)
			local textWidthBeforeCaret = surface.GetTextSize(string.sub(text, 1, caretPos))
			draw.RoundedBox(0, textWidthBeforeCaret + 5, 1, 2, h - 2, MenuColors.White)
		end
	end

	local FunctionsFocusLabel = vgui.Create("DLabel", Header)
	FunctionsFocusLabel:SetFont("GProfiler.Menu.SectionHeader")
	FunctionsFocusLabel:SetText(string.format("%s:", GProfiler.Language.GetPhrase("focus")))
	FunctionsFocusLabel:SizeToContents()
	FunctionsFocusLabel:SetPos(TabPadding + FilterFileLabel:GetWide() + FilterFile:GetWide() + 15, Header:GetTall() / 2 - FunctionsFocusLabel:GetTall() / 2)
	FunctionsFocusLabel:SetTextColor(MenuColors.White)

	local AddFocus = vgui.Create("DTextEntry", Header)
	AddFocus:SetFont("GProfiler.Menu.SectionHeader")
	AddFocus:SetText("")
	AddFocus:SetMouseInputEnabled(true)
	AddFocus:SetSize(150, Header:GetTall() - TabPadding * 1.5)
	AddFocus:SetPos(FunctionsFocusLabel:GetWide() + FunctionsFocusLabel:GetPos() + 5, Header:GetTall() / 2 - AddFocus:GetTall() / 2)
	AddFocus:SetTextColor(MenuColors.White)

	local FocusList = vgui.Create("DIconLayout", Header)
	FocusList:SetSpaceX(5)
	FocusList:SetSize(Header:GetWide() - AddFocus:GetWide() - FunctionsFocusLabel:GetWide() - StartButton:GetWide() - RealmSelector:GetWide() - FilterFileLabel:GetWide() - FilterFile:GetWide() - TabPadding * 5, Header:GetTall() - TabPadding)
	FocusList:SetPos(AddFocus:GetWide() + FunctionsFocusLabel:GetWide() + FunctionsFocusLabel:GetPos() + 10, Header:GetTall() / 2 - FocusList:GetTall() / 2)
	FocusList.Paint = nil

	local function AddFocusToList(value)
		local Pnl = FocusList:Add("DPanel")
		Pnl:SetSize(20, FocusList:GetTall())
		Pnl.Paint = function(s, w, h)
			draw.RoundedBox(4, 2, 2, w - 4, h - 4, MenuColors.RealmSelectorBackground)
		end

		local lbl = vgui.Create("DLabel", Pnl)
		lbl:SetFont("GProfiler.Menu.RealmSelector")
		lbl:SetText(string.Split(value, "function: ")[2])
		lbl:SizeToContents()
		lbl:SetPos(5, FocusList:GetTall() / 2 - lbl:GetTall() / 2)
		lbl:SetTextColor(MenuColors.White)

		local remove = vgui.Create("DButton", Pnl)
		remove:SetSize(20, 20)
		remove:SetPos(lbl:GetWide() + 10, FocusList:GetTall() / 2 - remove:GetTall() / 2)
		remove:SetText("X")
		remove:SetTextColor(MenuColors.White)
		remove:SetFont("GProfiler.Menu.RealmSelector")
		remove.Paint = function(s, w, h)
			draw.RoundedBox(4, 0, 0, w, h, MenuColors.ButtonOutline)
			draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonBackground)

			if s:IsHovered() then
				draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonHover)
			end
		end
		remove.DoClick = function()
			table.RemoveByValue(GProfiler.Functions.ActiveFocus, value)
		end

		Pnl:SizeToChildren(true, false)
		Pnl:SetWide(Pnl:GetWide() + 5)
	end

	for k, v in ipairs(GProfiler.Functions.ActiveFocus) do
		AddFocusToList(v)
	end

	AddFocus.OnEnter = function()
		if ValidateFocus(AddFocus:GetText()) and not table.HasValue(GProfiler.Functions.ActiveFocus, AddFocus:GetText()) then
			if !string.StartWith(AddFocus:GetText(), "function: ") then AddFocus:SetText("function: " .. AddFocus:GetText()) end
			table.insert(GProfiler.Functions.ActiveFocus, AddFocus:GetText())
			AddFocus:SetText("")
		end
	end

	local IsValidInput = false
	function AddFocus:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, MenuColors.RealmSelectorOutline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.RealmSelectorBackground)
		draw.RoundedBox(4, 1, 1, 10, h - 2, IsValidInput and FocusColors.Valid or FocusColors.Invalid)
		local x = draw.SimpleText(self:GetText(), "GProfiler.Menu.FocusEntry", 15, h / 2, MenuColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if self:IsEditing() and (x < w - 15) and (SysTime() % 1 > 0.5) then
			local caretPos = self:GetCaretPos()
			local text = self:GetText()
			surface.SetFont("GProfiler.Menu.FocusEntry")
			local textWidth = surface.GetTextSize(text)
			local textWidthBeforeCaret = surface.GetTextSize(string.sub(text, 1, caretPos))
			draw.RoundedBox(0, textWidthBeforeCaret + 15, 1, 2, h - 2, MenuColors.White)
		end
	end

	function AddFocus:OnTextChanged()
		IsValidInput = ValidateFocus(self:GetText())
	end

	local prevAmount = 0
	FocusList.Think = function()
		if prevAmount != #GProfiler.Functions.ActiveFocus then
			prevAmount = #GProfiler.Functions.ActiveFocus
			FocusList:Clear()
			FocusList:SetSize(Header:GetWide() - AddFocus:GetWide() - FunctionsFocusLabel:GetWide() - StartButton:GetWide() - RealmSelector:GetWide() - TabPadding * 5, Header:GetTall() - TabPadding)
			FocusList:SetPos(AddFocus:GetWide() + FunctionsFocusLabel:GetWide() + FunctionsFocusLabel:GetPos() + 10, Header:GetTall() / 2 - FocusList:GetTall() / 2)
			for k, v in ipairs(GProfiler.Functions.ActiveFocus) do
				AddFocusToList(v)
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
	local RightHeader, RightHeaderText = GProfiler.Menu.CreateHeader(SectionHeader, GProfiler.Language.GetPhrase("function_details"), LeftHeader:GetWide() + 10, 0, SectionHeader:GetWide() * rightFraction - 5, LeftHeader:GetTall())

	local LeftContent = vgui.Create("DPanel", Content)
	LeftContent:SetSize(Content:GetWide() * leftFraction - 5, Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	LeftContent:SetPos(0, SectionHeader:GetTall() + Header:GetTall())
	LeftContent.Paint = nil

	local RightContent = vgui.Create("DPanel", Content)
	RightContent:SetSize(Content:GetWide() * rightFraction - 5, Content:GetTall() - SectionHeader:GetTall() - Header:GetTall())
	RightContent:SetPos(LeftContent:GetWide() + 10, SectionHeader:GetTall() + Header:GetTall())
	RightContent.Paint = nil

	local FunctionDetailsBackground = vgui.Create("DPanel", RightContent)
	FunctionDetailsBackground:SetSize(RightContent:GetWide() - TabPadding * 2, RightContent:GetTall() - TabPadding * 2 - 50)
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
	FunctionDetails:SetText(GProfiler.Language.GetPhrase("function_select"))

	local FunctionDetailsSeparator = vgui.Create("DPanel", RightContent)
	FunctionDetailsSeparator:SetSize(RightContent:GetWide() - TabPadding * 2, 1)
	FunctionDetailsSeparator:SetPos(TabPadding, FunctionDetailsBackground:GetTall() + TabPadding * 2)
	FunctionDetailsSeparator.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, MenuColors.HeaderSeparator) end

	local BottomSection = vgui.Create("DPanel", RightContent)
	BottomSection:SetSize(RightContent:GetWide() - TabPadding * 2, RightContent:GetTall() - FunctionDetailsBackground:GetTall() - FunctionDetailsSeparator:GetTall() - TabPadding * 3)
	BottomSection:SetPos(TabPadding, FunctionDetailsBackground:GetTall() + FunctionDetailsSeparator:GetTall() + TabPadding * 3)
	BottomSection.Paint = nil

	local SelectedProfile = nil
	local Buttons = {
		[GProfiler.Language.GetPhrase("focus")] = function()
			if not SelectedProfile then return end
			if table.HasValue(GProfiler.Functions.ActiveFocus, SelectedProfile.focus) then
				table.RemoveByValue(GProfiler.Functions.ActiveFocus, SelectedProfile.focus)
			else
				table.insert(GProfiler.Functions.ActiveFocus, SelectedProfile.focus)
			end
		end,
		[GProfiler.Language.GetPhrase("print_details")] = function(b)
			if not SelectedProfile then return end

			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("function"), ": ", MenuColors.White, SelectedProfile.name, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("source"), ": ", MenuColors.White, SelectedProfile.source, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("lines"), ": ", MenuColors.White, SelectedProfile.lines, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("times_called"), ": ", MenuColors.White, SelectedProfile.calls, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("total_time"), ": ", MenuColors.White, SelectedProfile.time, "\n")
			MsgC(MenuColors.Blue, GProfiler.Language.GetPhrase("average_time"), ": ", MenuColors.White, SelectedProfile.average, "\n")

			b:SetText(GProfiler.Language.GetPhrase("printed"))
			timer.Simple(2, function()
				if not IsValid(b) then return end
				b:SetText(GProfiler.Language.GetPhrase("print_details"))
			end)
		end
	}

	local ButtonWidth = BottomSection:GetWide() / table.Count(Buttons)
	local ButtonHeight = BottomSection:GetTall() - TabPadding

	local i = 0
	for k, v in pairs(Buttons) do
		local Button = vgui.Create("DButton", BottomSection)
		Button:SetSize(ButtonWidth - 5, ButtonHeight)
		Button:SetPos(i * ButtonWidth + (i * 5), 0)
		Button:SetText(k)
		Button:SetTextColor(MenuColors.White)
		Button:SetFont("GProfiler.Menu.RealmSelector")
		Button.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, MenuColors.ButtonOutline)
			draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonBackground)

			if self:IsHovered() then
				draw.RoundedBox(4, 1, 1, w - 2, h - 2, MenuColors.ButtonHover)
			end
		end
		Button.DoClick = v
		i = i + 1
	end

	local FunctionProfiler = vgui.Create("DListView", LeftContent)
	FunctionProfiler:SetSize(LeftContent:GetWide() - TabPadding * 2, LeftContent:GetTall() - TabPadding * 2)
	FunctionProfiler:SetPos(TabPadding, TabPadding)
	FunctionProfiler:SetMultiSelect(false)
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("function"))
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("source"))
	FunctionProfiler:AddColumn(GProfiler.Language.GetPhrase("times_called"))
	FunctionProfiler:AddColumn(string.format("%s (ms)", GProfiler.Language.GetPhrase("total_time")))
	FunctionProfiler:AddColumn(string.format("%s (ms)", GProfiler.Language.GetPhrase("average_time")))
	-- FunctionProfiler:AddColumn("Garbage"):SetWide(5) -- Not confident on its accuracy yet

	for k, v in pairs(GProfiler.Functions.ProfileData) do
		if GProfiler.Functions.ProfileActive and GProfiler.Functions.Realm == "Client" then break end
		local line = FunctionProfiler:AddLine(v.name or "Unknown", string.format("%s (%s)", v.source, v.lines), v.calls, v.time, v.average, bytesToReadable(v.garbage or 0))
		line:SetSortValue(6, v.garbage or 0)
		line.OnMousePressed = function(s, l)
			if l == 108 then
				local menu = DermaMenu()
				menu:AddOption(GProfiler.Language.GetPhrase("focus"), function()
					if table.HasValue(GProfiler.Functions.ActiveFocus, v.focus) then
						table.RemoveByValue(GProfiler.Functions.ActiveFocus, v.focus)
					else
						table.insert(GProfiler.Functions.ActiveFocus, v.focus)
					end
				end):SetIcon("icon16/zoom.png")
				menu:AddOption(GProfiler.CopyLang("name"), function() SetClipboardText(v.name) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("source"), function() SetClipboardText(v.source) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("times_called"), function() SetClipboardText(v.calls) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("total_time"), function() SetClipboardText(v.time) end):SetIcon("icon16/page_copy.png")
				menu:AddOption(GProfiler.CopyLang("average_time"), function() SetClipboardText(v.average) end):SetIcon("icon16/page_copy.png")
				menu:Open()
				return
			end

			SelectedProfile = v
			for k, v in ipairs(FunctionProfiler.Lines) do
				v:SetSelected(false)
			end
			line:SetSelected(true)

			local lines = string.Split(v.lines, " - ")
			GProfiler.RequestFunctionSource(v.source, lines[1], lines[2], function(source)
				if not IsValid(FunctionDetails) then return end
				FunctionDetails:SetText(table.concat(source, "\n"))
			end)
		end
	end

	FilterFile.OnTextChanged = function()
		local filterText = FilterFile:GetText():lower()
		GProfiler.Functions.SourceFilter = FilterFile:GetText()
		for k, v in ipairs(FunctionProfiler.Lines) do
			local source = v:GetColumnText(2):lower()
			print(source, filterText)
			if string.find(source, filterText, 1, true) then
				v:SetVisible(true)
			else
				v:SetVisible(false)
			end
		end
		FunctionProfiler:DataLayout()
		FunctionProfiler:InvalidateLayout()
	end

	FunctionProfiler:SortByColumn(5, true)
	GProfiler.StyleDListView(FunctionProfiler)


	if GProfiler.Functions.SourceFilter != "" then
		FilterFile:SetText(GProfiler.Functions.SourceFilter)
		FilterFile:OnTextChanged()
		FilterFile:OnTextChanged()
	end
end

GProfiler.Menu.RegisterTab("Functions", "icon16/bug.png", 3, GProfiler.Functions.DoTab, function()
	if GProfiler.Functions.ProfileActive then
		return GProfiler.TimeRunning(GProfiler.Functions.StartTime, 0, GProfiler.Functions.ProfileActive) .. "s", MenuColors.ActiveProfile
	elseif GProfiler.Functions.Override then
		return GProfiler.Functions.Override, MenuColors.InactiveProfile
	end
end)

net.Receive("GProfiler_Functions_ServerProfileStatus", function()
	local status = net.ReadBool()
	local ply = net.ReadEntity()
	GProfiler.Functions.ProfileActive = status

	if ply == LocalPlayer() then
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end
end)

net.Receive("GProfiler_Functions_SendData", function(len, ply)
	local first = net.ReadBool()

	if first then
		GProfiler.Functions.ProfileData = {}
	end

	local last = net.ReadBool()
	local count = net.ReadUInt(32)
	for i = 1, count do
		local name = net.ReadString()
		local source = net.ReadString()
		local lines = net.ReadString()
		local calls = net.ReadUInt(22)
		local time = net.ReadFloat()
		local average = net.ReadFloat()
		local focus = net.ReadString()
		local garbage = net.ReadFloat()

		if not GProfiler.Functions.ProfileData[name] then
			GProfiler.Functions.ProfileData[name] = {
				name = name,
				source = source,
				lines = lines,
				calls = 0,
				time = 0,
				average = 0,
				focus = focus,
				garbage = 0
			}
		end

		local Dat = GProfiler.Functions.ProfileData[name]
		Dat.calls = Dat.calls + calls
		Dat.time = Dat.time + time
		Dat.average = Dat.average + average
		Dat.garbage = Dat.garbage + garbage
	end

	if last then
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
		GProfiler.Functions.ReceivingData = false
	end
end)

hook.Add("ExpressLoaded", "GProfiler_Functions", function()
	express.Receive("GProfiler_Functions_SendData", function(data)
		GProfiler.Functions.ReceivingData = false
		GProfiler.Functions.ProfileData = data
		GProfiler.Menu.OpenTab("Functions", GProfiler.Functions.DoTab)
	end)
end)
