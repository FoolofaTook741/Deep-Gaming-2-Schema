local MIX = {}

MIX.Class = "xenmatter"

MIX.Level = 1
MIX.Bench = "research"

MIX.Output = "research_xenmatter"
MIX.Input = {
	["research_xensample"] = {take = 3},
    ["research_solution"] = {take = 1},
}

impulse.RegisterMixture(MIX)
