local BENCH = {}

BENCH.Class = "medical"
BENCH.Name = "Medicine Bench"
BENCH.Model = "models/mosi/fallout4/furniture/workstations/chemistrystation02.mdl"

function BENCH:CanUse(ply)
	if ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MEDIC then
		return true
	end
	
	return false
end
impulse.RegisterBench(BENCH)
