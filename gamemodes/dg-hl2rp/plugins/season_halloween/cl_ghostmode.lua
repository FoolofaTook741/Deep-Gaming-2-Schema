local range = 1500 ^ 2
local col = Color(182, 252, 237)
local nextVortScan = 0
local plys = {}
local targs = {}
local geeman = {
    ["$pp_colour_addr"] = 0.13,
    ["$pp_colour_addg"] = 0.06,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = -0.03,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0.7,
    ["$pp_colour_mulr"] = 1,
    ["$pp_colour_mulg"] = 1,
    ["$pp_colour_mulb"] = 1
}
local drawScary = false

net.Receive("impulseGhostReality", function()
    drawScary = net.ReadBool()
    RunConsoleCommand("r_shadows", drawScary and "0" or "1")
    surface.PlaySound(Sound("ambient/levels/gman/gman_seg_00_01_03.wav"))
    LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 1, 0.1)
end)

net.Receive("impulseGhostTarget", function()
    GHOST_TARG = net.ReadEntity()
    if not IsValid(GHOST_TARG) or GHOST_TARG:EntIndex() == 0 then
        GHOST_TARG = nil
    end
end)

net.Receive("impulseGhostMessage", function()
    local msg = net.ReadString()
    local text = vgui.Create("impulseFadeText")

    function text:Think()
        local name = msg
        local nl = string.len(name)
        local crazyName = ""

        for i = 1, nl do
            local o = string.sub(name, i, i)
            if math.random(1, 5) == 1 then
                o = string.char(math.random(97, 122))
            end

            if math.random(1, 3) == 1 then
                o = string.upper(o)
            end

            crazyName = crazyName .. o
        end

        text.text = crazyName
    end

    text:Setup(msg, nil, nil, 1.5, 1.5, 3.5)
end)

function PLUGIN:PreDrawHalos()
    local ply = LocalPlayer()

    if not ply:GetSyncVar(SYNC_HAL_GHOST, false) or not ply:Alive() then
        return
    end

    if nextVortScan < CurTime() then
        local pos = ply:GetPos()
        plys = {}
        targs = {}

        for _, k in pairs(player.GetAll()) do
            if not k:Alive() and GHOST_TARG and GHOST_TARG == k then
                GHOST_TARG = nil
            end

            if not k:GetNoDraw() and k:GetPos():DistToSqr(pos) < range then
                if GHOST_TARG and GHOST_TARG == k then
                    table.insert(targs, k)
                else
                    table.insert(plys, k)
                end
            end
        end

        nextVortScan = CurTime() + 0.1
    end

    halo.Add(plys, col, 5, 5, 1, nil, true)
    halo.Add(targs, Color(255, 0, 0, 255), 8, 8, 5, nil, true)
end

function PLUGIN:HUDPaint()
    local ply = LocalPlayer()

    if not ply:GetSyncVar(SYNC_HAL_GHOST, false) or not ply:Alive() then
        return
    end

    local scrW, scrH = ScrW(), ScrH()
    local h = scrH * 0.1

    draw.SimpleText("You are a Ghostly Spirit", "Impulse-Elements36", scrW * 0.5, h, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText("/gs Ghost message to target | ALT+C (on player) - See options", "Impulse-Elements17", scrW * 0.5, h + 50, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText("Currently Hunting: " .. (IsValid(GHOST_TARG) and GHOST_TARG:Nick() or "No one"), "Impulse-Elements17", scrW * 0.5, h + 65, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    local tr = ply:GetEyeTrace()
    if tr.HitPos and IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:GetSyncVar(SYNC_HAL_GHOST, false) and not tr.Entity:GetNoDraw() then
        if (tr.Entity.LastStingerGhost or 0) < CurTime() then
            surface.PlaySound("music/stingers/hl1_stinger_song27.mp3")
            tr.Entity.LastStingerGhost = CurTime() + 100
        end
    end
end

function PLUGIN:RenderScreenspaceEffects()
    if drawScary then
        DrawColorModify(geeman)
    end
end

function PLUGIN:PrePlayerDraw(ply)
    if drawScary then
        if ply == LocalPlayer() then return false end
        if not ply:GetSyncVar(SYNC_HAL_GHOST, false) and not ply:GetSyncVar(SYNC_HAL_GHOST_TARGET, false) then
            return true
        end
    else
        if ply:GetSyncVar(SYNC_HAL_SCARY, false) then
            return true
        end
        if ply:GetSyncVar(SYNC_HAL_GHOST_VIS, false) and not LocalPlayer():GetSyncVar(SYNC_HAL_GHOST_TARGET, false) then
            return true
        end
    end
end

function PLUGIN:PreDrawSkyBox()
    if drawScary then
        return true
    end
end