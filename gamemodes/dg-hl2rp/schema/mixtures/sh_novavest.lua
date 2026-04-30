local MIX = {}

MIX.Class = "cos_novavest"

MIX.Level = 9
MIX.Bench = "general"

MIX.Output = "cos_otavest2"
MIX.Input = {
	["util_steel"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_heavyceramicplate"] = {take = 1},
	["util_platecarrier"] = {take = 1}
}

impulse.RegisterMixture(MIX)
