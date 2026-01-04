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
		Cost = 25000,
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
-- debug
--[[        print(LocalPlayer():GetTeamClass().. " Player Class")
        print(LocalPlayer():Team() .. " Player Team")

        print(v.class .. " vehicle class")
        print(v.faction .. "vehicle faction")]]

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
            net.SendToServer()

            parent:Remove()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
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
