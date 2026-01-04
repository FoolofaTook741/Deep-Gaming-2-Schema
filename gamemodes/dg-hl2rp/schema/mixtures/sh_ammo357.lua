local MIX = {}

MIX.Class = "ammo357"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "ammo_357"
MIX.Input = {
	["util_bulletcasing"] = {take = 3},
	["util_gunpowder"] = {take = 2}
}

impulse.RegisterMixture(MIX)
