    local e2BlacklistCmd = {
        description = "Blacklist a player from using E2 (minutes). 0 = permanent.",
        requiresArg = true,
        adminOnly = true,
        onRun = function(ply, arg)
            if not ply:IsAdmin() then return ply:Notify("You cannot use this command.") end
            if not impulse.WireE2 or not impulse.WireE2.MemberBlacklistSet then
                return ply:Notify("WireE2 blacklist system not loaded (sv_net.lua).")
            end

            local searchKey = arg[1]
            local minutes   = tonumber(arg[2] or "")
            local reason    = arg[3] and table.concat(arg, " ", 3) or "Blacklisted from E2."

            if not searchKey or minutes == nil then
                return ply:Notify("Usage: /e2blacklist <player|steamid> <minutes> [reason]")
            end

            local targ = impulse.FindPlayer(searchKey)
            local sid32 = IsValid(targ) and targ:SteamID() or searchKey

            if not tostring(sid32):match("^STEAM_%d:%d:%d+$") then
                return ply:Notify("Target must be an online player or a valid SteamID (STEAM_0:1:xxxx).")
            end

            local untilTs = impulse.WireE2.MemberBlacklistSet(sid32, minutes, reason, ply:SteamName())

            ply:Notify("E2 blacklisted "..sid32.." for "..(untilTs == 0 and "PERMANENT" or (minutes.." minute(s)"))..".")

            if IsValid(targ) then
                targ:Notify("You have been blacklisted from using E2.\nReason: "..reason)
            end

            local embeds = {{

                title = "E2 Member Blacklisted",
                color = 15158332,
                fields = {
                    { name = "Admin",    value = ply:SteamName().." ("..ply:SteamID()..")" },
                    { name = "Target",   value = IsValid(targ) and (targ:Nick().." ("..sid32..")") or sid32 },
                    { name = "Duration", value = untilTs == 0 and "Permanent" or (minutes.." minutes") },
                    { name = "Reason",   value = reason }
                }
            }}
            ReqwestLog(embeds, DG_E2)
        end
    }
    impulse.RegisterChatCommand("/e2blacklist", e2BlacklistCmd)

    local e2UnBlacklistCmd = {
        description = "Remove an E2 blacklist from a player.",
        requiresArg = true,
        adminOnly = true,
        onRun = function(ply, arg)
            if not ply:IsAdmin() then return ply:Notify("You cannot use this command.") end
            if not impulse.WireE2 or not impulse.WireE2.MemberBlacklistRemove then
                return ply:Notify("WireE2 blacklist system not loaded (sv_net.lua).")
            end

            local searchKey = arg[1]
            if not searchKey then
                return ply:Notify("Usage: /e2unblacklist <player|steamid>")
            end

            local targ = impulse.FindPlayer(searchKey)
            local sid32 = IsValid(targ) and targ:SteamID() or searchKey

            if not tostring(sid32):match("^STEAM_%d:%d:%d+$") then
                return ply:Notify("Target must be an online player or a valid SteamID (STEAM_0:1:xxxx).")
            end

            impulse.WireE2.MemberBlacklistRemove(sid32)

            ply:Notify("E2 blacklist removed for "..sid32..".")

            if IsValid(targ) then
                targ:Notify("Your E2 blacklist has been removed.")
            end

            local embeds = {{
                title = "E2 Member Unblacklisted",
                color = 3066993,
                fields = {
                    { name = "Admin",  value = ply:SteamName().." ("..ply:SteamID()..")" },
                    { name = "Target", value = IsValid(targ) and (targ:Nick().." ("..sid32..")") or sid32 }
                }
            }}
            ReqwestLog(embeds, DG_E2)
        end
    }
    impulse.RegisterChatCommand("/e2unblacklist", e2UnBlacklistCmd)
