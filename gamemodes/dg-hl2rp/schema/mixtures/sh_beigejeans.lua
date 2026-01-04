local MIX = {}

MIX.Class = "beigejeans"

MIX.Level = 1
MIX.Bench = "clothing"

MIX.Output = "clo_beigejeans"
MIX.Input = {
	["util_cloth"] = {take = 3}
}

impulse.RegisterMixture(MIX)
