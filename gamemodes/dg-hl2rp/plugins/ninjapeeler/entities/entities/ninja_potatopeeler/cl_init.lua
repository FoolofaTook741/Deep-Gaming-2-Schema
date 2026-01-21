include("shared.lua")

local myFrame
local progbar
local myLabel
local stateLabel
local qKeyPanel
local eKeyPanel

local LR = false
local incrementValue = 0.18
local drainRate = 0.004
local finished = false
local reps = 0
local lastInputTime = 0

surface.CreateFont("PotatoTitleFont", {
    font = "Roboto",
    size = 32,
    weight = 800,
    antialias = true
})

surface.CreateFont("PotatoBigFont", {
    font = "Roboto",
    size = 26,
    weight = 700,
    antialias = true
})

surface.CreateFont("PotatoSmallFont", {
    font = "Roboto",
    size = 20,
    weight = 500,
    antialias = true
})

function ENT:Draw()
    self:DrawModel()
end

hook.Add("Think", "potatoPeelLogic", function()
    if not IsValid(myFrame) or not myFrame:IsVisible() then return end
    if not IsValid(progbar) then return end

    local pressed = false

    if input.IsKeyDown(27) and not input.IsKeyDown(15) and LR == false and finished == false then
        LR = true
        pressed = true
        lastInputTime = CurTime()
        progbar:SetFraction(math.min(1, progbar:GetFraction() + incrementValue))
    end

    if input.IsKeyDown(15) and not input.IsKeyDown(27) and LR == true and finished == false then
        LR = false
        pressed = true
        lastInputTime = CurTime()
        progbar:SetFraction(math.min(1, progbar:GetFraction() + incrementValue))
    end

    if not pressed and finished == false then
        progbar:SetFraction(math.max(0, progbar:GetFraction() - drainRate))
    end

    if progbar:GetFraction() >= 1 and finished == false then
        finished = true
        reps = reps + 1
        myLabel:SetText("Potatoes Peeled: " .. reps)
        stateLabel:SetText("Potato peeled! Keep going...")
    end

    if finished == true then
        progbar:SetFraction(math.max(0, progbar:GetFraction() - 0.02))
        if progbar:GetFraction() <= 0 then
            finished = false
            stateLabel:SetText("Keep peeling...")
        end
    end

    if IsValid(qKeyPanel) and IsValid(eKeyPanel) then
        qKeyPanel.Active = not LR
        eKeyPanel.Active = LR
    end
end)

net.Receive("potatoSignal", function()
    drawFrame()
    myFrame:SetVisible(true)
    myFrame:MakePopup()
end)

function drawFrame()
    reps = 0
    LR = false
    finished = false

    if IsValid(myFrame) then
        myFrame:Remove()
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.4, ScrH() * 0.35)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.startTime = SysTime()

    frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, w, h)

        draw.RoundedBox(12, 0, 0, w, h, Color(18, 20, 26, 245))
        draw.RoundedBox(10, 4, 4, w - 8, h - 8, Color(30, 34, 42, 255))
        draw.RoundedBoxEx(10, 4, 4, w - 8, 42, Color(70, 110, 160), true, true, false, false)

        draw.SimpleText("POTATO PEELER", "PotatoTitleFont", w / 2, 25, Color(230, 240, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    myFrame = frame

    local inner = vgui.Create("DPanel", frame)
    inner:Dock(FILL)
    inner:DockMargin(20, 60, 20, 20)
    inner.Paint = function() end

    stateLabel = vgui.Create("DLabel", inner)
    stateLabel:Dock(TOP)
    stateLabel:SetTall(24)
    stateLabel:SetFont("PotatoSmallFont")
    stateLabel:SetText("Alternate Q and E to peel")
    stateLabel:SetTextColor(Color(220, 220, 230))
    stateLabel:SetContentAlignment(5)

    local barHolder = vgui.Create("DPanel", inner)
    barHolder:Dock(TOP)
    barHolder:DockMargin(40, 16, 40, 0)
    barHolder:SetTall(54)
    barHolder.Paint = function() end

    progbar = vgui.Create("DProgress", barHolder)
    progbar:Dock(FILL)
    progbar:SetFraction(0)

    progbar.Paint = function(self, w, h)
        local frac = self:GetFraction()
        draw.RoundedBox(8, 0, 0, w, h, Color(15, 15, 20))
        local r = Lerp(frac, 200, 80)
        local g = Lerp(frac, 120, 220)
        local b = Lerp(frac, 70, 120)
        draw.RoundedBox(8, 0, 0, w * frac, h, Color(r, g, b))
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    myLabel = vgui.Create("DLabel", inner)
    myLabel:Dock(TOP)
    myLabel:DockMargin(0, 10, 0, 0)
    myLabel:SetFont("PotatoBigFont")
    myLabel:SetText("Reps: 0")
    myLabel:SetTextColor(Color(240, 240, 245))
    myLabel:SetContentAlignment(5)

    local keyRow = vgui.Create("DPanel", inner)
    keyRow:Dock(TOP)
    keyRow:DockMargin(80, 10, 80, 0)
    keyRow:SetTall(60)
    keyRow.Paint = function() end

    local function KeyBox(text)
        local p = vgui.Create("DPanel", keyRow)
        p:SetWide(80)
        p.Active = false

        p.Paint = function(self, w, h)
            local glow = self.Active and (0.5 + math.sin(CurTime() * 6) * 0.5) or 0
            local col = Color(40 + glow * 80, 50 + glow * 120, 70 + glow * 160)
            draw.RoundedBox(8, 0, 0, w, h, col)
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText(text, "PotatoBigFont", w / 2, h / 2, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        return p
    end

    qKeyPanel = KeyBox("Q")
    qKeyPanel:Dock(LEFT)
    qKeyPanel:DockMargin(20, 0, 20, 0)

    eKeyPanel = KeyBox("E")
    eKeyPanel:Dock(RIGHT)
    eKeyPanel:DockMargin(20, 0, 20, 0)

    local bottom = vgui.Create("DButton", inner)
    bottom:Dock(BOTTOM)
    bottom:SetTall(44)
    bottom:SetText("TURN IN")
    bottom:SetFont("PotatoBigFont")
    bottom:SetTextColor(Color(240, 240, 240))

    bottom.Paint = function(self, w, h)
        local hover = self:IsHovered()
        local col = hover and Color(90, 180, 120) or Color(60, 130, 90)
        draw.RoundedBox(8, 0, 0, w, h, col)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    bottom.DoClick = function()
        net.Start("potatoesPeeled")
            net.WriteInt(reps, 32)
        net.SendToServer()
        frame:Close()
    end
end
