local MIX = {}

MIX.Class = "portablejammer"

MIX.Level = 8
MIX.Bench = "general"

MIX.Output = "cos_portablejammer"
MIX.Input = {
	["item_jammer"] = {take = 1},
	["util_glue"] = {take = 1},
    ["util_cloth"] = {take = 3}
}

impulse.RegisterMixture(MIX)
