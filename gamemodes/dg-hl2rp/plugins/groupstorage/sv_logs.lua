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
    local grp      = impulse.Group.Groups[groupName]
    local data     = (grp and grp.Data) or {}
    local logs     = data.logs or {}
    return logs
end

function ClearLogs(groupName)
    local grp = impulse.Group.Groups[groupName]
    if not grp then return end

    grp.Data          = grp.Data or {}
    grp.Data.logs     = {}
    impulse.Group.DBUpdateData(grp.ID, grp.Data)
end
