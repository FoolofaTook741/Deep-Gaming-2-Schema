ChrononLabs 		= ChrononLabs or {}
local self 		   	= {}
local include 	   	= include
local tostring		= tostring
local type		   	= type
local setmetatable 	= setmetatable
local initTime  	= SysTime ()

function ChrononLabs.MakeGateAway (SignalAccelerator, SignalFilter, ISaveMap)
    SignalFilter [ISaveMap] = SignalAccelerator
end

function self:WeakKeys ()
    local weakTable = {}

    setmetatable (weakTable,
		{
			__mode = "k"
		}
	)

    return weakTable
end

function self:TimeTracker ()
	local startupTime = SysTime ()
	startupTime 	  = startupTime - initTime

	return string.format ("%02d:%02d", math.floor (startupTime / 60), math.floor (startupTime % 60), math.floor (startupTime * 1000 % 1000))
end

function self:InternalId ()
	return "ChrononLabs:SystemDispatcher"
end

function self:Constructor ()
	self.LoadFile = self:WeakKeys ()

	self.LoadFile [#self.LoadFile + 1] = "chrononlabs/controllers/chrononlabs-initializer.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/runtime/resources.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/programlogs.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/diagnostics.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/playersessions/handleplayers.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/gateawayprocessor.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/runtime/heartbeat.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/worker.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/taskengine.lua"

	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/constants.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/operations.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/pluginloader.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/classifier.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/blueprint.lua"

	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/detectors/recoildetector.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/detectors/tickanalytics.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/detectors/management.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/detectors/vectordisruptor.lua"

	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/inputprocessor.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/ballisticsprocessor.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/playerstate.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/mechanics.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/arch/inferenceengine.lua"

	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/handlenotification.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/polling.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/configuration.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/administration/livechannel.lua"
	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/runtime/memorymanager.lua"

	self.LoadFile [#self.LoadFile + 1] = "SERVER|chrononlabs/controllers/classesmegastructure.lua"
end

function self:ParseCorrectFiles (_)
	if string.sub (self, 1, 6) == "SERVER" then
		return true
	else
		return false
	end
end

function self:DispatchFiles (file, server)
	if type (self) ~= "table" and not file then
		file = tostring (self)
	end
	if file ~= nil then
		include (file)

		return "> Dispatched > " .. file .. "."
	else
		if type (self) == "table" then
			return self:InternalId () .. ".DispatchFiles : Empty allocation provided."
		else
			return self:InternalId () .. ".DispatchFiles : Empty allocation provided."
		end
	end
end

function self:GetStateStatus (status)
	if status then
		return true
	end
end

self:Constructor ()
ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
self:DispatchFiles (self.LoadFile [1])
