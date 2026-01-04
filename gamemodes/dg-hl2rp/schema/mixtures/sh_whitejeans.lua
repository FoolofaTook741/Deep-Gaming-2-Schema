local MIX = {}

MIX.Class = "whitejeans"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_whitejeans"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
