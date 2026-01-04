local MIX = {}

MIX.Class = "greenbeanie"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_greenbeanie"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
