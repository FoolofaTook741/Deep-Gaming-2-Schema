DG = DG or {}
DG.Warns = DG.Warns or {}
DG.Bans = DG.Bans or {}
DG.Records = DG.Records or {}
DG.BanCache = DG.BanCache or {}

local PENDING_ACTIONS_POLL_INTERVAL = 4
local ONLINE_PLAYERS_RESYNC_INTERVAL = 180

util.AddNetworkString("dgRequestRecord")
util.AddNetworkString("dgSendRecord")
util.AddNetworkString("dgBroadcastAction")

local function ValidString(s, maxLen)
    return type(s) == "string" and #s > 0 and #s <= (maxLen or 64)
end
local function ValidSteamID(sid)
    return type(sid) == "string" and sid:match("^STEAM_%d:%d:%d+$") ~= nil
end
local function DBBool(v)
    if v == true then return true end
    if v == false or v == nil then return false end
    return tonumber(v) == 1
end

function DG.FormatBanMessage(reason, expiresAt, moderatorName, moderatorSteamid)
    local lines = { "You have been banned from the server." }

    if ValidString(reason) then
        table.insert(lines, "Reason: "..reason)
    end

    if ValidString(moderatorName) and ValidString(moderatorSteamid) then
        table.insert(lines, "Banned by: "..moderatorName.." ("..moderatorSteamid..")")
    end

    local expiry = tonumber(expiresAt)
    if expiry and expiry > 0 then
        table.insert(lines, "Unban date: "..os.date("%Y-%m-%d %H:%M:%S", expiry))
    else
        table.insert(lines, "This ban is permanent.")
    end

    return table.concat(lines, "\n")
end

function DG.FormatTarget(steamid, targ)
    if IsValid(targ) then
        return "**"..targ:SteamName().."** ("..steamid..") ("..targ:Nick()..")"
    end
    return steamid
end

function DG.DisplayName(steamid, targ)
    if IsValid(targ) then
        return targ:SteamName()
    end
    return steamid
end

function DG.BroadcastWarn(targetName, adminName, reason)
    net.Start("dgBroadcastAction")
        net.WriteUInt(1, 4)
        net.WriteString(targetName)
        net.WriteString(adminName)
        net.WriteString(reason)
    net.Broadcast()
end

function DG.BroadcastBan(targetName, adminName, lengthText, reason)
    net.Start("dgBroadcastAction")
        net.WriteUInt(2, 4)
        net.WriteString(targetName)
        net.WriteString(adminName)
        net.WriteString(lengthText)
        net.WriteString(reason)
    net.Broadcast()
end

function DG.IsBanEnforced(b)
    if not DBBool(b.active) then return false end
    local expiry = tonumber(b.expires_at)
    return (not expiry or expiry == 0 or expiry > os.time())
end

function DG.BanStatusLabel(b)
    if not DBBool(b.active) then return "removed" end
    if DG.IsBanEnforced(b) then return "ACTIVE" end
    return "expired"
end

function DG.WarnStatusLabel(w)
    if not DBBool(w.active) then return "removed" end
    return "ACTIVE"
end

function DG.LogEmbed(title, color, fields, webhook)
    local embeds = {{
        title = title,
        description = title,
        url = "https://pinnacle-gaming.xyz/bans",
        color = color,
        fields = fields
    }}
    ReqwestLog(embeds, webhook or DG_OPS)
end

local function loadBanCache()
    local query = mysql:Select("impulse_bans")
    query:Select("id")
    query:Select("steamid")
    query:Select("admin_steamid")
    query:Select("admin_steamname")
    query:Select("reason")
    query:Select("expires_at")
    query:Select("active")
    query:Where("active", 1)
    query:Callback(function(result, ok, err)
        if not ok then
            print("[DG] Ban cache load failed: "..tostring(err))
            return
        end
        DG.BanCache = {}
        for _, b in ipairs(result or {}) do
            if b.expires_at and DG.IsBanEnforced(b) then
                DG.BanCache[b.steamid] = b
            end
        end
    end)
    query:Execute()
end
hook.Add("DatabaseConnected", "DG.LoadBanCache", loadBanCache)

timer.Create("DG.BanCacheSweep", 300, 0, function()
    for steamid, b in pairs(DG.BanCache) do
        if not DG.IsBanEnforced(b) then
            DG.BanCache[steamid] = nil
        end
    end
end)

hook.Add("CheckPassword", "DG.CheckBan", function(steamID64, ipAddress, svPassword, clPassword, name)
    local steamid = util.SteamIDFrom64(steamID64)
    local ban = DG.BanCache[steamid]
    if ban then
        if DG.IsBanEnforced(ban) then
            return false, DG.FormatBanMessage(ban.reason, ban.expires_at, ban.admin_steamname, ban.admin_steamid)
        else
            DG.BanCache[steamid] = nil
        end
    end
end)

local function loadPlayerRecord(ply)
    local steamid = ply:SteamID()
    ply.dgRecord = { warns = {}, bans = {} }

    local warnQuery = mysql:Select("impulse_warns")
    warnQuery:Select("id")
    warnQuery:Select("steamid")
    warnQuery:Select("admin_steamid")
    warnQuery:Select("admin_steamname")
    warnQuery:Select("reason")
    warnQuery:Select("created_at")
    warnQuery:Select("active")
    warnQuery:Select("source")
    warnQuery:Where("steamid", steamid)
    warnQuery:Callback(function(result, ok, err)
        if not IsValid(ply) then return end
        if not ok then
            print("[DG] Warn lookup failed for "..steamid..": "..tostring(err))
            return
        end
        ply.dgRecord.warns = result or {}
        DG.Records:PushCounts(ply)
    end)
    warnQuery:Execute()

    local banQuery = mysql:Select("impulse_bans")
    banQuery:Select("id")
    banQuery:Select("steamid")
    banQuery:Select("admin_steamid")
    banQuery:Select("admin_steamname")
    banQuery:Select("reason")
    banQuery:Select("length_minutes")
    banQuery:Select("created_at")
    banQuery:Select("expires_at")
    banQuery:Select("active")
    banQuery:Select("source")
    banQuery:Where("steamid", steamid)
    banQuery:Callback(function(result, ok, err)
        if not IsValid(ply) then return end
        if not ok then
            print("[DG] Ban lookup failed for "..steamid..": "..tostring(err))
            return
        end
        ply.dgRecord.bans = result or {}
        DG.Records:PushCounts(ply)

        for _, b in ipairs(ply.dgRecord.bans) do
            if DG.IsBanEnforced(b) then
                local expiry = tonumber(b.expires_at)
                local kickMsg = DG.FormatBanMessage(b.reason, expiry, b.admin_steamname, b.admin_steamid)
                timer.Simple(0, function()
                    if IsValid(ply) then
                        ply:Kick(kickMsg)
                    end
                end)
                break
            end
        end
    end)
    banQuery:Execute()
end
hook.Add("PlayerInitialSpawn", "DG.LoadRecord", loadPlayerRecord)

function DG.Records:PushCounts(ply)
    if not IsValid(ply) or not ply.dgRecord then return end

    local activeWarns, activeBans = 0, 0
    for _, w in ipairs(ply.dgRecord.warns) do
        if DBBool(w.active) then activeWarns = activeWarns + 1 end
    end
    for _, b in ipairs(ply.dgRecord.bans) do
        if DG.IsBanEnforced(b) then activeBans = activeBans + 1 end
    end

    net.Start("opsGetRecord")
        net.WriteUInt(math.min(activeWarns, 255), 8)
        net.WriteUInt(math.min(activeBans, 255), 8)
    net.Send(ply)
end

function DG.Warns:Create(steamid, adminSteamid, adminName, reason, source, onComplete)
    onComplete = onComplete or function() end

    if not ValidSteamID(steamid) then return onComplete(false, "Invalid target SteamID.") end

    reason = ValidString(reason) and reason or "No reason provided."

    local warn = {
        steamid = steamid,
        admin_steamid = adminSteamid,
        admin_steamname = adminName,
        reason = reason,
        created_at = os.time(),
        active = 1,
        source = source or "ingame"
    }

    local query = mysql:Insert("impulse_warns")
    for k, v in pairs(warn) do
        query:Insert(k, v)
    end
    query:Callback(function(result, status, lastID)
        if not status then
            print("[DG] Warn insert FAILED for "..steamid)
            return onComplete(false, "Database insert failed.")
        end
        warn.id = lastID

        local targ = player.GetBySteamID(steamid)
        if IsValid(targ) then
            targ.dgRecord = targ.dgRecord or { warns = {}, bans = {} }
            table.insert(targ.dgRecord.warns, warn)

            net.Start("opsGiveWarn")
                net.WriteString(reason)
            net.Send(targ)

            DG.Records:PushCounts(targ)
        end

        DG.LogEmbed("Warn Issued", 16776960, {
            { name = "Warned User:", value = DG.FormatTarget(steamid, targ) },
            { name = "Warning Moderator:", value = adminName.." ("..adminSteamid..")" },
            { name = "Reason:", value = reason },
            { name = "Warn ID:", value = tostring(lastID) }
        }, DG_WARNS)

        DG.BroadcastWarn(DG.DisplayName(steamid, targ), adminName, reason)

        onComplete(true, "Warn #"..lastID.." issued.")
    end)
    query:Execute()
end

function DG.Warns:Remove(steamid, warnID, removedBySteamid, onComplete)
    onComplete = onComplete or function() end

    if not ValidSteamID(steamid) then return onComplete(false, "Invalid target SteamID.") end

    local query = mysql:Update("impulse_warns")
    query:Update("active", 0)
    query:Update("removed_by", removedBySteamid)
    query:Update("removed_at", os.time())
    query:Where("id", warnID)
    query:Execute()

    local targ = player.GetBySteamID(steamid)
    if IsValid(targ) and targ.dgRecord then
        for _, w in ipairs(targ.dgRecord.warns) do
            if tostring(w.id) == tostring(warnID) then
                w.active = 0
                break
            end
        end
        DG.Records:PushCounts(targ)
    end

    DG.LogEmbed("Warn Removed", 3066993, {
        { name = "Target:", value = steamid },
        { name = "Removed By:", value = removedBySteamid },
        { name = "Warn ID:", value = tostring(warnID) }
    }, DG_WARNS)

    onComplete(true, "Warn #"..tostring(warnID).." removed.")
end

function DG.Bans:Create(steamid, adminSteamid, adminName, minutes, reason, source, onComplete)
    onComplete = onComplete or function() end

    if not ValidSteamID(steamid) then return onComplete(false, "Invalid target SteamID.") end

    reason = ValidString(reason) and reason or "No reason provided."

    local ban = {
        steamid = steamid,
        admin_steamid = adminSteamid,
        admin_steamname = adminName,
        reason = reason,
        length_minutes = minutes,
        created_at = os.time(),
        expires_at = (minutes > 0) and (os.time() + minutes * 60) or nil,
        active = 1,
        source = source or "ingame"
    }

    local query = mysql:Insert("impulse_bans")
    for k, v in pairs(ban) do
        query:Insert(k, v)
    end
    query:Callback(function(result, status, lastID)
        if not status then
            print("[DG] Ban insert FAILED for "..steamid)
            return onComplete(false, "Database insert failed.")
        end
        ban.id = lastID

        if ban.expires_at and DG.IsBanEnforced(ban) then
            DG.BanCache[steamid] = ban
        end

        local targ = player.GetBySteamID(steamid)
        if IsValid(targ) then
            targ:Kick(DG.FormatBanMessage(reason, ban.expires_at, adminName, adminSteamid))
        end

        DG.LogEmbed("Ban Issued", 15548997, {
            { name = "Banned User:", value = DG.FormatTarget(steamid, targ) },
            { name = "Banning Moderator:", value = adminName.." ("..adminSteamid..")" },
            { name = "Reason:", value = reason },
            { name = "Length:", value = (minutes > 0) and (minutes.." Minutes") or "Permanent" },
            { name = "Ban ID:", value = tostring(lastID) }
        }, DG_BANS)

        DG.BroadcastBan(DG.DisplayName(steamid, targ), adminName, (minutes > 0) and (minutes.." Minutes") or "Permanent", reason)

        onComplete(true, "Ban #"..lastID.." issued.")
    end)
    query:Execute()
end

function DG.Bans:Remove(steamid, banID, removedBySteamid)
    if not ValidSteamID(steamid) then return end

    local query = mysql:Update("impulse_bans")
    query:Update("active", 0)
    query:Update("removed_by", removedBySteamid)
    query:Update("removed_at", os.time())
    query:Where("id", banID)
    query:Execute()

    DG.BanCache[steamid] = nil

    DG.LogEmbed("Ban Removed", 3066993, {
        { name = "SteamID:", value = steamid },
        { name = "Removed By:", value = removedBySteamid },
        { name = "Ban ID:", value = tostring(banID) }
    }, DG_BANS)
end

function DG.Bans:RemoveActive(steamid, removedBySteamid, onComplete)
    onComplete = onComplete or function() end

    if not ValidSteamID(steamid) then return onComplete(false, "Invalid target SteamID.") end

    local query = mysql:Update("impulse_bans")
    query:Update("active", 0)
    query:Update("removed_by", removedBySteamid)
    query:Update("removed_at", os.time())
    query:Where("steamid", steamid)
    query:Where("active", 1)
    query:Execute()

    DG.BanCache[steamid] = nil

    DG.LogEmbed("Ban(s) Removed", 3066993, {
        { name = "SteamID:", value = steamid },
        { name = "Removed By:", value = removedBySteamid }
    }, DG_BANS)

    onComplete(true, "Active ban(s) cleared.")
end

function DG.Bans:CheckActive(steamid, callback)
    local query = mysql:Select("impulse_bans")
    query:Select("id")
    query:Select("reason")
    query:Select("expires_at")
    query:Select("active")
    query:Where("steamid", steamid)
    query:Where("active", 1)
    query:Callback(function(result, ok, err)
        if not ok then
            callback(nil)
            return
        end
        callback(result and result[1] or nil)
    end)
    query:Execute()
end

function DG.SendRecordToPlayer(ply)
    if not ply.dgRecord then return end

    net.Start("dgSendRecord")
        net.WriteUInt(#ply.dgRecord.warns, 16)
        for _, w in ipairs(ply.dgRecord.warns) do
            net.WriteUInt(w.id or 0, 32)
            net.WriteString(w.reason or "")
            net.WriteUInt(w.created_at or 0, 32)
            net.WriteBool(DBBool(w.active))
        end

        net.WriteUInt(#ply.dgRecord.bans, 16)
        for _, b in ipairs(ply.dgRecord.bans) do
            net.WriteUInt(b.id or 0, 32)
            net.WriteString(b.reason or "")
            net.WriteUInt(b.created_at or 0, 32)
            net.WriteBool(DG.IsBanEnforced(b))
        end
    net.Send(ply)
end

net.Receive("dgRequestRecord", function(len, ply)
    DG.SendRecordToPlayer(ply)
end)

local function markActionDone(id, resultMessage)
    local q = mysql:Update("impulse_pendingactions")
    q:Update("status", "done")
    q:Update("result_message", resultMessage)
    q:Update("processed_at", os.time())
    q:Where("id", id)
    q:Execute()
end

local function markActionError(id, resultMessage)
    local q = mysql:Update("impulse_pendingactions")
    q:Update("status", "error")
    q:Update("result_message", resultMessage)
    q:Update("processed_at", os.time())
    q:Where("id", id)
    q:Execute()
end

local function executePendingAction(row)
    local payload = util.JSONToTable(row.payload) or {}

    local function finish(ok, message)
        if ok then
            markActionDone(row.id, message)
        else
            markActionError(row.id, message)
        end
    end

    if row.action_type == "ban" then
        DG.Bans:Create(payload.steamid, payload.admin_steamid, payload.admin_name, tonumber(payload.minutes) or 0, payload.reason, "discord", finish)
    elseif row.action_type == "unban" then
        DG.Bans:RemoveActive(payload.steamid, payload.admin_steamid or "DISCORD", finish)
    elseif row.action_type == "warn" then
        DG.Warns:Create(payload.steamid, payload.admin_steamid, payload.admin_name, payload.reason, "discord", finish)
    elseif row.action_type == "removewarn" then
        DG.Warns:Remove(payload.steamid, tonumber(payload.warn_id), payload.admin_steamid or "DISCORD", finish)
    elseif row.action_type == "syncgroup" then
        local steamid = tostring(payload.steamid or ""):Trim():upper()
        if not ValidSteamID(steamid) then return finish(false, "Invalid SteamID.") end
        if not isfunction(impulse.SyncGroupFromDatabase) then return finish(false, "Rank sync function is unavailable.") end
        impulse.SyncGroupFromDatabase(steamid)
        finish(true, "Group sync requested for "..steamid..".")
    else
        markActionError(row.id, "Unknown action type: "..tostring(row.action_type))
    end
end

local function processPendingActions()
    local query = mysql:Select("impulse_pendingactions")
    query:Select("id")
    query:Select("action_type")
    query:Select("payload")
    query:Where("status", "pending")
    query:Callback(function(result, ok, err)
        if not ok then
            print("[DG] Pending action poll failed: "..tostring(err))
            return
        end
        for _, row in ipairs(result or {}) do
            executePendingAction(row)
        end
    end)
    query:Execute()
end
timer.Create("DG.PendingActionsPoll", PENDING_ACTIONS_POLL_INTERVAL, 0, processPendingActions)

local function upsertOnlinePlayer(ply)
    local steamid = ply:SteamID()
    local del = mysql:Delete("impulse_onlineplayers")
    del:Where("steamid", steamid)
    del:Callback(function()
        local ins = mysql:Insert("impulse_onlineplayers")
        ins:Insert("steamid", steamid)
        ins:Insert("name", ply:Nick())
        ins:Insert("updated_at", os.time())
        ins:Execute()
    end)
    del:Execute()
end

hook.Add("DatabaseConnected", "DG.ClearOnlinePlayers", function()
    local del = mysql:Delete("impulse_onlineplayers")
    del:Execute()
end)

hook.Add("PlayerInitialSpawn", "DG.OnlinePlayersJoin", function(ply)
    upsertOnlinePlayer(ply)
end)

hook.Add("PlayerDisconnected", "DG.OnlinePlayersLeave", function(ply)
    local del = mysql:Delete("impulse_onlineplayers")
    del:Where("steamid", ply:SteamID())
    del:Execute()
end)

local function resyncOnlinePlayers()
    local del = mysql:Delete("impulse_onlineplayers")
    del:Callback(function()
        for _, p in ipairs(player.GetAll()) do
            upsertOnlinePlayer(p)
        end
    end)
    del:Execute()
end
timer.Create("DG.OnlinePlayersResync", ONLINE_PLAYERS_RESYNC_INTERVAL, 0, resyncOnlinePlayers)