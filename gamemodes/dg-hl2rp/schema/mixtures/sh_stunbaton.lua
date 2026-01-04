local MIX = {}

MIX.Class = "scrapstunbaton"

MIX.Level = 1
MIX.Bench = "scrap"

MIX.Output = "wep_stunstick"
MIX.Input = {
	["scrap_stunstick"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_pipe"] = {take = 2},
}

impulse.RegisterMixture(MIX)
