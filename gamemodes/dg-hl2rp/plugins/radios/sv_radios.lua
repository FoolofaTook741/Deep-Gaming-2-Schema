function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    local talkActive   = talker:GetSyncVar(SYNC_RADIO_TALK,    false)
    local listenActive = listener:GetSyncVar(SYNC_RADIO_LISTEN, false)
    local chan         = talker:GetSyncVar(SYNC_RADIO_CHANNEL,  1)
    local lchan = listener:GetSyncVar(SYNC_RADIO_CHANNEL, 1)

    if not talkActive or not listenActive then
        return
    end

    if chan == 1 and lchan == 1 then
        -- PT: same squad only
        local ts = talker:GetSyncVar(SYNC_SQUAD_ID, 0)
        local ls = listener:GetSyncVar(SYNC_SQUAD_ID, 0)
        if ts ~= 0 and ts == ls then
            return true
        else
            return false
        end

    elseif chan == 2 and lchan == 2 then
        -- MPF->MPF OR CTA->CTA
        local tT, lT = talker:Team(), listener:Team()
        if (tT == TEAM_CP or tT == TEAM_OTA) and lT == tT then
            return true
        else
            return false
        end

    elseif chan == 3 and lchan == 3 then
        -- COMMAND: MPF+CTA
        local tT, lT = talker:Team(), listener:Team()
        if (tT == TEAM_CP or tT == TEAM_OTA) and
           (lT == TEAM_CP or lT == TEAM_OTA) then
            return true
        else
            return false
        end
    end

    -- unknown channel: default to proximity
    return
end

hook.Add("OnPlayerChangedTeam", "Radio_ClearListenOnTeamChange", function(ply, oldTeam, newTeam)
    if SERVER and IsValid(ply) then
        ply:SetSyncVar(SYNC_RADIO_LISTEN, false, true)
    end
end)
