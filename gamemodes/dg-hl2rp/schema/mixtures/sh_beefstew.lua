local MIX = {}

MIX.Class = "beefstew"

MIX.Level = 8
MIX.Bench = "stove"

MIX.Output = "meal_beefstew"
MIX.Input = {
	["util_meat"] = {take = 2},
	["util_potato"] = {take = 4},
	["food_carrot"] = {take = 4}
}

impulse.RegisterMixture(MIX)
