local MIX = {}

MIX.Class = "scrapmpya8"

MIX.Level = 6
MIX.Bench = "scrap"

MIX.Output = "wep_mp7a8"
MIX.Input = {
	["scrap_mp7a8"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 1},
	["util_refinedmetalplate"] = {take = 5}
}

impulse.RegisterMixture(MIX)
