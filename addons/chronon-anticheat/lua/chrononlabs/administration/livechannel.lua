local self 		= {}
local pairs 	= pairs
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local isnumber	= isnumber
local print 	= print
local hook 		= hook
local timer 	= timer
local util 		= util
local file 		= file

function self:InternalId ()
    return "ChrononLabs:Administration"
end

function self:PreConstructor ()
    self.BanStorage = {}
    self.DataPath   = ChrononLabs ["ChrononLabs:ProgramLogs"].DataPathSubI .. "/bans.json"
    self.DataFile   = self.DataPath
end

function self:LoadBans ()
    local content = file.Read (self.DataFile, "DATA")
    
    if not content then
        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("WARNING: Failed to read ban database!")
        return
    end
    
    local success, data = pcall (util.JSONToTable, content)
    if not success or not data then
        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("WARNING: Failed to parse ban database!")
        return
    end
    
    self.BanStorage = data
end

function self:SaveBans ()
    if not self.BanStorage then return end
    
    local success, jsonData = pcall (util.TableToJSON, self.BanStorage, true)
    if not success then
        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("WARNING: Failed to serialize ban database!")
        return
    end
    
    local written = file.Write (self.DataFile, jsonData)
    if not file.Exists (self.DataFile, "DATA") then
        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("WARNING: Failed to write ban database!")
    end
end

function self:FormatTimeRemaining (duration)
    if not isnumber (duration) then
        return "∞"
    end

    local timeLeft = duration - os.time ()
    
    if timeLeft <= 0 then 
        return "Expired"
    end

    local days 		= math.floor (timeLeft / 86400)
    local hours 	= math.floor ((timeLeft % 86400) / 3600)
    local minutes 	= math.floor ((timeLeft % 3600) / 60)
    local seconds 	= timeLeft % 60

    local parts = {}
    
    if days > 0 then 
        table.insert (parts, days .. "d") 
    end
    if hours > 0 then 
        table.insert (parts, hours .. "h") 
    end
    if minutes > 0 then 
        table.insert (parts, minutes .. "m") 
    end
    if seconds > 0 then 
        table.insert (parts, seconds .. "s") 
    end

    return table.concat (parts, " ")
end


function self:Constructor ()
    local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]
    
    if not self.DataPath then
        self:PreConstructor ()
    end
    
    if not file.Exists (self.DataFile, "DATA") then
        file.Write (self.DataFile, "{}")
        SystemInformation:MiniLogger ("Created ban database at: " .. self.DataFile)
        
        if not file.Exists (self.DataFile, "DATA") then
            SystemInformation:MiniLogger ("WARNING: Failed to create ban database!")
        end
    end
    
    self.BanPlayer = function (target, duration, reason, admin)
        local banData = {
            name 		= type (target) == "Player" and target:Nick () or "Unknown",
            steamid 	= type (target) == "Player" and target:SteamID () or target,
            reason 		= reason or "No reason specified",
            admin 		= type (admin) == "Player" and admin:SteamID () or admin or "Console",
            admin_name 	= type (admin) == "Player" and admin:Nick () or "Console",
            timestamp 	= os.time (),
            duration 	= duration == 0 and "∞" or (os.time () + (duration * 60))
        }

        if type (target) == "Player" and IsValid (target) then
            target:Kick ("You have been banned: " .. banData.reason)
        end

        self.BanStorage [banData.steamid] = banData
        self:SaveBans ()

        SystemInformation:MiniLogger (string.format (
            "Ban issued: %s (%s) by %s for %s (%s)",
            banData.name,
            banData.steamid,
            banData.admin_name,
            self:FormatTimeRemaining (banData.duration),
            banData.reason
        ))

        for _, ply in ipairs (player.GetAll ()) do
            ply:ChatPrint (string.format (
                "[ChrononLabs] %s was banned by %s for %s (%s)",
                banData.name,
                banData.admin_name,
                self:FormatTimeRemaining (banData.duration),
                banData.reason
            ))
            ply:EmitSound ("ambient/energy/zap6.wav")
        end
    end

    self.UnbanPlayer = function (steamid, reason, admin)
        local banData = self.BanStorage [steamid]
        if not banData then
            return false, "Player is not banned"
        end

        local adminName = type (admin) == "Player" and admin:Nick () or "Console"
        self.BanStorage [steamid] = nil
        self:SaveBans ()

        SystemInformation:MiniLogger (string.format (
            "Unban issued: %s (%s) by %s (%s)",
            banData.name,
            steamid,
            adminName,
            reason or "No reason specified"
        ))

        for _, ply in ipairs (player.GetAll ()) do
            ply:ChatPrint (string.format (
                "[ChrononLabs] %s was unbanned by %s (%s)",
                banData.name,
                adminName,
                reason or "No reason specified"
            ))
            ply:EmitSound ("ambient/energy/zap6.wav")
        end

        return true
    end

    self.CheckBan = function (steamid)
        local banData = self.BanStorage [steamid]
        if not banData then 
            return false 
        end

        if banData.duration ~= "∞" and tonumber (banData.duration) < os.time () then
            self.UnbanPlayer (steamid, "Ban expired")
            return false
        end
        
        SystemInformation:MiniLogger ("Found active ban for: " .. steamid)

        return true, string.format (
            "You are banned from this server\nReason: %s\nTime Remaining: %s",
            banData.reason,
            self:FormatTimeRemaining (banData.duration)
        )
    end

    timer.Create ("ChrononLabs:BanCleanup", 300, 0, function ()
        for steamid, banData in pairs (self.BanStorage) do
            if banData.duration ~= "∞" and tonumber (banData.duration) < os.time () then
                self.UnbanPlayer (steamid, "Ban expired")
            end
        end
    end)

    self:LoadBans ()
    SystemInformation:MiniLogger ("Administration system initialized with " .. table.Count(self.BanStorage) .. " active bans")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())