local MIX = {}

MIX.Class = "beanie"

MIX.Level = 2
MIX.Bench = "clothing"

MIX.Output = "clo_beanie"
MIX.Input = {
	["util_cloth"] = {take = 2}
}

impulse.RegisterMixture(MIX)
