local timeCut = 604800

local function pruneOldLogs(logs)
    local cutoff = os.time() - timeCut
    for i = #logs, 1, -1 do
        if logs[i].time < cutoff then
            table.remove(logs, i)
        end
    end
end

local function updateDataByName(groupName, logInfo)
    local grp = impulse.Group.Groups[groupName]
    if not grp then return end

    grp.Data       = grp.Data or {}
    grp.Data.logs  = grp.Data.logs or {}

    table.insert(grp.Data.logs, 1, {
        time        = os.time(),
        type        = logInfo.type,
        amount      = logInfo.amount,
        description = logInfo.description or "",
        player      = logInfo.player
    })

    pruneOldLogs(grp.Data.logs)

    impulse.Group.DBUpdateData(grp.ID, grp.Data)
end

function LogDeposit(groupName, ply, amount, description)
	updateDataByName(groupName, {
		type        = "deposit",
		amount      = amount,
		description = description or "Deposit performed",
		player      = ply:Nick() .. " (" .. ply:SteamID() .. ")"
	})
end

function LogWithdrawal(groupName, ply, amount, description)
	updateDataByName(groupName, {
		type        = "withdrawal",
		amount      = amount,
		description = description or "Withdrawal performed",
		player      = ply:Nick() .. " (" .. ply:SteamID() .. ")"
	})
end

function GetLogs(groupName, limit, descFilter)
    limit = limit or 100

    local grp = impulse.Group.Groups[groupName]
    if not grp then return {} end

    grp.Data = grp.Data or {}
    grp.Data.logs = grp.Data.logs or {}

    pruneOldLogs(grp.Data.logs)

    local out = {}

    for _, log in ipairs(grp.Data.logs) do
        if #out >= limit then break end

        if not descFilter or tostring(log.description or ""):find(descFilter, 1, true) then
            out[#out + 1] = {
                time = tonumber(log.time) or os.time(),
                type = tostring(log.type or ""),
                amount = tonumber(log.amount) or 0,
                description = string.sub(tostring(log.description or ""), 1, 160),
                player = string.sub(tostring(log.player or ""), 1, 80)
            }
        end
    end

    return out
end

function ClearLogs(groupName)
    local grp = impulse.Group.Groups[groupName]
    if not grp then return end

    grp.Data          = grp.Data or {}
    grp.Data.logs     = {}
    impulse.Group.DBUpdateData(grp.ID, grp.Data)
end
