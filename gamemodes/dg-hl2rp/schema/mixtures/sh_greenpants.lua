local MIX = {}

MIX.Class = "greenpants"

MIX.Level = 6
MIX.Bench = "clothing"

MIX.Output = "clo_greenpants"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
