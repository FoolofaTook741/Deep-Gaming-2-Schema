local MIX = {}

MIX.Class = "satchel"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_satchel"
MIX.Input = {
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
