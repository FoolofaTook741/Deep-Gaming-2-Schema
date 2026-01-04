local MIX = {}

MIX.Class = "wep357"

MIX.Level = 6
MIX.Bench = "weapon"

MIX.Output = "wep_357"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_refinedmetalplate"] = {take = 3},
	["util_steel"] = {take = 3}
}

impulse.RegisterMixture(MIX)
