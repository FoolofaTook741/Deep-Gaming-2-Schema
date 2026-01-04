local MIX = {}

MIX.Class = "rainboots"

MIX.Level = 5
MIX.Bench = "clothing"

MIX.Output = "clo_rainboots"
MIX.Input = {
	["util_plastic"] = {take = 4}
}

impulse.RegisterMixture(MIX)
