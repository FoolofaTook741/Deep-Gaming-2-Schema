local MIX = {}

MIX.Class = "rebeluniform"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "useable_resuniform"
MIX.Input = {
	["util_cloth"] = {take = 6},
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 6}
}

impulse.RegisterMixture(MIX)
