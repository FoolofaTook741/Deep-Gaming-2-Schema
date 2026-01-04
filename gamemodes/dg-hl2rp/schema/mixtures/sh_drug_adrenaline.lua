local MIX = {}

MIX.Class = "adrenaline"

MIX.Level = 2
MIX.Bench = "medical"

MIX.Output = "stimulant_adrenaline"
MIX.Input = {
	["util_medicalsupplies"] = {take = 2},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
