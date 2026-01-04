local MIX = {}

MIX.Class = "combatgasmask"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "cos_combatgasmask"
MIX.Input = {
	["util_cloth"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 5}
}

impulse.RegisterMixture(MIX)
