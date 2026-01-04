local MIX = {}

MIX.Class = "confederate"

MIX.Level = 4
MIX.Bench = "clothing"

MIX.Output = "clo_confederate"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
