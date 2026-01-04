local MIX = {}

MIX.Class = "scrap357"

MIX.Level = 8
MIX.Bench = "scrap"

MIX.Output = "wep_357"
MIX.Input = {
	["scrap_357"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_gear"] = {take = 2},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
