local smeltBroadcastCol = Color(255, 180, 0)

local smeltState = {
	active         = false,
	smeltCount     = 0,
	smeltGoal      = 0,
	refinedCount   = 0,
	refinedGoal    = 0,
	bonusCredits   = 0,
	supervisorName = "",
	completedShifts = 0,
	payoutReady    = false,
}

net.Receive("SmeltingWorkshift_Update", function()
	smeltState.active           = net.ReadBool()
	smeltState.smeltCount       = net.ReadInt(16)
	smeltState.smeltGoal        = net.ReadInt(16)
	smeltState.refinedCount     = net.ReadInt(16)
	smeltState.refinedGoal      = net.ReadInt(16)
	smeltState.bonusCredits     = net.ReadInt(16)
	smeltState.supervisorName   = net.ReadString()
	smeltState.completedShifts  = net.ReadInt(16)
	smeltState.payoutReady      = net.ReadBool()

	if IsValid(impulse.SmeltingMenuFrame) then
		impulse.SmeltingMenuFrame:Refresh(smeltState)
	end
end)

net.Receive("SmeltingWorkshift_Broadcast", function()
	local msgType       = net.ReadString()
	local supervisorName = net.ReadString()
	local completedShifts = net.ReadInt(16)

	if msgType == "start" then
		chat.AddText(
			smeltBroadcastCol, "[REFINERY BROADCAST] ",
			color_white, supervisorName,
			smeltBroadcastCol, " has started a smelting workshift! Report to the refinery to participate."
		)
	elseif msgType == "end" then
		chat.AddText(
			smeltBroadcastCol, "[REFINERY BROADCAST] ",
			color_white, supervisorName .. "'s",
			smeltBroadcastCol, " workshift has completed successfully. That's ",
			color_white, tostring(completedShifts),
			smeltBroadcastCol, " smelting shift(s) completed for the city!"
		)
	elseif msgType == "cancel" then
	chat.AddText(
		smeltBroadcastCol, "[REFINERY BROADCAST] ",
		color_white, supervisorName,
		smeltBroadcastCol, "'s smelting workshift has been cancelled."
	)
	end
end)

net.Receive("SmeltingNPC_OpenMenu", function()
	local wsActive        = net.ReadBool()
	local wsSmeltCount    = net.ReadInt(16)
	local wsSmeltGoal     = net.ReadInt(16)
	local wsRefinedCount  = net.ReadInt(16)
	local wsRefinedGoal   = net.ReadInt(16)
	local wsBonusCredits  = net.ReadInt(16)
	local wsSupervisor    = net.ReadString()
	local completedShifts = net.ReadInt(16)
	local payoutReady     = net.ReadBool()
	local isSupervisor    = net.ReadBool()

	smeltState.active           = wsActive
	smeltState.smeltCount       = wsSmeltCount
	smeltState.smeltGoal        = wsSmeltGoal
	smeltState.refinedCount     = wsRefinedCount
	smeltState.refinedGoal      = wsRefinedGoal
	smeltState.bonusCredits     = wsBonusCredits
	smeltState.supervisorName   = wsSupervisor
	smeltState.completedShifts  = completedShifts
	smeltState.payoutReady      = payoutReady

	if IsValid(impulse.SmeltingMenuFrame) then
		impulse.SmeltingMenuFrame:Remove()
	end

	impulse.SmeltingMenuFrame = OpenSmeltingMenu(smeltState, isSupervisor)
end)

function OpenSmeltingMenu(state, isSupervisor)
	surface.PlaySound("buttons/button9.wav")

	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 400)
	frame:Center()
	frame:SetSkin("combine")
	frame:MakePopup()
	frame:SetTitle("<:: REFINERY FOREMAN ::>")
	frame.lblTitle:SetFont("BudgetLabel")
	frame.lblTitle:SetTextColor(color_white)

	function frame:Refresh(s)
		if IsValid(self.lblStatus) then
			if s.active then
				self.lblStatus:SetText("STATUS: ACTIVE WORKSHIFT")
				self.lblStatus:SetTextColor(Color(100, 220, 100))
			else
				self.lblStatus:SetText("STATUS: NO ACTIVE WORKSHIFT")
				self.lblStatus:SetTextColor(Color(220, 100, 100))
			end
		end

		if IsValid(self.lblSupervisor) then
			self.lblSupervisor:SetText(s.active and ("SHIFT LEAD: " .. s.supervisorName) or "SHIFT LEAD: --")
		end

		if IsValid(self.lblSmelt) then
			self.lblSmelt:SetText(s.active and ("SCRAP SMELTED: " .. s.smeltCount) or "SCRAP SMELTED: --")
		end

		if IsValid(self.lblRefined) then
			self.lblRefined:SetText(s.active and ("STEEL DELIVERED: " .. s.refinedCount .. " / " .. s.refinedGoal) or "STEEL DELIVERED: --")
		end

		if IsValid(self.refinedBar) then
			self.refinedBar:SetFraction(s.active and s.refinedGoal > 0 and math.Clamp(s.refinedCount / s.refinedGoal, 0, 1) or 0)
		end

		if IsValid(self.lblBonus) then
			self.lblBonus:SetText(s.active and ("RECYCLE BONUS: +" .. s.bonusCredits .. " cr") or "RECYCLE BONUS: --")
		end

		if IsValid(self.btnPayout) then
			self.btnPayout:SetVisible(isSupervisor and s.payoutReady)
			self.btnPayout:SetDisabled(not s.payoutReady)
		end

		if IsValid(self.btnStart) then
			self.btnStart:SetVisible(isSupervisor and not s.active)
			self.btnStart:SetDisabled(s.active)
		end

		if IsValid(self.btnCancel) then
			self.btnCancel:SetVisible(isSupervisor and s.active)
		end
	end

	local function Divider(parent, y, alpha)
		local div = vgui.Create("DPanel", parent)
		div:SetPos(10, y)
		div:SetSize(380, 1)
		function div:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 200, 50, alpha or 120))
		end
	end

	Divider(frame, 30)

	frame.lblStatus = vgui.Create("DLabel", frame)
	frame.lblStatus:SetPos(10, 38)
	frame.lblStatus:SetSize(380, 20)
	frame.lblStatus:SetFont("BudgetLabel")

	frame.lblSupervisor = vgui.Create("DLabel", frame)
	frame.lblSupervisor:SetPos(10, 60)
	frame.lblSupervisor:SetSize(380, 16)
	frame.lblSupervisor:SetFont("DebugFixed")
	frame.lblSupervisor:SetTextColor(Color(200, 200, 200))

	Divider(frame, 80, 80)

	frame.lblSmelt = vgui.Create("DLabel", frame)
	frame.lblSmelt:SetPos(10, 88)
	frame.lblSmelt:SetSize(380, 16)
	frame.lblSmelt:SetFont("DebugFixed")
	frame.lblSmelt:SetTextColor(Color(200, 200, 200))

	frame.lblRefined = vgui.Create("DLabel", frame)
	frame.lblRefined:SetPos(10, 108)
	frame.lblRefined:SetSize(380, 16)
	frame.lblRefined:SetFont("DebugFixed")
	frame.lblRefined:SetTextColor(Color(200, 200, 200))

	frame.refinedBar = vgui.Create("DProgress", frame)
	frame.refinedBar:SetPos(10, 128)
	frame.refinedBar:SetSize(380, 14)
	frame.refinedBar:SetFraction(0)

	frame.lblBonus = vgui.Create("DLabel", frame)
	frame.lblBonus:SetPos(10, 148)
	frame.lblBonus:SetSize(380, 16)
	frame.lblBonus:SetFont("DebugFixed")
	frame.lblBonus:SetTextColor(Color(100, 220, 100))

	Divider(frame, 170, 80)

	local lblCompleted = vgui.Create("DLabel", frame)
	lblCompleted:SetPos(10, 178)
	lblCompleted:SetSize(380, 16)
	lblCompleted:SetFont("DebugFixed")
	lblCompleted:SetTextColor(Color(255, 200, 50))
	lblCompleted:SetText("TOTAL COMPLETED WORKSHIFTS: " .. state.completedShifts)

	local lblDesc = vgui.Create("DLabel", frame)
	lblDesc:SetPos(10, 198)
	lblDesc:SetSize(380, 40)
	lblDesc:SetFont("DebugFixed")
	lblDesc:SetTextColor(Color(170, 170, 170))
	lblDesc:SetText("Smelt scrap, refine copper into steel,\ndeliver steel bars to the finish cart.")
	lblDesc:SetWrap(true)

	Divider(frame, 242, 80)

	frame.btnStart = vgui.Create("DButton", frame)
	frame.btnStart:SetPos(10, 250)
	frame.btnStart:SetSize(380, 28)
	frame.btnStart:SetFont("BudgetLabel")
	frame.btnStart:SetText("START REFINERY WORKSHIFT")
	frame.btnStart:SetTextColor(Color(255, 220, 80))
	function frame.btnStart:DoClick()
		surface.PlaySound("buttons/button9.wav")
		net.Start("SmeltingWorkshift_Start")
		net.SendToServer()
		if IsValid(impulse.SmeltingMenuFrame) then
			impulse.SmeltingMenuFrame:Remove()
		end
	end

	frame.btnPayout = vgui.Create("DButton", frame)
	frame.btnPayout:SetPos(10, 286)
	frame.btnPayout:SetSize(380, 28)
	frame.btnPayout:SetFont("BudgetLabel")
	frame.btnPayout:SetText("COLLECT WORKSHIFT PAYOUT")
	frame.btnPayout:SetTextColor(Color(100, 255, 120))
	function frame.btnPayout:DoClick()
		surface.PlaySound("buttons/button9.wav")
		net.Start("SmeltingWorkshift_Payout")
		net.SendToServer()
		if IsValid(impulse.SmeltingMenuFrame) then
			impulse.SmeltingMenuFrame:Remove()
		end
	end

	frame.btnCancel = vgui.Create("DButton", frame)
	frame.btnCancel:SetPos(10, 322)
	frame.btnCancel:SetSize(380, 28)
	frame.btnCancel:SetFont("BudgetLabel")
	frame.btnCancel:SetText("CANCEL WORKSHIFT")
	frame.btnCancel:SetTextColor(Color(220, 80, 80))
	function frame.btnCancel:DoClick()
		surface.PlaySound("buttons/button9.wav")

		local confirm = vgui.Create("DFrame")
		confirm:SetSize(300, 120)
		confirm:Center()
		confirm:SetSkin("combine")
		confirm:MakePopup()
		confirm:SetTitle("<:: CONFIRM CANCELLATION")
		confirm.lblTitle:SetFont("BudgetLabel")
		confirm.lblTitle:SetTextColor(color_white)
		function confirm:Paint(w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 240))
			draw.RoundedBox(4, 0, 0, w, 24, Color(180, 30, 30, 240))
		end

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
		function btnYes:DoClick()
			surface.PlaySound("buttons/button9.wav")
			net.Start("SmeltingWorkshift_Cancel")
			net.SendToServer()
			confirm:Remove()
			if IsValid(impulse.SmeltingMenuFrame) then
				impulse.SmeltingMenuFrame:Remove()
			end
		end

		local btnNo = vgui.Create("DButton", confirm)
		btnNo:SetPos(158, 70)
		btnNo:SetSize(130, 28)
		btnNo:SetFont("BudgetLabel")
		btnNo:SetText("NO, GO BACK")
		btnNo:SetTextColor(Color(100, 220, 100))
		function btnNo:DoClick()
			surface.PlaySound("buttons/button9.wav")
			confirm:Remove()
		end
	end

	local btnClose = vgui.Create("DButton", frame)
	btnClose:SetPos(10, 362)
	btnClose:SetSize(380, 24)
	btnClose:SetFont("DebugFixed")
	btnClose:SetText("[ CLOSE ]")
	function btnClose:DoClick()
		surface.PlaySound("buttons/button9.wav")
		frame:Remove()
	end

	frame:Refresh(state)

	return frame
end
