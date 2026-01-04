local MIX = {}

MIX.Class = "weppistol"

MIX.Level = 1
MIX.Bench = "weapon"

MIX.Output = "wep_pistol"
MIX.Input = {
	["util_pipe"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_plastic"] = {take = 6},
	["util_metalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
