local MIX = {}

MIX.Class = "wep_pm63"

MIX.Level = 3
MIX.Bench = "weapon"

MIX.Output = "wep_pm63"
MIX.Input = {
	["util_pipe"] = {take = 4},
	["util_glue"] = {take = 4},
	["util_gear"] = {take = 1},
}

impulse.RegisterMixture(MIX)
