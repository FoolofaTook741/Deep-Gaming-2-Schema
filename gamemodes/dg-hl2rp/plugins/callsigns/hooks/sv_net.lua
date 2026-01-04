util.AddNetworkString("impulseHL2RPCallsignEdit")
util.AddNetworkString("impulseHL2RPCallsignsDownload")
local CS_LINE = {
	[TEAM_CP] = "CP_CS_LINE",
	[TEAM_OTA] = "OTA_CS_LINE"
}

local CS_NUM = {
	[TEAM_CP] = "CP_CS_NUM",
	[TEAM_OTA] = "OTA_CS_NUM"
}

net.Receive("impulseHL2RPCallsignEdit", function(len,ply)
	if (ply.lastTryEditCS or 0) > CurTime() then return end
	ply.lastTryEditCS = CurTime() + 2.5
	
	if not (ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA) then
		return
	end


	if ply:GetTeamRank() < 1 then
		ply:Notify("You have progressed 1 rank to get access to taglines.")
		return
	end

	local csLine = net.ReadUInt(8)
	if not csLine then return end
	local csNum  = net.ReadUInt(8)
	if not csNum then return end
	csLine = math.Clamp(math.floor(csLine), 0, 99)
	csNum = math.Clamp(math.floor(csNum), 0, 99)

	if (csLine == 5 and (csNum == 80 or csNum == 88 or csNum == 18 or csNum == 8)) and ply:Team() == TEAM_CP then
		ply:Notify("Fuck You.")
		timer.Simple(3, function()
			ply:Kick()
		end)
		return
	end

	if csNum == 69 then
		ply:Notify("Fuck You.")
		timer.Simple(3, function()
			ply:Kick()
		end)
		return
	end

	if csLine == 11 and ply:Team() == TEAM_OTA and not ply:IsCPCommand() then
		ply:Notify("This tagline is supervisor exclusive.")
		return
	end

	if csNum > 9 and ply:IsCPCommand() then
		ply:Notify("You must choose a number 0-9.")
		return
	elseif csNum < 10 and not ply:IsCPCommand() then
		ply:Notify("You must choose a number 10-99.")
		return
	end

	impulse.Teams.SetWhitelist(ply:SteamID(), CS_LINE[ply:Team()], csLine)
	impulse.Teams.SetWhitelist(ply:SteamID(), CS_NUM[ply:Team()], csNum)

	ply:Notify("You have successfully set your tagline, please reconnect to apply it.")

end)

local PROMPT_INVALID_PARAMETER  = "Uh oh! A parameter we received was invalid. Maybe restart and try again?"
local PROMPT_SIMPLE_ERROR       = "Uh oh! Something went wrong. Maybe restart and try again?"
local PROMPT_INVALID_PERMISSION = "Uh oh! You shouldn't be here..."
local PROMPT_TIMEOUT            = "Please wait before trying to download more callsigns."
local PROMPT_TARGET_NOT_FOUND   = "Uh oh! The player you attempted to search could not be found. Maybe check your search parameters?"

local TARGET_TYPE_STEAMID32 = 1
local TARGET_TYPE_STEAMID64 = 2
local TARGET_TYPE_CALLSIGN  = 3

net.Receive("impulseHL2RPCallsignsDownload", function(len, ply)

	-- Hard rate limit
	if (ply.CSDBDL_HardLimit or 0) > CurTime() then
		return
	end
	ply.CSDBDL_HardLimit = CurTime() + 0.2

	-- Soft rate limit (Time limit w/ notification)
	if (ply.CSDBDL_SoftLimit or 0) > CurTime() then
		ply:Notify( PROMPT_TIMEOUT )
		return
	end
	ply.CSDBDL_SoftLimit = CurTime() + 2

	-- NETWORKING SECURITY --
	if not ply:IsCP() or (ply:Team() == TEAM_CA) then
		ply:Notify( PROMPT_INVALID_PERMISSION )
		return
	end

	local rankDat = ply:GetTeamRankData()

	if not rankDat.callsignAuthority then
		ply:Notify( PROMPT_INVALID_PERMISSION )
		return
	end

	-- INFO: We need to package and send the callsign data

	-- This is a simple int to tell use how we want to find the 
	local iTeam       = ply:Team()
	local iTargetType = net.ReadUInt(8)
	local sKeyWord    = net.ReadString()
	local bReadFromDB = net.ReadBool()
	local tReturnData = {}

	if not (iTargetType) then
		ply:Notify( PROMPT_INVALID_PARAMETER )
		return 
	end

	if not (sKeyWord) then
		ply:Notify( PROMPT_INVALID_PARAMETER )
		return
	end

	local sWhitelistTag = (iTeam == TEAM_CP) and "CP_CS_LINE" or "OTA_CS_LINE"
	local sWhitelistNum = (iTeam == TEAM_CP) and "CP_CS_NUM"  or "OTA_CS_NUM"
	local tWhitelistTag = (iTeam == TEAM_CP) and CP_CALLSIGNS_LINES or OTA_CALLSIGNS_LINES

	-- Search based on SteamID32
	if (iTargetType == TARGET_TYPE_STEAMID32) then

		if not ( string.StartWith(sKeyWord, "STEAM_0") ) then
			ply:Notify( PROMPT_INVALID_PARAMETER )
			return
		end

		if (bReadFromDB) then
			-- run a MySQL query and callback to a net message return bfdjklhfkldsnfkljsdh
		else
			local pTarget = player.GetBySteamID(sKeyWord)
			if not (IsValid(pTarget)) then
				ply:Notify( PROMPT_TARGET_NOT_FOUND )
				return
			end
			local tCallsign = tWhitelistTag[pTarget:GetTeamWhitelist(sWhitelistTag) or 0]
			if (tCallsign) then
				local sTag = (tCallsign.NiceName or "NULL")
				local iNum = (pTarget:GetTeamWhitelist(sWhitelistNum))
				if (iNum) then
					local sNum      = tostring(iNum)
					local sCallsign = (sTag .. "-" .. sNum)
					-- My brain hurts
					tReturnData.Callsign = sCallsign
				end
			end
		end

	end

end)