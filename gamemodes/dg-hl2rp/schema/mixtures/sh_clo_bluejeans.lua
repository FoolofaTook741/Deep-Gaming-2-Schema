local MIX = {}

MIX.Class = "bluejeans"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_bluejeans"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
