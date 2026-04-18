local oilBroadcastCol = Color(210, 140, 30)

impulse.OilWorkshift = impulse.OilWorkshift or {
	active          = false,
	forming         = false,
	oilDeposited    = 0,
	reservoirLiters = 0,
	bonusCredits    = 0,
	squadSize       = 0,
	minGroupSize    = 2,
	goalMet         = false,
}

net.Receive("OilWorkshift_Update", function()
	local ws           = impulse.OilWorkshift
	ws.active          = net.ReadBool()
	ws.forming         = net.ReadBool()
	ws.reservoirLiters = net.ReadInt(32)
	ws.oilDeposited    = net.ReadInt(32)
	ws.bonusCredits    = net.ReadInt(32)
	ws.squadSize       = net.ReadInt(8)
	ws.minGroupSize    = net.ReadInt(8)
	ws.scaledGoal      = net.ReadInt(32)
	ws.scaledPayout    = net.ReadInt(32)
	if IsValid(impulse.OilMenuFrame) then
		impulse.OilMenuFrame:Refresh(ws)
	end
end)

net.Receive("OilWorkshift_Broadcast", function()
	local msgType    = net.ReadString()
	local supName    = net.ReadString()
	local completed  = net.ReadInt(16)
	local extra      = net.ReadString()

	if msgType == "forming" then
		chat.AddText(
			oilBroadcastCol, "[OIL REFINERY BROADCAST] ",
			color_white, supName,
			oilBroadcastCol, " is forming an Oil Refinery Workshift group. Head to the oil refinery to particpate!"
		)
	elseif msgType == "start" then
		chat.AddText(
			oilBroadcastCol, "[OIL REFINERY BROADCAST] ",
			color_white, supName .. "'s",
			oilBroadcastCol, " Oil Refinery Workshift has begun with ",
			color_white, extra .. " workers",
			oilBroadcastCol, "!"
		)
	elseif msgType == "end" then
		chat.AddText(
			oilBroadcastCol, "[OIL REFINERY BROADCAST] ",
			color_white, supName .. "'s",
			oilBroadcastCol, " workshift completed! That's ",
			color_white, tostring(completed),
			oilBroadcastCol, " shift(s) completed for the city!"
		)
	elseif msgType == "cancel" then
		chat.AddText(
			oilBroadcastCol, "[OIL REFINERY BROADCAST] ",
			color_white, supName .. "'s",
			oilBroadcastCol, " forming Oil Refinery Workshift has been cancelled."
		)
	elseif msgType == "cancelactive" then
		chat.AddText(
			oilBroadcastCol, "[OIL REFINERY BROADCAST] ",
			color_white, supName .. "'s",
			oilBroadcastCol, " Oil Refinery Workshift has been ended early."
		)
	end
end)

net.Receive("OilWorkshift_GoalMet", function()
	impulse.OilWorkshift.goalMet = true
	if IsValid(impulse.OilMenuFrame) then
		impulse.OilMenuFrame:Refresh(impulse.OilWorkshift)
	end
end)

net.Receive("OilWorkshift_End", function()
	local ws           = impulse.OilWorkshift
	ws.active          = false
	ws.forming         = false
	ws.goalMet         = false
	ws.oilDeposited    = 0
	ws.reservoirLiters = 0
	ws.bonusCredits    = 0
	ws.squadSize       = 0
	if IsValid(impulse.OilMenuFrame) then
		impulse.OilMenuFrame:Refresh(ws)
	end
end)

net.Receive("OilNPC_OpenMenu", function()
	local wsActive     = net.ReadBool()
	local wsForming    = net.ReadBool()
	local wsDeposited  = net.ReadInt(32)
	local wsReservoir  = net.ReadInt(32)
	local wsBonus      = net.ReadInt(32)
	local wsGoalMet    = net.ReadBool()
	local wsPaid       = net.ReadBool()
	local wsSupervisor = net.ReadString()
	local wsSquadSize  = net.ReadInt(8)
	local wsMinGroup   = net.ReadInt(8)
	local wsScaledGoal = net.ReadInt(32)
	local wsScaledPay  = net.ReadInt(32)
	local completed    = net.ReadInt(16)
	local isSupervisor = net.ReadBool()
	local isShiftLead  = net.ReadBool()

	local ws           = impulse.OilWorkshift
	ws.active          = wsActive
	ws.forming         = wsForming
	ws.oilDeposited    = wsDeposited
	ws.reservoirLiters = wsReservoir
	ws.bonusCredits    = wsBonus
	ws.goalMet         = wsGoalMet
	ws.paid            = wsPaid
	ws.supervisorName  = wsSupervisor
	ws.squadSize       = wsSquadSize
	ws.minGroupSize    = wsMinGroup
	ws.scaledGoal      = wsScaledGoal
	ws.scaledPayout    = wsScaledPay

	if IsValid(impulse.OilMenuFrame) then impulse.OilMenuFrame:Remove() end
	impulse.OilMenuFrame = OpenOilMenu(ws, completed, isSupervisor, isShiftLead)
end)

function OpenOilMenu(state, completedShifts, isSupervisor, isShiftLead)
	surface.PlaySound("buttons/button9.wav")

	local frame = vgui.Create("DFrame")
	frame:SetSize(440, 100)
	frame:Center()
	frame:SetSkin("combine")
	frame:MakePopup()
	frame:SetTitle("<:: OIL REFINERY FOREMAN")
	frame.lblTitle:SetFont("BudgetLabel")
	frame.lblTitle:SetTextColor(color_white)

	function frame:Refresh(s)
		if not IsValid(self) then return end

		if IsValid(self.statusLabel) then
			if s.active then
				self.statusLabel:SetText("STATUS: ACTIVE  |  Lead: " .. (s.supervisorName or ""))
				self.statusLabel:SetTextColor(Color(100, 255, 100))
			elseif s.forming then
				self.statusLabel:SetText("STATUS: FORMING  |  Lead: " .. (s.supervisorName or "") .. "  |  Workers: " .. (s.squadSize or 0) .. "/" .. (s.minGroupSize or 2) .. " min")
				self.statusLabel:SetTextColor(Color(255, 210, 50))
			else
				self.statusLabel:SetText("STATUS: NO ACTIVE WORKSHIFT")
				self.statusLabel:SetTextColor(Color(255, 100, 100))
			end
		end
		if IsValid(self.progressLabel) then
			local goal = s.scaledGoal or 2000
			self.progressLabel:SetText("Refined Oil Deposited:  " .. (s.oilDeposited or 0) .. "L  /  " .. goal .. "L")
		end
		if IsValid(self.reservoirLabel) then
			self.reservoirLabel:SetText("Crude Reservoir:  " .. (s.reservoirLiters or 0) .. "L  /  20000L")
		end
		if IsValid(self.bonusLabel) then
			self.bonusLabel:SetText("Filter Bonus Accrued:  +" .. (s.bonusCredits or 0) .. " cr")
		end
		if IsValid(self.formBtn) then
			self.formBtn:SetVisible(isSupervisor and not s.active and not s.forming)
		end
		if IsValid(self.beginBtn) then
			local canBegin = isShiftLead and s.forming and (s.squadSize or 0) >= (s.minGroupSize or 2)
			self.beginBtn:SetVisible(isShiftLead and s.forming)
			self.beginBtn:SetDisabled(not canBegin)
			self.beginBtn:SetText("BEGIN WORKSHIFT  (" .. (s.squadSize or 0) .. "/" .. (s.minGroupSize or 2) .. " min)")
		end
		if IsValid(self.payoutBtn) then
			self.payoutBtn:SetVisible(isShiftLead and s.goalMet and not s.paid)
			self.payoutBtn:SetDisabled(not s.goalMet or s.paid)
			local pay = (s.scaledPayout or 12000) + (s.bonusCredits or 0)
			self.payoutBtn:SetText("COLLECT PAYOUT  (" .. pay .. " cr)")
		end
		if IsValid(self.cancelBtn) then
			self.cancelBtn:SetVisible(isShiftLead and (s.active or s.forming))
		end
	end

	local y = 38

	local function AddLabel(text, color)
		local lbl = vgui.Create("DLabel", frame)
		lbl:SetPos(12, y)
		lbl:SetSize(416, 20)
		lbl:SetFont("BudgetLabel")
		lbl:SetText(text)
		lbl:SetTextColor(color or color_white)
		y = y + 26
		return lbl
	end

	local function AddDivider()
		local d = vgui.Create("DPanel", frame)
		d:SetPos(12, y)
		d:SetSize(416, 1)
		d:SetBackgroundColor(Color(70, 70, 70))
		y = y + 12
	end

	local function AddButton(text, color, onClick)
		local btn = vgui.Create("DButton", frame)
		btn:SetPos(12, y)
		btn:SetSize(416, 34)
		btn:SetText(text)
		btn:SetFont("BudgetLabel")
		if color then btn:SetTextColor(color) end
		btn.DoClick = onClick
		y = y + 42
		return btn
	end

	frame.statusLabel    = AddLabel("STATUS: ...", color_white)
	frame.progressLabel  = AddLabel("Refined Oil Deposited:  0L  /  2000L", Color(150, 200, 255))
	frame.reservoirLabel = AddLabel("Crude Reservoir:  0L  /  20000L", Color(210, 170, 50))
	frame.bonusLabel     = AddLabel("Filter Bonus Accrued:  +0 cr", Color(100, 220, 100))
	AddLabel("Total Completed Shifts:  " .. completedShifts, Color(180, 180, 220))

	AddDivider()

	if isSupervisor then
		frame.formBtn = AddButton("FORM OIL WORKSHIFT GROUP", Color(255, 220, 80), function()
			net.Start("OilWorkshift_Form")
			net.SendToServer()
			frame:Remove()
		end)
	end

	if isShiftLead then
		frame.beginBtn = AddButton("BEGIN WORKSHIFT  (0/2 min)", Color(100, 210, 255), function()
			net.Start("OilWorkshift_Begin")
			net.SendToServer()
			frame:Remove()
		end)

		frame.payoutBtn = AddButton("COLLECT WORKSHIFT PAYOUT", Color(100, 255, 120), function()
			net.Start("OilWorkshift_Payout")
			net.SendToServer()
			frame:Remove()
		end)

		frame.cancelBtn = AddButton("CANCEL / END WORKSHIFT", Color(255, 100, 100), function()
			local confirm = vgui.Create("DFrame")
			confirm:SetSize(300, 120)
			confirm:Center()
			confirm:SetSkin("combine")
			confirm:MakePopup()
			confirm:SetTitle("<:: CONFIRM CANCELLATION")
			confirm.lblTitle:SetFont("BudgetLabel")
			confirm.lblTitle:SetTextColor(color_white)

			local lbl = vgui.Create("DLabel", confirm)
			lbl:SetPos(10, 30)
			lbl:SetSize(280, 30)
			lbl:SetFont("DebugFixed")
			lbl:SetTextColor(Color(220, 80, 80))
			lbl:SetText("Are you sure? All progress will be lost.")
			lbl:SetWrap(true)

			local btnYes = vgui.Create("DButton", confirm)
			btnYes:SetPos(10, 70)
			btnYes:SetSize(130, 28)
			btnYes:SetFont("BudgetLabel")
			btnYes:SetText("YES, CANCEL")
			btnYes:SetTextColor(Color(220, 80, 80))
			btnYes.DoClick = function()
				net.Start("OilWorkshift_End")
				net.SendToServer()
				confirm:Remove()
				frame:Remove()
			end

			local btnNo = vgui.Create("DButton", confirm)
			btnNo:SetPos(158, 70)
			btnNo:SetSize(130, 28)
			btnNo:SetFont("BudgetLabel")
			btnNo:SetText("NO, GO BACK")
			btnNo:SetTextColor(Color(100, 220, 100))
			btnNo.DoClick = function() confirm:Remove() end
		end)
	end

	AddButton("CLOSE", color_white, function() frame:Remove() end)

	frame:SetTall(y + 10)
	frame:Refresh(state)
	return frame
end