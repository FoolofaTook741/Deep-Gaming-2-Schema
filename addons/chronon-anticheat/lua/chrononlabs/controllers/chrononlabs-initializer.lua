local self 			= {}
local MsgC 			= MsgC
local type			= type
local previousSave 	= previousSave or {}
local sanitizedDate = string.gsub (os.date ("%d/%m/%Y"), "/", "_")
local http			= http
local table			= table
local game			= game
local pairs			= pairs
local timer			= timer

function self:InternalId ()
	return "ChrononLabs:Initializer"
end

function self:InitSetup ()
	self.QueueLogger = {}
	self.MaxQueueSize = 500
	self.LogFlushInterval = 5

	self.isHTTPReady = false
	self.logCounter  = self.logCounter or 0

	if timer and not timer.Exists ("ChrononLabs:LogFlush") then
		timer.Create ("ChrononLabs:LogFlush", self.LogFlushInterval, 0, function ()
			if ChrononLabs ["ChrononLabs:Initializer"] then
				ChrononLabs ["ChrononLabs:Initializer"]:ProcessLogQueue ()
			end
		end)
	end
end

function self:InitNetwork ()
    self.SendRequest = function (requestType, url, data, successCallback, errorCallback, headers)
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }

        if headers then
            for k, v in pairs (headers) do
                options [k] = v
            end
        end

        if requestType == "POST" then
            http.Post (url, data, successCallback, errorCallback, options)
        else
            http.Fetch (url, successCallback, errorCallback, options)
        end
    end

    self.Push = function (url, data, successCallback, errorCallback, headers)
        self.SendRequest ("POST", url, data, successCallback, errorCallback, headers)
    end

    self.Get = function (url, successCallback, errorCallback, headers)
        self.SendRequest ("GET", url, nil, successCallback, errorCallback, headers)
    end
end

function self:ProcessLogQueue ()
    if not self.isHTTPReady then return end

    while #self.QueueLogger > 0 do
        local message = table.remove (self.QueueLogger, 1)

		self.logCounter = self.logCounter + 1

        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }

        self.Push (ChrononLabs ["ChrononLabs:Factory"].FactoryList.ADD_LOG,
            {
                message = message,
				order	= tostring (self.logCounter)
            },
            function (body)
            end,
            function (err)
                table.insert (self.QueueLogger, 1, message)
            end,
            options
        )
    end
end

function self:MiniLogger (appender, shouldIgnore)
	if type (self) == "table" and not previousSave then
		--previousSave = previousSave or {}
	end

	if not self.QueueLogger then
		self:InitSetup ()
	end

	if not appender and type (self) ~= "table" then
		appender = self
	end

	if not shouldIgnore then
		Msg ("\n")
		MsgC (Color (255,255,255), "(", Color (255,0,0), "[!] ChrononLabs | " .. tostring (ChrononLabs ["ChrononLabs:SystemDispatcher"].TimeTracker ()) .. " [!]", Color (255,255,255),"): ", appender)
		Msg ("\n")
	end

	if previousSave then
		previousSave [#previousSave + 1] = "[" .. tostring (ChrononLabs ["ChrononLabs:SystemDispatcher"].TimeTracker ()) .. "] : " .. appender .. "\n"
	end

	if file.Exists ("chrononlabs/console/console" .. "_" .. sanitizedDate .. ".txt", "DATA") then
		if previousSave then
			file.Append ("chrononlabs/console/console" .. "_" .. sanitizedDate .. ".txt", table.concat (previousSave))
			previousSave = nil
		end
		file.Append ("chrononlabs/console/console" .. "_" .. sanitizedDate .. ".txt", "[" .. tostring (ChrononLabs ["ChrononLabs:SystemDispatcher"].TimeTracker ()) .. "] : " .. appender .. "\n")
	end

    local formattedMessage = "[" .. tostring (ChrononLabs ["ChrononLabs:SystemDispatcher"].TimeTracker ()) .. "] : " .. appender
    table.insert (self.QueueLogger, formattedMessage)

    if #self.QueueLogger > self.MaxQueueSize then
        table.remove (self.QueueLogger, 1)
    end

	-- Remote log delivery is batched by ChrononLabs:LogFlush.
end

function self:MiniLogger_ (appender, _)
	if not appender and type (self) ~= "table" then
		appender = self
	end

	Msg ("\n")
	MsgC (Color (255,255,255), "(", Color (255,0,0), "[!] ChrononLabs | " .. tostring (ChrononLabs ["ChrononLabs:SystemDispatcher"].TimeTracker ()) .. " [!]", Color (255,255,255),"): ", appender)
	Msg ("\n")
end

function self:GetServerIP ()
	return game.GetIPAddress () or "unknown"
end

function self:GetServerName ()
	return GetHostName () or "unknown"
end

function self:LoadSubPath ()
	if ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile and type (ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile) == "table" then

		for incremental = 1, #ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile do
			if not ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile [incremental] or incremental == 1 then
				goto skipIteration
			end

			local isServer 	  = ChrononLabs ["ChrononLabs:SystemDispatcher"].ParseCorrectFiles (ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile [incremental])
			local correctPath = string.gsub (ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile [incremental], "SERVER|", "")
			correctPath		  = string.gsub (correctPath, "CLIENT|", "")

			if isServer and SERVER then
				local output = ChrononLabs ["ChrononLabs:SystemDispatcher"].DispatchFiles (correctPath)
				self:MiniLogger (output)
			elseif not isServer then
				local output = ChrononLabs ["ChrononLabs:SystemDispatcher"].DispatchFiles (correctPath)
				self:MiniLogger (output)
			end

			::skipIteration::
		end
	else
		self:MiniLogger ('!!Could not retrieve element {ChrononLabs ["ChrononLabs:SystemDispatcher"].LoadFile}.')
	end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
self:LoadSubPath ()
