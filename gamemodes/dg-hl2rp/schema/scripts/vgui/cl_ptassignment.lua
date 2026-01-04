local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
    self:SetKeyboardInputEnabled(true)
    self:SetTitle(" ")
    self:MakePopup()
    self:SetDraggable(false)
    self:ShowCloseButton(false)

    self.LoadStart = CurTime()
    self.LoadDuration = 10
    self.LoadProgress = 0
    self.NextStutter = CurTime() + math.Rand(0.05, 0.4)
    self.StutterAmount = 0

    self.AmbientMessages = {
        "initializing dispatch system...",
        "connecting to central server...",
        "loading dispatch protocols...",
        "establishing secure connection...",
        "retrieving dispatch data...",
        "finalizing system checks...",
        "dispatch system ready.",
    }

    self.MessageSchedule = {
        self.LoadStart + 1.5,
        self.LoadStart + 3.5,
        self.LoadStart + 6,
        self.LoadStart + 8.5
    }
    self.CurrentMessageIndex = 0
    self.DisplayedMessages = {}

    self.CurrentMessageIndex = 0
    self.DisplayedMessages = {}
    self.TypewriterStates = {} 
    surface.PlaySound("foley/hacking/emp_tool_process.mp3")

    self.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("overlays/cmb_terminal_bg.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 25)
        surface.SetMaterial(Material("impulse_redux/propaganda.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(32, 200, 255, 255)
        surface.SetMaterial(Material("impulse_redux/corner_brackets.png"))
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 200)
        surface.SetMaterial(Material("overlays/cmb_bg_animated1"))
        surface.DrawTexturedRect(0, 0, w, h)

        local spinnerChars = { "|", "/", "—", "\\"}
        local spinnerIndex = math.floor(CurTime() * 7) % #spinnerChars + 1
        local spinnerChar = spinnerChars[spinnerIndex]

        draw.SimpleText(spinnerChar .. "   loading dsp os v1.3.2...   " .. spinnerChar, "combineTextSmol", w / 2, h / 2 - 100, Color(50,125,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local function DrawLoader(centerX, centerY)
            local baseRadius = math.min(w, h) / 16 
            local pulseScale = 1 + 0.3 * math.sin(CurTime() * 2)
            local radius = baseRadius * pulseScale
            local rotation = CurTime() * 45
            
            local segments = 64
            surface.SetDrawColor(100, 150, 255, 200) -- Blue circle
            for i = 0, segments - 1 do
                local angle1 = (i / segments) * 360 + rotation
                local angle2 = ((i + 1) / segments) * 360 + rotation
                
                local x1 = centerX + math.cos(math.rad(angle1)) * radius
                local y1 = centerY + math.sin(math.rad(angle1)) * radius
                local x2 = centerX + math.cos(math.rad(angle2)) * radius
                local y2 = centerY + math.sin(math.rad(angle2)) * radius
                
                surface.DrawLine(x1, y1, x2, y2)
            end
            
            local crossSize = radius * 1.5 
            surface.SetDrawColor(100, 150, 255, 255) 
            
            local cos_rot = math.cos(math.rad(rotation))
            local sin_rot = math.sin(math.rad(rotation))
            
            local hx1 = centerX + (-crossSize) * cos_rot - 0 * sin_rot
            local hy1 = centerY + (-crossSize) * sin_rot + 0 * cos_rot
            local hx2 = centerX + crossSize * cos_rot - 0 * sin_rot
            local hy2 = centerY + crossSize * sin_rot + 0 * cos_rot
            surface.DrawLine(hx1, hy1, hx2, hy2)
            
            local vx1 = centerX + 0 * cos_rot - (-crossSize) * sin_rot
            local vy1 = centerY + 0 * sin_rot + (-crossSize) * cos_rot
            local vx2 = centerX + 0 * cos_rot - crossSize * sin_rot
            local vy2 = centerY + 0 * sin_rot + crossSize * cos_rot
            surface.DrawLine(vx1, vy1, vx2, vy2)
        end

        local leftCenterX = w * 0.25
        local leftCenterY = h / 2
        DrawLoader(leftCenterX, leftCenterY)

        local rightCenterX = w * 0.75
        local rightCenterY = h / 2
        DrawLoader(rightCenterX, rightCenterY)

        surface.SetDrawColor(50, 125, 255, 1)

        local barW, barH = 400, 16
        local barX, barY = (w - barW) / 2, h / 2 
        surface.DrawRect(barX, barY, barW, barH)

        surface.SetDrawColor(50, 125, 255, 255)
        surface.DrawRect(barX + 2, barY + 2, (barW - 4) * self.LoadProgress, barH - 4)

        local msgY = 24
        for i, msg in ipairs(self.DisplayedMessages) do
            local state = self.TypewriterStates[i]
            if state then
                local charsToShow = math.min(math.floor((CurTime() - state.startTime) * 40), #msg)
                if charsToShow > #msg then charsToShow = #msg end
                draw.SimpleText(string.sub(msg, 1, charsToShow), "combineTextSmol", 24, msgY, Color(50,125,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText("", "combineTextSmol", 24, msgY, Color(50,125,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
            msgY = msgY + 32
        end
    end

    local modelSize = math.min(ScrW(), ScrH()) / 3

    self.LeftModel = vgui.Create("DModelPanel", self)
    self.LeftModel:SetSize(modelSize, modelSize)
    self.LeftModel:SetPos(ScrW() * 0.25 - modelSize/2, ScrH() / 2 - modelSize/2)
    self.LeftModel:SetModel(LocalPlayer():GetModel())
    self.LeftModel:SetCamPos(Vector(80, 0, 40))
    self.LeftModel:SetLookAt(Vector(0, 0, 35))
    self.LeftModel:SetFOV(50) 

    -- Right model panel  
    self.RightModel = vgui.Create("DModelPanel", self)
    self.RightModel:SetSize(modelSize, modelSize)
    self.RightModel:SetPos(ScrW() * 0.75 - modelSize/2, ScrH() / 2 - modelSize/2)
    self.RightModel:SetModel(LocalPlayer():GetModel())
    self.RightModel:SetCamPos(Vector(80, 0, 40))
    self.RightModel:SetLookAt(Vector(0, 0, 35))
    self.RightModel:SetFOV(50)

    local wireframeMat = Material("models/wireframe")
    self.LeftModel.PreDrawModel = function(panel, entity)
        render.MaterialOverride(wireframeMat)
        render.SetColorModulation(0.4, 0.6, 1) 
    end
    self.LeftModel.PostDrawModel = function(panel, entity)
        render.MaterialOverride()
        render.SetColorModulation(1, 1, 1)
    end

    self.RightModel.PreDrawModel = function(panel, entity)
        render.MaterialOverride(wireframeMat)
        render.SetColorModulation(0.4, 0.6, 1) 
    end
    self.RightModel.PostDrawModel = function(panel, entity)
        render.MaterialOverride()
        render.SetColorModulation(1, 1, 1)
    end
end

function PANEL:Think()
    if CurTime() >= (self.NextStutter or 0) then
        self.StutterAmount = math.Rand(1, 2)
        self.NextStutter = CurTime() + math.Rand(0.05, 0.4)
    end

    local elapsed = CurTime() - self.LoadStart
    local targetProgress = math.Clamp(elapsed / self.LoadDuration, 0, 1)
    if self.LoadProgress < targetProgress then
        self.LoadProgress = math.min(self.LoadProgress + self.StutterAmount, targetProgress)
    end

    if self.CurrentMessageIndex < #self.MessageSchedule then
        local nextTime = self.MessageSchedule[self.CurrentMessageIndex + 1]
        if CurTime() >= nextTime then
            self.CurrentMessageIndex = self.CurrentMessageIndex + 1
            local msg = self.AmbientMessages[self.CurrentMessageIndex] or ""
            table.insert(self.DisplayedMessages, msg)
            self.TypewriterStates[#self.DisplayedMessages] = {startTime = CurTime()}
        end
    end

    if self.LoadProgress >= 1 then
        vgui.Create("impulsePlayableDispatch") --TODO: Finish this menu
        self:Remove()        
    end
end

function PANEL:OnRemove()
    if IsValid(self.LeftModel) then
        self.LeftModel:Remove()
    end
    if IsValid(self.RightModel) then
        self.RightModel:Remove()
    end
end

vgui.Register("DispatchInitMenu", PANEL, "DFrame")