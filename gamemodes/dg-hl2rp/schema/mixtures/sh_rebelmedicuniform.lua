local MIX = {}

MIX.Class = "rebelmedicuniform"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "useable_medicuniform"
MIX.Input = {
	["util_cloth"] = {take = 3},
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 10}
}

impulse.RegisterMixture(MIX)
