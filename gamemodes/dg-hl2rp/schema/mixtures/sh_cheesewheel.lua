local MIX = {}

MIX.Class = "cheesewheel"

MIX.Level = 6
MIX.Bench = "stove"

MIX.Output = "meal_cheesewheel"
MIX.Input = {
	["ing_milk"] = {take = 4},
	["food_water"] = {take = 3}
}

impulse.RegisterMixture(MIX)
