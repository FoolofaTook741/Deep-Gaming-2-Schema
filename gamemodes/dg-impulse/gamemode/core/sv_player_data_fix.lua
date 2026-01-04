--[[
local CHECK_INTERVAL = 5 
local LOG_FILE = "player_data_issues.txt" 
local CORRUPTED_FACTION = TEAM_CITIZEN 
local KICK_REASON = "Data corruption detected. Please reconnect. Contact staff if this persists."


local function LogIssue(message)
    local logMessage = string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), message)
    file.Append(LOG_FILE, logMessage)
    print("[datafix] " .. message)
end

local function IsPlayerCorrupted(ply)
    if not IsValid(ply) then return false end
    if ply:Team() == CORRUPTED_FACTION and not ply.impulseID then
        return true
    end
    return false
end

local function HandleCorruptedPlayer(ply)
    if not IsValid(ply) then return end
    local steamID = ply:SteamID64() or "Unknown"
    LogIssue(string.format("Corrupted player detected: %s (%s)", ply:Nick(), steamID))
    
    ply:Notify("[Server] Your data appears corrupted. You will be kicked to prevent issues...")
    timer.Simple(1, function()
        if IsValid(ply) then
            ply:Kick(KICK_REASON)
        end
    end)
end

hook.Add("Think", "CheckCorruptedPlayers", function()
    if not timer.Exists("CorruptedPlayerCheck") then
        timer.Create("CorruptedPlayerCheck", CHECK_INTERVAL, 1, function()
            for _, ply in ipairs(player.GetAll()) do
                if IsPlayerCorrupted(ply) then
                    HandleCorruptedPlayer(ply)
                end
            end
        end)
    end
end)

hook.Add("PlayerInitialSpawn", "BlockDataFetchOnCorruption", function(ply)
    for _, otherPly in ipairs(player.GetAll()) do
        if otherPly ~= ply and IsPlayerCorrupted(otherPly) then
            LogIssue(string.format("Blocking data fetch for %s due to corrupted player", ply:Nick()))
            ply:Notify("[Server] Waiting for corrupted player data to resolve. Please wait...")
            timer.Simple(10, function()
                if IsValid(ply) then
                    ply:Notify("[Server] Retrying data fetch...")
                    -- Re-run the database query from PlayerInitialSpawn
                    local query = mysql:Select("impulse_players")
                    query:Select("id")
                    query:Select("rpname")
                    query:Select("group")
                    query:Select("rpgroup")
                    query:Select("rpgrouprank")
                    query:Select("xp")
                    query:Select("money")
                    query:Select("bankmoney")
                    query:Select("model")
                    query:Select("skin")
                    query:Select("data")
                    query:Select("skills")
                    query:Select("ammo")
                    query:Select("firstjoin")
                    query:Select("languages")
                    query:Select("sterilizedcredits")
                    query:Where("steamid", ply:SteamID())
                    query:Callback(function(result)
                        if IsValid(ply) and type(result) == "table" and #result > 0 then
                            impulse.SetupPlayer(ply, result[1])
                        elseif IsValid(ply) then
                            ply:Freeze(true)
                        end
                    end)
                    query:Execute()
                end
            end)
            return
        end
    end
end)

hook.Add("PlayerLoadDataFailed", "LogDataFailure", function(ply, errorMsg)
    local steamID = ply:SteamID64() or "Unknown"
    LogIssue(string.format("Data load failed for %s (%s): %s", ply:Nick(), steamID, tostring(errorMsg)))
end)
--]]