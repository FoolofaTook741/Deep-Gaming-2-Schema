local MIX = {}

MIX.Class = "browntrenchcoat"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_browntrenchcoat"
MIX.Input = {
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
