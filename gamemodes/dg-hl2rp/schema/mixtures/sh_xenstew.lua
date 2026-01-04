local MIX = {}

MIX.Class = "xenstew"

MIX.Level = 7
MIX.Bench = "stove"

MIX.Output = "food_xenstew"
MIX.Input = {
	["util_xenextract"] = {take = 2},
	["food_water"] = {take = 3}
}

impulse.RegisterMixture(MIX)
