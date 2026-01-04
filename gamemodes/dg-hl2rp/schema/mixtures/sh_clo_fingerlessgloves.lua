local MIX = {}

MIX.Class = "fingerlessgloves"

MIX.Level = 9
MIX.Bench = "clothing"

MIX.Output = "clo_fingerlessgloves"
MIX.Input = {
	["util_cloth"] = {take = 1}
}

impulse.RegisterMixture(MIX)
