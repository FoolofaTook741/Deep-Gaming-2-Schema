
hook.Add("PlayerUse", "DeepUseHooks", function(ply, ent)
    if IsValid(ply) and IsValid(ent) then
        if ent:GetClass() == "deep_promotion_terminal" then
            if ply:IsCivilProtectionUnit() == true then
                net.Start("DeepTerminalLua")
                net.WriteString("CPWhitelistIncrease()")
                net.SendToServer()
            elseif ply:IsOverwatchUnit() == true then
                net.Start("DeepTerminalLua")
                net.WriteString("OTAWhitelistIncrease()")
                net.SendToServer()
            end
        end
    end
    if IsValid(ply) and IsValid(ent) then
        if ent:GetClass() == "deep_ration_station" then
            if ply:IsCivilProtectionUnit() == true then
                net.Start("DeepRationReward")
                net.WriteString("250")
                net.WriteEnt(ent)
                net.SendToServer()
            elseif ply:Alive() and ply:XP() > 125000 then
                net.Start("DeepRationReward")
                net.WriteString("450")
                net.WriteEnt(ent)
                net.SendToServer()
            end
        end
    end
end)

net.Receive("DGRecentDCs", function()
    local recents = net.ReadTable()
    if LocalPlayer():IsAdmin() then
        for k,v in pairs(recents) do
            chat.AddText(recents[k])
        end
    end
end)

hook.Add("HUDPaint", "StalkerPaint", function()
    if LocalPlayer():Team() == TEAM_STALKER and timer.Exists(LocalPlayer():SteamID().."stalkerization") then 
        local tl = math.floor(timer.TimeLeft(LocalPlayer():SteamID().."stalkerization")) or 0
        surface.SetTextPos(ScrH() - 60, ScrW() - 60)
        surface.SetTextColor()
        surface.SetFont("Horizons32")
        surface.DrawText("Execution In: " .. tl .. " seconds.")
    end
end)

net.Receive("DeepPlaySound", function()
    local sound = net.ReadString()
    local delay = net.ReadUInt(10)
    if delay > 0 then
        timer.Simple(delay, function()
            surface.PlaySound(sound)    
        end)
    else
        surface.PlaySound(sound)    
    end
end)

net.Receive("dgSendRecord", function()
    local warnCount = net.ReadUInt(16)
    local warns = {}
    for i = 1, warnCount do
        warns[i] = {
            id = net.ReadUInt(32),
            reason = net.ReadString(),
            created_at = net.ReadUInt(32),
            active = net.ReadBool()
        }
    end

    local banCount = net.ReadUInt(16)
    local bans = {}
    for i = 1, banCount do
        bans[i] = {
            id = net.ReadUInt(32),
            reason = net.ReadString(),
            created_at = net.ReadUInt(32),
            active = net.ReadBool()
        }
    end

    chat.AddText(Color(238, 210, 2), "--- Your Standing ---")

    if #warns == 0 then
        chat.AddText(color_white, "No warnings on record.")
    else
        for _, w in ipairs(warns) do
            chat.AddText(color_white, "[Warn #"..w.id.."] ("..(w.active and "ACTIVE" or "expired/removed")..") "..w.reason)
        end
    end

    if #bans == 0 then
        chat.AddText(color_white, "No bans on record.")
    else
        for _, b in ipairs(bans) do
            chat.AddText(color_white, "[Ban #"..b.id.."] ("..(b.active and "ACTIVE" or "expired/removed")..") "..b.reason)
        end
    end
end)