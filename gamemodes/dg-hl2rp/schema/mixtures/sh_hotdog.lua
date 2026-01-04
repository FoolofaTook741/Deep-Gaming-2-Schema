local MIX = {}

MIX.Class = "hotdog"

MIX.Level = 3
MIX.Bench = "stove"

MIX.Output = "food_hotdog"
MIX.Input = {
	["util_meat"] = {take = 1},
	["food_bread"] = {take = 1}
}

impulse.RegisterMixture(MIX)
