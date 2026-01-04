local MIX = {}

MIX.Class = "vorthoodie"

MIX.Level = 6
MIX.Bench = "clothing"

MIX.Output = "clo_vorthoodie"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
