local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local util      = util
local table     = table
local timer     = timer
local pcall		= pcall
local Kick		= Kick

function self:InternalId ()
    return "ChrononLabs:InferenceEngine"
end

function self:Constructor ()
	local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]

    self.QueueConfig = {
        maxRetries 		= 480,
        retryDelay 		= 180,
        maxQueueSize 	= 128
    }
    
    self.PlayerQueues = {}
    
    self.InitPlayerQueue = function (steamId)
        if not self.PlayerQueues [steamId] then
            self.PlayerQueues [steamId] = {
                items = {},
                processing = false,
                failureCount = 0
            }
        end
        return self.PlayerQueues [steamId]
    end
    
    self.EnqueueRequest = function (batchData, callback)
        local steamId = batchData.steam_id
        if not steamId then
            SystemInformation:MiniLogger ("Error: No steam_id in batch data")
            return
        end
        
        local playerQueue = self.InitPlayerQueue (steamId)
        
        if #playerQueue.items >= self.QueueConfig.maxQueueSize then
            SystemInformation:MiniLogger ("Warning: Player queue is full for " .. steamId .. ", dropping oldest request")
            table.remove (playerQueue.items, 1)
        end
        
        table.insert (playerQueue.items, {
            batchData = batchData,
            callback = callback,
            retries = 0
        })
        
        if not playerQueue.processing then
            self.ProcessQueue (steamId)
        end
    end
    
    self.ProcessQueue = function (steamId)
        local playerQueue = self.PlayerQueues [steamId]
        if not playerQueue or #playerQueue.items == 0 or playerQueue.processing then
            return
        end
        
        playerQueue.processing = true
        local currentItem = playerQueue.items [1]
        
		local details = {
			player_name     = currentItem.batchData.player_name 	or 	"Unknown",
			steam_id        = currentItem.batchData.steam_id 		or 	"Unknown",
			player_ip       = currentItem.batchData.player_ip		or 	"Unknown",
			time_connected  = currentItem.batchData.time_connected 	or	"Unknown",
			server_name     = SystemInformation:GetServerName ()	or 	"Unknown",
			server_ip       = SystemInformation:GetServerIP   ()	or	"Unknown",
			server_id       = currentItem.batchData.server_id 		or 	"Unknown",
		}
		
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }
        
        local jsonPayload = util.TableToJSON (currentItem.batchData, true)
		local jsonDetails = util.TableToJSON (details, true)
		
        local function onSuccess (body, _, _, code)
            SystemInformation:MiniLogger ("HTTP Response Code: " .. code, true)

            if not self.PlayerQueues [steamId] then
                SystemInformation:MiniLogger ("Player " .. steamId .. " queue no longer exists, ignoring response", true)
                return
            end

            if code == 200 then
                local success, response = pcall (util.JSONToTable, body)
                if success and response then
                    if response.data then
                        playerQueue.failureCount = 0

                        if currentItem.callback then
                            currentItem.callback (response.data)
                        end

                        table.remove (playerQueue.items, 1)
                        playerQueue.processing = false
                        self.ProcessQueue (steamId)
                    else
                        self.HandleFailure (steamId, "No data field in response: " .. util.TableToJSON (response))
                    end
                else
                    self.HandleFailure (steamId, "Error parsing response: " .. tostring (body))
                end
            else
                self.HandleFailure (steamId, "Request failed with code: " .. code .. " | Response: " .. tostring (body))
            end
        end
        
        local function onError (err)
            self.HandleFailure (steamId, "Request error: " .. tostring (err))
        end

		ChrononLabs ["ChrononLabs:Initializer"].Push (ChrononLabs ["ChrononLabs:Factory"].FactoryList.PREDICT,
            {
                data 	= jsonPayload,
				details = jsonDetails
            },
            onSuccess,
            onError,
            options
        )
    end
    
    self.HandleFailure = function (steamId, errorMessage)
        SystemInformation:MiniLogger ("Player " .. steamId .. ": " .. errorMessage)

        local playerQueue = self.PlayerQueues [steamId]
        if not playerQueue then
            SystemInformation:MiniLogger ("Player " .. steamId .. " queue no longer exists, ignoring failure", true)
            return
        end

        local currentItem = playerQueue.items [1]
        playerQueue.failureCount = playerQueue.failureCount + 1
        
        if playerQueue.failureCount >= self.QueueConfig.maxRetries then
            SystemInformation:MiniLogger ("Critical: Maximum consecutive failures reached for player " .. steamId)
            
            local ply = player.GetBySteamID (steamId)
            if IsValid (ply) then
				self.PlayerQueues [steamId] = {
                    items 			= {},
                    processing 		= false,
                    failureCount 	= 0
                }

                --ply:Kick ("Chronon: Connection timeout. Failed to process player data after multiple consecutive attempts.") Not required in Beta.

				SystemInformation:MiniLogger ("Critical: Player " .. steamId .. " was kicked due to exceeding the maximum allowed data processing failures.")
            end
            
            return
        end

        if currentItem.retries < self.QueueConfig.maxRetries then
            currentItem.retries = currentItem.retries + 1
            SystemInformation:MiniLogger (string.format (
                "Player %s: Retrying request (%d/%d) in %d seconds...",
                steamId,
                currentItem.retries,
                self.QueueConfig.maxRetries,
                self.QueueConfig.retryDelay
            ))

            timer.Simple (self.QueueConfig.retryDelay, function ()
                if self.PlayerQueues [steamId] then
                    self.PlayerQueues [steamId].processing = false
                    self.ProcessQueue (steamId)
                end
            end)
        else
            SystemInformation:MiniLogger ("Request failed after maximum retries for player " .. steamId .. ", keeping in queue")
            playerQueue.processing = false
        end
    end
    
    self.ProcessInference = function (batchData, callback)
        self.EnqueueRequest (batchData, callback)
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())