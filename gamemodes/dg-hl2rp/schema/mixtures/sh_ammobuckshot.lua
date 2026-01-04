local MIX = {}

MIX.Class = "ammobuckshot"

MIX.Level = 6
MIX.Bench = "general"

MIX.Output = "ammo_buckshot"
MIX.Input = {
	["util_bulletcasing"] = {take = 3},
	["util_gunpowder"] = {take = 2}
}

impulse.RegisterMixture(MIX)
