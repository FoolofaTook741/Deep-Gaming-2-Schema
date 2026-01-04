local MIX = {}

MIX.Class = "wepshotgun"

MIX.Level = 7
MIX.Bench = "heavyweapon"

MIX.Output = "wep_shotgun"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 3},
	["util_steel"] = {take = 3}
}

impulse.RegisterMixture(MIX)

