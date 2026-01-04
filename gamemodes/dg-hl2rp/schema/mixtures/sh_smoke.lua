local MIX = {}

MIX.Class = "repairedturret"

MIX.Level = 16
MIX.Bench = "tech"

MIX.Output = "wep_wsmoke"
MIX.Input = {
	["util_plastic"] = {take = 6},
    ["util_refinedmetalplate"] = {take = 4},
    ["util_paint"] = {take = 1},
	["util_electronics"] = {take = 1}
}

impulse.RegisterMixture(MIX)
