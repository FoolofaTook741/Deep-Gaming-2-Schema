local MIX = {}

MIX.Class = "xenpie"

MIX.Level = 9
MIX.Bench = "stove"

MIX.Output = "meal_xenpie"
MIX.Input = {
	["util_xenextract"] = {take = 3},
	["ing_milk"] = {take = 2},
	["util_yeast"] = {take = 2}
}

impulse.RegisterMixture(MIX)
