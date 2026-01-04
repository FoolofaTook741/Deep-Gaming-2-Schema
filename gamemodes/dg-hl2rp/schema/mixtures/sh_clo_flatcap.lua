local MIX = {}

MIX.Class = "bluebeanie"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_flatcap"
MIX.Input = {
	["util_cloth"] = {take = 5}
}

impulse.RegisterMixture(MIX)
