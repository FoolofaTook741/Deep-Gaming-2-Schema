if SERVER then
    util.AddNetworkString("OverheadChatBubbleMessage") -- temp fallback
    hook.Add("PlayerSay", "ChatBubbleProcess", function(ply, text)
        if (CHAT_BANNED and CHAT_BANNED[ply:SteamID()]) or ply.KnockedOut then return end
        if impulse.Ops and impulse.Ops.AutoMod and impulse.Ops.AutoMod.FilterMessage(ply, text) then
            return
        end
        local textLower = string.lower(text)

        if textLower:sub(1,1) == "/" and textLower:sub(1,2) ~= "/y" and textLower:sub(1,2) ~= "/w" then
            return
        end

        
        if string.sub(textLower, 1, 1) == "/" and string.sub(textLower, 1, 2) ~= "/y" and string.sub(textLower, 1, 2) ~= "/w" then
            return
        end

        if string.sub(textLower, 1, 1) == "!" then
            return
        end

        local isYell = false
        local isWhisper = false
        if string.sub(textLower, 1, 2) == "/y" then
            text = string.Trim(string.sub(text, 3))
            isYell = true
        elseif string.sub(textLower, 1, 2) == "/w" then
            text = string.Trim(string.sub(text, 3))
            isWhisper = true
        else
            text = string.Trim(text)
        end

        if #text > 0 then
            text = string.upper(string.sub(text, 1, 1)) .. string.sub(text, 2)
            if not string.match(text, "[%.!?]$") then
                text = text .. "."
            end
        end

        local displayText = text
        if ply:IsCP() and ply:Team() ~= TEAM_CA then
            displayText = "<:: " .. displayText .. " ::>"
        end

        if #displayText > CHATBUBBLE.MaxMessageLength then
            displayText = string.sub(displayText, 1, CHATBUBBLE.MaxMessageLength - 3) .. "..."
        end

        net.Start("OverheadChatBubbleMessage")
        net.WriteEntity(ply)
        net.WriteString(displayText)
        net.WriteBool(isYell)
        net.WriteBool(isWhisper)
        
        local recipients = {ply}
        if isWhisper then
            for _, target in ipairs(player.GetAll()) do
                if target ~= ply and target:GetPos():Distance(ply:GetPos()) <= CHATBUBBLE.WhisperRange then
                    table.insert(recipients, target)
                end
            end
        else
            for _, target in ipairs(player.GetAll()) do
                if target ~= ply then
                    table.insert(recipients, target)
                end
            end
        end
        net.Send(recipients)
    end, 500)
end