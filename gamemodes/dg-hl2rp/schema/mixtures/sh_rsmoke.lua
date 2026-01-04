local MIX = {}

MIX.Class = "rsmoke"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "wep_rsmoke"
MIX.Input = {
	["util_paint"] = {take = 3},
	["util_glue"] = {take = 3},
    ["util_plastic"] = {take = 6}
}

impulse.RegisterMixture(MIX)
