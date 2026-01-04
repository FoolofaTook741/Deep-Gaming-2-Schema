local MIX = {}

MIX.Class = "boonie"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_boonie"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
