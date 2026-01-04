local MIX = {}

MIX.Class = "ext_mag"

MIX.Level = 4
MIX.Bench = "attachment"

MIX.Output = "att_extendedmag"
MIX.Input = {
	["util_metalplate"] = {take = 6},
	["util_glue"] = {take = 1}
}

impulse.RegisterMixture(MIX)
