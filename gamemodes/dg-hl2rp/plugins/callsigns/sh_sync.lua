function PLUGIN:CreateSyncVars()
	SYNC_CALLSIGN_LINE = impulse.Sync.RegisterVar(SYNC_INT)
	SYNC_CALLSIGN_NUM = impulse.Sync.RegisterVar(SYNC_INT)
end