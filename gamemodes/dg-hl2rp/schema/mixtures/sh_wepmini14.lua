local MIX = {}

MIX.Class = "wepmini14"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_mini14"
MIX.Input = {
	["util_pipe"] = {take = 4},
	["util_plastic"] = {take = 3},
	["util_glue"] = {take = 5},
	["util_gear"] = {take = 5},
	["util_steel"] = {take = 5},
}

impulse.RegisterMixture(MIX)
