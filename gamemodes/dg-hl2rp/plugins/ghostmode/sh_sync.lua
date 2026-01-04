function PLUGIN:CreateSyncVars()
    SYNC_HAL_GHOST = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_HAL_SCARY = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_HAL_GHOST_TARGET = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_HAL_GHOST_VIS = impulse.Sync.RegisterVar(SYNC_BOOL)
end