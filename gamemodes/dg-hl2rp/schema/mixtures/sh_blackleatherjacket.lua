local MIX = {}

MIX.Class = "blackleatherjacket"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_blackleatherjacket"
MIX.Input = {
	["util_cloth"] = {take = 9}
}

impulse.RegisterMixture(MIX)
