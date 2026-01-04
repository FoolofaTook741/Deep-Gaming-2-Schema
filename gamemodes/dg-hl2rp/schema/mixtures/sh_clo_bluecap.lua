local MIX = {}

MIX.Class = "bluecap"

MIX.Level = 1
MIX.Bench = "clothing"

MIX.Output = "clo_bluecap"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
