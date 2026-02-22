local MIX = {}

MIX.Class = "scrapmini14"

MIX.Level = 6
MIX.Bench = "scrap"

MIX.Output = "wep_mini14"
MIX.Input = {
	["scrap_mini14"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_pipe"] = {take = 4}
}

impulse.RegisterMixture(MIX)