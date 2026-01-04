local MIX = {}

MIX.Class = "ammolmg"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "ammo_lmg"
MIX.Input = {
	["util_bulletcasing"] = {take = 6},
	["util_gunpowder"] = {take = 4}
}

impulse.RegisterMixture(MIX)
