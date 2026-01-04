local MIX = {}

MIX.Class = "hunter_sight"

MIX.Level = 8
MIX.Bench = "attachment"

MIX.Output = "att_huntersight"
MIX.Input = {
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 2},
    ["util_pipe"] = {take = 1}
}

impulse.RegisterMixture(MIX)
