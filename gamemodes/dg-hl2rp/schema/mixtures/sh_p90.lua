local MIX = {}

MIX.Class = "plutonic_p90"

MIX.Level = 6
MIX.Bench = "heavyweapon"

MIX.Output = "plutonic_p90"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 2},
	["util_plastic"] = {take = 8},
	["util_steel"] = {take = 3}
}

impulse.RegisterMixture(MIX)
