local MIX = {}

MIX.Class = "scraposips"

MIX.Level = 2
MIX.Bench = "scrap"

MIX.Output = "wep_osips"
MIX.Input = {
	["scrap_osips"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_pipe"] = {take = 2},
	["util_metalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
