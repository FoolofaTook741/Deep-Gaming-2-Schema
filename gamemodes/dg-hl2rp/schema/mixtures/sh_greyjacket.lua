local MIX = {}

MIX.Class = "greyjacket"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_greyjacket"
MIX.Input = {
	["util_cloth"] = {take = 11}
}

impulse.RegisterMixture(MIX)
