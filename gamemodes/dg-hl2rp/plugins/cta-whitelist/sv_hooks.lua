hook.Add("CanPlayerChangeTeam", "CanPlayerChangeTeamCTA", function(ply, teamID)
    if teamID == TEAM_OTA then
        local teamData = impulse.Teams.Data[teamID]
    
        local hasWhitelist = ply:HasTeamWhitelist("TEAM_OTA", RANK_CGR) or false
        local cpRank = ply:HasTeamWhitelist("TEAM_CP", RANK_I1) or false
    
        if hasWhitelist then
            return
        elseif cpRank then
            impulse.Teams.SetWhitelist(ply:SteamID(), "TEAM_OTA", RANK_CGR)
            return
        end
    
        ply:Notify("Requires Civil Protection Rank i1+")
        return false
    end
end)