local MIX = {}

MIX.Class = "creatine"

MIX.Level = 5
MIX.Bench = "medical"

MIX.Output = "stimulant_creatine"
MIX.Input = {
	["util_medicalsupplies"] = {take = 7},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
