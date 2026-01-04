local MIX = {}

MIX.Class = "cos_m1helmet"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "cos_m1helmet"
MIX.Input = {
	["util_metalplate"] = {take = 5},
	["util_glue"] = {take = 4},
}

impulse.RegisterMixture(MIX)
