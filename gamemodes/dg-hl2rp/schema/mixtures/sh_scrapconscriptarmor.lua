local MIX = {}

MIX.Class = "scrapconscriptarmor"

MIX.Level = 10
MIX.Bench = "scrap"

MIX.Output = "cos_conscriptarmor"
MIX.Input = {
	["scrap_conscriptarmor"] = {take = 1},
	["util_ceramicplate"] = {take = 1},
	["cos_combatgasmask"] = {take = 1},
	["util_lens"] = {take = 2},
	["util_glue"] = {take = 3},
	["util_cloth"] = {take = 6}
}

impulse.RegisterMixture(MIX)
