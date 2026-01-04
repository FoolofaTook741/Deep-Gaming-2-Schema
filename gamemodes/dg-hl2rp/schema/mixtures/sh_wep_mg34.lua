local MIX = {}

MIX.Class = "wep_mg34"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_mg34"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 6},
	["util_glue"] = {take = 6},
	["util_gear"] = {take = 3},
	["util_steel"] = {take = 5}
}

impulse.RegisterMixture(MIX)
