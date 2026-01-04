local MIX = {}

MIX.Class = "winterjacket"

MIX.Level = 8
MIX.Bench = "clothing"

MIX.Output = "clo_winterjacket"
MIX.Input = {
	["util_cloth"] = {take = 11}
}

impulse.RegisterMixture(MIX)
