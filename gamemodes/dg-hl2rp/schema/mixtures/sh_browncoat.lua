local MIX = {}

MIX.Class = "browncoat"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_browncoat"
MIX.Input = {
	["util_cloth"] = {take = 8}
}

impulse.RegisterMixture(MIX)
