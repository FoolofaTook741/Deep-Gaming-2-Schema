local MIX = {}

MIX.Class = "cmore_sight"

MIX.Level = 4
MIX.Bench = "attachment"

MIX.Output = "att_cmore"
MIX.Input = {
	["util_plastic"] = {take = 1},
	["util_glue"] = {take = 1},
}

impulse.RegisterMixture(MIX)
