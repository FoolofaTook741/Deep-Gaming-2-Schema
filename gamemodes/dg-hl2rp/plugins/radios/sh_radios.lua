function PLUGIN:CreateSyncVars()
	SYNC_RADIO_LISTEN = impulse.Sync.RegisterVar(SYNC_BOOL)
	SYNC_RADIO_TALK = impulse.Sync.RegisterVar(SYNC_BOOL)
	SYNC_RADIO_CHANNEL = impulse.Sync.RegisterVar(SYNC_INT)
end

function PLUGIN:StartVoice(ply, plyIndex)
	if ply:GetSyncVar(SYNC_RADIO_ACTIVE, false) then
		ply:AddVoiceFX("Radio")
	end
end

function PLUGIN:EndVoice(ply, plyIndex)
	if ply:GetSyncVar(SYNC_RADIO_ACTIVE, false) then
		ply:RemoveVoiceFX("Radio")
	end
end