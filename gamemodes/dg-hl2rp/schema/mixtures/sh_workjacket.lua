local MIX = {}

MIX.Class = "workjacket"

MIX.Level = 6
MIX.Bench = "clothing"

MIX.Output = "clo_workjacket"
MIX.Input = {
	["util_cloth"] = {take = 9}
}

impulse.RegisterMixture(MIX)
