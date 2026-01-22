include("shared.lua")

local lightMat = Material("sprites/glow04_noz")

local CONFIG = {
    ChargeTime       = 3.8,
    FlashDuration    = 1.4,

    Lights = {
        { offset = Vector(7, -1.3, 40) },
        { offset = Vector(11, -1.3, 31) },
        { offset = Vector(11, -1.3, 20) },
    },

    SpriteSize       = 5.0,
    GlowMult         = 3,

    IdleGreen        = Color(100, 255, 140),
    IdleRed          = Color(255, 90,  90),   -- renamed for clarity
    AllWhite         = Color(245, 245, 255),
    ChargeGreen      = Color(110, 255, 150),
    FlashGreen       = Color(130, 255, 180),
    FlashRed         = Color(255, 110, 110),

    IdlePulseSpeed   = 1.4,
    ChargePulseSpeed = 7.0,
    FlashPulseSpeed  = 15.0,
    PulseAmplitude   = 0.28,
}

ENT.ChargeStart   = 0
ENT.IsCharging    = false
ENT.FlashStart    = 0
ENT.IsFlashing    = false
ENT.FlashCol      = Color(255,255,255)
ENT.PendingDeny   = false

net.Receive("RationScanStart", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    ent.ChargeStart  = CurTime()
    ent.IsCharging   = true
    ent.IsFlashing   = false
    ent.PendingDeny  = false
end)

net.Receive("RationScanResult", function()
    local ent     = net.ReadEntity()
    local success = net.ReadBool()

    if not IsValid(ent) then return end

    if not success then
        ent.PendingDeny = true
    end
end)

function ENT:DoFlash(col)
    self.IsFlashing = true
    self.FlashStart = CurTime()
    self.FlashCol   = col
    self.IsCharging = false
    self.PendingDeny = false
end

local function LerpColor(t, a, b)
    t = math.Clamp(t, 0, 1)
    return Color(
        Lerp(t, a.r, b.r),
        Lerp(t, a.g, b.g),
        Lerp(t, a.b, b.b)
    )
end

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos()
    local fwd = self:GetForward()
    local rgt = self:GetRight()
    local up  = self:GetUp()
    local ct  = CurTime()

    local lightState = self:GetLight()  -- 1 = red/offline, 3 = green/online

    cam.Start3D()
    render.SetMaterial(lightMat)

    if self.IsFlashing then
        local elapsed = ct - self.FlashStart
        if elapsed > CONFIG.FlashDuration then
            self.IsFlashing = false
        else
            local pulse = 0.35 + 0.65 * math.abs(math.sin(elapsed * CONFIG.FlashPulseSpeed))
            local alpha = 150 + pulse * 130
            local sz    = CONFIG.SpriteSize * (1 + pulse * 0.5)

            for _, l in ipairs(CONFIG.Lights) do
                local wp = pos + fwd * l.offset.x + rgt * l.offset.y + up * l.offset.z
                render.DrawSprite(wp, sz, 10, ColorAlpha(self.FlashCol, alpha))
                render.DrawSprite(wp, sz * 1.9, 18, ColorAlpha(self.FlashCol, alpha * 0.4))
            end
        end

    elseif self.IsCharging then
        local elapsed  = ct - self.ChargeStart
        local progress = math.Clamp(elapsed / CONFIG.ChargeTime, 0, 1)
        local litCount = math.floor(progress * #CONFIG.Lights) + 1

        local activeCol = LerpColor(progress, CONFIG.AllWhite, CONFIG.ChargeGreen)

        for i, light in ipairs(CONFIG.Lights) do
            local wp = pos + fwd*light.offset.x + rgt*light.offset.y + up*light.offset.z

            local col, alpha

            if i < litCount then
                col   = CONFIG.ChargeGreen
                alpha = 225
            elseif i == litCount then
                col   = activeCol
                local phase = ct * CONFIG.ChargePulseSpeed + i * 1.5
                local p     = 0.45 + 0.55 * (math.sin(phase) * 0.5 + 0.5)
                alpha = 170 + 70 * p
            else
                col   = Color(95, 95, 95)
                alpha = 30
            end

            render.DrawSprite(wp, CONFIG.SpriteSize, 7.5, ColorAlpha(col, alpha))
            if alpha > 65 then
                render.DrawSprite(wp, CONFIG.SpriteSize * CONFIG.GlowMult, 15, ColorAlpha(col, alpha * 0.42))
            end
        end

        if progress >= 1 then
            if self.PendingDeny then
                self:DoFlash(CONFIG.FlashRed)
            else
                self:DoFlash(CONFIG.FlashGreen)
            end
            self.IsCharging = false
            self.PendingDeny = false
        end

    else
        -- Idle: red if light == 1 (offline), green if light == 3 (online)
        local baseCol = (lightState == 1) and CONFIG.IdleRed or CONFIG.IdleGreen

        local t     = ct * CONFIG.IdlePulseSpeed
        local wave  = math.sin(t) * 0.5 + 0.5
        local pulse = CONFIG.PulseAmplitude + (1 - CONFIG.PulseAmplitude) * wave
        local alpha = 95 + pulse * 105
        local sz    = CONFIG.SpriteSize * (0.96 + pulse * 0.22)

        for _, l in ipairs(CONFIG.Lights) do
            local wp = pos + fwd*l.offset.x + rgt*l.offset.y + up*l.offset.z
            render.DrawSprite(wp, sz, 7, ColorAlpha(baseCol, alpha))
            render.DrawSprite(wp, sz * 1.75, 14, ColorAlpha(baseCol, alpha * 0.38))
        end
    end

    cam.End3D()
end

ENT.HUDName = "Ration Dispenser"
ENT.HUDDesc = "Retrieve your scheduled rations here."