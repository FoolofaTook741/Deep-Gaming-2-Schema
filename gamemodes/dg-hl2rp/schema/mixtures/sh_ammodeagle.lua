local MIX = {}

MIX.Class = "ammodeagle"

MIX.Level = 3
MIX.Bench = "general"

MIX.Output = "ammo_deagle"
MIX.Input = {
	["util_bulletcasing"] = {take = 2},
	["util_gunpowder"] = {take = 2}
}

impulse.RegisterMixture(MIX)
