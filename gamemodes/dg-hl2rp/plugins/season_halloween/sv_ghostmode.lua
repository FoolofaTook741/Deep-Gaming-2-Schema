util.AddNetworkString("impulseGhostTarget")
util.AddNetworkString("impulseGhostMessage")

function meta:GhostMode(isGhost)
    self:SetSyncVar(SYNC_HAL_GHOST, isGhost, true)

    if isGhost then
        self:SetHealth(99999)
        self:SetModel("models/player/sniper elite 3/skeleton_playermodel.mdl")
        self:SetBodygroup(3,1)
        self:SetLocalSyncVar(SYNC_HUNGER, 255)
        self:SetSyncVar(SYNC_RPNAME, "", true)
        self:SetSyncVar(SYNC_INCOGNITO, true, true)
    else
        self:SetSyncVar(SYNC_RPNAME, self.defaultRPName, true)
        self:SetSyncVar(SYNC_INCOGNITO, false, true)
        self:Spawn()
    end
end