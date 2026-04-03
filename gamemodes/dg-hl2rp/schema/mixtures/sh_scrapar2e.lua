local MIX = {}

MIX.Class = "scrapar2e"

MIX.Level = 10
MIX.Bench = "scrap"

MIX.Output = "wep_ar2e"
MIX.Input = {
	["scrap_ar2e"] = {take = 1},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 1},
	["util_steel"] = {take = 4},
	["util_energycore"] = {take = 5},
	["util_plastic"] = {take = 8},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
