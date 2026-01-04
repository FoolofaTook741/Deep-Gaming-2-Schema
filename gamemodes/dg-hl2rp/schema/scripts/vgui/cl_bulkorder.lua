-- marked for removal, can be replaced with Derma_Query

local PANEL = {}
local items = {
    ["food_apple"] = {
		Cost = 30,
        name = "Apple"
	},
    ["food_banana"] = {
		Cost = 30,
        name = "Banana"
	},
    ["food_orange"] = {
		Cost = 30,
        name = "Orange"
	},
    ["food_pineapple"] = {
		Cost = 50,
        name = "Pineapple"
	},
    ["util_cookingoil"] = {
		Cost = 15,
        name = "Cooking Oil"
	},
    ["util_meat"] = {
		Cost = 30,
        name = "Meat"
	},
    ["util_yeast"] = {
		Cost = 40,
        name = "Yeast"
	},
    ["ing_sugar"] = {
		Cost = 25,
        name = "Sugar"
	},
    ["util_chicken"] = {
		Cost = 40,
        name = "Chicken"
	},
    ["util_salt"] = {
		Cost = 25,
        name = "Salt"
	},
    ["ing_grapes"] = {
		Cost = 25,
        name = "Grapes"
	},
    ["util_coffeegrounds"] = {
		Cost = 20,
        name = "Coffee Grounds"
	},
    ["food_carrot"] = {
		Cost = 25,
        name = "Carrot"
	},
    ["food_tomato"] = {
		Cost = 25,
        name = "Tomato"
	},
	["ing_milk"] = {
		Cost = 25,
        name = "Milk"
	},
    ["food_waterspecial"] = {
		Cost = 20,
        name = "Special Water"
	},
	["food_water"] = {
		Cost = 15,
        name = "Water"
	},
	["util_potato"] = {
		Cost = 20,
        name = "Potato"
	}}

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
    self:SetSize(ScrW() / 2, ScrH() / 2)
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:MakePopup()
    local parent = self
    self.Add = 0

    local selfW = ScrW() / 2
    local selfH = ScrH() / 2
    -- Counter table for each item
    self.ItemCounts = {}

    -- title
    local titleLabel = vgui.Create("DLabel", self)
    titleLabel:SetFont("terminal50")
    titleLabel:SetText("Factory Order Display")
    titleLabel:SetPos(25,0)
    titleLabel:SizeToContents()

    local parentPanel = vgui.Create("DPanel", self)
    parentPanel:DockMargin(0,50,0,0)
    parentPanel:Dock(FILL)
    function parentPanel:Paint(w,h)
        return
    end

    local scroll = vgui.Create("DScrollPanel", parentPanel)
    scroll:Dock(FILL)
    -- item cards
    local lastY = 0
    for k,v in pairs(items) do
        self.Add = self.Add + 60
        lastY = 15 + self.Add
        self.ItemCounts[k] = 0 -- initialize counter

        local lbl = vgui.Create("DLabel", scroll)
        lbl:SetFont("terminal40")
        lbl:SetText(v.name)
        lbl:SetPos(25,15 + self.Add)
        lbl:SizeToContents()

        -- Counter label
        local countLbl = vgui.Create("DLabel", scroll)
        countLbl:SetFont("terminal32")
        countLbl:SetText("x0")
        countLbl:SetPos(selfW * 0.8, 15 + self.Add)
        countLbl:SizeToContents()

        local AddBtn = vgui.Create("DButton", scroll)
        AddBtn:SetFont("terminal32")
        AddBtn:SetText("ADD")
        AddBtn:SetPos(selfW * 0.32,15 + self.Add)
        AddBtn:SizeToContents()
        AddBtn:SetWide(125)
        local speed = 1000
        AddBtn.Paint = function(btn, w, h)
            local hovered = btn:IsHovered()
            btn.HoverAlpha = math.Approach(btn.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * speed)

            surface.SetDrawColor(81, 81, 81, 10)
            surface.DrawRect(0, 0, w, h)

            if btn.HoverAlpha > 0 then
                surface.SetDrawColor(32, 100, 32, btn.HoverAlpha)
                surface.DrawRect(0, 0, w, h)
            end

            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        -- Increment counter on click
        AddBtn.DoClick = function()
            self.ItemCounts[k] = math.Clamp(self.ItemCounts[k] + 1, 0, 20)
            countLbl:SetText("x" .. self.ItemCounts[k])
            countLbl:SizeToContents()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
            UpdatePurchaseButton()
        end

        local RemoveBtn = vgui.Create("DButton", scroll)
        RemoveBtn:SetFont("terminal32")
        RemoveBtn:SetText("REMOVE")
        RemoveBtn:SetPos(selfW * 0.57,15 + self.Add)
        RemoveBtn:SizeToContents()
        RemoveBtn:SetWide(125)
        local speed = 1000
        RemoveBtn.Paint = function(btn, w, h)
            local hovered = btn:IsHovered()
            btn.HoverAlpha = math.Approach(btn.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * speed)

            surface.SetDrawColor(81, 81, 81, 10)
            surface.DrawRect(0, 0, w, h)

            if btn.HoverAlpha > 0 then
                surface.SetDrawColor(100, 32, 32, btn.HoverAlpha)
                surface.DrawRect(0, 0, w, h)
            end

            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        -- Increment counter on click
        RemoveBtn.DoClick = function()
            self.ItemCounts[k] = math.Clamp(self.ItemCounts[k] - 1, 0, 20)
            countLbl:SetText("x" .. self.ItemCounts[k])
            countLbl:SizeToContents()
            UpdatePurchaseButton()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
        end
    end

    local purchaseBtn = vgui.Create("DButton", scroll)
    purchaseBtn:SetFont('terminal40')
    purchaseBtn:SetText("PURCHASE")
    purchaseBtn:SetPos(0, lastY + 70)
    purchaseBtn:SizeToContents()
    purchaseBtn:SetWide(parent:GetWide() - 40)

    function UpdatePurchaseButton()
        local totalCost = 0
        for k, count in pairs(self.ItemCounts) do
            totalCost = totalCost + (count * (items[k] and items[k].Cost or 0))
        end
        purchaseBtn:SetText("PURCHASE - " .. math.floor(totalCost/2) .. impulse.Config.CurrencyPrefix)
        purchaseBtn:SizeToContents()
        purchaseBtn:SetWide(parent:GetWide() - 40)
    end

    local speed = 1000
    purchaseBtn.Paint = function(btn, w, h)
        local hovered = btn:IsHovered()
        btn.HoverAlpha = math.Approach(btn.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * speed)

        surface.SetDrawColor(81, 81, 81, 10)
        surface.DrawRect(0, 0, w, h)

        if btn.HoverAlpha > 0 then
            surface.SetDrawColor(32, 100, 32, btn.HoverAlpha)
            surface.DrawRect(0, 0, w, h)
        end

        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    local parent = self
    purchaseBtn.DoClick = function()
        local orderTable = {}
        for k, count in pairs(self.ItemCounts) do
            orderTable[k] = {
                count = count,
                cost = items[k] and items[k].Cost or 0
            }
        end
        
        if LocalPlayer():Team() != TEAM_CWU then LocalPlayer():Notify("You must be a member of the CWU to do this!") parent:Remove() return 0 end

        net.Start("impulseBulkOrder")
            net.WriteTable(orderTable)
        net.SendToServer()
        surface.PlaySound("ui/hls_ui_scroll_click.wav")
        parent:Remove()
    end
end

-- ""

function PANEL:Paint(w,h)
	BlurRect(self.x, self.y, w, h)
	surface.SetDrawColor(Color(0,0,0,215)) -- menu body
	surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(255,255,255))
    surface.DrawRect(20,65,360,1)

	surface.SetDrawColor(color_white)
	surface.DrawOutlinedRect(self.x * 0.002, self.y * 0.007, w, h - 2, 1)
end
vgui.Register("ImpulseCWUBulkOrder", PANEL, "DFrame")
