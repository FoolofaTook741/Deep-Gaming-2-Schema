local MIX = {}

MIX.Class = "flashmask"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "cos_gp5gasmask"
MIX.Input = {
	["util_cloth"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 5},
    ["util_lens"] = {take = 3}
}

impulse.RegisterMixture(MIX)
