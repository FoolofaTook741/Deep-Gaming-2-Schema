function PLUGIN:CreateSyncVars()
	SYNC_CWU_SQUAD = impulse.Sync.RegisterVar(SYNC_INT)
	SYNC_CWU_SQUADLEAD = impulse.Sync.RegisterVar(SYNC_BOOL)
end