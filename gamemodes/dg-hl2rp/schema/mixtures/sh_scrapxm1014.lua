local MIX = {}

MIX.Class = "scrapxm1014"

MIX.Level = 7
MIX.Bench = "scrap"

MIX.Output = "wep_m500"
MIX.Input = {
	["scrap_xm1014"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_gear"] = {take = 2},
	["util_metalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
