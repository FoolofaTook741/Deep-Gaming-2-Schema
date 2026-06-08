local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local IsValid   = IsValid
local timer     = timer
local istable   = istable
local util      = util
local math      = math
local os        = os
local string	= string

function self:InternalId ()
    return "ChrononLabs:PlayerState"
end

function self:InitializeModules ()
	self.Operations = ChrononLabs ["ChrononLabs:Operations"]
    self.Management = ChrononLabs ["ChrononLabs:Management"]
    self.Constants  = ChrononLabs ["ChrononLabs:Constants"]
end

function self:Constructor ()
	self:InitializeModules ()
	
    self.HandlePlayerDeath = function (victim, _, attacker)
		if not IsValid (victim) then return end
		
		if IsValid (attacker) and attacker:IsPlayer () then

			if istable (attacker.activeSequence) then
				local sequence = attacker.activeSequence

				sequence.sequence_stats.total_kills = sequence.sequence_stats.total_kills + 1

				local victimId = victim:EntIndex ()
				if sequence.sequence_stats.target_stats [victimId] then
					sequence.sequence_stats.target_stats [victimId].kills =
						sequence.sequence_stats.target_stats [victimId].kills + 1
				end

				if sequence.sequence_stats.unique_targets > 0 then
					sequence.sequence_stats.kills_per_target = self.Operations:GaussianNoise (
						sequence.sequence_stats.total_kills / sequence.sequence_stats.unique_targets, 2
					)
				end

				-- Playback reconstruction: Update target_health to 0 for the killing shot
				if sequence.temp_data.target_last_hit_ticks and sequence.temp_data.target_last_hit_ticks [victimId] then
					local lastHitTick = sequence.temp_data.target_last_hit_ticks [victimId]
					if sequence.tick_data [lastHitTick] then
						sequence.tick_data [lastHitTick].target_health = 0
					end
				end
			end
		end
		
		self.Management.EndSequence (victim)
		
		if IsValid (attacker) and attacker:IsPlayer () then
			if not timer.Exists ("chronon.end_sequence_cooldown." .. attacker:SteamID ()) then
				timer.Create ("chronon.end_sequence_cooldown." .. attacker:SteamID (), 1.5, 1, function ()
					if IsValid (attacker) then
						self.Management.EndSequence (attacker)
					end
				end)
			end
		end
	end
    
    self.HandlePlayerDisconnect = function (ply)
        self.Management.EndSequence (ply)

        local steamId = ply:SteamID ()

		self.Constants.TickHistory		[steamId] = nil
		self.Constants.SessionCooldowns [steamId] = nil

		if ChrononLabs ["ChrononLabs:InputProcessor"].playerSampleState and ChrononLabs ["ChrononLabs:InputProcessor"].playerSampleState [steamId] then
			ChrononLabs ["ChrononLabs:InputProcessor"].playerSampleState [steamId] = nil
		end

		if ply.chrononSessionId and istable (self.Constants.Sessions [ply.chrononSessionId]) then
			self.Constants.Sessions [ply.chrononSessionId] = nil
		end
		
        if self.Constants.PendingSequences [steamId] and #self.Constants.PendingSequences [steamId] > 0 then
            local batchData = {
                steam_id 		= steamId,
                player_name 	= ply:Nick (),
                timestamp 		= os.time (),
				player_ip       = ChrononLabs ["ChrononLabs:PlayerState"].GetPlayerIP (ply),
				time_connected  = self.Operations.GetSessionDuration (ply),
				
                sequences 		= self.Constants.PendingSequences [steamId]
            }
            
            local sessionId = util.CRC (self.Management.GenerateSessionId (ply)) .. math.random (1, 999999)
            
            local inferenceResult = ChrononLabs ["ChrononLabs:InferenceEngine"].ProcessInference (batchData, function (result)
			
				local steamID 		= result.steam_id 		or "Unknown"
				local prediction 	= result.prediction 	or "Unknown"
				local confidence 	= result.confidence 	or 0
				local probability 	= result.probability 	or 0
		
				local logMessage = string.format (
					"Inference Result | SteamID: %s | Prediction: %s | Confidence: %.2f%% | Probability: %.2f%%",
					steamID, prediction, confidence, probability * 100
				)

				ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (logMessage, true)
				
				local ply = player.GetBySteamID (steamID)
				
				if not IsValid (ply) or not ply:IsPlayer () then
					return
				end
			end)
			
			self.Constants.PendingSequences [steamId] = nil

			ChrononLabs ["ChrononLabs:GarbageManager"]:QueueGarbageCollection ()
			--collectgarbage () -- White objt -> gray
			--collectgarbage () -- Gray objt  -> collected.
        end
		
		if ChrononLabs ["ChrononLabs:InferenceEngine"].PlayerQueues and ChrononLabs ["ChrononLabs:InferenceEngine"].PlayerQueues [steamId] then
			ChrononLabs ["ChrononLabs:InferenceEngine"].PlayerQueues [steamId] = nil
		end
    end
	
	self.GetPlayerIP = function (ply)
		if not IsValid (ply) or not ply:IsPlayer () then
			return "unknown"
		end
	
		return string.Explode (":", ply:IPAddress ()) [1] or "unknown"
	end
end

function self:Destructor ()
	hook.Remove ("PlayerDeath", "ChrononLabs:PlayerStateDT")
	hook.Remove ("PlayerDisconnected", "ChrononLabs:PlayerStateDC")
	
	self.HandlePlayerDeath 		= function () 
	end
	
	self.HandlePlayerDisconnect = function () 
	end
	
	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
