local MIX = {}

MIX.Class = "vortlabcoat"

MIX.Level = 7
MIX.Bench = "clothing"

MIX.Output = "clo_vortlabcoat"
MIX.Input = {
	["util_cloth"] = {take = 5}
}

impulse.RegisterMixture(MIX)
