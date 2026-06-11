--[[

local MIX = {}

MIX.Class = "ceramicplate"

MIX.Level = 9
MIX.Bench = "general"

MIX.Output = "util_ceramicplate"
MIX.Input = {
	["util_glue"] = {take = 4},
	["util_steel"] = {take = 8}
}

impulse.RegisterMixture(MIX)

]]--
