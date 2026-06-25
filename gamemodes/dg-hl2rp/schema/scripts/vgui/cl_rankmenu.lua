local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 400)
	self:Center()
	self:SetTitle("Division and rank selection")
	self:MakePopup()

	local ply = LocalPlayer()
	local plyTeam = ply:Team()
	local teamData = impulse.Teams.Data[plyTeam]

	local normalXP = ply:GetXP()
	local cpXP = 0

	if ply.GetCPFactionXP then
		cpXP = ply:GetCPFactionXP()
	end

	self.characterPreview = vgui.Create("impulseModelPanel", self)
	self.characterPreview:SetSize(600, 400)
	self.characterPreview:SetPos(115, 30)
	self.characterPreview:SetFOV(80)
	self.characterPreview:SetModel(ply:GetModel(), ply:GetSkin())
	self.characterPreview:MoveToBack()
	self.characterPreview:SetCursor("arrow")

	function self.characterPreview:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 40, 0))
	end

	if plyTeam == TEAM_CP then
		self.xpLbl = vgui.Create("DLabel", self)
		self.xpLbl:SetFont("Impulse-Elements18-Shadow")
		self.xpLbl:SetText("XP: " .. normalXP .. " | Civil Protection XP: " .. cpXP)
		self.xpLbl:SizeToContents()
		self.xpLbl:SetPos(10, 30)
	end

	self.divisionLbl = vgui.Create("DLabel", self)
	self.divisionLbl:SetFont("Impulse-Elements18-Shadow")
	self.divisionLbl:SetText("Division:")
	self.divisionLbl:SizeToContents()
	self.divisionLbl:SetPos(10, 55)

	self.divisionSelect = vgui.Create("DComboBox", self)
	self.divisionSelect:SetPos(10, 75)
	self.divisionSelect:SetSize(300, 23)
	self.divisionSelect:SetSortItems(false)
	self.divisionSelect:SetValue("Select a division")

	for v, k in pairs(teamData.classes) do
		local add = (k.whitelistLevel and " and whitelist") or ""
		local requiredXP = k.xp or 0

		if requiredXP <= normalXP then
			self.divisionSelect:AddChoice(k.name .. " - Requires " .. requiredXP .. " XP" .. add, v, false)
		else
			self.divisionSelect:AddChoice(k.name .. " - Requires " .. requiredXP .. " XP" .. add, v, false, "icon16/lock.png")
		end
	end

	local panel = self

	function self.divisionSelect:OnSelect(index, value, data)
		local div = teamData.classes[data]

		panel.descLblT:SetText(div.description or "")
		panel.descLblT:SetWrap(true)

		if div.model then
			panel.characterPreview:SetModel(div.model)
		end

		if div.skin then
			panel.characterPreview.Entity:SetSkin(div.skin)
		end

		if div.noSubMats then
			panel.characterPreview.Entity:SetSubMaterial(0, nil)
		else
			if panel.characterPreview.subMats then
				for v, k in pairs(panel.characterPreview.subMats) do
					panel.characterPreview.Entity:SetSubMaterial(v - 1, k)
				end
			elseif plyTeam == TEAM_CP then
				-- panel.characterPreview.Entity:SetSubMaterial(0, "models/impulse/cp/rank_i4")
			end
		end

		if (div.xp or 0) > normalXP then
			panel.doneBtn.DivisionName = nil
			panel.doneBtn.Division = nil
			return
		end

		if div.bodygroups then
			for v, k in pairs(div.bodygroups) do
				panel.characterPreview.Entity:SetBodygroup(k[1], k[2])
			end
		end

		panel.doneBtn.DivisionName = div.name
		panel.doneBtn.Division = data
	end

	self.rankLbl = vgui.Create("DLabel", self)
	self.rankLbl:SetFont("Impulse-Elements18-Shadow")
	self.rankLbl:SetText("Rank:")
	self.rankLbl:SizeToContents()
	self.rankLbl:SetPos(10, 105)

	self.rankSelect = vgui.Create("DComboBox", self)
	self.rankSelect:SetPos(10, 125)
	self.rankSelect:SetSize(300, 23)
	self.rankSelect:SetSortItems(false)
	self.rankSelect:SetValue("Select a rank")

	for v, k in pairs(teamData.ranks) do
		local add = (k.whitelistLevel and " + whitelist") or ""

		local useCPXP = k.faction_xp != nil
		local requiredXP = useCPXP and k.faction_xp or (k.xp or 0)
		local availableXP = useCPXP and cpXP or normalXP
		local xpName = useCPXP and "Civil Protection XP" or "XP"

		if requiredXP <= availableXP then
			self.rankSelect:AddChoice(k.name .. " - Requires " .. requiredXP .. " " .. xpName .. add, v, false)
		else
			self.rankSelect:AddChoice(k.name .. " - Requires " .. requiredXP .. " " .. xpName .. add, v, false, "icon16/lock.png")
		end
	end

	function self.rankSelect:OnSelect(index, value, data)
		local rank = teamData.ranks[data]
		local div = teamData.classes[panel.doneBtn.Division]

		if rank.model then
			panel.characterPreview:SetModel(rank.model)
		end

		if rank.subMaterial then
			panel.characterPreview.subMats = {}

			for v, k in pairs(rank.subMaterial) do
				panel.characterPreview.Entity:SetSubMaterial(v - 1, k)
				panel.characterPreview.subMats[v] = k
			end
		end

		if rank.bodygroups then
			for v, k in pairs(rank.bodygroups) do
				panel.characterPreview.Entity:SetBodygroup(k[1], k[2])
			end
		end

		if div and div.noSubMats then
			panel.characterPreview.Entity:SetSubMaterial(0, nil)
		end

		local useCPXP = rank.faction_xp != nil
		local requiredXP = useCPXP and rank.faction_xp or (rank.xp or 0)
		local availableXP = useCPXP and cpXP or normalXP

		if requiredXP > availableXP then
			panel.doneBtn.RankName = nil
			panel.doneBtn.Rank = nil
			return
		end

		panel.doneBtn.RankName = rank.name
		panel.doneBtn.Rank = data
	end

	self.descLbl = vgui.Create("DLabel", self)
	self.descLbl:SetFont("Impulse-Elements18-Shadow")
	self.descLbl:SetText("Description:")
	self.descLbl:SizeToContents()
	self.descLbl:SetPos(10, 175)

	self.descLblT = vgui.Create("DLabel", self)
	self.descLblT:SetText("")
	self.descLblT:SetFont("Impulse-Elements14")
	self.descLblT:SetPos(10, 195)
	self.descLblT:SetContentAlignment(7)
	self.descLblT:SetSize(300, 160)

	self.doneBtn = vgui.Create("DButton", self)
	self.doneBtn:SetPos(10, 370)
	self.doneBtn:SetSize(300, 23)
	self.doneBtn:SetText("No division or rank selected")
	self.doneBtn:SetDisabled(true)

	function self.doneBtn:Think()
		if self.DivisionName and self.RankName then
			self:SetText("Become a " .. self.DivisionName .. " " .. self.RankName)
			self:SetDisabled(false)
			return
		end

		self:SetDisabled(true)
		self:SetText("No valid division and/or rank selected")
	end

	function self.doneBtn:DoClick()
		if self.Division and self.Rank then
			net.Start("impulseHL2RPRankBecome")
			net.WriteUInt(self.Division, 8)
			net.WriteUInt(self.Rank, 8)
			net.SendToServer()

			panel:Remove()
		end
	end
end

vgui.Register("impulseRankMenu", PANEL, "DFrame")