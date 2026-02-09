local TRACKED_TEAMS = {
    [TEAM_CP] = "mpf",
    [TEAM_OTA] = "ota",
    [TEAM_CA]  = "ca"
}

local function setupDataTable(ply)
    ply.impulseData = ply.impulseData or {}
    ply.impulseData.job_time = ply.impulseData.job_time or {
        mpf = 0,
        ota = 0,
        ca  = 0
    }
end

local function startTracking(ply)
    if not IsValid(ply) then return end
    if ply._jobPlaytime then return end
    local key = TRACKED_TEAMS[ply:Team()]
    if not key then return end

    setupDataTable(ply)

    ply._jobPlaytime = {
        key = key,
        start = CurTime()
    }
end

local function stopTracking(ply)
    if not IsValid(ply) then return end
    if not ply._jobPlaytime then return end
    local elapsed = math.floor(CurTime() - ply._jobPlaytime.start)
    ply._jobPlaytime = nil

    if elapsed <= 0 then return end

    setupDataTable(ply)

    local key = TRACKED_TEAMS[ply:Team()] or ply._jobPlaytime.key
    local dataKey = key or ply._jobPlaytime.key

    ply.impulseData.job_time[dataKey] =
        (ply.impulseData.job_time[dataKey] or 0) + elapsed

    ply:SaveData()
end

hook.Add("OnPlayerChangedTeam", "Impulse.JobPlaytime.TeamChange", function(ply)
    stopTracking(ply)
    timer.Simple(0, function()
        if IsValid(ply) then
            startTracking(ply)
        end
    end)
end)


hook.Add("PostSetupPlayer", "Impulse.TeamPlaytime.TeamChange", function(ply)
    timer.Simple(0, function()
        if IsValid(ply) then
            startTracking(ply)
        end
    end)
end)

hook.Add("PlayerDeath", "Impulse.TeamPlaytime.Death", function(ply)
    stopTracking(ply)
end)

hook.Add("PlayerDisconnected", "Impulse.TeamPlaytime.Disconnect", function(ply)
    stopTracking(ply)
end)