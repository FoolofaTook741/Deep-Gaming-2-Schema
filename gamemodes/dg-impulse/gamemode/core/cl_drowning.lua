local DG_FADE_DURATION = 1
local DG_DRIFT_TOLERANCE = 0.4

local predictedAir = nil
local submerged = false
local displayAlpha = 0
local fadeStart = nil
local hidden = true
local lastSeq = -1

surface.CreateFont("OxygenFont", {
    font = "Roboto Bold",
    size = 30,
    weight = 800,
    antialias = true
})

net.Receive("DG_WaterState", function()
    local seq = net.ReadUInt(16)
    local isSubmerged = net.ReadBool()
    local serverAir = net.ReadFloat()

    local isStale = (seq <= lastSeq) and not (lastSeq > 60000 and seq < 5000)
    if isStale then return end
    lastSeq = seq

    submerged = isSubmerged

    if predictedAir == nil or math.abs(predictedAir - serverAir) > DG_DRIFT_TOLERANCE then
        predictedAir = serverAir
    end
end)

hook.Add("Think", "DG_DrowningPredict", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() or predictedAir == nil then return end

    local maxAir = impulse.Config.MaxAir
    local waterThreshold = impulse.Config.WaterLevel or 3
    local isSubmerged = ply:WaterLevel() >= waterThreshold and ply:GetMoveType() != MOVETYPE_NOCLIP
    local ft = FrameTime()

    if isSubmerged then
        predictedAir = math.max(0, predictedAir - ft)
    else
        predictedAir = math.min(maxAir, predictedAir + ft)
    end

    submerged = isSubmerged

    if isSubmerged or predictedAir < maxAir then
        displayAlpha = 255
        fadeStart = nil
        hidden = false
    elseif not hidden then
        fadeStart = fadeStart or CurTime()
    end
end)

local function DrawArc(x, y, radius, thickness, startAng, endAng, seg, color)
    local step = (endAng - startAng) / seg
    surface.SetDrawColor(color)
    draw.NoTexture()
    for i = 0, seg - 1 do
        local ang1 = math.rad(startAng + step * i)
        local ang2 = math.rad(startAng + step * (i + 1))
        local poly = {
            {x = x + math.sin(ang1) * radius, y = y - math.cos(ang1) * radius},
            {x = x + math.sin(ang2) * radius, y = y - math.cos(ang2) * radius},
            {x = x + math.sin(ang2) * (radius - thickness), y = y - math.cos(ang2) * (radius - thickness)},
            {x = x + math.sin(ang1) * (radius - thickness), y = y - math.cos(ang1) * (radius - thickness)}
        }
        surface.DrawPoly(poly)
    end
end

hook.Add("HUDPaint", "DG_O2Indicator", function()
    if impulse.hudEnabled == false then return end
    if predictedAir == nil or hidden then return end

    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end
    if ply:GetMoveType() == MOVETYPE_NOCLIP then return end

    local maxAir = impulse.Config.MaxAir

    if fadeStart then
        local t = CurTime() - fadeStart
        displayAlpha = math.Clamp(255 * (1 - t / DG_FADE_DURATION), 0, 255)
        if displayAlpha <= 0 then
            fadeStart = nil
            hidden = true
            return
        end
    end

    if displayAlpha < 1 then return end

    local frac = math.Clamp(predictedAir / maxAir, 0, 1)
    local x, y = ScrW() / 2, ScrH() - 120
    local radius, thickness = 30, 6

    DrawArc(x, y, radius, thickness, 0, 360, 40, Color(0, 0, 0, 150 * (displayAlpha / 255)))
    local col = frac > 0.3 and Color(80, 170, 255, displayAlpha) or Color(220, 50, 50, displayAlpha)
    DrawArc(x, y, radius, thickness, 0, 360 * frac, 40, col)
    draw.SimpleText("O₂", "OxygenFont", x, y, Color(255, 255, 255, displayAlpha * (220 / 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)