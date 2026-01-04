local MIX = {}

MIX.Class = "blackshoes"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_blackshoes"
MIX.Input = {
	["util_plastic"] = {take = 4}
}

impulse.RegisterMixture(MIX)
