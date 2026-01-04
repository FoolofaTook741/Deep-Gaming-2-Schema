local MIX = {}

MIX.Class = "hopper_mine"

MIX.Level = 14
MIX.Bench = "tech"

MIX.Output = "item_grenade"
MIX.Input = {
	["util_gunpowder"] = {take = 12},
	["util_steel"] = {take = 3},
	["util_rdxcompound"] = {take = 1}
}

impulse.RegisterMixture(MIX)

