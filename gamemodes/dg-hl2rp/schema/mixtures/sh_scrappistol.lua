local MIX = {}

MIX.Class = "scrappistol"

MIX.Level = 1
MIX.Bench = "scrap"

MIX.Output = "wep_pistol"
MIX.Input = {
	["scrap_pistol"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 3},
}

impulse.RegisterMixture(MIX)
