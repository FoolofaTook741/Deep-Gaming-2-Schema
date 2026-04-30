local MIX = {}

MIX.Class = "platecarrier"

MIX.Level = 8
MIX.Bench = "general"

MIX.Output = "util_platecarrier"
MIX.Input = {
	["util_cloth"] = {take = 8},
	["util_glue"] = {take = 4},
	["util_lvl2plate"] = {take = 1}
}

impulse.RegisterMixture(MIX)
