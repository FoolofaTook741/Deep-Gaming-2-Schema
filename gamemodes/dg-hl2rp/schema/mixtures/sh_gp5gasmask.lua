local MIX = {}

MIX.Class = "flashmask"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "cos_gp5gasmask"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_plastic"] = {take = 2},
    ["util_lens"] = {take = 4},
    ["cos_combatgasmask"] = {take = 1}
}

impulse.RegisterMixture(MIX)
