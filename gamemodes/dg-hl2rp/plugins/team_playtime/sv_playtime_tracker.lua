impulse.PlaytimeTracker = impulse.PlaytimeTracker or {}

local trackerState = impulse.PlaytimeTracker

trackerState.tracking = trackerState.tracking or {}
trackerState.pendingTotals = trackerState.pendingTotals or {}
trackerState.pendingHistory = trackerState.pendingHistory or {}

if trackerState.totalsFlushInProgress == nil then
    trackerState.totalsFlushInProgress = false
end

if trackerState.historyFlushInProgress == nil then
    trackerState.historyFlushInProgress = false
end

trackerState.totalsFlushStartedAt = trackerState.totalsFlushStartedAt or 0
trackerState.historyFlushStartedAt = trackerState.historyFlushStartedAt or 0

local tracking = trackerState.tracking
local pendingTotals = trackerState.pendingTotals
local pendingHistory = trackerState.pendingHistory

local function validSteamID(steamID)
    return isstring(steamID) and steamID:match("^STEAM_%d:%d:%d+$") ~= nil
end

local function getPlayerID(ply)
    local playerID = tonumber(ply.impulseID)

    if not playerID or playerID <= 0 then
        return nil
    end

    return math.floor(playerID)
end

local function utcBucketStart(timestamp)
    local utc = os.date("!*t", timestamp)

    return string.format("%04d-%02d-%02d %02d:00:00", utc.year, utc.month, utc.day, utc.hour), utc
end

local function queueSpan(playerID, startedAt, endedAt)
    playerID = tonumber(playerID)
    startedAt = math.floor(tonumber(startedAt) or 0)
    endedAt = math.floor(tonumber(endedAt) or 0)

    if not playerID or playerID <= 0 then return end
    if startedAt <= 0 or endedAt <= startedAt then return end

    local totalSeconds = endedAt - startedAt

    pendingTotals[playerID] = (pendingTotals[playerID] or 0) + totalSeconds

    local cursor = startedAt

    while cursor < endedAt do
        local bucketStart, utc = utcBucketStart(cursor)
        local secondsIntoHour = (utc.min * 60) + utc.sec
        local secondsUntilNextHour = 3600 - secondsIntoHour
        local segmentSeconds = math.min(endedAt - cursor, secondsUntilNextHour)

        if segmentSeconds <= 0 then
            break
        end

        local key = tostring(playerID) .. "|" .. bucketStart
        local bucket = pendingHistory[key]

        if not bucket then
            bucket = {
                playerID = playerID,
                bucketStart = bucketStart,
                seconds = 0
            }

            pendingHistory[key] = bucket
        end

        bucket.seconds = bucket.seconds + segmentSeconds
        cursor = cursor + segmentSeconds
    end
end

local function startTrackingPlayer(ply, now)
    if not IsValid(ply) or ply:IsBot() then return false end

    local steamID = ply:SteamID()

    if not validSteamID(steamID) then return false end

    local playerID = getPlayerID(ply)

    if not playerID then return false end

    if tracking[steamID] then
        tracking[steamID].playerID = playerID
        return true
    end

    now = math.floor(tonumber(now) or os.time())

    tracking[steamID] = {
        playerID = playerID,
        lastRecordedAt = now
    }

    return true
end

local function capturePlayer(ply, now, removeAfter)
    if not IsValid(ply) or ply:IsBot() then return end

    local steamID = ply:SteamID()

    if not validSteamID(steamID) then return end

    now = math.floor(tonumber(now) or os.time())

    local state = tracking[steamID]

    if not state then
        if not removeAfter then
            startTrackingPlayer(ply, now)
        end

        return
    end

    local currentPlayerID = getPlayerID(ply)

    if currentPlayerID and currentPlayerID ~= state.playerID then
        state.playerID = currentPlayerID
        state.lastRecordedAt = now
    else
        queueSpan(state.playerID, state.lastRecordedAt, now)
        state.lastRecordedAt = now
    end

    if removeAfter then
        tracking[steamID] = nil
    end
end

local function subtractSuccessfulTotals(snapshot)
    for playerID, seconds in pairs(snapshot) do
        local current = pendingTotals[playerID] or 0
        local remaining = math.max(0, current - seconds)

        if remaining > 0 then
            pendingTotals[playerID] = remaining
        else
            pendingTotals[playerID] = nil
        end
    end
end

local function subtractSuccessfulHistory(snapshot)
    for key, sent in pairs(snapshot) do
        local current = pendingHistory[key]

        if current then
            local remaining = math.max(0, (current.seconds or 0) - sent.seconds)

            if remaining > 0 then
                current.seconds = remaining
            else
                pendingHistory[key] = nil
            end
        end
    end
end

local function recoverStaleFlushes()
    local now = os.time()

    if trackerState.totalsFlushInProgress and trackerState.totalsFlushStartedAt > 0 and now - trackerState.totalsFlushStartedAt > 180 then
        print("[DG Playtime] Totals flush appears stale; allowing retry.")
        trackerState.totalsFlushInProgress = false
        trackerState.totalsFlushStartedAt = 0
    end

    if trackerState.historyFlushInProgress and trackerState.historyFlushStartedAt > 0 and now - trackerState.historyFlushStartedAt > 180 then
        print("[DG Playtime] History flush appears stale; allowing retry.")
        trackerState.historyFlushInProgress = false
        trackerState.historyFlushStartedAt = 0
    end
end

local function flushTotals()
    recoverStaleFlushes()

    if trackerState.totalsFlushInProgress then return end

    local snapshot = {}
    local values = {}
    local now = os.time()

    for playerID, seconds in pairs(pendingTotals) do
        seconds = math.floor(tonumber(seconds) or 0)

        if seconds > 0 then
            snapshot[playerID] = seconds
            values[#values + 1] = string.format("(%d, %d, %d)", playerID, seconds, now)
        end
    end

    if #values == 0 then return end

    trackerState.totalsFlushInProgress = true
    trackerState.totalsFlushStartedAt = now

    local sql = [[
        INSERT INTO `impulse_playtime_totals`
            (`player_id`, `total_seconds`, `updated_at`)
        VALUES
    ]] .. table.concat(values, ",") .. [[
        ON DUPLICATE KEY UPDATE
            `total_seconds` = `total_seconds` + VALUES(`total_seconds`),
            `updated_at` = GREATEST(`updated_at`, VALUES(`updated_at`))
    ]]

    mysql:RawQuery(sql, function(result, status)
        trackerState.totalsFlushInProgress = false
        trackerState.totalsFlushStartedAt = 0

        if status ~= true then
            print("[DG Playtime] Totals batch failed: " .. tostring(result))
            return
        end

        subtractSuccessfulTotals(snapshot)
    end)
end

local function flushHistory()
    recoverStaleFlushes()

    if trackerState.historyFlushInProgress then return end

    local snapshot = {}
    local values = {}

    for key, bucket in pairs(pendingHistory) do
        local seconds = math.floor(tonumber(bucket.seconds) or 0)

        if seconds > 0 then
            snapshot[key] = {
                seconds = seconds
            }

            values[#values + 1] = string.format("(%d, '%s', %d)", bucket.playerID, bucket.bucketStart, seconds)
        end
    end

    if #values == 0 then return end

    trackerState.historyFlushInProgress = true
    trackerState.historyFlushStartedAt = os.time()

    local sql = [[
        INSERT INTO `impulse_playtime_hourly`
            (`player_id`, `bucket_start`, `seconds_played`)
        VALUES
    ]] .. table.concat(values, ",") .. [[
        ON DUPLICATE KEY UPDATE
            `seconds_played` = LEAST(3600, `seconds_played` + VALUES(`seconds_played`))
    ]]

    mysql:RawQuery(sql, function(result, status)
        trackerState.historyFlushInProgress = false
        trackerState.historyFlushStartedAt = 0

        if status ~= true then
            print("[DG Playtime] History batch failed: " .. tostring(result))
            return
        end

        subtractSuccessfulHistory(snapshot)
    end)
end

local function flushPending()
    flushHistory()
    flushTotals()
end

local function captureAllPlayers()
    local now = os.time()

    for _, ply in ipairs(player.GetHumans()) do
        if not IsValid(ply) then continue end

        local steamID = ply:SteamID()

        if not tracking[steamID] then
            startTrackingPlayer(ply, now)
        else
            capturePlayer(ply, now, false)
        end
    end
end

hook.Add("PostSetupPlayer", "DG.PlaytimeTrackingStart", function(ply)
    startTrackingPlayer(ply, os.time())
end)

hook.Add("PlayerDisconnected", "DG.PlaytimeTrackingDisconnect", function(ply)
    local steamID = ply:SteamID()
    local state = tracking[steamID]

    if not state then return end

    queueSpan(state.playerID, state.lastRecordedAt, os.time())

    tracking[steamID] = nil
end)

hook.Add("DatabaseConnected", "DG.PlaytimeTrackingDatabaseReady", function()
    local now = os.time()

    for _, ply in ipairs(player.GetHumans()) do
        startTrackingPlayer(ply, now)
    end

    flushPending()
end)

timer.Create("DG.PlaytimeTrackingFlush", 60, 0, function()
    captureAllPlayers()
    flushPending()
end)

hook.Add("OnReloaded", "DG.PlaytimeTrackingReloaded", function()
    local now = os.time()

    for _, ply in ipairs(player.GetHumans()) do
        local steamID = ply:SteamID()

        if not tracking[steamID] then
            startTrackingPlayer(ply, now)
        end
    end

    flushPending()
end)

hook.Add("ShutDown", "DG.PlaytimeTrackingShutdown", function()
    captureAllPlayers()
    flushPending()
end)