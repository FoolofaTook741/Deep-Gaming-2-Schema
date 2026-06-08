local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local pairs		= pairs
local nRound	= math.Round
local string	= string
local istable	= istable

function self:InternalId ()
	return "ChrononLabs:Operations"
end

function self:Constructor ()
	local classifier = ChrononLabs ["ChrononLabs:Classifier"]

	self.GetSessionDuration = function (ply)
		local connectedTime = ply:TimeConnected ()
		local seconds = math.floor (connectedTime)
		local minutes = math.floor (seconds / 60)
		local hours = math.floor   (minutes / 60)

		minutes = minutes % 60
		seconds = seconds % 60

		if hours > 0 then
			return string.format ("%dh %dm %ds", hours, minutes, seconds)
		elseif minutes > 0 then
			return string.format ("%dm %ds", minutes, seconds)
		else
			return string.format ("%ds", seconds)
		end
	end

	self.CalculateAverage = function (self, tbl)
		local count = #tbl
		if count == 0 then return 0 end

		local sum = 0
		for _, value in ipairs (tbl) do
			sum = sum + value
		end

		return sum / count
	end

	self.GaussianNoise = function (self, n, decimals)
		if not isnumber (n) then
			return 0
		end

		decimals = decimals or 3

		if decimals < 1 then
			decimals = 1
		end

		return nRound (n, decimals)
	end

	self.CloneTickData = function (tickData)
		local clone = {}

		for key, value in pairs (tickData) do
			if istable (value) then
				local nested = {}

				for nestedKey, nestedValue in pairs (value) do
					nested [nestedKey] = nestedValue
				end

				clone [key] = nested
			else
				clone [key] = value
			end
		end

		return clone
	end

	self.WeaponData = function (weapon)
		if not IsValid (weapon) or not isentity (weapon) then
			return {
				class = weapon:GetClass (),
			}
		end
	end

	self.UpdateTargetStats = function (sequence, target, hitInfo)
		local targetId = target:EntIndex ()

		local stats = sequence.sequence_stats.target_stats [targetId] or {
			hits 				= 0,
			headshots 			= 0,
			bodyshots 			= 0,
			distance_classes 	= {},
			velocities 			= {},
			total_damage 		= 0,
			kills 				= 0
		}

		stats.hits = stats.hits + 1
		if hitInfo.headshot then
			stats.headshots = stats.headshots + 1
		else
			stats.bodyshots = stats.bodyshots + 1
		end

		local distanceClass = classifier.DistanceClassification (hitInfo.distance)
		table.insert (stats.distance_classes, distanceClass)
		table.insert (stats.velocities, self:GaussianNoise (target:GetVelocity ():Length (), 2))

		sequence.sequence_stats.target_stats [targetId] = stats
	end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
