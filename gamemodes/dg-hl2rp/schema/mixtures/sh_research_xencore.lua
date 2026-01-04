local MIX = {}

MIX.Class = "xencore"

MIX.Level = 1
MIX.Bench = "research"

MIX.Output = "research_xencore"
MIX.Input = {
	["research_xenmatter"] = {take = 2},
    ["util_medicalsupplies"] = {take = 3},
    ["food_water"] = {take = 1},
    ["util_metalplate"] = {take = 4},
}

impulse.RegisterMixture(MIX)
