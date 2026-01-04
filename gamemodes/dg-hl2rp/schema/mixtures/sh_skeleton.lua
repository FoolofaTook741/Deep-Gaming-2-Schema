local MIX = {}

MIX.Class = "mix_skeleton"

MIX.Level = 4
MIX.Bench = "weapon"

MIX.Output = "wep_skeleton"
MIX.Input = {
	["util_metalplate"] = {take = 2},
	["util_cloth"] = {take = 1},
    ["util_glue"] = {take = 1}
}

impulse.RegisterMixture(MIX)
