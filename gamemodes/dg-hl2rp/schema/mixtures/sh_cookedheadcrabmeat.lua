local MIX = {}

MIX.Class = "cookedheadcrab"

MIX.Level = 7
MIX.Bench = "stove"

MIX.Output = "food_cookedheadcrabmeat"
MIX.Input = {
	["util_rawheadcrabmeat"] = {take = 1},
	["util_salt"] = {take = 2},
	["util_cookingoil"] = {take = 1}
}

impulse.RegisterMixture(MIX)
