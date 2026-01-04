-- Little optimization for something that really shouldn't be O(n)

local PLAYER = FindMetaTable("Player")

if PLAYER.UserID and debug.getinfo(PLAYER.UserID).short_src == "[C]" then
	VOICEBOX_FX_PLAYER_USERID = VOICEBOX_FX_PLAYER_USERID or PLAYER.UserID

	function PLAYER:UserID()
		return self.__VoiceBox_UserID or VOICEBOX_FX_PLAYER_USERID(self)
	end

	local function cache(ply)
		ply.__VoiceBox_UserID = VOICEBOX_FX_PLAYER_USERID(ply)
	end
	hook.Add("PlayerInitialSpawn", "VoiceBox.FX.UserIDCache", cache)
	hook.Add("PlayerAuthed", "VoiceBox.FX.UserIDCache", cache)
end