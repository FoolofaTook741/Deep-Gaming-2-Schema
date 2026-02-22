local MIX = {}

MIX.Class = "mosinnagant"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_mosin"
MIX.Input = {
	["util_wood"] = {take = 8},
	["util_plastic"] = {take = 2},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 3},
	["util_steel"] = {take = 6},
}

impulse.RegisterMixture(MIX)
