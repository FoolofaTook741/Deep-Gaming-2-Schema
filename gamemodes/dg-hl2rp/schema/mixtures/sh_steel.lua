local MIX = {}

MIX.Class = "steel"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "util_steel"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 2},
	["util_glue"] = {take = 1}
}

impulse.RegisterMixture(MIX)
