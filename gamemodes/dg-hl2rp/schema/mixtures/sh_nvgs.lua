local MIX = {}

MIX.Class = "nvgs"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "util_nvgs"
MIX.Input = {
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 1},
	["util_metalplate"] = {take = 2},
    ["util_plastic"] = {take = 2},
	["util_electronics"] = {take = 3}
}

impulse.RegisterMixture(MIX)

