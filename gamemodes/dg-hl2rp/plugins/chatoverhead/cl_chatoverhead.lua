CHATBUBBLE = CHATBUBBLE or {}

CHATBUBBLE.MaxLineLength = 60
CHATBUBBLE.DisplayTime = 4
CHATBUBBLE.FadeTime = 0.5
CHATBUBBLE.NormalColor = Color(200, 200, 255)
CHATBUBBLE.YellColor = Color(255, 100, 100)
CHATBUBBLE.WhisperColor = Color(150, 150, 200)
CHATBUBBLE.TextFont = "ChatBubbleFont"
CHATBUBBLE.YellFont = "ChatBubbleYellFont"
CHATBUBBLE.WhisperFont = "ChatBubbleWhisperFont"
CHATBUBBLE.TextSize = 24
CHATBUBBLE.YellTextSize = 36
CHATBUBBLE.WhisperTextSize = 18
CHATBUBBLE.LineSpacing = 30
CHATBUBBLE.WhisperLineSpacing = 22
CHATBUBBLE.WhisperRange = 200
CHATBUBBLE.MaxMessageLength = 50

if CLIENT then
    surface.CreateFont("ChatBubbleFont", {
        font = "Arial",
        size = CHATBUBBLE.TextSize,
        weight = 600,
        antialias = true,
    })

    surface.CreateFont("ChatBubbleYellFont", {
        font = "Arial",
        size = CHATBUBBLE.YellTextSize,
        weight = 800,
        antialias = true,
    })

    surface.CreateFont("ChatBubbleWhisperFont", {
        font = "Arial",
        size = CHATBUBBLE.WhisperTextSize,
        weight = 500,
        antialias = true,
        italic = true,
    })

    local bubbles = {}

    net.Receive("OverheadChatBubbleMessage", function()
        local ply = net.ReadEntity()
        local text = net.ReadString()
        local isYell = net.ReadBool()
        local isWhisper = net.ReadBool()

        if not IsValid(ply) then
            return
        end

        local lines = {}
        local currentLine = ""
        for word in string.gmatch(text, "%S+") do
            if #currentLine + #word + 1 > CHATBUBBLE.MaxLineLength then
                table.insert(lines, currentLine)
                currentLine = word
            else
                currentLine = currentLine .. (currentLine == "" and "" or " ") .. word
            end
        end
        if currentLine ~= "" then
            table.insert(lines, currentLine)
        end

        bubbles[ply] = {
            lines = lines,
            startTime = CurTime(),
            font = isWhisper and CHATBUBBLE.WhisperFont or (isYell and CHATBUBBLE.YellFont or CHATBUBBLE.TextFont),
            color = isWhisper and CHATBUBBLE.WhisperColor or (isYell and CHATBUBBLE.YellColor or CHATBUBBLE.NormalColor),
            isYell = isYell,
            isWhisper = isWhisper
        }
    end)

    hook.Add("PostDrawTranslucentRenderables", "UniqueMattChatBubbleRender", function()
        for ply, bubble in pairs(bubbles) do
            if not IsValid(ply) or CurTime() > bubble.startTime + CHATBUBBLE.DisplayTime + CHATBUBBLE.FadeTime then
                bubbles[ply] = nil
                continue
            end

            local pos = ply:GetPos() + Vector(0, 0, 80)
            local ang = LocalPlayer():EyeAngles()
            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)

            local alpha = 255
            local timeElapsed = CurTime() - bubble.startTime
            if timeElapsed < CHATBUBBLE.FadeTime then
                alpha = (timeElapsed / CHATBUBBLE.FadeTime) * 255
            elseif timeElapsed > CHATBUBBLE.DisplayTime then
                alpha = (1 - (timeElapsed - CHATBUBBLE.DisplayTime) / CHATBUBBLE.FadeTime) * 255
            end

            cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.15)
                local y = 0
                local lineSpacing = bubble.isWhisper and CHATBUBBLE.WhisperLineSpacing or CHATBUBBLE.LineSpacing
                for i, line in ipairs(bubble.lines) do
                    draw.SimpleText(line, bubble.font, 0, y, ColorAlpha(bubble.color, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    y = y + lineSpacing
                end
            cam.End3D2D()
        end
    end)
end