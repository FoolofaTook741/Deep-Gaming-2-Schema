include("shared.lua")

local SCREEN_OFFSET_UP      = 49
local SCREEN_OFFSET_FORWARD = -2.36
local SCREEN_OFFSET_RIGHT   = 8.3

local SCREEN_ROT_SPIN = 90
local SCREEN_ROT_TILT = 42

local SCREEN_SCALE  = 0.07
local SCREEN_WIDTH  = 265
local SCREEN_HEIGHT = 135

surface.CreateFont("Terminal_Title", {
    font = "Roboto",
    size = 20,
    weight = 700,
    extended = true
})

surface.CreateFont("Terminal_Sub", {
    font = "Roboto",
    size = 14,
    weight = 600,
    extended = true
})

surface.CreateFont("Terminal_Body", {
    font = "Consolas",
    size = 13,
    weight = 400,
    extended = true
})

surface.CreateFont("Terminal_Error", {
    font = "Roboto",
    size = 22,
    weight = 900,
    extended = true
})

surface.CreateFont("Terminal_ErrorSmall", {
    font = "Consolas",
    size = 13,
    weight = 500,
    extended = true
})

local boolToConnected = {
    [true] = "CONNECTED",
    [false] = "DISCONNECTED"
}

local function StatusColor(b)
    return b and Color(0, 200, 120) or Color(200, 50, 50)
end

function ENT:Draw()
    self:DrawModel()

    local cityCode = impulse.Dispatch.GetCityCode()

    local terminalCol = Color(0, 151, 255, 255)
    local bgCol       = Color(5, 12, 25, 245)
    local frameCol    = Color(10, 25, 45, 255)

    if cityCode == CODE_JW then
        terminalCol = Color(210, 0, 0, 255)
        bgCol = Color(15, 0, 0, 245)
    elseif cityCode == CODE_UNREST then
        terminalCol = Color(200, 100, 0, 255)
        bgCol = Color(18, 8, 0, 245)
    elseif cityCode == CODE_AJ then
        terminalCol = Color(75, 0, 0, 255)
        bgCol = Color(10, 2, 2, 245)
    elseif cityCode == CODE_LOST then
        terminalCol = Color(0, 0, 0, 255)
        bgCol = Color(0, 0, 0, 245)
    elseif cityCode == CODE_FRACTURED then
        terminalCol = Color(200, 50, 0, 255)
        bgCol = Color(18, 5, 0, 245)
    end

    local entAng = self:GetAngles()
    local entPos = self:GetPos()

    local pos = entPos
    local ang = entAng

    pos = pos + (ang:Up() * SCREEN_OFFSET_UP)
    pos = pos + (ang:Forward() * SCREEN_OFFSET_FORWARD)
    pos = pos + (ang:Right() * SCREEN_OFFSET_RIGHT)

    ang:RotateAroundAxis(ang:Up(), SCREEN_ROT_SPIN)
    ang:RotateAroundAxis(ang:Forward(), SCREEN_ROT_TILT)

    local w, h = SCREEN_WIDTH, SCREEN_HEIGHT
    local t = CurTime()

    local emp = self:IsEMPed()

    if emp then
        cam.Start3D2D(pos, ang, SCREEN_SCALE)
            surface.SetDrawColor(Color(20, 0, 0, 255))
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(Color(10, 0, 0, 240))
            surface.DrawRect(2, 2, w - 4, h - 4)

            for i = 1, 7 do
                surface.SetDrawColor(255, 255, 255, math.random(10, 45))
                surface.DrawRect(2, math.random(6, h - 6), w - 4, math.random(1, 4))
            end

            local flicker = 190 + 65 * math.abs(math.sin(t * 11))
            local jitterX = math.sin(t * 22) * 2
            local jitterY = math.cos(t * 18) * 1.5

            draw.SimpleText(
                "ERROR",
                "Terminal_Error",
                w / 2 + jitterX,
                h * 0.32 + jitterY,
                Color(255, 60, 60, flicker),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

            draw.SimpleText(
                "TERMINAL MALFUNCTION",
                "Terminal_ErrorSmall",
                w / 2 - jitterX,
                h * 0.47 - jitterY,
                Color(255, 200, 200, 230),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

            draw.SimpleText(
                "EMP INTERFERENCE DETECTED",
                "Terminal_ErrorSmall",
                w / 2,
                h * 0.62,
                Color(200, 120, 120, 210),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

            local scanY = 2 + (h - 4) * ((t * 0.8) % 1)
            surface.SetDrawColor(255, 255, 255, 25)
            surface.DrawRect(2, scanY, w - 4, 2)
        cam.End3D2D()
        return
    end

    local user = self:GetNetworkedUser()
    local terminalID = "TERMINAL: " .. self:EntIndex()
    local statusLine = "NO ACTIVE USER"
    local userName

    if user and user ~= -1 then
        user = Entity(user)
        if IsValid(user) and user:IsPlayer() and user:IsCP() then
            statusLine = "USER ONLINE"
            userName = user:Name()
        end
    end

    local timeStr = os.date("%H:%M:%S - %d/%m", os.time())

    local humanIndex     = "CONNECTED"
    local convictIndex   = boolToConnected[self:GetConvictIndex()] or "UNKNOWN"
    local overwatchIndex = boolToConnected[self:GetOverwatchIndex()] or "UNKNOWN"

    cam.Start3D2D(pos, ang, SCREEN_SCALE)
        surface.SetDrawColor(frameCol)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(bgCol)
        surface.DrawRect(2, 2, w - 4, h - 4)

        surface.SetDrawColor(terminalCol)
        surface.DrawRect(2, 2, w - 4, 20)

        draw.SimpleText("CITY TERMINAL", "Terminal_Sub",
            6, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local cityStatus = "STABLE"
        if cityCode == CODE_JW then cityStatus = "JUDGEMENT"
        elseif cityCode == CODE_UNREST then cityStatus = "UNREST"
        elseif cityCode == CODE_AJ then cityStatus = "AUTONOMOUS"
        elseif cityCode == CODE_LOST then cityStatus = "LOST"
        elseif cityCode == CODE_FRACTURED then cityStatus = "FRACTURED"
        end

        draw.SimpleText(cityStatus, "Terminal_Sub",
            w - 6, 12, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        local x = 6
        local y = 26

        draw.SimpleText(terminalID, "Terminal_Body", x, y, terminalCol)
        draw.SimpleText("TIME: " .. timeStr, "Terminal_Body", x, y + 14, Color(200, 220, 255))
        draw.SimpleText(statusLine, "Terminal_Body", x, y + 26, Color(200, 220, 255))

        if userName then
            draw.SimpleText("USER: " .. userName, "Terminal_Body", x, y + 38, color_white)
        else
            draw.SimpleText("USER: N/A", "Terminal_Body", x, y + 38, Color(130, 150, 180))
        end

        local iy = y + 54

        draw.SimpleText("STATUS", "Terminal_Sub", x, iy, Color(220, 230, 255))

        local function DrawIndex(label, value, yPos, active)
            local col = StatusColor(active)
            surface.SetDrawColor(col)
            surface.DrawRect(x, yPos + 4, 5, 5)
            draw.SimpleText(label, "Terminal_Body", x + 8, yPos, Color(200, 220, 255))
            draw.SimpleText(value, "Terminal_Body", x + 95, yPos, col)
        end

        DrawIndex("HUMAN",     humanIndex,     iy + 12, true)
        DrawIndex("CONVICT",   convictIndex,   iy + 24, convictIndex == "CONNECTED")
        DrawIndex("OVERWATCH", overwatchIndex, iy + 36, overwatchIndex == "CONNECTED")

        local scanY2 = 2 + (h - 4) * ((t * 0.25) % 1)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawRect(2, scanY2, w - 4, 1)
    cam.End3D2D()
end

sound.Add({
    name = "terminal_idle",
    channel = CHAN_STATIC,
    level = 60,
    volume = 1,
    sound = "ambient/machines/combine_terminal_loop1.wav"
})

sound.Add({
    name = "terminal_damaged",
    channel = CHAN_STATIC,
    level = 60,
    volume = 1,
    sound = "ambient/energy/spark1.wav"
})

function ENT:Think()
    if (self.nextTerminalCheck or 0) < CurTime() then
        local plyPos = LocalPlayer():GetPos()
        local emp = self:IsEMPed()

        if emp then
            if (plyPos - self:GetPos()):LengthSqr() <= (600 ^ 2) then
                if not self.Emitting then
                    self:EmitSound("terminal_damaged")
                    self.Emitting = true
                end
            elseif self.Emitting then
                self:StopSound("terminal_damaged")
                self.Emitting = false
            end
            self.nextTerminalCheck = CurTime() + 5
        else
            if (plyPos - self:GetPos()):LengthSqr() <= (600 ^ 2) then
                if not self.Emitting then
                    self:EmitSound("terminal_idle")
                    self.Emitting = true
                end
            elseif self.Emitting then
                self:StopSound("terminal_idle")
                self.Emitting = false
            end
            self.nextTerminalCheck = CurTime() + 2
        end
    end
end
