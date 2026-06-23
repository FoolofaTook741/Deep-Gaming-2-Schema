if ChrononLabs ["ChrononLabs:SystemDispatcher"]:GetStateStatus (CLIENT) then
	return
end

local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print

function self:InternalId ()
	return "ChrononLabs:PlayerSession"
end

function self:Constructor ()
	self.PlayerSession = self.PlayerSession or {}
end

function self:CreatePlayerSession (ply)
	if not ply or not ChrononLabs ["ChrononLabs:ProgramLogs"]:IsPlayerValid_ (ply) then
		ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Denied session creation due to invalid player.")
		
		return 
	end
	
	local playerName 		= ply:SteamName () or ply:Nick() or ply:Name () or "Unknown"
	local playerId	 		= ply:SteamID 	()
	local uniquePlayerId 	= ply:SteamID64 ()
	
	if not self.PlayerSession [uniquePlayerId] then
		self.PlayerSession [uniquePlayerId] = 
		{
			["TotalCount"] 	= 0,
			["TotalSize"]	= 0,
			["Seed"]		= CurTime (),
			["Constructor"]	= "",
		}
	end
	
	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Created player " .. playerName .. " (" .. playerId .. ")'s session.")
end

function self:DestroyPlayerSession (ply)
	if not ply or not ChrononLabs ["ChrononLabs:ProgramLogs"]:IsPlayerValid_ (ply) then
		ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Denied session destruction due to invalid player.")
		
		return 
	end
	
	local playerName 		= ply:SteamName () or ply:Nick() or ply:Name () or "Unknown"
	local playerId	 		= ply:SteamID 	()
	local uniquePlayerId 	= ply:SteamID64 ()
	
	if not self.PlayerSession [uniquePlayerId] then
		return
	end
	
	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Destroyed player " .. playerName .. " (" .. playerId .. ")'s session.")
	self.PlayerSession [uniquePlayerId] = nil
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
