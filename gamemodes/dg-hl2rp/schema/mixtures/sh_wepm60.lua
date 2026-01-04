local MIX = {}

MIX.Class = "wepm60"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_m60"
MIX.Input = {
	["util_glue"] = {take = 6},
	["util_pipe"] = {take = 5},
	["util_gear"] = {take = 2},
	["util_steel"] = {take = 5},
	["util_refinedmetalplate"] = {take = 4}
}

impulse.RegisterMixture(MIX)
