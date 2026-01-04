local MIX = {}

MIX.Class = "vortbackpack"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_vortbackpack"
MIX.Input = {
	["util_cloth"] = {take = 8}
}

impulse.RegisterMixture(MIX)
