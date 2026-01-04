local MIX = {}

MIX.Class = "adderall"

MIX.Level = 3
MIX.Bench = "medical"

MIX.Output = "stimulant_adderall"
MIX.Input = {
	["util_medicalsupplies"] = {take = 5},
	["item_pillbottle"] = {take = 1},
}

impulse.RegisterMixture(MIX)
