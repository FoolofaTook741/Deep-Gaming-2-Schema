local MIX = {}

MIX.Class = "chefshat"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_chefhat"
MIX.Input = {
	["util_cloth"] = {take = 3}
}

impulse.RegisterMixture(MIX)
