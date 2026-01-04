local PANEL = {}

PANEL.CrashTime = 0
PANEL.ShowPanel = 0
PANEL.ShowInfoAnim = 0
PANEL.ShowPanelAnim = 0

local blur = Material("pp/blurscreen")
local function BlurScreen()
    local amount = 6
    local x, y = 0, 0
    local scrW, scrH = ScrW(), ScrH()

    surface.SetDrawColor(0, 0, 0, 192)
    surface.DrawRect(0, 0, scrW, scrH)

    surface.SetDrawColor(255, 255, 255, 127)
    surface.SetMaterial(blur)

    for i = 1, 5 do
        blur:SetFloat("$blur", (i / 3) * amount)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

local gradientU, gradientD = Material("vgui/gradient-u"), Material("vgui/gradient-d")
function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()

    self:SetPaintedManually(true)
    self:SetVisible(false)
    self:MakePopup()
    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)

    local logo = vgui.Create("DHTML", self)
    logo:SetSize(self:GetWide() * 0.5, 192)
    logo:SetPos(self:GetWide() * 0.5 - logo:GetWide() * 0.5, self:GetTall() * 0.065)
    logo:SetMouseInputEnabled(false)
    function logo:ConsoleMessage(msg) end
    logo:SetHTML([[
    <!DOCTYPE html>
    <html>
        <head>
            <style>
            body, html {
                padding: 0;
                margin: 0;
                overflow: hidden;
            }
            img {
                position: absolute;
                -webkit-transform: translate(-50%, -50%);
                top: 50%;
                left: 50%;
                max-width: 100%;
                max-height: 100%;
                display: block;
            }
            </style>
        </head>
        <body>
            <img id="img"></img>
            <script>
                var url = "]] .. string.JavascriptSafe(crashmenu.Config.LogoURL) .. [[";
                document.getElementById("img").src = url;
            </script>
        </body>
    </html>
    ]])
    
    local chatboxContainer = self:Add("Panel")
    self.ChatboxContainer = chatboxContainer
    chatboxContainer:SetWide(self:GetWide() * 0.5)
    chatboxContainer:SetTall(self:GetTall() * 0.33)
    chatboxContainer:SetPos(self:GetWide() * 0.5 * 0.66, self:GetTall() * 0.5)

    local reconnect = self:Add("DButton")
    reconnect:SetFont("crashmenu_2")
    reconnect:SetTextColor(color_white)
    reconnect:SetWide(self:GetWide() * 0.5 * 0.33)
    reconnect:SetTall(48)
    reconnect:MoveAbove(chatboxContainer, -reconnect:GetTall())
    reconnect:MoveLeftOf(chatboxContainer, 8)
    local buttonPaint = function(btn, w, h)
        surface.SetDrawColor(btn.Color or color_white)
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(gradientU)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 31.875)
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        surface.SetDrawColor(255, 255, 255, 31.875)
        surface.DrawOutlinedRect(2, 2, w - 4, h - 4)
        surface.DrawOutlinedRect(3, 3, w - 6, h - 6)

        if btn:IsHovered() and btn.Depressed then
            surface.SetDrawColor(0, 0, 0, 24)
            surface.DrawRect(0, 0, w, h)
        elseif btn:IsHovered() then
            surface.SetDrawColor(255, 255, 255, 4)
            surface.DrawRect(0, 0, w, h)
        end
    end
    reconnect.Paint = buttonPaint
    self.AutoDisabled = false
    function reconnect.Think()
        local dots = ("."):rep(math.floor(RealTime()) % 4)

        if reconnect:IsHovered() and not self.AutoDisabled then
            reconnect:SetText("Disable auto-reconnect?")
        elseif not self.AutoDisabled then
            reconnect:SetText("Auto-reconnecting soon" .. dots)
        else
            reconnect:SetText("Reconnect")
        end

        if self.Reconnecting then
            reconnect:SetText("Reconnecting" .. dots)
        end

        if self.AutoDisabled then
            reconnect.Color = Color(64, 127, 64, 255)
        else
            reconnect.Color = Color(127, 127, 64, 255)
        end

        if not self.AutoDisabled and self.NextTry and self.NextTry <= RealTime() and self.Reconnecting then
            RunConsoleCommand("retry")
        end
    end
    function reconnect.DoClick()
        if not self.AutoDisabled then
            self.AutoDisabled = true
        else
            RunConsoleCommand("retry")
        end
    end

    local prev
    for i, data in pairs(crashmenu.Config.Servers or {}) do
        local server = self:Add("DButton")
        server:SetFont("crashmenu_2")
        server:SetTextColor(color_white)
        server:SetText(data.Name)
        server:SetWide(self:GetWide() * 0.5 * 0.33)
        server:SetTall(48)
        server:MoveBelow(prev or reconnect, 8)
        server:MoveLeftOf(chatboxContainer, 8)
        server.Color = Color(96, 64, 127, 255)
        server.Paint = buttonPaint
        function server:DoClick()
            if data.IP then
                LocalPlayer():ConCommand("connect " .. data.IP)
            elseif data.URL then
                gui.OpenURL(data.URL)
            end
        end
        prev = server
    end

    local disconnect = self:Add("DButton")
    disconnect:SetFont("crashmenu_2")
    disconnect:SetTextColor(color_white)
    disconnect:SetText("Disconnect")
    disconnect:SetWide(self:GetWide() * 0.5 * 0.33)
    disconnect:SetTall(48)
    disconnect:MoveBelow(prev or reconnect, 8)
    disconnect:MoveLeftOf(chatboxContainer, 8)
    disconnect.Color = Color(127, 64, 64, 255)
    disconnect.Paint = buttonPaint
    function disconnect:DoClick()
        RunConsoleCommand("disconnect")
    end

    hook.Add("PostRenderVGUI", self, function()
        self.ShowPanelAnim = Lerp(FrameTime() * 1.75, self.ShowPanelAnim, self.ShowPanel)
        if self.ShowPanel == 0 and self.ShowPanelAnim < 0.01 then
            self:SetVisible(false)
            return
        end

        if (RealTime() - self.CrashTime) >= 2.25 then
            self.ShowInfoAnim = Lerp(FrameTime() * 1.25, self.ShowInfoAnim, 1)
        end

        if self.ShowPanel == 1 then
            if gui.IsGameUIVisible() then
                self:SetKeyboardInputEnabled(false)
                self:SetMouseInputEnabled(false)
                return
            else
                self:SetKeyboardInputEnabled(true)
                self:SetMouseInputEnabled(true)
            end
        end

        surface.SetAlphaMultiplier(self.ShowPanelAnim)

        BlurScreen()

        surface.SetAlphaMultiplier(1)

        local progress = ScrW() * (0.5 * self.ShowPanelAnim)
        local scissorX = ScrW() * 0.5 - progress
        render.SetScissorRect(scissorX, 0, scissorX + progress * 2, ScrH(), true)
            self:PaintManual()
            if IsValid(self.ServerMenu) then self.ServerMenu:PaintManual() end
        render.SetScissorRect(0, 0, 0, 0, false)
    end)
    
    self:LoadChatboxCode()
end

-- You did this, Rubat. x86-64 only.
function PANEL:LoadChatboxCode()
    // TODO: Make this retry on failure?

    HTTP({
        method = "GET",
        url = ("http://%s/room/%s"):format(crashmenu.Host, crashmenu.Config.ChatRoomID),
        success = function(code, html)
            if (code >= 200 and code < 300) then
                self.ChatboxHTML = html
            else 
                print("Failed to load chatbox JS: error" .. code)
                print(html)
            end
        end,
        failed = function(err)
            print("Failed to load chatbox JS: " .. err)
        end
    })
    HTTP({
        method = "GET",
        url = ("http://%s/app.js"):format(crashmenu.Host),
        success = function(code, js)
            if (code >= 200 and code < 300) then
                self.ChatboxJS = js
            else 
                print("Failed to load chatbox JS: error" .. code)
                print(js)
            end
        end,
        failed = function(err)
            print("Failed to load chatbox JS: " .. err)
        end
    })
end

function PANEL:LoadChatbox()
    hook.Add("Think", self, function()
        if (not self.ChatboxHTML or not self.ChatboxJS) then return end
    
        if (self.Chatbox) then self.Chatbox:Remove() end

        local chatbox = self.ChatboxContainer:Add("DHTML")
        self.Chatbox = chatbox
        chatbox:Dock(FILL)
        chatbox:AddFunction("crashmenu", "chatTick", function() if self.ShowPanel == 1 then chat.PlaySound() end end)
        chatbox:AddFunction("crashmenu", "getData", function()         
            local host = ("wss://%s/room/%s"):format(crashmenu.Host, crashmenu.Config.ChatRoomID)
            local steamId = LocalPlayer():SteamID64()
            return host, steamId 
        end)
        chatbox:SetHTML(self.ChatboxHTML)
        chatbox:RunJavascript([[
            window._WebSocket = WebSocket;
        ]])
        
        -- hook.Add("Think", chatbox, function()
        --     if (not IsValid(chatbox)) then hook.Remove("Think", chatbox) end
        --     if (not chatbox:IsLoading()) then
        --         timer.Simple(0, function() 
        chatbox:AddFunction("crashmenu", "ready", function()                                                 
            chatbox:RunJavascript(self.ChatboxJS)
        end)
        chatbox:RunJavascript([[           
            // This is copium for if Awesomium was even going to work with WebSockets in the first place
            const fn = function(host, steamId) {
                window._host = host;
                window._steamId = steamId;
                
                crashmenu.ready();
            };
            const data = crashmenu.getData(fn);
            if (data) {
                const host = data.host
                const steamId = data.steamId;
                
                fn(host, steamId);
            };
        ]])
        --         end)
        --         hook.Remove("Think", chatbox)
        --     end
        -- end)
        
        hook.Remove("Think", self)
    end)
end

function PANEL:Show()
    if self.ShowPanel ~= 1 then
        if crashmenu.Config.CrashSound then surface.PlaySound(crashmenu.Config.CrashSound) end
        self.CrashTime = RealTime()
        self.Reconnecting = false
        self.NextTry = RealTime() + 10
        self.ShowPanel = 1
        self:LoadChatbox()
    end
    self:SetVisible(true)
end

function PANEL:Hide()    
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
    if self.ShowPanel ~= 0 then
        surface.PlaySound("plats/hall_elev_door.wav")
        self.ShowPanel = 0
        self.ShowInfoAnim = 0
        self.ShowPanelAnim = 0
        self.AutoDisabled = false
    end
end

surface.CreateFont("crashmenu_1", {
    font = crashmenu.Config.BigFont or "Roboto Bk",
    size = ScreenScale(24),
})
surface.CreateFont("crashmenu_2", {
    font = crashmenu.Config.Font or "Roboto",
    size = ScreenScale(8),
})
function PANEL:Paint(w, h)
    local col1 = crashmenu.Config.Color1

    if crashmenu.Config.Gradient then
        surface.SetDrawColor(0, 0, 0, 192)
    else
        surface.SetDrawColor(col1)
    end
    surface.DrawRect(0, 0, w, h)

    if crashmenu.Config.Gradient then
        surface.SetDrawColor(col1)
        surface.SetMaterial(gradientD)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    if crashmenu.Config.Gradient then
        surface.SetDrawColor(col1.r + 32, col1.g + 32, col1.b + 32, col1.a * 0.5)
    else
        surface.SetDrawColor(255, 255, 255, 31)
    end
    surface.DrawRect(math.floor(2 + w * 0.5 - w * (0.5 * self.ShowPanelAnim)), 0, 2, h)
    surface.DrawRect(math.ceil(w * 0.5 + w * (0.5 * self.ShowPanelAnim) - 4), 0, 2, h)

    surface.SetFont("crashmenu_1")

    local txt = crashmenu.Config.Title or "Uh oh, looks like the server gave up..?"
    local txtW, txtH = surface.GetTextSize(txt)
    local txtX, txtY = w * 0.5 - txtW * 0.5, h * 0.33 - (txtH * 0.66) * self.ShowInfoAnim
    local matrix = Matrix()
    matrix:Translate(Vector(self:GetPos()))
    matrix:Translate(Vector(txtX, txtY))
    matrix:Translate(Vector(txtW, txtH) * 0.5)
    matrix:Scale(Vector(1, 1) * self.ShowPanelAnim)
    matrix:Rotate(Angle(0, (math.sin(RealTime() * 0.5) * 27.5) * (1.125 - self.ShowPanelAnim), 0))
    matrix:Translate(-Vector(txtW, txtH) * 0.5)
    matrix:Translate(-Vector(self:GetPos()))
    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        cam.PushModelMatrix(matrix)
            if crashmenu.Config.FontShadows then
                surface.SetTextColor(0, 0, 0, 127)
                surface.SetTextPos(4, 4)
                surface.DrawText(txt)
            end

            surface.SetTextColor(255, 255, 255)
            surface.SetTextPos(0, 0)
            surface.DrawText(txt)
        cam.PopModelMatrix()
    render.PopFilterMag()
    render.PopFilterMin()

    surface.SetFont("crashmenu_2")

    local txt = crashmenu.Config.SubTitle
    surface.SetAlphaMultiplier(self.ShowInfoAnim)
    if crashmenu.Config.FontShadows then
        draw.DrawText(txt, "crashmenu_2", w * 0.5 + 2, h * 0.33 + (txtH * 0.66) * self.ShowInfoAnim + 2, Color(0, 0, 0, 127), TEXT_ALIGN_CENTER)
    end
    draw.DrawText(txt, "crashmenu_2", w * 0.5, h * 0.33 + (txtH * 0.66) * self.ShowInfoAnim, Color(192, 192, 192), TEXT_ALIGN_CENTER)
    surface.SetAlphaMultiplier(1)

    for _, child in pairs(self:GetChildren()) do
        child:SetAlpha(255 * self.ShowPanelAnim)
    end
end

vgui.Register("ReconnectPanel", PANEL, "EditablePanel")

if IsValid(crashmenu.Panel) then crashmenu.Panel:Remove() end
