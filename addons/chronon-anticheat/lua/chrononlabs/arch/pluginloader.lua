local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local pcall		= pcall
local http      = http
local util      = util
local timer     = timer

function self:InternalId ()
	return "ChrononLabs:PluginLoader"
end

function self:Constructor ()
	local SystemResources = ChrononLabs ["ChrononLabs:Initializer"]
	
    self.Cache = {
        LastFetch 		= 0,
        WeaponClasses 	= {},
        CacheTimeout 	= 300
    }
    
    self.IsCacheValid = function ()
        return (os.time () - self.Cache.LastFetch) < self.Cache.CacheTimeout
    end
    
    self.GetWeaponClassifications = function ()
        if self:IsCacheValid () then
            return self.Cache.WeaponClasses
        end
        
        self:FetchWeaponClassifications ()
        return self.Cache.WeaponClasses
    end
    
    self.FetchWeaponClassifications = function ()
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }
        
        ChrononLabs ["ChrononLabs:Initializer"].Get (ChrononLabs ["ChrononLabs:Factory"].FactoryList.CLASSIFICATIONS,
            function (body, _, headers, code)
                if code == 200 then
                    local success, response = pcall (util.JSONToTable, body)
                    if success and response then
                        if response.data then
                            self.Cache.WeaponClasses = response.data
                            self.Cache.LastFetch = os.time()
                            SystemResources:MiniLogger ("Successfully loaded weapon classifications")
                        else
                            SystemResources:MiniLogger ("Error: Response missing data field | Response: " .. tostring(body))
                        end
                    else
                        SystemResources:MiniLogger ("Error parsing weapon classifications JSON | Response: " .. tostring(body))
                    end
                else
                    SystemResources:MiniLogger ("Failed to fetch weapon classifications: HTTP " .. tostring(code) .. " | Response: " .. tostring(body))
                end
            end,
            function (error)
                SystemResources:MiniLogger ("Failed to fetch weapon classifications: " .. tostring(error))
            end,
            options
        )
    end
    

    timer.Create ("ChrononLabs:PluginLoader.Refresh", self.Cache.CacheTimeout, 0, function ()
        self:FetchWeaponClassifications ()
    end)
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())