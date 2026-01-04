local MIX = {}

MIX.Class = "scrapsw500"

MIX.Level = 10
MIX.Bench = "scrap"

MIX.Output = "wep_sw500"
MIX.Input = {
	["scrap_sw500"] = {take = 1},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 3},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
