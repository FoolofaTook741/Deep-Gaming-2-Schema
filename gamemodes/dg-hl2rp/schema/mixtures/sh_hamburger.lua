local MIX = {}

MIX.Class = "burger"

MIX.Level = 5
MIX.Bench = "stove"

MIX.Output = "food_hamburger"
MIX.Input = {
	["util_meat"] = {take = 1},
	["food_bread"] = {take = 1},
	["food_apple"] = {take = 2}
}

impulse.RegisterMixture(MIX)
