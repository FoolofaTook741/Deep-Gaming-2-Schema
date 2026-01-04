local MIX = {}

MIX.Class = "wep_ptrs41"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_ptrs41"
MIX.Input = {
	["util_pipe"] = {take = 6},
	["util_glue"] = {take = 5},
	["util_gear"] = {take = 4},
	["util_steel"] = {take = 5}
}

impulse.RegisterMixture(MIX)
