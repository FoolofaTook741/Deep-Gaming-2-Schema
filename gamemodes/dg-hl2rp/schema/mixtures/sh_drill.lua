local MIX = {}

MIX.Class = "drill"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_drill"
MIX.Input = {
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 6},
	["util_steel"] = {take = 3},
	["util_electronics"] = {take = 7},
}

impulse.RegisterMixture(MIX)
