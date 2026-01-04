local BENCH = {}

BENCH.Class = "research"
BENCH.Name = "Civic Workforce Research Fabricator"
BENCH.Model = "models/mosi/fallout4/furniture/workstations/robotworkbench.mdl"

function BENCH:CanUse(ply)
	if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and ply:GetTeamClass() == CLASS_RESEARCH then
		return true
	end
	
	return false
end
impulse.RegisterBench(BENCH)
