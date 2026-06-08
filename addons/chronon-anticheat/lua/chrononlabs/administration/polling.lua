local self 		= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print 	= print
local pcall		= pcall
local util 		= util
local timer 	= timer
local hook 		= hook
local timer 	= timer

function self:InternalId ()
    return "ChrononLabs:ServerPoll"
end

function self:PreConstructor ()
    self.POLL_INTERVAL 			= 20

    self.lastPollSuccess 		= 0
    self.consecutiveFailures 	= 0
	self.isPolling 				= false
	self.pollToken 				= 0
	self.pollSafetyTimeout 		= 15
end

function self:Constructor ()
	local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]

    self.PollServer = function ()
        if not ChrononLabs ["ChrononLabs:Initializer"] or
		   not ChrononLabs ["ChrononLabs:Initializer"].isHTTPReady then
			return
		end

		if self.isPolling then
			return
		end

		self.isPolling = true
		self.pollToken = self.pollToken + 1
		local pollToken = self.pollToken

		timer.Create ("ChrononLabsServerPollSafety", self.pollSafetyTimeout, 1, function ()
			if self.pollToken == pollToken then
				self.isPolling = false
			end
		end)

        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }

        local data = {
            curtime = tostring (CurTime ())
        }

        ChrononLabs ["ChrononLabs:Initializer"].Push (ChrononLabs ["ChrononLabs:Factory"].FactoryList.SERVER_POLL, data,
            function (body, _, _, code)
				if self.pollToken == pollToken then
					self.isPolling = false
					timer.Remove ("ChrononLabsServerPollSafety")
				end

                local success, response = pcall (util.JSONToTable, body)
                if code == 200 and success and response and response.success then
                    if self.consecutiveFailures > 0 then
                        SystemInformation:MiniLogger ("Connection restored after " .. self.consecutiveFailures .. " failed attempts")
                    end

                    self.consecutiveFailures = 0
                    self.lastPollSuccess = CurTime ()
                else
                    self.consecutiveFailures = self.consecutiveFailures + 1
                    SystemInformation:MiniLogger ("Failed to update status: HTTP " .. tostring(code) .. " | Response: " .. tostring(body))
                end
            end,

            function (err)
				if self.pollToken == pollToken then
					self.isPolling = false
					timer.Remove ("ChrononLabsServerPollSafety")
				end

                self.consecutiveFailures = self.consecutiveFailures + 1
                SystemInformation:MiniLogger ("Poll request error: " .. err)
            end,
            options
        )
    end

    timer.Create ("ChrononLabsServerPollHealth", 60, 0, function ()
        if not self.IsPollHealthy then
            SystemInformation:MiniLogger ("!!WARNING: Server poll has failed " .. self.consecutiveFailures .. " times in a row")
        end

		if self.consecutiveFailures >= 4320 then
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Connection failed: Unable to reach the server after " .. self.consecutiveFailures .. " attempts")
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Unloading Chronon to prevent further issues..")

			ChrononLabs ["ChrononLabs:Mechanics"]			:Destructor ()
			ChrononLabs ["ChrononLabs:PlayerState"]			:Destructor ()
			ChrononLabs ["ChrononLabs:InputProcessor"]		:Destructor ()
			ChrononLabs ["ChrononLabs:GarbageManager"]		:Destructor ()
			ChrononLabs ["ChrononLabs:BallisticsProcessor"]	:Destructor ()

			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Chronon unloaded successfully!")
			timer.Remove ("ChrononLabsServerPollHealth")

			collectgarbage ("collect")
		end
    end)

    self.GetLastPollSuccess = function ()
        return self.lastPollSuccess
    end

    self.GetConsecutiveFailures = function ()
        return self.consecutiveFailures
    end

    self.IsPollHealthy = function ()
        return self.consecutiveFailures < 3
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
