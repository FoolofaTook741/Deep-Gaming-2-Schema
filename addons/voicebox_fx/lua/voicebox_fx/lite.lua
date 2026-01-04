local function LiteFunc(a, b)
	if __VoiceBox_Lite_EngineCheck then return nil end
	__VoiceBox_Lite_EngineCheck = true
	local ret = VoiceBox.Lite.PlayerCanHearPlayersLocalVoice(a:EntIndex(), b:EntIndex())
	__VoiceBox_Lite_EngineCheck = false
	return ret
end
if VoiceBox.Lite then
	VoiceBox.FX.__PlayerCanHearPlayersVoice = LiteFunc
else
	hook.Add("VoiceBox.Lite", "VoiceBox.FX", function()
		VoiceBox.FX.__PlayerCanHearPlayersVoice = LiteFunc
	end)

	VoiceBox.FX.__PlayerCanHearPlayersVoice = function(a, b)
		if __VoiceBox_Lite_EngineCheck then return nil end
		__VoiceBox_Lite_EngineCheck = true
		local ret = GAMEMODE:PlayerCanHearPlayersVoice(a, b)
		__VoiceBox_Lite_EngineCheck = false
		return ret
	end
end