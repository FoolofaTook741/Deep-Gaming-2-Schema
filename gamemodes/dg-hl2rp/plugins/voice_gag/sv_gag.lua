function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if impulse.IsGagged(talker) then return false end
end