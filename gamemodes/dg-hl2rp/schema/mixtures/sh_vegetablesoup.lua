local MIX = {}

MIX.Class = "veggiesoup"

MIX.Level = 9
MIX.Bench = "stove"

MIX.Output = "food_vegetablesoup"
MIX.Input = {
	["food_carrot"] = {take = 3},
	["util_potato"] = {take = 3},
	["food_tomato"] = {take = 3}
}

impulse.RegisterMixture(MIX)
