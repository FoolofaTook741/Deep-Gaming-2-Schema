local MIX = {}

MIX.Class = "backpack"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_backpack"
MIX.Input = {
	["util_cloth"] = {take = 8}
}

impulse.RegisterMixture(MIX)
