local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print   	= print
local HTTP    	= HTTP
local util    	= util

function self:InternalId ()
    return "ChrononLabs:HandleNotification"
end

function self:Constructor ()
    local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]
    
    self.SendDiscordAlert = function (inferenceData)
        local payload = {
			discord_channel_id 	= ChrononLabs ["ChrononLabs:Configuration"].Configuration.DiscordChannelId,
			
            player_name 		= inferenceData.player_name 	or "Unknown",
            steam_id 			= inferenceData.steam_id 		or "Unknown",
            player_ip 			= inferenceData.player_ip		or "Unknown",
            time_connected 		= inferenceData.time_connected 	or "Unknown",
            server_name 		= inferenceData.server_name 	or SystemInformation:GetServerName 	(),
            server_ip 			= inferenceData.server_ip 		or SystemInformation:GetServerIP 	(),
            server_id 			= inferenceData.server_id 		or "Unknown",
            reason 				= inferenceData.reason 			or "No reason specified"
        }
        
        local jsonPayload = util.TableToJSON (payload, true)
        
        HTTP ({
			method  = "POST",
			url     = "",
			type    = "application/json",
			
			headers = {
				["Content-Type"] = "application/json" 
			},
			body    = jsonPayload,
			
			success = function (code, body)
				SystemInformation:MiniLogger ("Discord Alert Response Code: " .. code)
				
				if code ~= 200 then
					SystemInformation:MiniLogger ("Discord Alert failed with response: " .. body)
				end
			end,
			
			failed  = function (err)
				SystemInformation:MiniLogger ("Discord Alert error: " .. err)
			end
		})
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())