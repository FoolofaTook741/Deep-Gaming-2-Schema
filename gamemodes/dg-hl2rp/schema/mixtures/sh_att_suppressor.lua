local MIX = {}

MIX.Class = "suppressor"

MIX.Level = 1
MIX.Bench = "attachment"

MIX.Output = "att_pistol_silencer"
MIX.Input = {
	["util_pipe"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 3}
}

impulse.RegisterMixture(MIX)
