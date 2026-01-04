local MIX = {}

MIX.Class = "tier2"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "cos_lightvest"
MIX.Input = {
	["util_cloth"] = {take = 2},
	["util_glue"] = {take = 1},
	["util_lvl2plate"] = {take = 1}
}

impulse.RegisterMixture(MIX)
