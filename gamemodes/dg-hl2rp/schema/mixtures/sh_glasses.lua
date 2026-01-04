local MIX = {}

MIX.Class = "glasses"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_glasses"
MIX.Input = {
	["util_plastic"] = {take = 3}
}

impulse.RegisterMixture(MIX)
