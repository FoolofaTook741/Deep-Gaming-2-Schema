local PANEL = {}

function PANEL:Init()
	self.model = vgui.Create("DModelPanel", self)
	self.model:SetPaintBackground(false)
	self:SetMouseInputEnabled(true)
	self:SetTall(64)

	self:SetCursor("hand")
end

function PANEL:SetItem(netitem, wide)
	local direct = self.ContainerType
	local item = impulse.Inventory.Items[(direct and netitem) or netitem.id]
	self.Item = item

	if not direct then
		self.IsEquipped = netitem.equipped or false
		self.IsRestricted = netitem.restricted or false
	end

	self.Weight = item.Weight or 0
	self.Count = 1

	local panel = self

	self.model:SetPos(0, 0)
	self.model:SetSize(64, 64)
	self.model:SetMouseInputEnabled(true)
	self.model:SetModel(item.Model)
	self.model:SetSkin(item.Skin or 0)
	self.model:SetFOV(item.FOV or 35)

	if self.Item.ItemColour then
		self.model:SetColor(self.Item.ItemColour)
	end

	function self.model:LayoutEntity(ent)
	    ent:SetAngles(Angle(0, 90, 0))

	    if panel.Item.Material then
	        ent:SetMaterial(panel.Item.Material)
	    end

	    if not item.NoCenter then
	        self:SetLookAt(Vector(0, 0, 0))
	    end

	    hook.Run("InventoryItemLayoutEntity", ent, panel.Item, panel.InvID, panel.model, panel.Type)
	end

	function self.model:DoClick()
		panel:OnMousePressed()
	end

	function self.model:DoRightClick()
		panel:OnMousePressed(MOUSE_RIGHT)
	end

	local camPos = self.model.Entity:GetPos()
	camPos:Add(Vector(0, 25, 25))

	local min, max = self.model.Entity:GetRenderBounds()

	if item.CamPos then
		self.model:SetCamPos(item.CamPos)
	else
		self.model:SetCamPos(camPos -  Vector(10, 0, 16))
	end

	self.model:SetLookAt((max + min) / 2)

	self.desc = vgui.Create("DLabel", self)
	self.desc:SetPos(65, 30)

	if self.Basic then
		self.desc:SetSize(270, 30)
	else
		self.desc:SetSize(wide - 530, 30)
	end

	if wide < 800 then
		self.desc:SetFont("Impulse-Elements14")
	else
		self.desc:SetFont("Impulse-Elements16")
	end

	self.desc:SetText(item.Desc or "")
	self.desc:SetContentAlignment(7)
	self.desc:SetWrap(true)

	self.count = vgui.Create("DLabel", self)

	if self.IsRestricted or self.Item.Illegal then
		self.count:SetPos(42, 28)
	else
		self.count:SetPos(42, 38)
	end

	self.count:SetText("")
	self.count:SetTextColor(impulse.Config.MainColour)
	self.count:SetFont("Impulse-Elements19-Shadow")
	self.count:SetSize(36, 20)

	function self.count:Think()
		if panel.Count > 1 and panel.Count != self.lastCount then
			self:SetText("x"..panel.Count)
			self.lastCount = panel.Count
			panel.Weight = panel.Count * panel.Item.Weight

			local wShift = 0

			if panel.Count > 99 then
				wShift = -16
			elseif panel.Count > 9 then
				wShift = -8
			end

			if panel.IsRestricted or panel.Item.Illegal then
				self:SetPos(42 + wShift, 28)
			else
				self:SetPos(42 + wShift, 38)
			end
		end
	end

	if self.Basic then return end
	local restrictedMat = "icon16/error.png"
	local illegalMat = "icon16/exclamation.png"

	if self.IsRestricted then
		self.tip = vgui.Create("DImageButton", self)
		self.tip:SetPos(43, 45)
		self.tip:SetSize(16, 16)
		self.tip:SetImage(restrictedMat)
	elseif self.Item.Illegal then
		self.tip = vgui.Create("DImageButton", self)
		self.tip:SetPos(43, 45)
		self.tip:SetSize(16, 16)
		self.tip:SetImage(illegalMat)
	end
end

function PANEL:OnMousePressed(keycode)
	if self.Disabled then
		return
	end

	if self.ContainerType or self.ContainerInv then
		local itemid

		if self.Type == 1 then
			itemid = self.InvID
		else
			itemid = impulse.Inventory.ClassToNetID(self.Item.UniqueID)
		end
		net.Start("deepGroupInvContainerDoMove")
		net.WriteUInt(slot, 16)
		net.WriteUInt(self.Type, 4)
		net.SendToServer()


		return
	end
	
	if self.Basic then
		local invid = self.InvID
		local count = self.Count
		
		if keycode == MOUSE_RIGHT and count > 1 then
			
			local m = DermaMenu(self)
			local opt

			local function makeMoveOption(amount)
			local classID = impulse.Inventory.ClassToNetID(self.Item.UniqueID)
			local toGroup = (self.Type == 1)
			m:AddOption("Move "..amount, function()
				net.Start("deepGroupInvContainerDoMoveMass")
				net.WriteUInt(amount, 8)
				net.WriteUInt(classID, 10)
				net.WriteUInt(self.Type, 4)
			  net.SendToServer()
			end):SetIcon("icon16/arrow_right.png")
			end

			if count >= 2  then makeMoveOption(2)   end
			if count >= 5  then makeMoveOption(5)   end
			if count >= 10 then makeMoveOption(10)  end
			if count >= 15 then makeMoveOption(15)  end
			m:Open()

			return
			
		else
			net.Start("deepGroupInvContainerDoMove")
			net.WriteUInt(invid, 16)
			net.WriteUInt(self.Type, 4)
			net.SendToServer()

			return
		end
	end

	local popup = DermaMenu(self)
	popup.Inv = self

	if self.Item.OnUse then
		local shouldUse = true

		if self.Item.ShouldTraceUse then
			local trace = {}
			trace.start = LocalPlayer():EyePos()
			trace.endpos = trace.start + LocalPlayer():GetAimVector() * 85
			trace.filter = LocalPlayer()

			local trEnt = util.TraceLine(trace).Entity
			shouldUse = false

			if trEnt and IsValid(trEnt) and self.Item.ShouldTraceUse(self.Item, LocalPlayer(), trEnt) then
				shouldUse = true
			end
		end
		
	end

	function popup:Think()
		if not IsValid(self.Inv) then
			return self:Remove()
		end
	end

	popup:Open()
end

local bodyCol = Color(50, 50, 50, 210)
local restrictedCol = Color(255, 223, 0, 255)
local illegalCol = Color(255, 0, 0, 255)
local equippedCol =  Color(0, 220, 0, 140)
local restrictedMat =  Material("icon16/error.png")
local illegalMat = Material("icon16/exclamation.png")
function PANEL:Paint(w, h)
	surface.SetDrawColor(bodyCol)
	surface.DrawRect(0, 0, w, h)

	local item = self.Item
	if item then
		surface.SetTextColor(item.Colour or color_white)
		surface.SetFont("Impulse-Elements19-Shadow")
		surface.SetTextPos(65, 10)
		surface.DrawText(item.Name)

		draw.SimpleText(self.Weight.."kg", "Impulse-Elements16", w - 10, 10, color_white, TEXT_ALIGN_RIGHT)

		if self.Basic then return end

		if self.IsEquipped then
			surface.SetDrawColor(equippedCol)
			surface.DrawRect(0, 0, 5, h)
		end
	end
end

local disabledCol = Color(15, 15, 15, 210)
function PANEL:PaintOver(w, h)
	if self.Disabled then
		surface.SetDrawColor(disabledCol)
		surface.DrawRect(0, 0, w, h)
	end
end


vgui.Register("deepInventoryItem", PANEL, "DPanel")
