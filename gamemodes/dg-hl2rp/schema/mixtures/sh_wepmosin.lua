local MIX = {}

MIX.Class = "mosinnagant"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_mosin"
MIX.Input = {
	["util_wood"] = {take = 14},
	["util_plastic"] = {take = 4},
	["util_glue"] = {take = 6},
	["util_gear"] = {take = 4},
	["util_steel"] = {take = 9},
}

impulse.RegisterMixture(MIX)
