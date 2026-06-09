--[[
'include("shared.lua")
AddCSLuaFile("imgui.lua")
AddCSLuaFile("cl_ui3d2d.lua")
AddCSLuaFile("cl_ui3d2d_extras.lua")
local imgui = include("imgui.lua")
include("cl_ui3d2d.lua")
include("cl_ui3d2d_extras.lua")

surface.CreateFont("Terminal100", {
    font = "Segoe UI Light",
    size = 100,
    weight = 100,
    antialias = true,
    shadow = false,
    outline = false
})

local resinWeapons = {
    ["resin_ar2"] ={
        NiceName = "AR2",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 8,
        requiredItem = "wep_ar2",
    },
    ["resin_mp7"] = {
        NiceName = "MP7",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 4,
        requiredItem = "wep_mp7",
    },
    ["resin_mp7a8"] = {
        NiceName = "MP7A8",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 6,
        requiredItem = "wep_mp7a8",
    },
    ["resin_pistol"] = {
        NiceName = "USP",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 1,
        requiredItem = "wep_pistol",
    },
    ["resin_shotgun"] = {
        NiceName = "SPAS-12",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 7,
        requiredItem = "wep_shotgun",
    },
    ["resin_ak47"] = {
        NiceName = "AK47",
        Model = "models/weapons/w_irifle.mdl",
        Cost = 7,
        requiredItem = "wep_ak47",
    }
}

local wid = 80
local hig = 10

local function Box( x, y, w, h, color, outlineCol)
	--BlurRect( x, y, w, h )

	surface.SetDrawColor(color or Color(0, 0, 0, 200) )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( outlineCol or color_white )
	surface.DrawRect( x, y, wid, 5 )
	surface.DrawRect( x, y + h, wid, 5 )

	surface.DrawRect( x + (w - wid) - 1, y, wid, 5 )
	surface.DrawRect( x + (w - wid) - 1, y + h, wid, 5 )

	surface.DrawRect( x + w - 1, y, 5, hig )
	surface.DrawRect( x, y, 5, hig )

	surface.DrawRect( x, y + (h - hig), 5, hig )
	surface.DrawRect( x + w - 1, y + (h - hig) + 1, 5, hig )
end

local function DrawCenteredBox( x, y, w, h )
    x = x-(w/2)
    y = y-(h/2)

    Box( x, y, w, h )
end

net.Receive("impulseRebelFabricator", function()
    local fabricator = net.ReadEntity()
    vgui.Create("impulseRebelFabricatorMenu")
end)

local drawCol = Color(23,103,200,125)
local buttonColor = Color(50,200,255,125)
local clickSound = "ui/hls_ui_scroll_click.wav"

local MAX_DISTANCE = 110
local background = Material("overlays/cmb_terminal_bg.png")
local background2 = Material("overlays/cmb_bg_animated1")

function ENT:Draw()
    parent = self
    self:DrawModel()
    local client = LocalPlayer()
    local entAng = self:GetAngles()
    local pos, ang = Vector(-14,-23,44), Angle(-4,0,47)
    local parentEntity = self


    local fadeAlpha = 100 + math.abs(math.sin(CurTime() * 2)) * 155
    local darkBlue = Color(20, 40, 60, fadeAlpha)
    local lightBlue = Color(20, 90, 255, fadeAlpha)

    local flashAlpha = 100 + math.abs(math.sin(CurTime() * 4)) * 155
    local flashingColor = Color(255, 25, 25, flashAlpha)
    local colorWhite = Color(25, 255, 25, flashAlpha)
    local chargeColor = Color(255, 255, 25, flashAlpha)

    if self:GetNWBool("IsUseable") == true then
        text = "FABRICATOR STATUS :: ACTIVE"
        ColorToUse = colorWhite
    else
        text = "FABRICATOR STATUS :: INACTIVE"
        ColorToUse = flashingColor
    end

    if self:GetNWBool("IsCharging") == true then
        text = "FABRICATOR STATUS :: CHARGING"
        ColorToUse = chargeColor
    end

    if imgui.Entity3D2D(self, Vector(-14,-23,44), Angle(-4,0,47), 0.01) then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(background)
        surface.DrawTexturedRect(-1600, -1600, 2500, 1200)
        surface.SetMaterial(background2)
        surface.DrawTexturedRect(-1600, -1600, 2500, 1200)

        local boxFlashAlpha = 10 + math.abs(math.sin(CurTime() * 1.2)) * 20
        local boxFillColor = Color(ColorToUse.r, ColorToUse.g, ColorToUse.b, boxFlashAlpha)
        Box(-1300, -820, 1250, 150, boxFillColor, Color(ColorToUse.r, ColorToUse.g, ColorToUse.b, 255))
        draw.SimpleText(text, "Terminal100", -1200, -800, ColorToUse)


        local startX = -1400
        local btnSize = 300 -- Square size
        local btnPad = 70
        local i = 0

        if self:GetNWBool("IsUseable") == true then
            draw.SimpleText("Select An Upgrade", "Terminal100", -1200, -1500, Color(20,255,20,200))
            for class, wep in pairs(resinWeapons) do
                local x = startX + i * (btnSize + btnPad)
                local y = -1200

                draw.SimpleText(wep.NiceName or class, "Terminal100", x + btnSize/2, y - 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

                local outlineColor = (self.SelectedWeaponClass == class) and Color(20,255,20,200) or darkBlue

                local wasPressed = imgui.xTextButton(
                    "",
                    "Terminal100",
                    x, y, btnSize, btnSize, 10,
                    outlineColor, outlineColor, outlineColor
                )

                if self.SelectedWeaponClass == class then
                    local margin = 30
                    surface.SetDrawColor(20, 255, 20, 200)
                    surface.DrawRect(x + margin, y + margin, btnSize - margin*2, btnSize - margin*2)
                end

                if wasPressed then
                    surface.PlaySound(clickSound)
                    self.SelectedWeaponClass = class
                end

                self.cost = wep.Cost or 0

                i = i + 1
            end

            local purchaseBtnY = -1200 + btnSize + 95
            local purchaseBtnW, purchaseBtnH = 600, 120
            local purchaseBtnX = startX + ((i-1) * (btnSize + btnPad)) / 2 - purchaseBtnW/2 + 800

            local canPurchase = self.SelectedWeaponClass ~= nil
            local purchaseBtnColor = canPurchase and Color(20,255,20,200) or Color(255,50,50,180)

            local purchasePressed = imgui.xTextButton(
                "PURCHASE",
                "Terminal100",
                purchaseBtnX, purchaseBtnY, purchaseBtnW, purchaseBtnH, 10,
                purchaseBtnColor, purchaseBtnColor, purchaseBtnColor
            )

            Box(purchaseBtnX, purchaseBtnY, purchaseBtnW, purchaseBtnH, Color(purchaseBtnColor.r, purchaseBtnColor.g, purchaseBtnColor.b, 10), Color(purchaseBtnColor.r, purchaseBtnColor.g, purchaseBtnColor.b, 255))

            if purchasePressed and canPurchase then
                surface.PlaySound("combine_tech/civic_station/station_menu_select.mp3")
               net.Start("impulseRebelFabricatorBuyWeapon")
                    net.WritePlayer(LocalPlayer())
                    net.WriteString(self.SelectedWeaponClass)
                    net.WriteInt(self.cost, 16)
                    net.WriteEntity(parent)
                    print(resinWeapons[self.SelectedWeaponClass].requiredItem)
                    net.WriteString(resinWeapons[self.SelectedWeaponClass].requiredItem)
                net.SendToServer()
            end
        end
    imgui.End3D2D()
    end



    if not IsValid(self.MainPanel) then
        self.MainPanel = vgui.Create("DPanel")
        self.MainPanel:SetSize(1500, 1300)
        self.MainPanel.Paint = function(s, w, h)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(Material("overlays/cmb_terminal_bg.png"))
            surface.DrawTexturedRect(0, 0, w,h)

            surface.SetMaterial(Material("overlays/cmb_bg_animated1"))
            surface.DrawTexturedRect(0, 0, w,h)
            draw.SimpleText(text, "Terminal100", w/2, h/8, ColorToUse, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn = vgui.Create("DButton", self.MainPanel)
        btn:SetSize(1200, 150)
        btn:SetPos(150, 1000)
        btn:SetText("CHARGE FABRICATOR")
        btn:SetFont("Terminal100")
        btn:SetTextColor(Color(255, 255, 255))

        btn.DoClick = function()
            surface.PlaySound(clickSound)
            if not self:GetNWBool("IsUseable") then
                net.Start("impulseRebelFabricatorChargeSeq")
                    net.WriteEntity(self)
                    net.WritePlayer(LocalPlayer())
                net.SendToServer()
            end
        end

        btn.Paint = function(s, w, h)
            surface.SetDrawColor(ColorToUse.r, ColorToUse.g, ColorToUse.b, 50)
            surface.DrawOutlinedRect(0, 0, w, h, 20)

            
            if s:IsHovered() then
                surface.SetDrawColor(ColorToUse.r, ColorToUse.g, ColorToUse.b, 50)
            else
                surface.SetDrawColor(ColorToUse.r, ColorToUse.g, ColorToUse.b, 10)
            end

            surface.DrawRect(0, 0, w, h)
        end-- Buttons for AR2, MP7, MP7A8, USP, Stun Baton, SPAS-12, AK-47

    end



    local pos = self:GetPos() + self:GetUp() * 70
    local pos = pos + self:GetForward() * -20
    pos = pos + self:GetRight() * 8
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Right(), 0)
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 90)
    local scale = 0.01

    ui3d2d.drawVgui(self.MainPanel, pos, ang, scale, self)

end


--[[

    -- pos = pos + (ang:Up() * 0.3)
    -- pos = pos + (ang:Forward() * 0.6)
    -- pos = pos + (ang:Right() * 0.3)

    local dist = (client:GetPos() - self:GetPos()):LengthSqr()

    if (client:GetPos() - self:GetPos()):LengthSqr() > MAX_DISTANCE ^ 2 then

        if IsValid(self.MainPanel) then
            self.MainPanel:Remove()
            self.MainPanel = nil
        end

        return
    end

    local alpha = (MAX_DISTANCE - dist / MAX_DISTANCE) * 4
    
    if IsValid(self.MainPanel) then
        if dist > MAX_DISTANCE ^ 2 then return end
        ui3d2d.drawVgui(self.MainPanel, pos, ang, 0.01, self)
        self.MainPanel:SetAlpha(alpha)
    else
        self.MainPanel = vgui.Create( "impulseRebelFabricatorMenu" )
        self.MainPanel.Entity = self
    end



function ENT:OldDraw()
    self:DrawModel()

    local fadeAlpha = 100 + math.abs(math.sin(CurTime() * 2)) * 155
    local darkBlue = Color(20, 40, 60, fadeAlpha)
    local lightBlue = Color(20, 90, 255, fadeAlpha)

    if imgui.Entity3D2D(self, Vector(-14,-23,44), Angle(-4,0,47), 0.01) then
        surface.SetDrawColor(color_white)

        surface.SetMaterial(Material("overlays/cmb_terminal_bg.png"))
        surface.DrawTexturedRect(-1600, -1600, 2500, 1200)

        surface.SetMaterial(Material("overlays/cmb_bg_animated1"))
        surface.DrawTexturedRect(-1600, -1600, 2500, 1200)

        -- End BG
        surface.SetDrawColor(Color(20, 40, 60, 20))
        surface.DrawRect(-800, -1200, 1200, 150)

        local wasPressed = imgui.xTextButton("ACTIVATE FABRICATOR", "!Segoe UI Light@100", -800, -1200, 1200, 150, 15, darkBlue, lightBlue, darkBlue)

       

        if wasPressed then
            surface.PlaySound(clickSound)

            net.Start("impulseRebelFabricatorChargeSeq")
                net.WriteEntity(self)
                net.WritePlayer(LocalPlayer())
            net.SendToServer()
        end

        imgui.End3D2D()
	end
end
--]]