local MIX = {}

MIX.Class = "blackjacket"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_blackjacket"
MIX.Input = {
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
