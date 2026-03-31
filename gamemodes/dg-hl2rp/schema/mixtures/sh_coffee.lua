local MIX = {}

MIX.Class = "coffee"

MIX.Level = 1
MIX.Bench = "stove"
MIX.XPMultiplier = 0.5
MIX.Multi = true --use to allow multiple outputs of a single item when crafting  ex. how this allows 4 coffees instead of one
MIX.Amount = 4 --set the amount so that the ui is properly updated

MIX.Outputs = { "food_coffee", "food_coffee", "food_coffee", "food_coffee" }
MIX.Input = {
	["food_water"] = {take = 2},
	["util_coffeegrounds"] = {take = 2},

}

impulse.RegisterMixture(MIX)
