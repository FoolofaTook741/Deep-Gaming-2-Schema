local MIX = {}

MIX.Class = "meatglue"

MIX.Level = 2
MIX.Bench = "general"

MIX.Output = "util_glue"
MIX.Input = {
	["food_suspiciousmeat"] = {take = 1},
}

impulse.RegisterMixture(MIX)
