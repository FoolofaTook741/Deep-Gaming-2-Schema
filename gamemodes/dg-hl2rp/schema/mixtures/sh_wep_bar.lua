local MIX = {}

MIX.Class = "wep_bar"

MIX.Level = 7
MIX.Bench = "heavyweapon"

MIX.Output = "wep_bar"
MIX.Input = {
	["util_wood"] = {take = 5},
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 2},
	["util_refinedmetalplate"] = {take = 3}
}

impulse.RegisterMixture(MIX)
