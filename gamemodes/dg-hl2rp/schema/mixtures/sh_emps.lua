local MIX = {}

MIX.Class = "suemp"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "item_suemp"
MIX.Input = {
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 4},
	["util_electronics"] = {take = 1},
	["util_pipe"] = {take = 1}
}

impulse.RegisterMixture(MIX)