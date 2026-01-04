local MIX = {}

MIX.Class = "vortcloak"

MIX.Level = 4
MIX.Bench = "clothing"

MIX.Output = "clo_vortcloak"
MIX.Input = {
	["util_cloth"] = {take = 4}
}

impulse.RegisterMixture(MIX)
