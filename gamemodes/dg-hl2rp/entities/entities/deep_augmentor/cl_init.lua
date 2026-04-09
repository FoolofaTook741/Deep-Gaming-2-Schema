include("shared.lua")

local COL_BG      = Color(28, 28, 28, 250)
local COL_PANEL   = Color(40, 40, 40, 255)
local COL_BORDER  = Color(70, 70, 70, 255)
local COL_BTN     = Color(52, 52, 52, 255)
local COL_BTN_HOV = Color(72, 72, 72, 255)
local COL_TEXT    = Color(210, 210, 210, 255)
local COL_SUB     = Color(130, 130, 130, 255)
local COL_X       = Color(160, 60, 60, 255)
local COL_X_HOV   = Color(200, 70, 70, 255)

local function MakeAugButton(parent, label, sublabel, x, y, w, h, onClick)
    local btn = vgui.Create("DPanel", parent)
    btn:SetPos(x, y)
    btn:SetSize(w, h)
    btn.IsHovered = false

    btn.Paint = function(self, pw, ph)
        local col = self.IsHovered and COL_BTN_HOV or COL_BTN
        draw.RoundedBox(4, 0, 0, pw, ph, col)
        draw.RoundedBox(4, 0, 0, pw, 2, COL_BORDER)

        draw.SimpleText(label, "DermaDefaultBold", pw / 2, ph / 2 - 8, COL_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if sublabel then
            draw.SimpleText(sublabel, "DermaDefault", pw / 2, ph / 2 + 10, COL_SUB, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    btn.OnCursorEntered = function(self) self.IsHovered = true end
    btn.OnCursorExited  = function(self) self.IsHovered = false end
    btn.OnMousePressed  = function(self, mc)
        if mc == MOUSE_LEFT then onClick() end
    end

    return btn
end

net.Receive("impulseAugmentorOpen", function()
    local canSkin  = net.ReadBool()
    local canNova  = net.ReadBool()

    if IsValid(_AugmentorPanel) then _AugmentorPanel:Remove() end

    local W, H = 320, 180
    local frame = vgui.Create("DFrame")
    frame:SetSize(W, H)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()
    _AugmentorPanel = frame

    frame.Paint = function(self, fw, fh)
        draw.RoundedBox(6, 0, 0, fw, fh, COL_BG)
        draw.RoundedBox(6, 0, 0, fw, 1, COL_BORDER)
        draw.RoundedBox(6, 0, fh - 1, fw, 1, COL_BORDER)

        draw.SimpleText("AUGMENTOR TERMINAL", "DermaDefaultBold", fw / 2, 18, COL_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Select an option below", "DermaDefault", fw / 2, 34, COL_SUB, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(COL_BORDER)
        surface.DrawLine(16, 46, fw - 16, 46)
    end

    local closeBtn = vgui.Create("DPanel", frame)
    closeBtn:SetPos(W - 28, 6)
    closeBtn:SetSize(20, 20)
    closeBtn.IsHovered = false
    closeBtn.Paint = function(self, cw, ch)
        local col = self.IsHovered and COL_X_HOV or COL_X
        draw.RoundedBox(3, 0, 0, cw, ch, col)
        draw.SimpleText("✕", "DermaDefault", cw / 2, ch / 2, COL_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn.OnCursorEntered = function(self) self.IsHovered = true end
    closeBtn.OnCursorExited  = function(self) self.IsHovered = false end
    closeBtn.OnMousePressed  = function(self, mc)
        if mc == MOUSE_LEFT then frame:Remove() end
    end

    local btnY   = 58
    local btnH   = 88
    local margin = 12
    local btnW   = (W - margin * 3) / 2

    if canSkin then
        local skinX = margin
        local skinW = canNova and btnW or (W - margin * 2)
        MakeAugButton(frame, "TOGGLE SKIN", "Change your unit skin", skinX, btnY, skinW, btnH, function()
            net.Start("impulseAugmentorChoice")
            net.WriteUInt(1, 4)
            net.SendToServer()
            frame:Remove()
        end)
    end

    if canNova then
        local novaX = canSkin and (margin * 2 + btnW) or margin
        local novaW = canSkin and btnW or (W - margin * 2)
        MakeAugButton(frame, "TOGGLE NOVA", "Switch NOVA Prospekt uniform", novaX, btnY, novaW, btnH, function()
            net.Start("impulseAugmentorChoice")
            net.WriteUInt(2, 4)
            net.SendToServer()
            frame:Remove()
        end)
    end
end)