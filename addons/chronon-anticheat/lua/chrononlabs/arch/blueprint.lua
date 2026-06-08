local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local util 		= util
local Angle 	= Angle
local timer		= timer
local string	= string
local pcall		= pcall

function self:InternalId ()
    return "ChrononLabs:Blueprint"
end

function self:Constructor ()
    self.SequenceTemplate 	= nil
    self.maxRetries 		= 1440
    self.retryDelay 		= 60
    self.currentRetry 		= 0
    
    self.RetryFetch = function ()
        if self.currentRetry < self.maxRetries then
            self.currentRetry = self.currentRetry + 1
            
            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (
                string.format (
                    "Retrying sequence template fetch (%d/%d) in %d seconds...", 
                    self.currentRetry, 
                    self.maxRetries, 
                    self.retryDelay
                )
            )
            
            timer.Simple (self.retryDelay, function ()
                self:FetchSequenceTemplate ()
            end)
        else
            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Failed to fetch sequence template after " .. self.maxRetries .. " attempts")
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Unloading Chronon to prevent further issues..")
			
			ChrononLabs ["ChrononLabs:Mechanics"]			:Destructor ()
			ChrononLabs ["ChrononLabs:PlayerState"]			:Destructor ()
			ChrononLabs ["ChrononLabs:InputProcessor"]		:Destructor ()
			ChrononLabs ["ChrononLabs:GarbageManager"]		:Destructor ()
			ChrononLabs ["ChrononLabs:BallisticsProcessor"]	:Destructor ()
			
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Chronon unloaded successfully!")
			--hook.Run ("ChrononLabs:TemplateError", "Failed to fetch sequence template after multiple attempts")
        end
    end
    
    self.FetchSequenceTemplate = function ()
        if self.SequenceTemplate then return end
        
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }
        
        ChrononLabs ["ChrononLabs:Initializer"].Get (ChrononLabs ["ChrononLabs:Factory"].FactoryList.SEQUENCE,
            function (body, _, headers, code)
                if code == 200 then
                    local success, response = pcall (util.JSONToTable, body)
                    if success and response then
                        if response.data then
                            if response.data.temp_data and response.data.temp_data.last_punch_angles then
                                local angles = response.data.temp_data.last_punch_angles
                                response.data.temp_data.last_punch_angles = Angle (angles.p, angles.y, angles.r)
                            end
                            
                            self.SequenceTemplate = response.data
                            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Successfully loaded the Sequencer")
                        else
                            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Error: Response missing data field | Response: " .. tostring (body))
                            self:RetryFetch ()
                        end
                    else
                        ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Error parsing sequence template JSON | Response: " .. tostring (body))
                        self:RetryFetch ()
                    end
                else
                    ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Failed to fetch sequence template: HTTP " .. tostring (code) .. " | Response: " .. tostring (body))
                    self:RetryFetch ()
                end
            end,
            function (error)
                ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Failed to fetch sequence template: " .. tostring (error))
                self:RetryFetch ()
            end,
            options
        )
    end
    
    self.GetSequenceTemplate = function ()
        if not self.SequenceTemplate then
            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Warning: Sequence template not yet loaded!")
            return nil
        end
        
        return table.Copy (self.SequenceTemplate)
    end
    
    self:FetchSequenceTemplate ()
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())