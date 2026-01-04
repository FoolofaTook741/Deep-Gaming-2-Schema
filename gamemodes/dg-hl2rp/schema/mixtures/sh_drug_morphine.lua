local MIX = {}

MIX.Class = "drug_morphine"

MIX.Level = 6
MIX.Bench = "medical"

MIX.Output = "stimulant_morphine"
MIX.Input = {
	["util_medicalsupplies"] = {take = 8},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
