local MIX = {}

MIX.Class = "wep_m4a1"

MIX.Level = 8
MIX.Bench = "heavyweapon"

MIX.Output = "wep_m4a1"
MIX.Input = {
	["util_pipe"] = {take = 3},
	["util_glue"] = {take = 2},
	["util_gear"] = {take = 1},
	["util_steel"] = {take = 2},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
