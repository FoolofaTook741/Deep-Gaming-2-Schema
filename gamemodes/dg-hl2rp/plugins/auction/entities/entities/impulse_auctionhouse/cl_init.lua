include("shared.lua")
include("cl_auctionhouse.lua")
include("cl_auctions.lua")

local NOTIFICATION_COLOR = Color(255, 220, 0)
local NOTIFICATION_SHADOW = Color(0, 0, 0, 180)
local hasNotification = false

function ENT:Draw()
    self:DrawModel()

    if hasNotification then
        local pos = self:GetPos() + Vector(0, 0, 82)
        local ang = (LocalPlayer():GetPos() - pos):Angle()
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)

        cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.4)
            draw.SimpleText("!", "Impulse-Elements23-Shadow", 2, -2, NOTIFICATION_SHADOW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("!", "Impulse-Elements23-Shadow", 0, -4, NOTIFICATION_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

net.Receive("AuctionHouse_ShowNotification", function()
    local ent = net.ReadEntity()
    if IsValid(ent) and ent == Entity(ent:EntIndex()) then
        hasNotification = true
    end
end)

net.Receive("AuctionHouse_ClearNotification", function()
    local ent = net.ReadEntity()
    if IsValid(ent) then
        hasNotification = false
    end
end)

net.Receive("AuctionHouse_Open", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    if IsValid(impulse.AuctionHousePanel) then
        impulse.AuctionHousePanel:Remove()
    end

    impulse.AuctionHousePanel = vgui.Create("impulseAuctionHouse")
end)