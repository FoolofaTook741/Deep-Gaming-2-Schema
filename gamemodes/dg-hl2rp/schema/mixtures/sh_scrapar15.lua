local MIX = {}

MIX.Class = "scrapar15"

MIX.Level = 6
MIX.Bench = "scrap"

MIX.Output = "wep_ar15"
MIX.Input = {
	["scrap_ar15"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_pipe"] = {take = 4}
}

impulse.RegisterMixture(MIX)