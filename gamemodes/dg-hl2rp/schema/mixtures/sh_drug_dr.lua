local MIX = {}

MIX.Class = "drug_dr"

MIX.Level = 10
MIX.Bench = "medical"

MIX.Output = "stimulant_dr"
MIX.Input = {
	["util_medicalsupplies"] = {take = 14},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
