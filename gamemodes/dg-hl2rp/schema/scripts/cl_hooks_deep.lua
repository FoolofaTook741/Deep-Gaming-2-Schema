
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