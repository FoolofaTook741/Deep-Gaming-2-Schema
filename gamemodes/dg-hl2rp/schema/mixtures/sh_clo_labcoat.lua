local MIX = {}

MIX.Class = "labcoat"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_labcoat"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
