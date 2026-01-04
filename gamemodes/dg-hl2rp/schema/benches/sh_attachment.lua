local BENCH = {}

BENCH.Class = "attachment"
BENCH.Name = "Attachment Workbench"
BENCH.Desc = "Can be used to create modifications for your weapons."
BENCH.Model = "models/ammoworkbench.mdl"
BENCH.Illegal = true
BENCH.Skill = "medical"

impulse.RegisterBench(BENCH)
