util.AddNetworkString("impulseGhostTarget")
util.AddNetworkString("impulseGhostMessage")
util.AddNetworkString("impulseGhostVisible")
util.AddNetworkString("impulseGhostReality")
function meta:GhostMode(isGhost)
    self:SetSyncVar(SYNC_HAL_GHOST, isGhost, true)

    if isGhost then
        self:SetHealth(99999)
        self:SetModel("models/player/gman_high.mdl")
        self:SetLocalSyncVar(SYNC_HUNGER, 255)
        self:SetSyncVar(SYNC_RPNAME, "", true)
        self:SetSyncVar(SYNC_INCOGNITO, true, true)
    else
        self:SetSyncVar(SYNC_RPNAME, self.defaultRPName, true)
        self:SetSyncVar(SYNC_INCOGNITO, false, true)
        self:Spawn()
    end
end

SCARY_WORLDERS = {}

function PLUGIN:PlayerCanHearPlayersVoice(listener,talker)
    if listener.InScaryWorld then
        if not (talker.InScaryWorld) then
            listener.CanHear[talker] = false
        end
    end
    if talker.InScaryWorld then
        if not (listener.InScaryWorld) then
            listener.CanHear[talker] = false
        end
    end
end