local MIX = {}

MIX.Class = "greenjacket"

MIX.Level = 6
MIX.Bench = "clothing"

MIX.Output = "clo_greenjacket"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
