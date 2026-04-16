local MIX = {}

MIX.Class = "rsmoke"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "wep_wsmoke"
MIX.Input = {
	["util_paint"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_gunpowder"] = {take = 4},
    ["util_pipe"] = {take = 1}
}

impulse.RegisterMixture(MIX)
