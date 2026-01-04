local MIX = {}

MIX.Class = "runningshoes"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_runningshoes"
MIX.Input = {
	["util_plastic"] = {take = 4}
}

impulse.RegisterMixture(MIX)
