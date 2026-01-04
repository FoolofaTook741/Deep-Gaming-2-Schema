local MIX = {}

MIX.Class = "detonator"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "item_ieddetonator"
MIX.Input = {
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 10},
	["util_electronics"] = {take = 2},
}

impulse.RegisterMixture(MIX)
