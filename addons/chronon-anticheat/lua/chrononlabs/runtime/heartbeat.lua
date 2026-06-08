local self   	= {}
local ipairs 	= ipairs
local http   	= http
local string 	= string
local util   	= util
local tostring 	= tostring
local os		= os
local jit		= jit
local engine	= engine
local player	= player
local game		= game

function self:InternalId ()
    return "ChrononLabs:Health"
end

function self:Constructor ()
	local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]
	
    self.ProcessError = function (errorLogged, realm, stack, name, addon_id)
        if not string.find (errorLogged, "chronon") and not string.find (errorLogged, "ChrononLabs") then
            return
        end
        
        local data = {
            error          = errorLogged,
            stack          = util.TableToJSON (stack, false),
            realm          = realm,
            addon          = addon_id or 0,
            gamemode       = engine.ActiveGamemode (),
            gmv            = VERSIONSTR,
            os             = jit.os,
            addon_name     = name or "chronon-anticheatx",
            time           = os.time (),
            player_count   = tostring (player.GetCount () .. " / " .. game.MaxPlayers ()),
            server_name    = SystemInformation:GetServerName (),
            server_ip      = SystemInformation:GetServerIP ()
        }
        
        local options = {
            ["Token"] = ChrononLabs ["ChrononLabs:Configuration"].Configuration.ServerAPIToken
        }
        
        SystemInformation.Push (ChrononLabs ["ChrononLabs:Factory"].GetFactory ("app/gmod/health.php"), data,
            function (body)
                SystemInformation:MiniLogger ("Error logged successfully", true)
            end,
            
            function (err)
                SystemInformation:MiniLogger ("Failed to log error: " .. err, true)
            end,
            options
        )
    end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())