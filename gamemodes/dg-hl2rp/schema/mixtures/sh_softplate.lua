local MIX = {}

MIX.Class = "tier2plate"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "util_lvl2plate"
MIX.Input = {
	["util_plastic"] = {take = 6},
	["util_glue"] = {take = 2},
    ["util_cloth"] = {take = 2},
}

impulse.RegisterMixture(MIX)
