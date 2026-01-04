local MIX = {}

MIX.Class = "weptt"

MIX.Level = 3
MIX.Bench = "weapon"

MIX.Output = "wep_tt"
MIX.Input = {
	["util_pipe"] = {take = 4},
	["util_glue"] = {take = 2},
	["util_plastic"] = {take = 6},
	["util_metalplate"] = {take = 3}
}

impulse.RegisterMixture(MIX)
