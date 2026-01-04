local MIX = {}

MIX.Class = "vortsatchel"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_vortsatchel"
MIX.Input = {
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
