local MIX = {}

MIX.Class = "vortarmor"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "cos_vortarmor"
MIX.Input = {
	["util_plastic"] = {take = 10},
	["util_glue"] = {take = 4},
}

impulse.RegisterMixture(MIX)
