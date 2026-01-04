local MIX = {}

MIX.Class = "weptrench"

MIX.Level = 8
MIX.Bench = "heavyweapon"

MIX.Output = "wep_m500"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 1},
	["util_refinedmetalplate"] = {take = 4},
	["util_steel"] = {take = 3}
}

impulse.RegisterMixture(MIX)

