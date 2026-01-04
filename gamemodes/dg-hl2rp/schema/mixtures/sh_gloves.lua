local MIX = {}

MIX.Class = "gloves"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_gloves"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
