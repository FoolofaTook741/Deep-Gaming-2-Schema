local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local unpack	= unpack
local string	= string
local bit       = bit

function self:InternalId ()
    return "ChrononLabs:Factory"
end

function self:Constructor ()
    self.tension 	= string.char (unpack ({104, 116, 116, 112, 115}))
    self._d 		= "22383B612D273C30255C372F29303C60212B2B"
    self._k 		= "CHRONON_K3Y"
    
    self._hexToByte = function (str)
        local result = ""
        for i = 1, #str, 2 do
            result = result .. string.char (tonumber (str:sub (i, i + 1), 16))
        end
        return result
    end
    
    self._xor = function (str, key)
        local result = ""
        for i = 1, #str do
            local byte = bit.bxor (str:byte (i), key:byte ((i - 1) % #key + 1))
            result = result .. string.char (byte)
        end
        return result
    end
    
    self.GetFactory = function (pts)
        local bytes = self._hexToByte (self._d)
        
        local maxer = self._xor (bytes, self._k)
        
        local url = string.format ("%s://%s/%s", self.tension, maxer, pts)
        
        return url
    end
    
    self.FactoryList = {
        PREDICT         = self.GetFactory ("app/predict.php"),
        SERVER_POLL     = self.GetFactory ("services/server_poll.php"),
        ADD_LOG         = self.GetFactory ("services/add_log.php"),
        SEQUENCE        = self.GetFactory ("app/gmod/sequencer.php"),
        CLASSIFICATIONS = self.GetFactory ("app/gmod/swepclassifications.php"),
		GET_COMMANDS    = self.GetFactory ("services/get_commands.php")
    }
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())