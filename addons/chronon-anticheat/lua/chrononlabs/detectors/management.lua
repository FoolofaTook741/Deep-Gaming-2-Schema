local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local file      = file
local istable   = istable
local string 	= string
local math		= math
local table		= table

function self:InternalId ()
    return "ChrononLabs:Management"
end

function self:InitializeModules ()
	self.Operations = ChrononLabs ["ChrononLabs:Operations"]
    self.Constants 	= ChrononLabs ["ChrononLabs:Constants"]

	self.Blueprint  = ChrononLabs ["ChrononLabs:Blueprint"]
    self.Plugin		= ChrononLabs ["ChrononLabs:PluginLoader"]
	self.Notify		= ChrononLabs ["ChrononLabs:HandleNotification"]
end

function self:Constructor ()
	self:InitializeModules ()

    self.GenerateSessionId = function (ply)
        local timestamp     = string.format ("%0.6f", SysTime ())
        local randomSegment = string.format ("%06x", math.random (0, 16777215))
        local steamId       = string.Replace (ply:SteamID (), ":", "_")

        local sessionId = string.format ("%s_%s_%s", timestamp, randomSegment, steamId)

        if istable (self.Constants.Sessions [sessionId]) then
            local uuidSegment = string.format ("%04x%04x",
                math.random (0, 0xffff),
                math.random (0, 0xffff)
            )

            sessionId = sessionId .. "_" .. uuidSegment
        end

        return sessionId
    end

    self.ChrononSession = function (ply)
        ply.chrononSessionId = ply.chrononSessionId or self.GenerateSessionId (ply)

        if istable (self.Constants.Sessions [ply.chrononSessionId]) then
            return self.Constants.Sessions [ply.chrononSessionId]
        end

        ply.vectorDisruptorInformation = {
            lastAngle        = nil,
            flickThreshold   = 5.0,
            lastFlickTime    = 0,
            minFlickInterval = 0.1
        }

        self.Constants.Sessions [ply.chrononSessionId] = {
            sessionId = ply.chrononSessionId,
            sequences = {},
            sequenceCount = 0
        }

        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Starting new session for " .. ply:SteamName ())

        return self.Constants.Sessions [ply.chrononSessionId]
    end

	self.ChrononSequence = function (ply)
        local session = self.ChrononSession (ply)
		local inputProcessor = ChrononLabs ["ChrononLabs:InputProcessor"]
		local CloneTickData = self.Operations.CloneTickData

        timer.Create ("chronon.end_sequence." .. ply:SteamID (), self.Constants.Config.Timeout, 1, function ()
            self.EndSequence (ply)
        end)

        if ply.activeSequence then
            local activeWeapon = IsValid (ply:GetActiveWeapon ()) and ply:GetActiveWeapon ():GetClass ()

            if activeWeapon ~= ply.activeSequence.weapon then
                self.EndSequence (ply)
            end

            return ply.activeSequence
        end

        local sequenceTemplate = self.Blueprint:GetSequenceTemplate ()
        if not sequenceTemplate then
            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Warning: Cannot create sequence - template not loaded for " .. ply:Nick ())
            return nil
        end

        ply.activeSequence = sequenceTemplate
		ply.activeSequence.sequence_id = "active_combat_sequence"
		ply.activeSequence.steam_id = ply:SteamID ()
		ply.activeSequence.weapon = IsValid (ply:GetActiveWeapon ()) and ply:GetActiveWeapon ():GetClass ()
		ply.activeSequence.weapon_class = ply.activeSequence.weapon or "unknown"
		ply.activeSequence.timestamp_start = os.time ()
		ply.activeSequence.curtime_start = CurTime ()
		ply.activeSequence.temp_data.tick_start =
			(inputProcessor and inputProcessor.GetPlayerSampleTick and inputProcessor.GetPlayerSampleTick (ply))
			or 0
		ply.activeSequence.tickrate = self.Constants.Config.TargetTickRate or self.Constants.Config.TickRate
		ply.activeSequence.raw_tickrate = self.Constants.Config.EngineTickRate or ply.activeSequence.tickrate
		ply.activeSequence.weapon_stats = self.Operations.WeaponData (ply:GetActiveWeapon ())

		-- Playback reconstruction data (sequence-level)
		ply.activeSequence.map_name = game.GetMap ()
		ply.activeSequence.player_model = ply:GetModel ()

        local history = self.Constants.TickHistory [ply:SteamID ()] or {}
        for i = 1, #history do
            ply.activeSequence.pre_shot_ticks [i] = CloneTickData (history [i])
        end

		if not ply:IsWorldClickingDisabled () then
			ply:DisableWorldClicking (true)
		end

        return ply.activeSequence
    end

	self.IsSequenceQualified = function (sequence)
		local stats = sequence.sequence_stats or {}
		local totalShots = tonumber (stats.total_shots) or 0
		local hits = tonumber (stats.hits) or 0
		local totalDamage = tonumber (stats.total_damage) or 0
		local headshots = tonumber (stats.headshots) or 0
		local totalKills = tonumber (stats.total_kills) or 0

		if totalKills >= 1 then
			return true
		end

		local score = (totalShots * 1)
			+ (hits * 3)
			+ (headshots * 6)
			+ (totalDamage * 0.2)

		if score >= 12 then
			return true
		end

		return false, string.format (
			"score=%.2f shots=%d hits=%d headshots=%d damage=%d kills=%d",
			score,
			totalShots,
			hits,
			headshots,
			totalDamage,
			totalKills
		)
	end

	local function FindMaxInTable (t)
		if not t or #t == 0 then return 0 end

		local max = t [1]
		for i = 2, #t do
			if t [i] > max then
				max = t [i]
			end
		end

		return max
	end


	self.EndSequence = function (ply)
        if not istable (ply.activeSequence) then return end

		local inputProcessor = ChrononLabs ["ChrononLabs:InputProcessor"]
		local Operations = self.Operations
		local GaussianNoise = Operations.GaussianNoise
		local CalculateAverage = Operations.CalculateAverage

        if timer.Exists ("chronon.end_sequence_cooldown." .. ply:SteamID ()) then
            timer.Remove ("chronon.end_sequence_cooldown." .. ply:SteamID ())
        end

        self.Constants.SessionCooldowns [ply:SteamID ()] = CurTime () + 1
        local session = self.ChrononSession (ply)

        local copySequence = table.Copy (ply.activeSequence)
		local currentSampleTick =
			(inputProcessor and inputProcessor.GetPlayerSampleTick and inputProcessor.GetPlayerSampleTick (ply))
			or (ply.activeSequence.temp_data.total_ticks or 0)
		copySequence.sequence_stats.duration_ticks = math.max (0, currentSampleTick - (ply.activeSequence.temp_data.tick_start or 0))
        copySequence.sequence_stats.combat_duration = GaussianNoise (Operations, CurTime () - ply.activeSequence.curtime_start, 0)

        if copySequence.sequence_stats.combat_duration > 0 then
            copySequence.sequence_stats.damage_per_second = GaussianNoise (Operations,
                copySequence.sequence_stats.total_damage / copySequence.sequence_stats.combat_duration, 2
            )
        end

        if copySequence.sequence_stats.duration_ticks > 0 then
            copySequence.sequence_stats.micro_smoothing_ratio_p1 = GaussianNoise (Operations,
                copySequence.sequence_stats.micro_smoothing_counts_p1 / copySequence.sequence_stats.duration_ticks, 3
            )

            copySequence.sequence_stats.micro_smoothing_ratio_r1 = GaussianNoise (Operations,
                copySequence.sequence_stats.micro_smoothing_counts_r1 / copySequence.sequence_stats.duration_ticks, 3
            )

            copySequence.sequence_stats.micro_smoothing_ratio_r2 = GaussianNoise (Operations,
                copySequence.sequence_stats.micro_smoothing_counts_r2 / copySequence.sequence_stats.duration_ticks, 3
            )

			copySequence.sequence_stats.esp_medium_range_ratio = GaussianNoise (Operations,
                copySequence.sequence_stats.esp_medium_range_hits / copySequence.sequence_stats.duration_ticks, 3
            )

            copySequence.sequence_stats.esp_long_range_ratio = GaussianNoise (Operations,
                copySequence.sequence_stats.esp_long_range_hits / copySequence.sequence_stats.duration_ticks, 3
            )
        end

		local tempData = copySequence.temp_data
		local recoilCompensation = tempData and tempData.recoil_compensation
		if recoilCompensation and #recoilCompensation.x > 1 then
			copySequence.sequence_stats.avg_recoil_compensation.x = GaussianNoise (Operations,
				CalculateAverage (Operations, recoilCompensation.x)
			)
			copySequence.sequence_stats.avg_recoil_compensation.y = GaussianNoise (Operations,
				CalculateAverage (Operations, recoilCompensation.y)
			)

			local sumX, sumY = 0, 0
			local avgX = copySequence.sequence_stats.avg_recoil_compensation.x
			local avgY = copySequence.sequence_stats.avg_recoil_compensation.y

			for _, compX in ipairs (recoilCompensation.x) do
				sumX = sumX + (compX - avgX)^2
			end
			for _, compY in ipairs (recoilCompensation.y) do
				sumY = sumY + (compY - avgY)^2
			end

			copySequence.sequence_stats.recoil_consistency.x = GaussianNoise (Operations,
				math.sqrt (sumX / #recoilCompensation.x)
			)
			copySequence.sequence_stats.recoil_consistency.y = GaussianNoise (Operations,
				math.sqrt (sumY / #recoilCompensation.y)
			)

			copySequence.sequence_stats.max_recoil_delta.x = GaussianNoise (Operations,
				FindMaxInTable (recoilCompensation.x)
			)
			copySequence.sequence_stats.max_recoil_delta.y = GaussianNoise (Operations,
				FindMaxInTable (recoilCompensation.y)
			)
		end

        copySequence.timestamp_end 	= os.time ()
        copySequence.curtime_end 	= CurTime ()
        copySequence.temp_data 		= nil

        local shouldKeep, discardReason = self.IsSequenceQualified (copySequence)

        if shouldKeep then
			session.sequenceCount = session.sequenceCount + 1
			copySequence.sequence_id = "combat_" .. session.sequenceCount

			local steamId = ply:SteamID ()
			self.Constants.PendingSequences [steamId] = self.Constants.PendingSequences [steamId] or {}

			local sessionCopy 		= table.Copy (session)
			sessionCopy.sequences 	= nil
			sessionCopy.sequence 	= copySequence
			sessionCopy.session_id 	= nil

			table.insert (self.Constants.PendingSequences [steamId], sessionCopy)

			if #self.Constants.PendingSequences [steamId] >= self.Constants.Config.SequencesPerBatch then
				local batchData = {
					steam_id 		= steamId,
					player_name 	= ply:Nick (),
					timestamp 		= os.time (),
					player_ip       = ChrononLabs ["ChrononLabs:PlayerState"].GetPlayerIP (ply),
					time_connected  = self.Operations.GetSessionDuration (ply),

					sequences 		= self.Constants.PendingSequences [steamId]
				}

				local sessionId = util.CRC (self.GenerateSessionId (ply)) .. math.random (1, 999999)


				self.Constants.PendingSequences [steamId] = {}


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
			end
        elseif self.Constants.Config.DebugMode then
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (
				"Discarding low-quality sequence for " .. ply:Nick () .. " (" .. (discardReason or "no reason") .. ")"
			)
        end

		if ply:IsWorldClickingDisabled () then
			ply:DisableWorldClicking (false)
		end

        ply.activeSequence = nil
        timer.Remove ("chronon.end_sequence." .. ply:SteamID ())
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
