local MIX = {}

MIX.Class = "flannelshirt"

MIX.Level = 6
MIX.Bench = "clothing"

MIX.Output = "clo_flannelshirt"
MIX.Input = {
	["util_cloth"] = {take = 12}
}

impulse.RegisterMixture(MIX)
