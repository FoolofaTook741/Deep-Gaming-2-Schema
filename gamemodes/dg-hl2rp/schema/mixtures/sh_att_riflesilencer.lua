local MIX = {}

MIX.Class = "riflesilencer"

MIX.Level = 6
MIX.Bench = "attachment"

MIX.Output = "att_rifle_silencer"
MIX.Input = {
	["util_pipe"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 3}
}

impulse.RegisterMixture(MIX)
