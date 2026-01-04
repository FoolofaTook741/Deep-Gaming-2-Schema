local MIX = {}

MIX.Class = "silverjacket"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_silverjacket"
MIX.Input = {
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
