local MIX = {}

MIX.Class = "redpants"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_redpants"
MIX.Input = {
	["util_cloth"] = {take = 28}
}

impulse.RegisterMixture(MIX)
