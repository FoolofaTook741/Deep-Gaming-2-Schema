local MIX = {}

MIX.Class = "c4explosive"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "item_c4"
MIX.Input = {
	["util_plastic"] = {take = 16},
    ["util_rdxcompound"] = {take = 5},
    ["util_electronics"] = {take = 3},
}

impulse.RegisterMixture(MIX)
