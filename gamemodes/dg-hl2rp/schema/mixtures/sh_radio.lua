local MIX = {}

MIX.Class = "radio"

MIX.Level = 4
MIX.Bench = "general"
MIX.XPMultiplier = 1

MIX.Output = "item_radio"
MIX.Input = {
	["util_plastic"] = {take = 4},
	["util_pipe"] = {take = 2},
	["util_electronics"] = {take = 1}
}

impulse.RegisterMixture(MIX)
