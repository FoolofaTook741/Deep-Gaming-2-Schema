local MIX = {}

MIX.Class = "signaljammer"

MIX.Level = 8
MIX.Bench = "general"

MIX.Output = "item_jammer"
MIX.Input = {
	["util_metalplate"] = {take = 12},
	["util_glue"] = {take = 2},
	["util_electronics"] = {take = 1},
}

impulse.RegisterMixture(MIX)
