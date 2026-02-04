function PLUGIN:PlayerShouldGetHungry(ply)
	if ply:IsAdmin() and ply:GetMoveType() == MOVETYPE_NOCLIP then
		return false
	end
end

local function GiveAdminTools(ply)
    if ply:IsAdmin() then
        ply:Give("weapon_physgun")
        ply:Give("gmod_tool")
        ply:Give("impulse_hands")
    end
end

hook.Add("PlayerSpawn", "GiveAdminToolsOnSpawn", GiveAdminTools)

hook.Add("OnPlayerChangedTeam", "GiveAdminToolsOnTeamChange", function(ply, oldTeam, newTeam)
    timer.Simple(0.1, function()
        if IsValid(ply) then
            GiveAdminTools(ply)
        end
    end)
end)