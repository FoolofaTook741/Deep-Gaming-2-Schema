local MIX = {}

MIX.Class = "redwinterjacket"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_redwinterjacket"
MIX.Input = {
	["util_cloth"] = {take = 11}
}

impulse.RegisterMixture(MIX)
