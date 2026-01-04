local MIX = {}

MIX.Class = "scrapar2"

MIX.Level = 9
MIX.Bench = "scrap"

MIX.Output = "wep_ar2"
MIX.Input = {
	["scrap_ar2"] = {take = 1},
	["util_glue"] = {take = 7},
	["util_gear"] = {take = 3},
	["util_energycore"] = {take = 3},
	["util_plastic"] = {take = 6},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
