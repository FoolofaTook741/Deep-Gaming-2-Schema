local MIX = {}

MIX.Class = "wepak47"

MIX.Level = 9
MIX.Bench = "heavyweapon"

MIX.Output = "wep_ak47"
MIX.Input = {
	["util_pipe"] = {take = 3},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 2},
	["util_steel"] = {take = 3},
	["util_wood"] = {take = 2}
}

impulse.RegisterMixture(MIX)
