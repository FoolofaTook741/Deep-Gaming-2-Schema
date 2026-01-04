local MIX = {}

MIX.Class = "paintedwood"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "item_paintedwood"
MIX.Input = {
	["util_wood"] = {take = 2},
    ["util_paint"] = {take = 1},
}

impulse.RegisterMixture(MIX)
