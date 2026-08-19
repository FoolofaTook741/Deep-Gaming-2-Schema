local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local tickRate	= engine.TickInterval
local nRound	= math.Round

local TARGET_TICKRATE = 22
local TARGET_TICK_INTERVAL = 1 / TARGET_TICKRATE


function self:InternalId ()
	return "ChrononLabs:Constants"
end

function self:Constructor()
	local engineTickInterval = tickRate ()
	local engineTickRate = 1 / engineTickInterval

	-- Weak tables (ephemeron) not well supported by Lua 5.1, collected whenever they feel like it but not instantly compared to Lua 5.2.
    self.Sessions 			= ChrononLabs ["ChrononLabs:SystemDispatcher"].WeakKeys ()
    self.SessionCooldowns 	= ChrononLabs ["ChrononLabs:SystemDispatcher"].WeakKeys ()
    self.TickHistory 		= ChrononLabs ["ChrononLabs:SystemDispatcher"].WeakKeys ()
    self.PendingSequences 	= ChrononLabs ["ChrononLabs:SystemDispatcher"].WeakKeys ()
    self.DetectionHistory 	= {}
    
    self.Config = {
        Timeout 			= 3,
		SequenceTicks		= 15,
        SessionGoal 		= 150,
		SequencesPerBatch 	= 5,
        DebugMode 			= false,
        FilterSecondaryBullets = false,
        Folder 				= "legit",
		TargetTickRate 		= TARGET_TICKRATE,
		TargetTickInterval 	= TARGET_TICK_INTERVAL,
		EngineTickRate 		= engineTickRate,
		EngineTickInterval 	= engineTickInterval,
        TickRate 			= TARGET_TICKRATE,
        PreShotTicks 		= nRound (660 * TARGET_TICK_INTERVAL)
    }
    
    self.RCSConfig = {
        MaxContinuousShots 		= 10,
        ProAimTeleportThreshold = 15,
        MinDistForAimChecks 	= 10,
        PlayerSphereRadius 		= 3
    }
	
	self.DistanceRanges = {
		[1] = {
			name = "point_blank",
			max = 128
		},
		[2] = {
			name = "close",
			max = 512
		},
		[3] = {
			name = "medium",
			max = 1024
		},
		[4] = {
			name = "long",
			max = 2048
		},
		[5] = {
			name = "extreme",
			max = math.huge
		}
	}
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
