local self 	 = {}
local pairs	 = pairs
local ipairs = ipairs
local util   = util
local http   = http
local timer  = timer
local player = player

function self:InternalId ()
    return "ChrononLabs:BanLookup"
end

function self:Constructor ()
    local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]
    
    self.PendingChecks = {}
    
    self.BanCache = {}
    self.CacheTimeout = 300 -- 5 minutes cache timeout
    
	self.GetDynamicBanScannerInterval = function ()
		local playerCount = player.GetCount ()
		
		local minInterval = 5
		local maxInterval = 90
		local scaleFactor = 6
		
		-- Square root scaling
		local calculatedInterval = minInterval + scaleFactor * math.sqrt (math.max (playerCount - 1, 0))
		
		return math.min (calculatedInterval, maxInterval)
	end

	self.GetRelativeTime = function (timestamp)
		local currentTime = os.time ()
		local difference = timestamp - currentTime
		
		if difference <= 0 then
			return "Expired"
		end
		
		local years 	= difference / (365.25 * 24 * 60 * 60)
		local months 	= difference / (30.44 * 24 * 60 * 60)
		local days 		= difference / (24 * 60 * 60)
		local hours 	= difference / (60 * 60)
		local minutes 	= difference / 60
		
		years 		= math.ceil (years)
		months 		= math.ceil (months)
		days 		= math.ceil (days)
		hours 		= math.ceil (hours)
		minutes 	= math.ceil (minutes)
		
		if years > 0 then
			return string.format ("in %d year%s", years, years == 1 and "" or "s")
		elseif months > 0 then
			return string.format ("in %d month%s", months, months == 1 and "" or "s")
		elseif days > 0 then
			return string.format ("in %d day%s", days, days == 1 and "" or "s")
		elseif hours > 0 then
			return string.format ("in %d hour%s", hours, hours == 1 and "" or "s")
		else
			return string.format ("in %d minute%s", minutes, minutes == 1 and "" or "s")
		end
	end

    self.CacheBannedPlayer = function (steamid, ban_info)
        self.BanCache [steamid] = {
            banned = true,
            reason = ban_info.reason or "No reason specified",
            banned_until = ban_info.banned_until,
            cached_at = os.time ()
        }
        
        SystemInformation:MiniLogger ("Cached banned player: " .. steamid, true)
    end
    
    self.IsPlayerCachedBanned = function (steamid)
        local cached = self.BanCache [steamid]
        if not cached then
            return false
        end
        
        if os.time () - cached.cached_at > self.CacheTimeout then
            self.BanCache [steamid] = nil
            return false
        end
        
        if cached.banned_until and cached.banned_until < os.time () then
            self.BanCache [steamid] = nil
            return false
        end
        
        return true, cached
    end
    
    self.CleanupBanCache = function ()
        local currentTime = os.time ()
        local cleaned = 0
        
        for steamid, cached in pairs (self.BanCache) do
            local shouldRemove = false
            
            if currentTime - cached.cached_at > self.CacheTimeout then
                shouldRemove = true
            end
            
            if cached.banned_until and cached.banned_until < currentTime then
                shouldRemove = true
            end
            
            if shouldRemove then
                self.BanCache [steamid] = nil
                cleaned = cleaned + 1
            end
        end
        
        if cleaned > 0 then
            SystemInformation:MiniLogger ("Cleaned " .. cleaned .. " expired ban cache entries", true)
        end
    end

    self.CheckBans = function (player_ids, callback)
        if #player_ids == 0 then
            return
        end
        
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken,
            ["Content-Type"] = "application/x-www-form-urlencoded"
        }
        
        local data = {
            player_ids = util.TableToJSON (player_ids)
        }
        
        SystemInformation:MiniLogger ("Sending ban lookup request for players: " .. table.concat (player_ids, ", "), true)
        
		SystemInformation.Push (ChrononLabs ["ChrononLabs:Factory"].GetFactory ("services/lookup.php"),
            data,
            function (body, length, headers, code)
                SystemInformation:MiniLogger ("Ban lookup response received - Code: " .. tostring (code), true)
                SystemInformation:MiniLogger ("Response body: " .. tostring (body), true)
                
                if code == 200 then
                    local success, response = pcall (util.JSONToTable, body)
                    
                    if success and response then
                        if response.success then
                            if response.players then
                                for steamid, ban_info in pairs (response.players) do
                                    if ban_info.banned then
                                        self.CacheBannedPlayer (steamid, ban_info)
                                    else
                                        self.BanCache [steamid] = nil
                                    end
                                end
                            end
                            
                            callback (response.players)
                        else
                            SystemInformation:MiniLogger ("API Error: " .. (response.message or "No error message"))
                            callback (nil)
                        end
                    else
                        SystemInformation:MiniLogger ("Failed to parse JSON response: " .. tostring (body))
                        callback (nil)
                    end
                else
                    SystemInformation:MiniLogger ("Ban lookup failed with code: " .. code .. " | " .. tostring (body))
                    callback (nil)
                end
            end,
            function (err)
                SystemInformation:MiniLogger ("Ban lookup error: " .. err)
                callback (nil)
            end,
            options
        )
    end
    
    self.CheckOnlinePlayers = function ()
        local player_ids = {}
        local player_cache = {}
		
        for _, ply in ipairs (player.GetHumans ()) do
            if IsValid (ply) then
                local steam_id = ply:SteamID ()
                player_ids [#player_ids + 1] = steam_id
                player_cache [steam_id] = ply
            end
        end
        
        if #player_ids == 0 then 
            return 
        end
        
        self.CheckBans (player_ids, function (results)
            if not results then return end
            
            for steam_id, ban_info in pairs (results) do
                if ban_info.banned then
                    local ply = player_cache [steam_id]
                    
                    if IsValid (ply) then
						local ban_reason = string.format (
							"You have been banned\nReason: %s\nExpires: %s",
							ban_info.reason or "No reason specified",
							ban_info.banned_until and self.GetRelativeTime (ban_info.banned_until) or "Never"
						)
                        
                        SystemInformation:MiniLogger ("Kicking banned player found during scan: " .. steam_id)
                        
                        self.CacheBannedPlayer (steam_id, ban_info)
                        ply:Kick (ban_reason)
                    end
                end
            end
        end)
    end
	
	
	self.RunBanScannerAndReschedule = function ()
		self.CheckOnlinePlayers ()
		
		-- Clean cache periodically
		self.CleanupBanCache ()
		
		-- timer.Adjust having unwanted behaviors, we keep it basic.
		timer.Create("ChrononLabs:BanScanner", self.GetDynamicBanScannerInterval (), 1, self.RunBanScannerAndReschedule)
	end
    
	timer.Create ("ChrononLabs:BanScanner", self.GetDynamicBanScannerInterval (), 1, self.RunBanScannerAndReschedule)
	
	-- Clean cache every 2 minutes
	timer.Create ("ChrononLabs:BanCacheCleanup", 120, 0, self.CleanupBanCache)
end

function self:IsPlayerChecking (steamid)
    return self.PendingChecks [steamid] ~= nil
end

function self:OnPlayerConnect (steamid64, ip, name, password)
    if not steamid64 or steamid64 == "0" then
        return false, "Invalid SteamID"
    end
    
    local steamid = util.SteamIDFrom64 (steamid64)
    if not steamid then
        return false, "Invalid SteamID conversion" 
    end
    
    local isCachedBanned, cachedBan = self.IsPlayerCachedBanned (steamid)
    if isCachedBanned then
        local ban_reason = string.format (
            "You have been banned\nReason: %s\nExpires: %s",
            cachedBan.reason,
            cachedBan.banned_until and self.GetRelativeTime (cachedBan.banned_until) or "Never"
        )
        
        SystemInformation:MiniLogger ("Rejecting cached banned player: " .. steamid, true)
        return false, ban_reason
    end
    
    if self:IsPlayerChecking (steamid) then
        return true, "Checking ban status..."
    end
    
    self.PendingChecks [steamid] = true
    
    local PlayerConnectionCheck = {
        steamid 	= steamid,
        steamid64 	= steamid64,
        ip 			= ip,
        name 		= name,
        password 	= password,
        attempts 	= 0,
        maxAttempts = 10,
        timeout 	= CurTime () + 10
    }
    
    self.CheckBans ({steamid}, function (results)
        self.PendingChecks[steamid] = nil
        
        if results and results [steamid] and results [steamid].banned then
			local banned_info = results [steamid]
			local ban_reason = string.format (
				"You have been banned\nReason: %s\nExpires: %s",
				banned_info.reason or "No reason specified",
				banned_info.banned_until and self.GetRelativeTime (banned_info.banned_until) or "Never"
			)
            
            -- Cache the ban before kicking
            self.CacheBannedPlayer (steamid, banned_info)
            game.KickID (steamid, ban_reason)
        end
    end)
    
    return true, "Checking ban status..."
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())