local MIX = {}

MIX.Class = "mix_stiletto"

MIX.Level = 9
MIX.Bench = "weapon"

MIX.Output = "wep_stiletto"
MIX.Input = {
	["util_steel"] = {take = 1},
	["util_plastic"] = {take = 1},
    ["util_glue"] = {take = 1}
}

impulse.RegisterMixture(MIX)
