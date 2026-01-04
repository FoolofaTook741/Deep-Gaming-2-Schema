local MIX = {}

MIX.Class = "antlionmeat"

MIX.Level = 6
MIX.Bench = "stove"

MIX.Output = "food_cookedantlionmeat"
MIX.Input = {
	["util_rawantlionmeat"] = {take = 1},
	["util_salt"] = {take = 2},
	["util_cookingoil"] = {take = 1}
}

impulse.RegisterMixture(MIX)
