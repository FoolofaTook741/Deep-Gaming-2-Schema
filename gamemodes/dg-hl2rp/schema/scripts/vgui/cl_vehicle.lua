-- marked for removal, can be replaced with Derma_Query

local PANEL = {}
local vehicles = {
    ["lvs_wheeldrive_hl2_combine_apc_armed"] = {
		Cost = 2000,
        name = "Armored Personnel Carrier",
        model = "",
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-3899.2036132813, -9463.15625, -429.78695678711)
	},
    ["lvs_helicopter_hl2_combine_dropship_bypass"] = {
		Cost = 18000,
        name = "Drop Ship",
        model = "",
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-906.78112792969, -9445.0107421875, -458.90270996094)
	},
    ["lvs_helicopter_hl2_combine_hunter"] = {
		Cost = 8000,
        name = "Hunter Chopper",
        model = "",
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-3899.2036132813, -9463.15625, -429.78695678711)
	},
    }

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

local SELL_SCAN_RADIUS = 600
local function IsKnownPurchasableVehicle(ent)
    if not IsValid(ent) then return false end
    return vehicles[ent:GetClass()] ~= nil
end

local function GetNearbySellableVehicles(term)
    if not IsValid(term) then return {} end

    local out = {}
    local tpos = term:GetPos()
    local rSqr = SELL_SCAN_RADIUS * SELL_SCAN_RADIUS

    local lvsEnts = ents.FindByClass("lvs_*")

    for _, ent in ipairs(lvsEnts) do
        local class = ent:GetClass()
        local vdata = vehicles[class]
        if vdata then
            if tpos:DistToSqr(ent:GetPos()) <= rSqr then
                table.insert(out, ent)
            end
        end
    end

    return out
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
    titleLabel:SetText("Vehicle Requisition Display")
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
    for k,v in pairs(vehicles) do

        if LocalPlayer():GetTeamClass() ~= v.class or LocalPlayer():Team() ~= v.faction then
            continue
        end


        self.Add = self.Add + 60
        lastY = 15 + self.Add
        self.ItemCounts[k] = 0 -- initialize counter

        local lbl = vgui.Create("DLabel", scroll)
        lbl:SetFont("terminal40")
        lbl:SetText(v.name .. " - " .. v.Cost .. " OCAAB")
        lbl:SetPos(25,15 + self.Add)
        lbl:SizeToContents()

        local AddBtn = vgui.Create("DButton", scroll)
        AddBtn:SetFont("terminal32")
        AddBtn:SetText("PURCHASE")
        AddBtn:SetPos(selfW * 0.75,15 + self.Add)
        AddBtn:SizeToContents()
        AddBtn:SetWide(145)
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

        AddBtn.DoClick = function()
            if LocalPlayer():GetTeamClass() ~= v.class or LocalPlayer():Team() ~= v.faction then
                LocalPlayer():Notify("You are the incorrect class for this!")
                parent:Remove()
                return
            end

            net.Start("PinnaclePurchaseVehicle")
            net.WriteString(k)
            net.WriteEntity(parent.Terminal)
            net.SendToServer()

            parent:Remove()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
        end
    end

    -- SELL BACK (50% of cost)
    self.Add = self.Add + 90

    local sellHeader = vgui.Create("DLabel", scroll)
    sellHeader:SetFont("terminal40")
    sellHeader:SetText("Sell Back (50%)")
    sellHeader:SetPos(25, 15 + self.Add)
    sellHeader:SizeToContents()

    self.Add = self.Add + 45

    local function MakeSellButton(rowY, vehEnt, vdata)
        local refund = math.floor((vdata.Cost or 0) * 0.5)

        local SellBtn = vgui.Create("DButton", scroll)
        SellBtn:SetFont("terminal32")
        SellBtn:SetText("SELL")
        SellBtn:SetPos(selfW * 0.75, rowY)
        SellBtn:SizeToContents()
        SellBtn:SetWide(145)

        local speed = 1000
        SellBtn.Paint = function(btn, w, h)
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

        SellBtn.DoClick = function()
            if not IsValid(parent.Terminal) then
                LocalPlayer():Notify("Terminal invalid.")
                parent:Remove()
                return
            end

            if not IsValid(vehEnt) then
                LocalPlayer():Notify("Vehicle no longer exists.")
                parent:Remove()
                return
            end

            -- quick client hint (server must enforce too)
            if parent.Terminal:GetPos():DistToSqr(vehEnt:GetPos()) > (350 * 350) then
                LocalPlayer():Notify("Bring the vehicle closer to the terminal.")
                return
            end

            net.Start("PinnacleSellVehicle")
            net.WriteEntity(parent.Terminal)
            net.WriteEntity(vehEnt)
            net.SendToServer()

            parent:Remove()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
        end
    end

    if not IsValid(self.Terminal) then
        local warn = vgui.Create("DLabel", scroll)
        warn:SetFont("terminal32")
        warn:SetText("Sell list unavailable (no terminal reference).")
        warn:SetPos(25, 15 + self.Add)
        warn:SizeToContents()
        return
    end

    local nearby = GetNearbySellableVehicles(self.Terminal)
    if #nearby == 0 then
        local none = vgui.Create("DLabel", scroll)
        none:SetFont("terminal32")
        none:SetText("No sellable vehicles nearby.")
        none:SetPos(25, 15 + self.Add)
        none:SizeToContents()
    else
        for _, vehEnt in ipairs(nearby) do
            local class = vehEnt:GetClass()
            local vdata = vehicles[class]
            if vdata then
                self.Add = self.Add + 60
                local rowY = 15 + self.Add
                local refund = math.floor((vdata.Cost or 0) * 0.5)

                local lbl = vgui.Create("DLabel", scroll)
                lbl:SetFont("terminal32")
                lbl:SetText(("%s - Refund %d OCAAB"):format(vdata.name or class, refund))
                lbl:SetPos(25, rowY)
                lbl:SizeToContents()

                MakeSellButton(rowY, vehEnt, vdata)
            end
        end
    end
end

-- ""

function PANEL:Paint(w,h)
	BlurRect(self.x, self.y, w, h)
	surface.SetDrawColor(Color(0,0,0,215)) -- menu body
	surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(255,255,255))
    surface.DrawRect(20,65,450,1)

	surface.SetDrawColor(color_white)
	surface.DrawOutlinedRect(self.x * 0.002, self.y * 0.007, w, h - 2, 1)
end
vgui.Register("VehicleTerminalMenu", PANEL, "DFrame")
