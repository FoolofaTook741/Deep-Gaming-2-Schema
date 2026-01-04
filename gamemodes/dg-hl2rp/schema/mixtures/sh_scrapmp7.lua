local MIX = {}

MIX.Class = "scrapmp7"

MIX.Level = 4
MIX.Bench = "scrap"

MIX.Output = "wep_mp7"
MIX.Input = {
	["scrap_mp7"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_metalplate"] = {take = 4}
}

impulse.RegisterMixture(MIX)
