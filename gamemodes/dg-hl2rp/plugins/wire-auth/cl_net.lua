if CLIENT then

    local pendingEntries = {}
    local impulseE2Panel

    local PANEL = {}

    function PANEL:Init()
        self:SetSize(600,400)
        self:Center()
        self:SetTitle("Pending E2 Approvals")
        self:MakePopup()
        self:SetDeleteOnClose(true)

        self.list = vgui.Create("DListView", self)
        self.list:Dock(FILL)
        self.list:AddColumn("Hash")
        self.list:AddColumn("Owner")
        self.list:AddColumn("Score")
        self.list:AddColumn("Verdict")

        function self.list:OnRowRightClick(idx,row)
            local hash = row:GetValue(1)
            local data = pendingEntries[hash] or {}
            local menu = DermaMenu()

            menu:AddOption("View Code", function()
                local win = vgui.Create("DFrame")
                win:SetTitle("E2 Code: "..hash.." by "..data.owner)
                win:SetSize(800,600); win:Center(); win:MakePopup()
                win.Paint = function(self,w,h)
                    draw.RoundedBox(6,0,0,w,h,Color(30,30,30,230))
                end
                local html = vgui.Create("DHTML",win)
                html:Dock(FILL)
                local safe = (data.code or ""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
                html:SetHTML("<!doctype html><html><body style='background:#1e1e1e;color:#fff;font-family:Consolas,monospace;white-space:pre-wrap;'>"..safe.."</body></html>")
            end)

            menu:AddOption("AI Analysis", function()
                local rev = data.details or "No analysis available."
                local w = vgui.Create("DFrame")
                w:SetTitle("AI Analysis: "..hash)
                w:SetSize(500,300); w:Center(); w:MakePopup()
                local txt = vgui.Create("DTextEntry",w)
                txt:Dock(FILL); txt:SetMultiline(true); txt:SetEditable(false)
                txt:SetText(rev)
            end):SetIcon("icon16/information.png")

            menu:AddOption("Approve", function()
                net.Start("wire_e2_approve"); net.WriteString(hash); net.SendToServer()
                pendingEntries[hash] = nil
                if IsValid(impulseE2Panel) then impulseE2Panel:Refresh() end
            end):SetIcon("icon16/tick.png")

            menu:AddOption("Deny", function()
                local frm = vgui.Create("DFrame")
                frm:SetTitle("Deny E2: "..hash)
                frm:SetSize(400,200); frm:Center(); frm:MakePopup()
                local txt = vgui.Create("DTextEntry",frm)
                txt:Dock(TOP); txt:SetTall(100); txt:SetMultiline(true); txt:DockMargin(10,30,10,5)
                local btn = vgui.Create("DButton",frm)
                btn:Dock(BOTTOM); btn:DockMargin(10,5,10,10)
                btn:SetText("Send Denial")
                function btn:DoClick()
                    local reason = txt:GetValue():Trim()
                    if reason=="" then Derma_Message("Enter a reason.","Error","OK") return end
                    net.Start("wire_e2_deny")
                    net.WriteString(hash); net.WriteString(reason)
                    net.SendToServer()
                    pendingEntries[hash] = nil
                    if IsValid(impulseE2Panel) then impulseE2Panel:Refresh() end
                    frm:Close()
                end
            end):SetIcon("icon16/cross.png")

            menu:Open()
        end

        function self.list:OnRowCursorEntered(idx,row)
            local hash = row:GetColumnText(1)
            local data = pendingEntries[hash] or {}
            local verdict = data.verdict or "N/A"
            local details = data.details or "No analysis."
            row:SetTooltip("Verdict: "..verdict.."\nAnalysis: "..details)
        end
    end

    function PANEL:Refresh()
        self.list:Clear()
        for hash,data in pairs(pendingEntries) do
            local scoreTxt   = data.score   and string.format("%d%%", data.score) or "…"
            local verdictTxt = data.verdict or "N/A"
            local line = self.list:AddLine(hash, data.owner, scoreTxt, verdictTxt)
            line:SetTooltip("Verdict: "..verdictTxt.."\nAnalysis: "..(data.details or "No analysis."))
        end
    end

    vgui.Register("impulseE2SubmissionViewer", PANEL, "DFrame")

    concommand.Add("wire_e2_viewer", function()
        if not LocalPlayer():IsLeadAdmin() then
            chat.AddText(Color(255,0,0),"[WireE2] Access denied."); return
        end
        if not IsValid(impulseE2Panel) then
            impulseE2Panel = vgui.Create("impulseE2SubmissionViewer")
        else
            impulseE2Panel:MakePopup()
        end
        net.Start("wire_e2_request_list"); net.SendToServer()
    end)

    net.Receive("wire_e2_pending_list", function()
        if not LocalPlayer():IsLeadAdmin() then return end
        local count = net.ReadUInt(16)
        local wasOpen = IsValid(impulseE2Panel)
        for i=1,count do
            local hash, owner, code = net.ReadString(), net.ReadString(), net.ReadString()
            local prev = pendingEntries[hash] or {}
            pendingEntries[hash] = {
                owner   = owner,
                code    = code,
                score   = prev.score,
                verdict = prev.verdict,
                details = prev.details
            }
            if not prev.owner then
                chat.AddText(
                    Color(200,200,0),"[WireE2] New script pending: ",
                    Color(150,200,255),hash,
                    Color(255,255,255)," by ",
                    Color(150,200,255),owner
                )
                chat.AddText(
                    Color(0,200,0),"Type ",
                    Color(255,255,255),"wire_e2_viewer",
                    Color(0,200,0)," to open the panel."
                )
            end
        end
        if wasOpen then impulseE2Panel:Refresh() end
    end)

    net.Receive("wire_e2_review", function()
        if not LocalPlayer():IsLeadAdmin() then return end
        local hash, score, verdict, details =
            net.ReadString(), net.ReadFloat(), net.ReadString(), net.ReadString()
        pendingEntries[hash] = pendingEntries[hash] or {}
        pendingEntries[hash].score   = score
        pendingEntries[hash].verdict = verdict
        pendingEntries[hash].details = details
        if IsValid(impulseE2Panel) then impulseE2Panel:Refresh() end
    end)

    net.Receive("wire_e2_removed", function()
        if not LocalPlayer():IsLeadAdmin() then return end
        local hash = net.ReadString()
        pendingEntries[hash] = nil
        if IsValid(impulseE2Panel) then impulseE2Panel:Refresh() end
    end)
	
	net.Receive("wire_e2_user_approved", function()
		local adminName = net.ReadString()

		chat.AddText(
			Color(0, 200, 0),
			"[WireE2] ",
			color_white,
			string.format("Your E2 has been approved by %s.", adminName)
		)
	end)

	net.Receive("wire_e2_user_denied", function()
		local adminName = net.ReadString()
		local reason    = net.ReadString()

		chat.AddText(
			Color(200, 0, 0),
			"[WireE2] ",
			color_white, 
			string.format("Your E2 has been denied by %s.", adminName),
			color_white,
			" Reason: ",
			Color(200, 200, 200),
			reason
		)
	end)
end