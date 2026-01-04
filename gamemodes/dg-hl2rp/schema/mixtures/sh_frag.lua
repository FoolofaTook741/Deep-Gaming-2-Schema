local MIX = {}

MIX.Class = "grenade"

MIX.Level = 8
MIX.Bench = "general"

MIX.Output = "item_grenade"
MIX.Input = {
	["util_metalplate"] = {take = 3},
	["util_gunpowder"] = {take = 5}
}

impulse.RegisterMixture(MIX)
