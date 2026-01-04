-- Copyright (c) 2021 - Nick S. / Landis Community

local PANEL = {}

function PANEL:HandleServerData()

end

function PANEL:CreateSearchSystem()
	-- https://www.youtube.com/watch?v=-h6vcngFOEk

	-- For Steam ID searches.
	self.txtSteamIDInput = vgui.Create("DTextEntry", self, "SearchMain")
	local srch = self.txtSteamIDInput
	local btn  = self.btnTargetTypeCycle
	srch:SetPos(20 + btn:GetWide(), 35)
	srch:SetWide(self:GetWide() - btn:GetWide() - 40)

	self.dwnCallsignTagSelector = vgui.Create("DComboBox", self, "CallsignTagSelector")
	local dropTag = self.dwnCallsignTagSelector
	dropTag:Hide() -- Only used in Cycle #3
	dropTag:SetPos(20 + btn:GetWide(), 35)
	dropTag:SetSortItems(false)
	local w = self:GetWide() - btn:GetWide() - 40
	dropTag:SetWide((w/2) - 5)

	self.dwnCallsignNumSelector = vgui.Create("DComboBox", self, "CallsignNumSelector")
	local dropNum = self.dwnCallsignNumSelector
	dropNum:Hide() -- Only used in Cycle #3
	dropNum:SetSortItems(false)
	dropNum:SetPos(25 + btn:GetWide() + dropTag:GetWide(), 35)
	dropNum:SetWide((w/2) - 5)

	local ply = LocalPlayer()
	-- Setup selections for taglines
	if (ply:Team() == TEAM_CP) then
		for i, v in ipairs(CP_CALLSIGNS_LINES) do
			dropTag:AddChoice(v.NiceName)
		end
	else
		for i, v in ipairs(OTA_CALLSIGNS_LINES) do
			dropTag:AddChoice(v.NiceName)
		end
	end

	for i = 1, 10 do
		dropNum:AddChoice(tostring(i))
	end

	self.btnFetch = vgui.Create("DButton", self, "Fetch")
	local btn = self.btnFetch
	btn:SetPos(10,100)
	btn:SetText("FETCH CALLSIGN DATA")
	btn:SetFont("BudgetLabel")
	btn:SizeToContents()
end

function PANEL:LayoutSearchSystem()
	local srch = self.txtSteamIDInput
	local btn  = self.btnTargetTypeCycle
	srch:SetPos(20 + btn:GetWide(), 35)
	srch:SetWide(self:GetWide() - btn:GetWide() - 40)

	local dropTag = self.dwnCallsignTagSelector
	local dropNum = self.dwnCallsignNumSelector
	local w = self:GetWide() - btn:GetWide() - 40
	dropTag:SetPos(20 + btn:GetWide(), 35)
	dropTag:SetWide((w/2) - 5)
	dropNum:SetPos(25 + btn:GetWide() + dropTag:GetWide(), 35)
	dropNum:SetWide((w/2) - 5)

	if (self.iTargetTypeCycle == 3) then
		dropTag:Show()
		dropNum:Show()
		srch:Hide()
	else
		dropTag:Hide()
		dropNum:Hide()
		srch:Show()
	end
end

function PANEL:TargetTypeCycle(nosound)
	if not (nosound) then
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	if (self.iTargetTypeCycle + 1 > self.iTargetTypeCycleMax) then
		self.iTargetTypeCycle = 1
	else
		self.iTargetTypeCycle = self.iTargetTypeCycle + 1
	end
	self.btnTargetTypeCycle:SetText(self.tTargetTypeCycleEnum[self.iTargetTypeCycle])
	self.btnTargetTypeCycle:SizeToContents()
	self:LayoutSearchSystem()
	self:LayoutCycleHelper()
end

function PANEL:CreateTargetTypeCycleButton()
	self.btnTargetTypeCycle = vgui.Create("DButton", self, "TargetTypeCycle")
	local btn = self.btnTargetTypeCycle
	btn:SetSkin("combine")
	btn:SetPos(10,35)
	btn:SetText(self.tTargetTypeCycleEnum[self.iTargetTypeCycle])
	btn:SetFont("BudgetLabel")
	btn:SizeToContents()
	
	local panel = self

	function btn:DoClick()
		panel:TargetTypeCycle(false)
	end
end

function PANEL:LayoutCycleHelper()
	local lbl = self.lblTargetTypeCycleHelper
	lbl:SetText(self.tTargetTypeCycleHelperEnum[self.iTargetTypeCycle]) -- start w/ #1 :D
	--lbl:SizeToContents()
end

function PANEL:CreateTargetTypeCycleHelper()
	self.lblTargetTypeCycleHelper = vgui.Create("DLabel", self, "TargetTypeCycleHelper")
	local lbl = self.lblTargetTypeCycleHelper
	local btn = self.btnTargetTypeCycle
	lbl:SetText(self.tTargetTypeCycleHelperEnum[1]) -- start w/ #1 :D
	lbl:SetFont("DebugFixed")
	lbl:SetPos(10, 45 + btn:GetTall())
	lbl:SizeToContentsY()
	lbl:SetWide(580)
	lbl:SetAutoStretchVertical(true)
end

function PANEL:Init()

	local ply = LocalPlayer()

	if not ply:IsCP() or (ply:Team() == TEAM_CA) then
        self:Remove()
		return
    end

	local panel = self -- store reference

	-- Setting our instance parameters
	self.DBCallsigns = {}
	self.iTargetTypeCycle = 1
	self.iTargetTypeCycleMax = 3
	self.tTargetTypeCycleEnum = {
		[1] = "SteamID 32",
		[2] = "SteamID 64",
		[3] = "Callsign"
	}
	self.tTargetTypeCycleHelperEnum = {
		[1] = "Search for a single person from a valid SteamID 32. (Starts with STEAM_0) You\ncan click the button to change to a Steam ID 64 search.",
		[2] = "Search for a single person from a valid SteamID 64. (Starts with 7)",
		[3] = "Search for someone based on a callsign alone, can be useful if you don't know\ntheir Steam ID, however it is more taxing on the server. Try to use infrequently."
	}

	-- setup dimensions & shit
	self:SetSize(600,500)
	self:Center()
	self:SetTitle("CCA CALLSIGN MANAGER")
	self:SetSkin("combine")
	self:MakePopup()

	-- Run funcs to create UI
	self:CreateTargetTypeCycleButton()
	self:CreateSearchSystem()
	self:CreateTargetTypeCycleHelper()
end

function PANEL:PaintOver(w, h)
	local c = table.Count(self.DBCallsigns)
	if c < 1 then
		draw.SimpleText(
			"Nothing to show",
			"impulseHL2RPOverlayBig",
			w / 2,
			h / 2,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end

end

vgui.Register("impulseCallsignManager", PANEL, "DFrame")