local PANEL = {}
local bodyCol = Color(0, 0, 0, 250)

local speed = 1000

local w, h = ScrW(), ScrH()
local blurDrawPanel = {
	[1] = function(x, y, w, h)
		-- Bokeh DOF blur
		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
		DrawBokehDOF(6, 0, 0)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
}

local function BlurRect(x, y, w, h)
	blurDrawPanel[1](x,y,w,h)
end

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:SetTitle("")
	self:MakePopup()
	self:SetDraggable(false)
end

function PANEL:SetupVendor()
	local lp = LocalPlayer()

	local trace = {}
	trace.start = lp:EyePos()
	trace.endpos = trace.start + lp:GetAimVector() * 120
	trace.filter = lp

	local tr = util.TraceLine(trace)

	if not tr.Entity or not IsValid(tr.Entity) or tr.Entity:GetClass() != "impulse_vendor" then
		return self:Remove()
	end

	local npc = tr.Entity
	local vendorType = npc:GetVendor()

	if not vendorType then
		return print("[impulse] Vendor has no VendorType set!")
	end

	if not impulse.Vendor.Data[vendorType] then
		return print("[impulse] "..vendorType.." invalid.")
	end

	self.NPC = npc
	self.Vendor = impulse.Vendor.Data[vendorType]

	if self.Vendor.Talk and impulse.GetSetting("misc_vendorgreeting", true) then
		surface.PlaySound(impulse.GetRandomAmbientVO(self.Vendor.Gender))
	end

	local yNameLbl = vgui.Create("DLabel", self)
	yNameLbl:SetText("Vendor")
	yNameLbl:SetFont("terminal64")
	yNameLbl:SetPos(80, 65)
	yNameLbl:SizeToContents()

	local vDescLbl = vgui.Create("DLabel", self)
	vDescLbl:SetText(self.Vendor.Desc)
	vDescLbl:SetFont("terminal32")
	vDescLbl:SetPos(w * 0.4, 58)
	vDescLbl:SetSize(ScrW(), 40)

	local yNameLbl = vgui.Create("DLabel", self)
	yNameLbl:SetText("- You")
	yNameLbl:SetFont("terminal64")
	yNameLbl:SetPos(1600, 58)
	yNameLbl:SizeToContents()

	local yDescLbl = vgui.Create("DLabel", self)
	yDescLbl:SetText("You have "..LocalPlayer():GetMoney().." "..impulse.Config.CurrencyName )
	yDescLbl:SetFont("terminal32")
	yDescLbl:SetPos(ScrW() * 0.53, 100)
	yDescLbl:SetSize(300, 20)
	yDescLbl.lastMoney = LocalPlayer():GetMoney()

	function yDescLbl:Think()
		if self.lastMoney != LocalPlayer():GetMoney() then
			self.lastMoney = LocalPlayer():GetMoney()
			self:SetText("You have "..LocalPlayer():GetMoney().." "..impulse.Config.CurrencyName)
		end
	end

	local w, h = self:GetSize()
	local empty = true

	self.vendorScroll = vgui.Create("DScrollPanel", self)
	self.vendorScroll:SetPos(75, 150)
	self.vendorScroll:SetSize(600, h - 200)

	for v,k in pairs(self.Vendor.Sell) do
		if not k.CanBuy or k.CanBuy(LocalPlayer()) then
			local itemid = impulse.Inventory.ClassToNetID(v)

			if not itemid then
				print("[impulse] "..v.." is invalid!")
				continue
			end

			local item = impulse.Inventory.Items[itemid]

			if not item then
				print("[impulse] Failed to resolve ItemID "..itemid.."! (Class "..v..")!")
				continue
			end

			local vendorItem = self.vendorScroll:Add("impulseVendorItem")
			vendorItem:SetItem(item, k)
			vendorItem.Parent = self
			vendorItem:Dock(TOP)
			vendorItem:DockMargin(0, 0, 0, 10)
		end

		empty = false
	end

	for v,k in pairs(self.Vendor.Sell) do
		if k.CanBuy and not k.CanBuy(LocalPlayer()) then
			local itemid = impulse.Inventory.ClassToNetID(v)

			if not itemid then
				print("[impulse] "..v.." is invalid!")
				continue
			end

			local item = impulse.Inventory.Items[itemid]

			if not item then
				print("[impulse] Failed to resolve ItemID "..itemid.."! (Class "..v..")!")
				continue
			end

			local vendorItem = self.vendorScroll:Add("impulseVendorItem")
			vendorItem:SetItem(item, k)
			vendorItem.Parent = self
			vendorItem:Dock(TOP)
			vendorItem:DockMargin(0, 0, 0, 10)
		end

		empty = false
	end

	if empty then
		local emptyLbl = vgui.Create("DLabel", self.vendorScroll)
		emptyLbl:SetText("Nothing to buy")
		emptyLbl:SetFont("terminal32")
		emptyLbl:SizeToContents()
		emptyLbl:Dock(TOP)
		emptyLbl:DockMargin(0, 20, 0, 0)
		emptyLbl:SetContentAlignment(5)
	end

	empty = true

	self.youScroll = vgui.Create("DScrollPanel", self)
	self.youScroll:SetPos(ScrH() * 0.92, 150)
	self.youScroll:SetSize(600, h - 299)

	for v,k in pairs(impulse.Inventory.Data[0][1]) do
		if k.restricted then
			continue	
		end

		local item = impulse.Inventory.Items[k.id]
		local class = item.UniqueID

		if self.Vendor.Buy and self.Vendor.Buy[class] then
			local vendorItem = self.youScroll:Add("impulseVendorItem")
			vendorItem.Selling = true
			vendorItem.ItemID = v
			vendorItem:SetItem(item, self.Vendor.Buy[class])
			vendorItem.Parent = self
			vendorItem:Dock(TOP)
			vendorItem:DockMargin(0, 0, 0, 10)
			empty = false
		end
	end

	if empty then
		local emptyLbl = vgui.Create("DLabel", self.youScroll)
		emptyLbl:SetText("Nothing to sell")
		emptyLbl:SetFont("terminal32")
		emptyLbl:SizeToContents()
		emptyLbl:Dock(TOP)
		emptyLbl:DockMargin(0, 20, 0, 0)
		emptyLbl:SetContentAlignment(5)
	end

	self.exitBtn = vgui.Create("DButton", self)
  	self.exitBtn:SetPos(w * 0.45, 975)
  	self.exitBtn:SetSize(200, 50)
	self.exitBtn:SetFont("terminal40")
	self.exitBtn:SetTextColor(Color(255, 255, 255, 255))
  	self.exitBtn:SetText("Exit")

	self.exitBtn.HoverAlpha = 0

	self.exitBtn.Paint = function(btn, w, h)
		local hovered = btn:IsHovered()
		btn.HoverAlpha = math.Approach(btn.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * speed)

		surface.SetDrawColor(81, 81, 81, 10)
		surface.DrawRect(0, 0, w, h)

		if btn.HoverAlpha > 0 then
			surface.SetDrawColor(32, 32, 32, btn.HoverAlpha)
			surface.DrawRect(0, 0, w, h)
		end

		surface.SetDrawColor(255, 255, 255, 200)
		surface.DrawOutlinedRect(0, 0, w, h)
	end


	function self.exitBtn:DoClick()
		self:GetParent():Remove()
	end

	function self:Paint(w, h)
		surface.SetDrawColor(bodyCol) -- menu body
		surface.DrawRect(0, 0, ScrW(), ScrH())
		
		surface.SetDrawColor(255,255,255,255)
		BlurRect(0, 0, w, h)
		draw.DrawText(self.Vendor.Name, "terminal64", w/2, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		--surface.DrawRect(w/2.655, 65, w / 4, 2, Color(0, 0, 0, 150))
	end
end

local headerDark = Color(20, 20, 20, 180)
local listDark = Color(0, 0, 0, 28)
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h)

	surface.SetDrawColor(headerDark)
	surface.DrawRect(0, 25, 340, 58)
	surface.DrawRect(440, 25, 340, 58)

	surface.SetDrawColor(listDark)
	surface.DrawRect(0, 83, 340, h)
	surface.DrawRect(440, 83, 340, h)
end

vgui.Register("impulseVendorMenu", PANEL, "DFrame")
