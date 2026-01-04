local MIX = {}

MIX.Class = "redsuit"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_redsuit"
MIX.Input = {
	["util_cloth"] = {take = 35}
}

impulse.RegisterMixture(MIX)
