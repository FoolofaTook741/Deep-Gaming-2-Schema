local PANEL = {}

local resin = 0
local researchpoints = 0
local funding = 0
local weaponryresearchlevel = 0
local technologyresearchlevel = 0
local economyresearchlevel = 0
local raf = 1

net.Receive("DeepUpdateResearch", function()
	resin = net.ReadFloat()
	researchpoints = net.ReadUInt(32)
	funding = net.ReadUInt(32)
	weaponryresearchlevel = net.ReadUInt(32)
	technologyresearchlevel = net.ReadUInt(32)
	economyresearchlevel = net.ReadUInt(32)
	raf = net.ReadUInt(32)
end)


function PANEL:Init()
	self:SetSize(430, 450)
	self:Center()
	self:SetSkin("combine")
	self:MakePopup()
	self.lblTitle:SetFont("BudgetLabel")
	self.lblTitle:SetTextColor(color_white)

	local panel = self
	local lp = LocalPlayer()

	self:SetTitle("<:: WORKFORCE MANAGEMENT SYSTEM")
	self:SetUpCWPDA()
end


function PANEL:SetUpCWPDA()
    self.sheet = vgui.Create("DColumnSheet", self)
	self.sheet:Dock(FILL)
	self.sheet.Navigation:SetWidth(50)
	
	if IsValid(self.make) then
		self.make:Remove()
	end

	if IsValid(self.scroll) then
		self.scroll:Remove()
	end
    
	
    local panel = self
	
	self.squadPnl = vgui.Create("DPanel", self.sheet)
	self.squadPnl:Dock(FILL)
	self.squadPnl.IsSquadPanel = true

	self.sheet:AddSheet("SHIFTS", self.squadPnl).Button:SetFont("DebugFixed")
	self.scroll = vgui.Create("DScrollPanel", self.squadPnl)
	self.scroll:SetPos(10, 80)
	self.scroll:SetSize(340, 370)

	local squads = {}
	local lp = LocalPlayer()
	local mySquad = lp:GetSyncVar(SYNC_CWU_SQUAD, 0)
	if mySquad == 0 then mySquad = nil end
	local imLeader = lp:GetSyncVar(SYNC_CWU_SQUADLEAD)
	local curSquads = 0

	for _, ply in pairs(team.GetPlayers(lp:Team())) do
        if ply:Team() ~= TEAM_CWU then continue end
        local squadID = ply:GetSyncVar(SYNC_CWU_SQUAD)
		if not squadID or squadID == 0 then continue end
		local plyIsLeader = ply:GetSyncVar(SYNC_CWU_SQUADLEAD)
		
		local function addUnit(s)
			local base = vgui.Create("DPanel")
			base:SetSkin("combine")
			function base:Paint() end

			local lbl = vgui.Create("DLabel", base)
			lbl:SetPos(0, 0)
			lbl:SetText("  ⏺ " .. ply:Nick() .. (plyIsLeader and " (LEAD)" or ""))
			lbl:SetFont("DebugFixed")
			lbl:SizeToContents()

			if squadID == mySquad then
				lbl:SetTextColor(Color(75,155,45))
			end

			if (squadID == mySquad) and imLeader and (ply ~= lp) then
				local kick = vgui.Create("DButton", base)
				kick:SetText("KICK")
				kick:SetFont("DebugFixed")
				kick:SetPos(290, 2)
				kick:SetSize(35, 16)
				function kick:DoClick()
					surface.PlaySound("buttons/button9.wav")
					if not IsValid(ply) then return LocalPlayer():Notify("This player disconnected!") end
					net.Start("workshiftSquadKick")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end

			if plyIsLeader then
				s.members:InsertAtTop(base)
				s.HasLeader = true
			else
				s.members:AddItem(base)
			end
			s.count = (s.count or 0) + 1
		end

		if not squads[squadID] then
			squads[squadID] = vgui.Create("DCollapsibleCategory", self.scroll)
			squads[squadID]:SetLabel("WS " .. squadID)
			squads[squadID]:Dock(TOP)
			squads[squadID].Header:SetFont("DebugFixed")
			if mySquad then
					if squadID == mySquad then
						squads[squadID].Header:SetTextColor(Color(75,155,45))
					else
						squads[squadID]:SetExpanded(false)
					end
				else
					squads[squadID]:SetExpanded(true)
				end

			local colInv = Color(29, 50, 107, 120)
			squads[squadID].Paint = function(self)
				self:SetBGColor(colInv)
			end

			local s = squads[squadID]
			s.squadId = squadID
			s.members = vgui.Create("DPanelList", s)
			s.members:EnableHorizontal(false)
			s:SetContents(s.members)

			if not mySquad or mySquad == squadID then
				s.join = vgui.Create("DButton", squads[squadID].Header)
				s.join:SetText(squadID == mySquad and "LEAVE" or "JOIN")
				s.join:SetFont("DebugFixed")
				s.join:SetPos(250, 0)
				s.join:SetSize(90, 20)
				s.join:SetTextColor(squadID == mySquad and Color(255, 0, 0) or nil)


				if squadID ~= mySquad and not lp:CWUSquadCanJoin(squadID) then
					s.join:SetDisabled(true)
				end
				function s.join:DoClick()
					if squadID ~= mySquad then
						net.Start("workshiftSquadJoin")
						net.WriteUInt(squadID, 8)
						net.SendToServer()
					else
						net.Start("workshiftSquadLeave")
						net.SendToServer()
					end
				end
			end



			addUnit(s)
			curSquads = curSquads + 1
		else
			addUnit(squads[squadID])
		end
	end
	
	for squadID, pnl in pairs(squads) do
		if mySquad == squadID and not pnl.HasLeader then
			pnl.claim = vgui.Create("DButton", pnl.Header)
			pnl.claim:SetText("CLAIM")
			pnl.claim:SetFont("DebugFixed")
			pnl.claim:SetPos(150, 0)
			pnl.claim:SetSize(90, 20)

			pnl.claim.DoClick = function(self)
				net.Start("workshiftSquadClaim")
				net.SendToServer()
				surface.PlaySound("buttons/button9.wav")
			end
		end
		pnl:SetLabel("WS "..pnl.squadId.."    ("..pnl.count.."/"..(lp:Team() == TEAM_CWU and 10)..")")
	end

	self.make = vgui.Create("DButton", self.squadPnl)
	self.make:SetPos(10, 50)
	self.make:SetSize(340, 20)
	self.make:SetFont("DebugFixed")
	self.make:SetText("CREATE WORKSHIFT (" .. curSquads .. "/4)")
	if not lp:CWUSquadCanMake() then
		self.make:SetDisabled(true)
	end
	function self.make:DoClick()
		net.Start("workshiftSquadMake")
		net.SendToServer()
		surface.PlaySound("buttons/button9.wav")
	end
	
	if (LocalPlayer():GetTeamClass() == CLASS_RESEARCH or LocalPlayer():GetTeamRank() >= RANK_MINISTER) and (LocalPlayer():Team() == TEAM_CWU or LocalPlayer():Team() == TEAM_VORT) then
		self.researchpanel = vgui.Create("DPanel", self.sheet)
		self.researchpanel:Dock(FILL)		
		self.sheet:AddSheet("R&D", self.researchpanel).Button:SetFont("DebugFixed")

		self.resincount = vgui.Create("DLabel", self.researchpanel)
		self.resincount:SetText("RESIN: " .. resin .. " KG")
		self.resincount:SetFont("DebugFixed")
		self.resincount:SizeToContents()
		self.resincount:Dock(TOP)

		self.rpcount = vgui.Create("DLabel", self.researchpanel)
		self.rpcount:SetText("RESEARCH POINTS: " .. researchpoints)
		self.rpcount:SetFont("DebugFixed")
		self.rpcount:SizeToContents()
		self.rpcount:Dock(TOP)

		self.fundingcount = vgui.Create("DLabel", self.researchpanel)
		self.fundingcount:SetText("FUNDING: " .. funding .. "C")
		self.fundingcount:SetFont("DebugFixed")
		self.fundingcount:SizeToContents()
		self.fundingcount:Dock(TOP)

		self.blank1 = vgui.Create("DLabel", self.researchpanel)
		self.blank1:SetText("")
		self.blank1:SetFont("DebugFixed")
		self.blank1:SizeToContents()
		self.blank1:Dock(TOP)

		self.weaponslvl = vgui.Create("DLabel", self.researchpanel)
		self.weaponslvl:SetText("WEAPONS RESEARCH LEVEL: " .. weaponryresearchlevel)
		self.weaponslvl:SetFont("DebugFixed")
		self.weaponslvl:SizeToContents()
		self.weaponslvl:Dock(TOP)

		self.economylvl = vgui.Create("DLabel", self.researchpanel)
		self.economylvl:SetText("ECONOMY RESEARCH LEVEL: " .. economyresearchlevel)
		self.economylvl:SetFont("DebugFixed")
		self.economylvl:SizeToContents()
		self.economylvl:Dock(TOP)

		self.techlvl = vgui.Create("DLabel", self.researchpanel)
		self.techlvl:SetText("TECHNOLOGY RESEARCH LEVEL: " .. technologyresearchlevel)
		self.techlvl:SetFont("DebugFixed")
		self.techlvl:SizeToContents()
		self.techlvl:Dock(TOP)

		self.blank = vgui.Create("DLabel", self.researchpanel)
		self.blank:SetText("")
		self.blank:SetFont("DebugFixed")
		self.blank:SizeToContents()
		self.blank:Dock(TOP)

		self.raf = vgui.Create("DLabel", self.researchpanel)
		self.raf:SetText("RESEARCH ACCUMULATION FACTOR: " .. raf .. "/m")
		self.raf:SetFont("DebugFixed")
		self.raf:SizeToContents()
		self.raf:Dock(TOP)

		self.blank = vgui.Create("DLabel", self.researchpanel)
		self.blank:SetText("")
		self.blank:SetFont("DebugFixed")
		self.blank:SizeToContents()
		self.blank:Dock(TOP)
	end
	
	if (LocalPlayer():GetTeamClass() == CLASS_RESEARCH and LocalPlayer():GetTeamRank() >= RANK_SUPERVISOR or LocalPlayer():GetTeamRank() >= RANK_MINISTER) and (LocalPlayer():Team() == TEAM_CWU or LocalPlayer():Team() == TEAM_VORT) then
	
		self.complabel = vgui.Create("DLabel", self.researchpanel)
		self.complabel:SetText("RESEARCH COMPUTERS:")
		self.complabel:SetFont("DebugFixed")
		self.complabel:SizeToContents()
		self.complabel:Dock(TOP)
		
		self.PurchaseLRGC = vgui.Create("DButton", self.researchpanel)
		self.PurchaseLRGC:SetFont("BudgetLabel")
		self.PurchaseLRGC:SetText("PURCHASE L.G.R.C. - 2500C")
		self.PurchaseLRGC.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("lgrc")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseLRGC:Dock(TOP)

		self.PurchaseMRGC = vgui.Create("DButton", self.researchpanel)
		self.PurchaseMRGC:SetFont("BudgetLabel")
		self.PurchaseMRGC:SetText("PURCHASE M.G.R.C. - 7000C")
		self.PurchaseMRGC.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("mgrc")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseMRGC:Dock(TOP)

		self.PurchaseHRGC = vgui.Create("DButton", self.researchpanel)
		self.PurchaseHRGC:SetFont("BudgetLabel")
		self.PurchaseHRGC:SetText("PURCHASE H.G.R.C. - 15000C")
		self.PurchaseHRGC.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("hgrc")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseHRGC:Dock(TOP)

		self.blank = vgui.Create("DLabel", self.researchpanel)
		self.blank:SetText("")
		self.blank:SetFont("DebugFixed")
		self.blank:SizeToContents()
		self.blank:Dock(TOP)

		self.matlabel = vgui.Create("DLabel", self.researchpanel)
		self.matlabel:SetText("MATERIAL SHIPMENTS:")
		self.matlabel:SetFont("DebugFixed")
		self.matlabel:SizeToContents()
		self.matlabel:Dock(TOP)

		self.PurchasePlastic = vgui.Create("DButton", self.researchpanel)
		self.PurchasePlastic:SetFont("BudgetLabel")
		self.PurchasePlastic:SetText("PURCHASE PLASTIC SHIPMENT - 250C")
		self.PurchasePlastic.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("plastic")
			net.SendToServer()
			self:Remove()
		end
		self.PurchasePlastic:Dock(TOP)

		self.PurchaseResin = vgui.Create("DButton", self.researchpanel)
		self.PurchaseResin:SetFont("BudgetLabel")
		self.PurchaseResin:SetText("PURCHASE RESIN SHIPMENT - 3000C")
		self.PurchaseResin.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("resin")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseResin:Dock(TOP)

		self.blank = vgui.Create("DLabel", self.researchpanel)
		self.blank:SetText("")
		self.blank:SetFont("DebugFixed")
		self.blank:SizeToContents()
		self.blank:Dock(TOP)

		self.matlabel = vgui.Create("DLabel", self.researchpanel)
		self.matlabel:SetText("MACHINERY:")
		self.matlabel:SetFont("DebugFixed")
		self.matlabel:SizeToContents()
		self.matlabel:Dock(TOP)

		self.PurchaseResin = vgui.Create("DButton", self.researchpanel)
		self.PurchaseResin:SetFont("BudgetLabel")
		self.PurchaseResin:SetText("PURCHASE FABRICATOR - 25000C")
		self.PurchaseResin.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("fabricator")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseResin:Dock(TOP)

		self.PurchaseRecycler = vgui.Create("DButton", self.researchpanel)
		self.PurchaseRecycler:SetFont("BudgetLabel")
		self.PurchaseRecycler:SetText("PURCHASE RECYCLER - 5000C")
		self.PurchaseRecycler.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("recycler")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseRecycler:Dock(TOP)

		self.PurchaseACF = vgui.Create("DButton", self.researchpanel)
		self.PurchaseACF:SetFont("BudgetLabel")
		self.PurchaseACF:SetText("PURCHASE A.C.F. - 25000C")
		self.PurchaseACF.DoClick = function()
			net.Start("DeepPurchaseRC")
			net.WriteString("acf")
			net.SendToServer()
			self:Remove()
		end
		self.PurchaseACF:Dock(TOP)
	end

    if LocalPlayer():GetTeamRank() >= RANK_SUPERVISOR then
		self.workshiftpnl = vgui.Create("DPanel", self.sheet)
		self.workshiftpnl:Dock(FILL)

		function self.workshiftpnl:Paint()
			return
		end
		self.StartMiningWorkshift = vgui.Create("DButton", self.workshiftpnl)
    	self.StartMiningWorkshift:SetFont("BudgetLabel")
    	self.StartMiningWorkshift:SetText("START REFINERY WORKSHIFT")
    	self.StartMiningWorkshift.DoClick = function()
    	    net.Start("DeepStartWorkshift")
    	    net.WriteString("mining")
    	    net.SendToServer()
    	    self:Remove()
    	end
    	self.StartMiningWorkshift:Dock(TOP)

        self.StartLaundryWorkshift = vgui.Create("DButton", self.workshiftpnl)
    	self.StartLaundryWorkshift:SetFont("BudgetLabel")
    	self.StartLaundryWorkshift:SetText("START LAUNDROMAT WORKSHIFT")
    	self.StartLaundryWorkshift.DoClick = function()
    	    net.Start("DeepStartWorkshift")
    	    net.WriteString("laundry")
    	    net.SendToServer()
    	    self:Remove()
    	end
    	self.StartLaundryWorkshift:Dock(TOP)

        self.StartOutlandsWorkshift = vgui.Create("DButton", self.workshiftpnl)
    	self.StartOutlandsWorkshift:SetFont("BudgetLabel")
    	self.StartOutlandsWorkshift:SetText("START OUTLANDS WORKSHIFT")
    	self.StartOutlandsWorkshift.DoClick = function()
    	    net.Start("DeepStartWorkshift")
    	    net.WriteString("outlands")
    	    net.SendToServer()
    	    self:Remove()
    	end
    	self.StartOutlandsWorkshift:Dock(TOP)

        self.StartICTWorkshift = vgui.Create("DButton", self.workshiftpnl)
    	self.StartICTWorkshift:SetFont("BudgetLabel")
    	self.StartICTWorkshift:SetText("START ICT WORKSHIFT")
    	self.StartICTWorkshift.DoClick = function()
    	    net.Start("DeepStartWorkshift")
    	    net.WriteString("ict")
    	    net.SendToServer()
    	    self:Remove()
    	end
    	self.StartICTWorkshift:Dock(TOP)

        self.StartMedicalWorkshift = vgui.Create("DButton", self.workshiftpnl)
    	self.StartMedicalWorkshift:SetFont("BudgetLabel")
    	self.StartMedicalWorkshift:SetText("START MEDICAL WORKSHIFT")
    	self.StartMedicalWorkshift.DoClick = function()
    	    net.Start("DeepStartWorkshift")
    	    net.WriteString("medical")
    	    net.SendToServer()
    	    self:Remove()
    	end
    	self.StartMedicalWorkshift:Dock(TOP)
		
		self.sheet:AddSheet("WORK", self.workshiftpnl).Button:SetFont("DebugFixed")

		self.workerPnl = vgui.Create("DPanel", self.sheet)
		self.workerPnl:Dock(FILL)

		local b = self.sheet:AddSheet("STAFF", self.workerPnl)
		b.Button:SetFont("DebugFixed")

		self.workerScroll = vgui.Create("DScrollPanel", self.workerPnl)
		self.workerScroll:Dock(FILL)
		
		for v,k in pairs(player.GetAll()) do
			if k:Team() == TEAM_CWU then
				local entry = self.workerScroll:Add("impulseTerminalPlayer")
				entry.NoButtons = true
				entry.master = self
				entry:SetWorkerPlayer(k)
				entry:SetHeight(60)
				entry:Dock(TOP)
			end
		end

		function self.workerPnl:Paint()
			return
		end
	end
end

vgui.Register("DeepCWPDAMenu", PANEL, "DFrame")

net.Receive("DeepOpenCWMenu", function()
	impulse.CWMenu = vgui.Create("DeepCWPDAMenu")
end)


