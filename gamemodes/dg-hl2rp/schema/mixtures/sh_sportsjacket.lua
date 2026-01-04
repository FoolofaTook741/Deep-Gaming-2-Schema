local MIX = {}

MIX.Class = "sportsjacket"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_sportsjacket"
MIX.Input = {
	["util_cloth"] = {take = 7}
}

impulse.RegisterMixture(MIX)
