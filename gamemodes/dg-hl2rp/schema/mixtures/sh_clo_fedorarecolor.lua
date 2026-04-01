local MIX = {}

MIX.Class = "fedorarecolor"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_fedorarecolor"
MIX.Input = {
	["util_cloth"] = {take = 7}
}

impulse.RegisterMixture(MIX)
