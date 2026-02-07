local MIX = {}

MIX.Class = "scraphb"

MIX.Level = 6
MIX.Bench = "scrap"

MIX.Output = "wep_honeybadger"
MIX.Input = {
	["scrap_hb"] = {take = 1},
	["util_glue"] = {take = 3},
	["util_pipe"] = {take = 4}
}

impulse.RegisterMixture(MIX)
