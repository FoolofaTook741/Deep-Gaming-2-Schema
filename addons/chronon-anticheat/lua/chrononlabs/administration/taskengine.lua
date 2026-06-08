local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local pcall		= pcall
local util      = util
local timer     = timer
local math      = math

function self:InternalId ()
    return "ChrononLabs:OpCodeRunner"
end

function self:Constructor ()
    local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]
    
    self.Config = {
        PollInterval    = 30,
        MaxRetries      = 2880,
        RetryDelay      = 30,
        MaxCommands     = 10
    }
    
    self.State = {
        IsProcessing        = false,
        ConsecutiveFailures = 0,
        LastSuccessTime     = 0,
        ExecutedCommands    = 0
    }
    
    self.ExecuteCommand = function (command)
        if not command or command == "" then
            SystemInformation:MiniLogger ("WARNING: Empty command received")
            return false
        end
        
        print ("[ChrononLabs] Executing command: " .. command)
        
        SystemInformation:MiniLogger ("Executing command: " .. command)
        
        local success, result = pcall (function ()
            game.ConsoleCommand (command .. "\n")
        end)
        
        if success then
            self.State.ExecutedCommands = self.State.ExecutedCommands + 1
            
            print ("[ChrononLabs] Command executed successfully (#" .. self.State.ExecutedCommands .. "): " .. command)
            
            SystemInformation:MiniLogger ("Command executed successfully (#" .. self.State.ExecutedCommands .. "): " .. command)
            return true
        else
            print ("[ChrononLabs] Command execution failed: " .. command .. " | Error: " .. tostring (result))
            
            SystemInformation:MiniLogger ("Command execution failed: " .. command .. " | Error: " .. tostring (result))
            return false
        end
    end
    
    self.ProcessCommands = function (commands)
        if not commands or #commands == 0 then
            SystemInformation:MiniLogger ("No commands to execute", true)
            return
        end
        
        if #commands > self.Config.MaxCommands then
            SystemInformation:MiniLogger ("WARNING: Too many commands received (" .. #commands .. "), limiting to " .. self.Config.MaxCommands)
			
            local truncatedCommands = {}
            for i = 1, self.Config.MaxCommands do
                truncatedCommands [i] = commands [i]
            end
            commands = truncatedCommands
        end
        
        SystemInformation:MiniLogger ("Processing " .. #commands .. " command(s)")
        
        local successCount = 0
        local failureCount = 0
        
        for i, command in ipairs (commands) do
            if self.ExecuteCommand (command) then
                successCount = successCount + 1
            else
                failureCount = failureCount + 1
            end
        end
        
        SystemInformation:MiniLogger (string.format (
            "Command batch completed: %d successful, %d failed", 
            successCount, 
            failureCount
        ))
    end
    
    self.FetchCommands = function ()
        if self.State.IsProcessing then
            SystemInformation:MiniLogger ("Command fetch already in progress, skipping", true)
            return
        end
        
        if not ChrononLabs ["ChrononLabs:Initializer"].isHTTPReady then
            SystemInformation:MiniLogger ("HTTP not ready, skipping command fetch", true)
            return
        end
        
        self.State.IsProcessing = true
        
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }
        
        SystemInformation:MiniLogger ("Fetching commands from server...", true)
        
        local data = {
            server_id = SystemInformation:GetServerName () or "unknown"
        }
        
        ChrononLabs ["ChrononLabs:Initializer"].Push (ChrononLabs ["ChrononLabs:Factory"].FactoryList.GET_COMMANDS,
            data,
            function (body, _, headers, code)
                self.State.IsProcessing = false
                
                if code == 200 then
                    local success, response = pcall (util.JSONToTable, body)
                    if success and response then
                        if response.success and response.data then
                            self.State.ConsecutiveFailures = 0
                            self.State.LastSuccessTime = CurTime ()
                            
                            self.ProcessCommands (response.data)
                        else
                            SystemInformation:MiniLogger ("API returned error: " .. tostring (response.message or "Unknown error"))
                            self.State.ConsecutiveFailures = self.State.ConsecutiveFailures + 1
                        end
                    else
                        SystemInformation:MiniLogger ("Failed to parse command response JSON: " .. tostring (body))
                        self.State.ConsecutiveFailures = self.State.ConsecutiveFailures + 1
                    end
                else
                    SystemInformation:MiniLogger ("Command fetch failed with HTTP " .. tostring (code) .. ": " .. tostring (body))
                    self.State.ConsecutiveFailures = self.State.ConsecutiveFailures + 1
                end
                
                if self.State.ConsecutiveFailures >= self.Config.MaxRetries then
                    SystemInformation:MiniLogger ("WARNING: Command fetch has failed " .. self.State.ConsecutiveFailures .. " times in a row")
                end
            end,
            function (error)
                self.State.IsProcessing = false
                self.State.ConsecutiveFailures = self.State.ConsecutiveFailures + 1
                SystemInformation:MiniLogger ("Command fetch error: " .. tostring (error))
            end,
            options
        )
    end
    
    self.StartCommandPolling = function ()
        SystemInformation:MiniLogger ("Starting command polling (interval: " .. self.Config.PollInterval .. "s)")
        
        timer.Simple (2, self.FetchCommands)
        
        timer.Create ("ChrononLabs:CommandPolling", self.Config.PollInterval, 0, function ()
            self.FetchCommands ()
        end)
    end
    
    self.StopCommandPolling = function ()
        timer.Remove ("ChrononLabs:CommandPolling")
        SystemInformation:MiniLogger ("Command polling stopped")
    end
    
    self.GetStatus = function ()
        return {
            IsProcessing        = self.State.IsProcessing,
            ConsecutiveFailures = self.State.ConsecutiveFailures,
            LastSuccessTime     = self.State.LastSuccessTime,
            ExecutedCommands    = self.State.ExecutedCommands,
            IsHealthy           = self.State.ConsecutiveFailures < self.Config.MaxRetries
        }
    end
    
    timer.Create ("ChrononLabs:CommandHealthCheck", 300, 0, function ()
        local status = self.GetStatus ()
        
        if not status.IsHealthy then
            SystemInformation:MiniLogger ("!!WARNING: Command executor is unhealthy - " .. status.ConsecutiveFailures .. " consecutive failures")
        end
        
        if status.LastSuccessTime > 0 then
            local timeSinceSuccess = CurTime () - status.LastSuccessTime
            if timeSinceSuccess > (self.Config.PollInterval * 10) then
                SystemInformation:MiniLogger ("WARNING: No successful command fetch in " .. math.floor (timeSinceSuccess) .. " seconds")
            end
        end
    end)
end

function self:Destructor ()
    self.StopCommandPolling ()
    timer.Remove ("ChrononLabs:CommandHealthCheck")
    
    self.ExecuteCommand = function () 
    end
    
    self.FetchCommands = function () 
    end
    
    ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())