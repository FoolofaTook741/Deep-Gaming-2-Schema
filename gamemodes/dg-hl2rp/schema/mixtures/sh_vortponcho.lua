local MIX = {}

MIX.Class = "vortponcho"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_vortponcho"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
