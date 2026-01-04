local MIX = {}

MIX.Class = "blueshoes"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_blueshoes"
MIX.Input = {
	["util_plastic"] = {take = 4}
}

impulse.RegisterMixture(MIX)
