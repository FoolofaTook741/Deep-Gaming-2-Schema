local MIX = {}

MIX.Class = "sniperscope"

MIX.Level = 1
MIX.Bench = "attachment"

MIX.Output = "att_optic"
MIX.Input = {
	["util_pipe"] = {take = 2},
	["util_glue"] = {take = 2},
	["util_gear"] = {take = 1},
	["util_plastic"] = {take = 8}
}

impulse.RegisterMixture(MIX)
