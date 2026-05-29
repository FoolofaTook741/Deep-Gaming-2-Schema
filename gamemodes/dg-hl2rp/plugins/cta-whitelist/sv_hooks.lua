hook.Add("CanPlayerChangeTeam", "CanPlayerChangeTeamCTA", function(ply, teamID)
    if teamID == TEAM_OTA then
        local teamData = impulse.Teams.Data[teamID]
    
        local hasWhitelist = ply:HasTeamWhitelist("TEAM_OTA", 1) or false
        local cpRank = ply:HasTeamWhitelist("TEAM_CP", 3) or false
    
        if hasWhitelist or cpRank then
            return true
        end
    
        ply:Notify("Requires Civil Protection Rank i1+")
        return false
    end
end)