local MIX = {}

MIX.Class = "hopper_mine"

MIX.Level = 10
MIX.Bench = "tech"

MIX.Output = "item_mine"
MIX.Input = {
	["util_gunpowder"] = {take = 20},
	["util_electronics"] = {take = 3},
	["util_steel"] = {take = 2},
}

impulse.RegisterMixture(MIX)

