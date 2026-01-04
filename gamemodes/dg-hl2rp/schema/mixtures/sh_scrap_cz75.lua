local MIX = {}

MIX.Class = "scrapcz"

MIX.Level = 2
MIX.Bench = "scrap"

MIX.Output = "wep_cz75"
MIX.Input = {
	["scrap_cz75"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_plastic"] = {take = 4},
}

impulse.RegisterMixture(MIX)
