local MIX = {}

MIX.Class = "machineresin"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "resin_machineready"
MIX.Input = {
	["util_resin"] = {take = 25}
}

impulse.RegisterMixture(MIX)
