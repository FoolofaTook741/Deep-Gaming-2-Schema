function PLUGIN:CreateSyncVars()
    SYNC_GASSED = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_FLASHED = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_STUNNED = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_KNOCKEDOUT = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_KNOCKOUT_ENDS = impulse.Sync.RegisterVar(SYNC_BIGINT)
end