local MIX = {}

MIX.Class = "thermite"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "item_thermite"
MIX.Input = {
	["util_plastic"] = {take = 4},
    ["util_gunpowder"] = {take = 15},
    ["util_pipe"] = {take = 1},
}

impulse.RegisterMixture(MIX)
