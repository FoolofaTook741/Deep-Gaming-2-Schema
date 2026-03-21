local MIX = {}

MIX.Class = "windbreaker"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_windbreaker"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
