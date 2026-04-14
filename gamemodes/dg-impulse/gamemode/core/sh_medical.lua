function meta:HasBrokenLegs()
    if SERVER then
        return impulse.BrokenLegsPlayers[self] == true
    end
    return self:GetSyncVar(SYNC_BROKENLEGS, false)
end