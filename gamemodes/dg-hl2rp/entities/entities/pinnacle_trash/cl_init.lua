include("shared.lua")

ENT.AutomaticFrameAdvance = true
local activeScavenge = false

net.Receive("impulseScavengeCancel", function()
    activeScavenge = false
end)


net.Receive("impulseScavengeProgress", function()
   local ent = net.ReadEntity()
    local duration = net.ReadFloat()
    activeScavenge = true

    local isCleaning = false
    if ent and ent.CWUScavengeRemove then
        isCleaning = true
    end

        local frame = vgui.Create("DFrame")
        frame:SetTitle("")
        frame:SetSize(800, 800)
        frame:Center()
        frame:MakePopup()
        frame:ShowCloseButton(false)
        frame:SetDraggable(false)

        local startTime = CurTime()
        local endTime = startTime + duration

        frame.Paint = function(self, w, h)
            if not activeScavenge or not IsValid(ent) then
                self:Remove()
                return
            end

            local label = "Scavenging trash..."
            if LocalPlayer():Team() == TEAM_CWU and LocalPlayer():GetTeamClass() == CLASS_INDUST or LocalPlayer():Team() == TEAM_VORT then
                label = "Cleaning up trash..."
            end
            draw.SimpleText(label, "terminal50", w/2, h/2 - 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            local frac = math.Clamp((CurTime() - startTime) / duration, 0, 1)
            local dashCount = 5
            local filledDashes = math.floor(dashCount * frac + 0.5)
            local dashSize = 22
            local spacing = 12
            local totalWidth = dashCount * dashSize + (dashCount - 1) * spacing
            local startX = (w - totalWidth) / 2
            local y = h / 2

            for i = 1, dashCount do
                local x = startX + (i - 1) * (dashSize + spacing)
                surface.SetDrawColor(i <= filledDashes and Color(25,52,180,255) or Color(255,255,255,40))
                surface.DrawRect(
                    x,
                    y - dashSize / 2,
                    dashSize,
                    dashSize
                )
            end
        end

        timer.Simple(duration, function()
            if IsValid(frame) then
                frame:Remove()
            end
        end)
    end)

-- ...existing code...