local MIX = {}

MIX.Class = "coffee"

MIX.Level = 4
MIX.Bench = "stove"
MIX.XPMultiplier = 0.5

MIX.Output = "food_coffee"
MIX.Input = {
	["food_water"] = {take = 2},
	["util_coffeegrounds"] = {take = 2},

}

impulse.RegisterMixture(MIX)
