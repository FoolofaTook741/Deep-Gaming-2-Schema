local MIX = {}

MIX.Class = "bluebeanie"

MIX.Level = 1
MIX.Bench = "clothing"

MIX.Output = "clo_bluebeanie"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
