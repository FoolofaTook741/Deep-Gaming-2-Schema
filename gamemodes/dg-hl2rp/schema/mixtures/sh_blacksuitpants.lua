local MIX = {}

MIX.Class = "blacksuitpants"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_blacksuitpants"
MIX.Input = {
	["util_cloth"] = {take = 28}
}

impulse.RegisterMixture(MIX)
