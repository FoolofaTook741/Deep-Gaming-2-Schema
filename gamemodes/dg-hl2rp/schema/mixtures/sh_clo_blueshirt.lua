local MIX = {}

MIX.Class = "blueshirt"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_blueshirt"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
