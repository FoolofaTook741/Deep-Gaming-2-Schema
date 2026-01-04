local MIX = {}

MIX.Class = "fedora"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_fedora"
MIX.Input = {
	["util_cloth"] = {take = 7}
}

impulse.RegisterMixture(MIX)
