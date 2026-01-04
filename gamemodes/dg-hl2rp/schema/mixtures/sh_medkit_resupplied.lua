local MIX = {}

MIX.Class = "resupplied_medkit"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "wep_medkit"
MIX.Input = {
	["util_medicalsupplies"] = {take = 5},
	["item_emptymedkit"] = {take = 1},
}

impulse.RegisterMixture(MIX)
