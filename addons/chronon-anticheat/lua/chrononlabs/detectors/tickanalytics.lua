local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local table     = table
local IsValid   = IsValid
local table		= table

function self:InternalId ()
    return "ChrononLabs:TickAnalytics"
end

function self:Constructor ()
    local Constants = ChrononLabs ["ChrononLabs:Constants"]
    
    self.UpdateTickHistory = function (ply, tick_data)
        if not IsValid (ply) then return end
        
		local playerSteamId = ply:SteamID ()
		
        if not Constants.TickHistory [playerSteamId] then
            Constants.TickHistory [playerSteamId] = {}
        end
        
        local history = Constants.TickHistory [playerSteamId]
        
        table.insert (history, tick_data)
        
        while #history > Constants.Config.PreShotTicks do
            table.remove (history, 1)
        end
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())