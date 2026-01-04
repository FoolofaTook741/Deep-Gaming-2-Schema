include("shared.lua")

local FLASHBANG_FLASHTIMER = 5
local FLASHBANG_EFFECT_DELAY = 2

local function DrawFlashbangEffect()
    local ct = CurTime()
    local endtime = LocalPlayer().m_fFlashbangEnd
    if (endtime and endtime > ct) then
        if (endtime - ct > FLASHBANG_FLASHTIMER) then
            Alpha = 255
        else
            FlashAlpha = 1 - (ct - (endtime - FLASHBANG_FLASHTIMER)) / (endtime - (endtime - FLASHBANG_FLASHTIMER))
            Alpha = FlashAlpha * 255
        end

        surface.SetDrawColor(255, 255, 255, math.Round(Alpha))
        surface.DrawRect(0, 0, ScrW(), ScrH())
    else
        hook.Remove("PostDrawHUD", "FLASHBANG_DrawFlashbangEffect")
    end
end

local function RenderFlashbangEffect()
    local endtime = LocalPlayer().m_fFlashbangEnd
    if (endtime) then
        if (endtime > CurTime() and endtime - FLASHBANG_EFFECT_DELAY - CurTime() <= FLASHBANG_FLASHTIMER) then
            local FlashAlpha = 1 - (CurTime() - (endtime - FLASHBANG_FLASHTIMER)) / (FLASHBANG_FLASHTIMER)
            DrawMotionBlur(0, FlashAlpha / ((FLASHBANG_FLASHTIMER + FLASHBANG_EFFECT_DELAY) / (FLASHBANG_FLASHTIMER * 4)), 0)
        elseif (endtime > CurTime()) then
            DrawMotionBlur(0, 0.01, 0)
        else
            hook.Remove("RenderScreenspaceEffects", "FLASHBANG_RenderFlashbangEffect")
            DrawMotionBlur(0, 0, 0)
        end
    end
end

net.Receive("SH_FLASHBANG", function()
    if (!IsValid(LocalPlayer())) then
        return
    end

    local f = net.ReadFloat()

    local mft = FLASHBANG_SETTINGS.MaxFlashTime
    FLASHBANG_FLASHTIMER = mft * (5 / 6)
    FLASHBANG_EFFECT_DELAY = mft * (2 / 6)


    LocalPlayer().m_fFlashbangStart = CurTime()
    LocalPlayer().m_fFlashbangEnd = CurTime() + f

    hook.Add("PostDrawHUD", "FLASHBANG_DrawFlashbangEffect", DrawFlashbangEffect)
    hook.Add("RenderScreenspaceEffects", "FLASHBANG_RenderFlashbangEffect", RenderFlashbangEffect)
end)