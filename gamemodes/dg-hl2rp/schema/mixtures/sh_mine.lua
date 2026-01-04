local MIX = {}

MIX.Class = "hopper_mine"

MIX.Level = 12
MIX.Bench = "tech"

MIX.Output = "item_mine"
MIX.Input = {
	["util_gunpowder"] = {take = 5},
	["util_electronics"] = {take = 3},
	["util_steel"] = {take = 2},
	["util_rdxcompound"] = {take = 1}
}

impulse.RegisterMixture(MIX)

