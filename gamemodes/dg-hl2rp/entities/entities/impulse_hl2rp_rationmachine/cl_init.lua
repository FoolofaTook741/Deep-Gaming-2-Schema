include("shared.lua")

local glowMat = Material("sprites/glow04_noz")

local lightCols = {
    [1] = Color(255, 70, 70),
    [2] = Color(70, 255, 70),
    [3] = Color(70, 70, 255)
}

ENT.HUDName = "Ration Dispenser"
ENT.HUDDesc = "Retrieve your scheduled rations here."

local ActiveScans = {}

net.Receive("RationScanStart", function()
    local ent = net.ReadEntity()
    local ply = net.ReadEntity()
    local duration = net.ReadFloat()

    if not IsValid(ent) or not IsValid(ply) then return end

    ActiveScans[ent] = {
        target = ply,
        start = CurTime(),
        duration = duration,
        result = nil,
        resultTime = nil
    }
end)

net.Receive("RationScanResult", function()
    local ent = net.ReadEntity()
    local accepted = net.ReadBool()

    local data = ActiveScans[ent]
    if not data then return end

    data.result = accepted and "accept" or "deny"
    data.resultTime = CurTime()
end)

function ENT:Draw()
    self:DrawModel()

    local state = self:GetLight() or 1
    local baseCol = lightCols[state] or lightCols[1]

    local pos = self:GetPos()
    local t = CurTime()

	local glowPos = pos
    	+ self:GetForward() * 11
   	 	+ self:GetUp() * 22
    	+ self:GetRight() * -1.3


    local baseSize = 8
    local pulseSize = baseSize + math.sin(t * 4) * 1.5

    local innerAlpha = 210 + math.sin(t * 7) * 25
    local outerAlpha = 40 + math.sin(t * 2) * 5

    render.SetMaterial(glowMat)

    render.DrawSprite(
        glowPos,
        pulseSize,
        pulseSize,
        Color(baseCol.r, baseCol.g, baseCol.b, innerAlpha)
    )

    render.DrawSprite(
        glowPos,
        pulseSize * 1.9,
        pulseSize * 1.9,
        Color(baseCol.r, baseCol.g, baseCol.b, outerAlpha)
    )

    local dlight = DynamicLight(self:EntIndex())
    if dlight then
        dlight.pos = glowPos
        dlight.r = baseCol.r
        dlight.g = baseCol.g
        dlight.b = baseCol.b
        dlight.brightness = 1.2
        dlight.Decay = 400
        dlight.Size = 85
        dlight.DieTime = t + 0.1
    end

    local scan = ActiveScans[self]
    if not scan then return end
    if not IsValid(scan.target) then ActiveScans[self] = nil return end

    local now = CurTime()
    local elapsed = now - scan.start
    local scanFrac = math.Clamp(elapsed / scan.duration, 0, 1)
    local eased = scanFrac * scanFrac * (3 - 2 * scanFrac)

    local resultCol = nil
    if scan.result and scan.resultTime then
        local sinceResult = now - scan.resultTime
        if sinceResult > 0.6 then
            ActiveScans[self] = nil
            return
        end

        if scan.result == "accept" then
            resultCol = Color(80, 255, 80)
        else
            resultCol = Color(255, 60, 60)
        end
    end

    local target = scan.target
    local mins, maxs = target:OBBMins(), target:OBBMaxs()
    local bodyHeight = maxs.z - mins.z

    local localScanHeight = Lerp(eased, mins.z + 5, maxs.z - 5)
    local localPoint = Vector(0, 0, localScanHeight)
    local worldPoint = target:LocalToWorld(localPoint)

    local beamCol
    if resultCol then
        local flash = 0.7 + math.sin(now * 12) * 0.3
        beamCol = Color(
            resultCol.r * flash,
            resultCol.g * flash,
            resultCol.b * flash
        )
    else
        local pulse = 0.85 + math.sin(now * 8) * 0.15
        beamCol = Color(
            120 * pulse,
            220 * pulse,
            255,
            255
        )
    end

    local beamWidthCore = 6
    local beamWidthOuter = 10

    render.SetColorMaterial()
    render.DrawBeam(glowPos, worldPoint, beamWidthOuter, 0, 1, Color(beamCol.r, beamCol.g, beamCol.b, 110))
    render.DrawBeam(glowPos, worldPoint, beamWidthCore, 0, 1, beamCol)

    render.SetMaterial(glowMat)
    render.DrawSprite(worldPoint, 9, 9, beamCol)

    local sheetWidth = 26
    local sheetHeight = bodyHeight + 10
    local normal = (worldPoint - glowPos):GetNormalized()
    local sheetAlpha = 40 + math.sin(now * 10) * 10

    render.SetColorMaterial()
    render.DrawQuadEasy(
        worldPoint,
        -normal,
        sheetWidth,
        sheetHeight,
        Color(beamCol.r, beamCol.g, beamCol.b, sheetAlpha),
        0
    )
end
