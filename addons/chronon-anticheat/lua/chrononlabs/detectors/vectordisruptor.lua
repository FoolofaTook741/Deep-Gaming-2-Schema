local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local math      = math
local CurTime   = CurTime
local IsValid   = IsValid
local isangle   = isangle

function self:InternalId ()
    return "ChrononLabs:VectorDisruptor"
end

function self:Constructor ()
    local constantsModule  = ChrononLabs ["ChrononLabs:Constants"]
    
    self.GetAngleDifference = function (a1, a2)
        local diff = math.abs (a1 - a2)
        return diff > 180 and 360 - diff or diff
    end

    self.DetectFlick = function (player, currentAngles, lastAngles)
        if not IsValid (player) or not isangle (currentAngles) or not isangle (lastAngles) then 
            return false, 0 
        end
        
        local pitchDiff = self.GetAngleDifference (currentAngles.p, lastAngles.p)
        local yawDiff = self.GetAngleDifference (currentAngles.y, lastAngles.y)
        
        local angleDelta = math.sqrt (pitchDiff * pitchDiff + yawDiff * yawDiff)
        
        if not player.vectorDisruptorInformation then
            player.vectorDisruptorInformation = {
                flickThreshold   = 5.0,
                lastFlickTime    = 0,
                minFlickInterval = 0.1
            }
        end
        
        local currentTime = CurTime ()
        local timeSinceLastFlick = currentTime - (player.vectorDisruptorInformation.lastFlickTime or 0)
        
        if angleDelta > player.vectorDisruptorInformation.flickThreshold and 
           timeSinceLastFlick > player.vectorDisruptorInformation.minFlickInterval then
            player.vectorDisruptorInformation.lastFlickTime = currentTime
           
            return 1, angleDelta
        end
        
        return 0, angleDelta
    end
	
	self.GetSpeedRatio = function (target)
		local currentSpeed 	= target:GetVelocity ():Length ()
		local maxSpeed 		= target:GetRunSpeed ()
		
		return math.Round (currentSpeed / maxSpeed, 2)
	end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())