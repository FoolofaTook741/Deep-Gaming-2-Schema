local MIX = {}

MIX.Class = "ammo40"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "ammo_40mm"
MIX.Input = {
	["util_bulletcasing"] = {take = 1},
	["util_gunpowder"] = {take = 12}
}

impulse.RegisterMixture(MIX)
