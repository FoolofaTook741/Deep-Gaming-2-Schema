local MIX = {}

MIX.Class = "scraposisg"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "wep_osisg"
MIX.Input = {
	["scrap_osisg"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_pipe"] = {take = 3},
	["util_metalplate"] = {take = 3}
}

impulse.RegisterMixture(MIX)
