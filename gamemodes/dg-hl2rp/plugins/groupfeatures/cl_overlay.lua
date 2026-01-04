local surface = surface
local draw = draw
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math = math
local player = player
local pairs = pairs
local ScrW = ScrW
local ScrH = ScrH

local nextFlicker
local nextCheck

local GRP_OVERLAY_COLS = {
    Color(255, 145, 0),
}

local GRP_OVERLAY_ICONS = {
    Material("vgui/killicons/iw4_choppergunner"),
}

impulse.GroupWaypoints = impulse.GroupWaypoints or {}

local function DrawGroupWaypoints()
    for i = 1, #impulse.GroupWaypoints do
        local waypointData = impulse.GroupWaypoints[i]
        if not waypointData then continue end
        local pos = waypointData.pos:ToScreen()

        if not waypointData.nextUpdate or waypointData.nextUpdate < CurTime() then
            local plyPos = LocalPlayer():GetPos()

            waypointData.dist = (waypointData.pos:Distance(plyPos) / 39.3701) -- 39 inches in meter
            waypointData.nextUpdate = CurTime() + 0.5
        end
        if not waypointData.mat then
            surface.SetMaterial(Material("impulse/hl2rp/overlay/move"))
        else
            surface.SetMaterial(waypointData.mat)
        end
        if not waypointData.colour then
            surface.SetDrawColor(Color(100,100,100))
        else   
            surface.SetDrawColor(waypointData.colour)
        end
        surface.DrawTexturedRect(pos.x - 16, pos.y, 32, 32)
        draw.SimpleText("[ "..waypointData.text.." ]", "BudgetLabel", pos.x, pos.y + 30, waypointData.textcolour or color_white, TEXT_ALIGN_CENTER)

        if waypointData.name then
            local prefix = waypointData.prefix or "MEMBER"
            local text = waypointData.name

            draw.SimpleText("[ "..prefix..": "..text.." ]", "BudgetLabel", pos.x, pos.y + 42, color_white, TEXT_ALIGN_CENTER)
            draw.SimpleText("[ DIST: "..math.Round(waypointData.dist).."m ]", "BudgetLabel", pos.x, pos.y + 54, color_white, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("[ DIST: "..math.Round(waypointData.dist).."m ]", "BudgetLabel", pos.x, pos.y + 42, color_white, TEXT_ALIGN_CENTER)
        end

        if waypointData.endtime and waypointData.endtime < CurTime() then
            impulse.GroupWaypoints[i] = nil
            LocalPlayer():EmitSound("impulse/typewriter4.wav", 35, 60)
        end 
    end
end

local function DrawGroupHUD()
    local lp = LocalPlayer()
    local offset = 0
    local myGroup = lp:GetSyncVar(SYNC_GROUP_NAME, nil)


    if myGroup and not lp:IsCP() then
        DrawGroupWaypoints() 
    end
end

hook.Add("HUDPaint", "deepHL2RPGroupOverlay", DrawGroupHUD)

function impulse.AddGroupWaypoint(message, pos, duration, icon, colour, textcolour, unit, sender, citizen)
    local waypoint = {
        text = message,
        pos = pos,
        endtime = duration and (CurTime() + duration) or nil,
        mat = GRP_OVERLAY_ICONS[icon] or Material("vgui/target"), -- Fallback material
        colour = GRP_OVERLAY_COLS[colour or 1],
        textcolour = GRP_OVERLAY_COLS[textcolour or 1] or color_white
    }

    if unit and IsValid(unit) then
        waypoint.name = unit:Nick()
        waypoint.prefix = "MEMBER"
    elseif sender and IsValid(sender) then
        waypoint.name = sender:Nick()
        waypoint.prefix = "SENDER"
    elseif citizen then
        waypoint.name = citizen:Nick()
        waypoint.prefix = "TARGET"
    end

    local id = table.insert(impulse.GroupWaypoints, waypoint)

    LocalPlayer():EmitSound("impulse/typewriter1.wav", 45, 135)

    return id
end

net.Receive("deepHL2RPGroupWaypoint",function()
    local message = net.ReadString()
    local pos = net.ReadVector()
    local duration = net.ReadUInt(10)
    local icon = net.ReadUInt(8)
    local colour = net.ReadUInt(8)
    local unit = net.ReadUInt(8)

    if unit != 0 then
        unit = Entity(unit)

        if not IsValid(unit) then
            unit = nil
        end
    end

    impulse.AddGroupWaypoint(message, pos, duration, icon, colour, colour, unit or nil)
end)