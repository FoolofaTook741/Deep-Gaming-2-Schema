local BENCH = {}


BENCH.Class = "cwu"
BENCH.Name = "CWU Workbench"
BENCH.Desc = "Can be used to craft more interesting items."
BENCH.Model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl"
BENCH.Illegal = true
BENCH.NotIllegalFor = {TEAM_CWU}

impulse.RegisterBench(BENCH)
