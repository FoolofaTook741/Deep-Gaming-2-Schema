local MIX = {}

MIX.Class = "reddot_sight"

MIX.Level = 6
MIX.Bench = "attachment"

MIX.Output = "att_reddot"
MIX.Input = {
	["util_plastic"] = {take = 3},
	["util_glue"] = {take = 1},
}

impulse.RegisterMixture(MIX)
