local MIX = {}

MIX.Class = "cz75recipe"

MIX.Level = 2
MIX.Bench = "weapon"

MIX.Output = "wep_cz75"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 4},
}

impulse.RegisterMixture(MIX)
