local MIX = {}

MIX.Class = "drug_steroids"

MIX.Level = 6
MIX.Bench = "medical"

MIX.Output = "stimulant_steroids"
MIX.Input = {
	["util_medicalsupplies"] = {take = 7},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
