local MIX = {}

MIX.Class = "blackgreenjacket"

MIX.Level = 11
MIX.Bench = "clothing"

MIX.Output = "clo_blackgreenjacket"
MIX.Input = {
	["util_cloth"] = {take = 8}
}

impulse.RegisterMixture(MIX)
