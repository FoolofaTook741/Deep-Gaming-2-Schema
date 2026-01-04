local MIX = {}

MIX.Class = "pizza"

MIX.Level = 7
MIX.Bench = "stove"

MIX.Output = "meal_pizza"
MIX.Input = {
	["food_tomato"] = {take = 3},
	["util_meat"] = {take = 2},
	["util_yeast"] = {take = 2}
}

impulse.RegisterMixture(MIX)
