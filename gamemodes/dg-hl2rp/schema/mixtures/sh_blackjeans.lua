local MIX = {}

MIX.Class = "blackjeans"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_blackjeans"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
