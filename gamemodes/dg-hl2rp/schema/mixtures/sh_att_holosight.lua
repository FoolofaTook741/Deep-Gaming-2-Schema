local MIX = {}

MIX.Class = "holographic_sight"

MIX.Level = 2
MIX.Bench = "attachment"

MIX.Output = "att_holosight"
MIX.Input = {
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 2}
}

impulse.RegisterMixture(MIX)
